#!/usr/bin/env python3
"""Re-anchor Rosepine-Dark's dark ramp so the window background is #191724.

The upstream Rosepine-Dark build ships a window background of #111019, which is
darker than Rose Pine's actual base. This script lifts the too-dark tones up to
#191724 and snaps the rest of the ramp onto the standard Rose Pine ladder.

Why #191724 specifically: rofi's theme (rofi/rose-pine.rasi) sets
`background: #191724`. Matching the GTK window background to it makes the drun
overlay read as part of the window underneath instead of a panel floating above
it. Change one and you must change the other, or that effect breaks.

themes/Rosepine-Dark/ in this repo is ALREADY recolored -- you do not need to run
this to use the theme. Run it only to re-derive the result from a fresh upstream
copy of the theme.

Usage:  ./recolor-rosepine.py [path/to/theme]   (default: ~/.themes/Rosepine-Dark)
        ./recolor-rosepine.py --check [path]    (report only, change nothing)
"""
import re
import sys
import pathlib
import collections

# current -> Rose Pine equivalent, by the role each color plays in the theme.
# #21202e is deliberately absent: it is already highlight-low and stays as shipped.
HEX_MAP = {
    "060609": "14121f",  # fallback :hover
    "070609": "14121f",  # wm_border
    "09080c": "191724",  # gtk-2.0 base/bg -> window color
    "111019": "191724",  # base           <- window, headerbar, sidebar   * THE FIX
    "171622": "1c1a2b",  # gradient stop
    "191724": "1f1d2e",  # surface        <- message dialogs
    "1c1a29": "211f33",  # gradient stop
    "1f1e26": "21202e",  # highlight-low  <- titlebar buttons
    "232032": "26233a",  # overlay        <- menus, popovers, OSD
    "2b283e": "26233a",  # overlay
    "393545": "403d52",  # highlight-med
    "3c3b47": "403d52",  # highlight-med  <- borders, strokes
    "403e43": "403d52",  # highlight-med
    "454064": "524f67",  # highlight-high <- tooltips
}

# Decimal rgba() background/shadow forms. Two are deliberately NOT here:
#   rgba(33, 32, 46, a) -> #21202e views, unchanged by design
#   rgba(25, 23, 36, a) -> dark ink drawn ON light foam/rose accent fills.
# That second one is a foreground token, not a background. Lightening it
# destroys the contrast of text sitting on the accent color.
DEC_MAP = {
    (17, 16, 25): (25, 23, 36),   # 111019 -> 191724
    (35, 32, 50): (38, 35, 58),   # 232032 -> 26233a
}

TEXT_EXT = {".css", ".rc", ".svg", ".theme", ".xml"}

hex_re = re.compile("#(" + "|".join(HEX_MAP) + ")\\b", re.I)
dec_re = re.compile(r"\b(\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\b")


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    check = "--check" in sys.argv
    root = pathlib.Path(args[0] if args else "~/.themes/Rosepine-Dark").expanduser()

    if not (root / "index.theme").is_file():
        sys.exit(f"error: {root} does not look like a GTK theme (no index.theme)")

    # NOT idempotent: #191724 is both a target (of #111019) and a source
    # (-> #1f1d2e), so a second pass would undo the anchor. #111019 exists only
    # in an untouched upstream build, which makes it a reliable sentinel.
    sentinel = root / "gtk-3.0" / "gtk.css"
    if not sentinel.is_file():
        sys.exit(f"error: {sentinel} not found")
    if "#111019" not in sentinel.read_text(encoding="utf-8"):
        print(f"{root} is already recolored (no #111019 in gtk-3.0/gtk.css).")
        print("Nothing to do -- running again would undo it.")
        return

    counts = collections.Counter()
    touched = []

    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        if path.suffix.lower() not in TEXT_EXT and path.name != "gtkrc":
            continue
        try:
            src = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue

        # checkbox/radio/toggle glyphs: #191724 there is the tick drawn ON the
        # accent fill, same dark-ink-on-light role as rgba(25,23,36). Leave it.
        in_assets = "assets" in path.relative_to(root).parts

        def sub_hex(m):
            key = m.group(1).lower()
            if key == "191724" and in_assets:
                counts["#191724 kept (glyph ink on accent)"] += 1
                return m.group(0)
            counts[f"#{key} -> #{HEX_MAP[key]}"] += 1
            return "#" + HEX_MAP[key]

        def sub_dec(m):
            rgb = tuple(int(g) for g in m.groups())
            if rgb not in DEC_MAP:
                return m.group(0)
            new = DEC_MAP[rgb]
            counts[f"rgba{rgb} -> rgba{new}"] += 1
            return "%d, %d, %d" % new

        out = dec_re.sub(sub_dec, hex_re.sub(sub_hex, src))
        if out != src:
            touched.append(str(path.relative_to(root)))
            if not check:
                path.write_text(out, encoding="utf-8")

    verb = "would change" if check else "changed"
    print(f"{verb} {len(touched)} file(s) in {root}")
    for f in touched:
        print("  ", f)
    if counts:
        print("\nreplacements:")
        for k, v in sorted(counts.items(), key=lambda kv: -kv[1]):
            print(f"  {v:>4}  {k}")
    else:
        print("\nnothing to do -- already recolored.")


if __name__ == "__main__":
    main()
