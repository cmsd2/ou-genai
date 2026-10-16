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

Sibling of [ou-refs](../ou-refs): same install, same layout.

## Install

```sh
make link      # symlink into TEXMFHOME; repo edits take effect immediately
make check     # confirm kpsewhich resolves the file
make test      # build example.tex from a dir holding no copy of the .sty
```

`make install` copies instead of symlinking; `make uninstall` removes it.
On CoCalc: `git clone ... ~/ou-genai && cd ~/ou-genai && make link`.

## Use

Put `\genaiproforma[...]` straight after `\begin{document}` (the OU wants it
first). With [ou-tma](https://ctan.org/pkg/ou-tma) loaded, the module code
is taken from `\mycourse`, so nothing else is needed.

| Key | Effect |
|---|---|
| `starting`, `improving`, `learning`, `none` | tick that box |
| `learning={worked through Unit 2}` | tick it and print a note underneath |
| `starting=false` | untick (the default; useful to override `\genaisetup`) |
| `module=M249`, `presentation=27J` | override the heading prefix |
| `frame` | draw a box round the whole proforma |
| `showinstruction=false` | drop the italic "Please use this proforma..." line |
| `variant=<name>` | use another proforma wording (see below) |

The same keys work in `\genaisetup{...}` in the preamble, for defaults.

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
preamble; `example.tex` does exactly that.

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
