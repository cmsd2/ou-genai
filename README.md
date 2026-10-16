# ou-genai

The "TMA proforma for generative AI use" that the OU asks students to put at
the start of every TMA, as a LaTeX package. One command, tick boxes by name:

```latex
\usepackage{ou-genai}
...
\begin{document}
\genaiproforma[learning, improving={polished the wording of Q3}]
```

produces

> **M248 26J: TMA proforma for generative AI use**
>
> *Please use this proforma at the beginning of your TMA to indicate how/if
> you have used generative AI.*
>
> I have used Generative AI in this TMA (such as Copilot, Gemini or ChatGPT)
> to help with the following:
> [please tick all that apply]
>
> ☐ As a starting point or inspiration with a part of the TMA
>   e.g. to understand wording in the TMA.
> ☒ To improve my own work
>   e.g. with style and phrasing.
>   *polished the wording of Q3*
> ☒ As a learning aid
>   e.g. when working through the mathematics.
> ☐ I did not use generative AI to help me with this TMA

Sibling of [ou-refs](https://github.com/cmsd2/ou-refs): same install, same
layout. Needs only `amssymb` (for the box glyphs) and a LaTeX from 2020 or
later (`expl3` is in the kernel).

## Install

It is one file, `ou-genai.sty`. Put it where your TeX distribution looks for
personal packages, then `\usepackage{ou-genai}` works from any document.

`tlmgr` (TeX Live) and the MiKTeX Console only install packages published on
CTAN, and this one is not, so neither can fetch it; that is what the steps
below are for. The one CTAN dependency worth having is the OU's own TMA
package, which they can install:

```sh
tlmgr install ou-tma     # TeX Live / MacTeX; MiKTeX installs it on first use
```

### TeX Live / MacTeX (macOS, Linux, CoCalc, Overleaf's engine)

`kpsewhich` reports the personal tree; TeX Live scans it live, so there is
no database to refresh:

```sh
git clone https://github.com/cmsd2/ou-genai.git
cd ou-genai
make link        # symlink into TEXMFHOME; `git pull` updates it in place
make check       # prints the path kpsewhich now resolves ou-genai.sty to
make test        # builds example.tex from a dir holding no copy of the .sty
```

`make install` copies instead of symlinking; `make uninstall` removes it.
Without `make`, the same by hand:

```sh
dir="$(kpsewhich -var-value=TEXMFHOME)/tex/latex/ou-genai"   # ~/Library/texmf/... on macOS, ~/texmf/... on Linux
mkdir -p "$dir" && cp ou-genai.sty "$dir/"
kpsewhich ou-genai.sty                                        # should print that path
```

### MiKTeX (Windows)

MiKTeX has no `TEXMFHOME`; it keeps a list of *roots* and an index of their
contents. `link-windows.ps1` is `make link` for that world: it registers
`$HOME\texmf` as a root and puts a symlink to `ou-genai.sty` in it, so
`git pull` updates the installed copy. Symlinks need Developer Mode (Settings
> System > For developers) or an elevated shell; without either the script
copies the file instead and tells you to re-run it after each pull.

```powershell
git clone https://github.com/cmsd2/ou-genai.git
cd ou-genai
.\link-windows.ps1             # -Root D:\texmf to use another root; -Unlink to undo
```

It ends by printing where `kpsewhich` now finds `ou-genai.sty`. Re-run it
only if files are added or renamed; MiKTeX indexes names, not contents.

By hand, if you'd rather copy than link:

```powershell
mkdir $HOME\texmf\tex\latex\ou-genai
copy ou-genai.sty $HOME\texmf\tex\latex\ou-genai\
initexmf --register-root=$HOME\texmf
miktex fndb refresh            # older MiKTeX: initexmf --update-fndb
kpsewhich ou-genai.sty         # should print the path under $HOME\texmf
```

### No install

Copy `ou-genai.sty` next to the `.tex` file. That is also the Overleaf
route: upload it to the project.

## Use

### 1. Load it

```latex
\documentclass[a4paper,11pt]{article}
\usepackage[pdfbookmark]{ou-tma}   % the usual OU TMA package, optional
\usepackage{ou-genai}

\myname{A. Student}
\mypin{X1234567}
\mycourse{M248}
\mytma{01}
```

Load order does not matter. If `ou-tma` is present, `\mycourse` supplies the
module code in the heading; without it the variant's own default (`M248`)
is used, or pass `module=`.

### 2. Configure (optional)

Defaults for the whole document go in the preamble:

```latex
\genaisetup{variant=m248-26j, frame, showinstruction=false}
```

Every key below is valid here as well as on the command itself.

### 3. Invoke

Straight after `\begin{document}` (the OU wants the proforma first), tick
whichever apply:

```latex
\begin{document}
\genaiproforma[learning, improving={polished the wording of Q3}]
```

| Key | Effect |
|---|---|
| `starting`, `improving`, `learning`, `none` | tick that box |
| `learning={worked through Unit 2}` | tick it and print a note underneath |
| `starting=false` | untick (overrides a `\genaisetup` default) |
| `module=M249`, `presentation=27J` | override the heading prefix |
| `frame` | draw a box round the whole proforma |
| `gap=3em` | vertical space after it, matching `ou-tma`'s gap between questions (default); `gap=0pt` for none |
| `showinstruction=false` | drop the italic "Please use this proforma…" line |
| `variant=<name>` | use another proforma wording (see below) |

Ticking nothing raises a package warning rather than silently printing an
empty form. So does ticking `none` alongside another box.

Restyle by `\renewcommand`ing `\genaiticked`, `\genaiunticked`,
`\genaidetail{#1}`, `\genaiheadingfont` or `\genaiinstructionfont`.

## When the proforma changes

The wording is not hard-coded in the macros. It lives in a named *variant*
at the bottom of `ou-genai.sty`; `m248-26j` is the default and is a verbatim
transcription of `M248 TMA proforma for generative AI 26J.docx`.

**Never edit a published variant.** When a later module or presentation
issues a different form, add a new block under it:

```latex
\genaidefinevariant{m248-27j}{
  inherit      = m248-26j,          % start from a copy of the old one
  presentation = {27J},
  intro        = {I have used Generative AI in this TMA to help with:},
  items = {
    coding = {To write or check code}{e.g. an R script to draw a plot.},
    %% an existing key here REPLACES that item's wording
  },
  remove    = {improving},          % drop a box by key
  movetoend = {none},               % new items append; keep this one last
}
```

and select it per document with `\genaisetup{variant=m248-27j}` (or
`\genaiproforma[variant=...]`). Old TMAs keep building unchanged because
they still resolve to `m248-26j`. A variant can equally be defined in a TMA
preamble; `example.tex` does exactly that. Define variants at top level
(the preamble), not inside a group or environment.

Everything a variant can set:

| Field | Meaning |
|---|---|
| `inherit` | copy fields and items from another variant first |
| `heading`, `instruction`, `intro`, `tick` | the four lines of prose; empty drops the line |
| `module`, `presentation` | defaults for the heading prefix |
| `items` | `key = {wording}{e.g. line}` pairs; order is print order, new keys append |
| `remove` | comma list of item keys to delete |
| `movetoend` | comma list of item keys to shift to the end, wording kept |
| `exclusive` | keys that warn when ticked with any other (`none`) |

## Notes

- Tick boxes are `\square` and `\boxtimes` from `amssymb`, the same glyphs
  Word uses (U+2610 / U+2612), so no font juggling is needed.
- `ou-tma.sty` is a separate CTAN package; this one only reads its
  `\mycourse` value and works without it.
- Under `ou-tma`, the first maths in a document used to attract two
  "Font shape `U/wasy/b/n' not available" warnings, pinned to whatever
  line that was, usually `\genaiproforma`. The cause is `wasysym` declaring
  a bold series its font lacks while `bm` probes for it. This package
  declares that shape as a silent substitution, so the warnings are gone
  for the whole document, not just the proforma.

## Licence

[MIT](LICENSE). The proforma wording is the Open University's, reproduced
as issued for use in OU assessments; the MIT licence covers this package's
code and documentation.
