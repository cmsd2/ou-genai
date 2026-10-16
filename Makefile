# Resolves to ~/Library/texmf on macOS and ~/texmf on Linux, automatically.
TEXMFHOME := $(shell kpsewhich -var-value=TEXMFHOME)
STYDIR    := $(TEXMFHOME)/tex/latex/ou-genai

.PHONY: install link uninstall check test

## copy the file in (machines where you don't keep the repo checked out)
install:
	@mkdir -p "$(STYDIR)"
	@install -m 644 ou-genai.sty "$(STYDIR)/"
	@echo "installed into $(TEXMFHOME)"

## symlink instead, so edits in the repo take effect immediately
link:
	@mkdir -p "$(STYDIR)"
	@ln -sf "$(CURDIR)/ou-genai.sty" "$(STYDIR)/ou-genai.sty"
	@echo "linked $(CURDIR) into $(TEXMFHOME)"

uninstall:
	@rm -f "$(STYDIR)/ou-genai.sty"
	@echo "removed from $(TEXMFHOME)"

# cd / first: kpsewhich searches "." before the trees, so running this
# from the repo would find the local copy and always look like success.
check:
	@echo "TEXMFHOME = $(TEXMFHOME)"
	@cd / && echo "sty: $$(kpsewhich ou-genai.sty || echo 'NOT FOUND')"

## build the smoke test from a directory holding no copy of ou-genai.sty,
## so a pass proves it was resolved from TEXMFHOME.
test:
	@rm -rf .test && mkdir -p .test && cp example.tex .test/
	@cd .test && latexmk -pdf -interaction=nonstopmode example.tex >build.log 2>&1 || true
	@cd .test && if grep -qE '^! ' example.log; then \
	    echo "FAILED:"; grep -m5 -E '^! ' example.log; false; \
	  elif grep -q "Package ou-genai Warning" example.log; then \
	    echo "FAILED: ou-genai warned"; grep -m5 -A2 "Package ou-genai Warning" example.log; false; \
	  else echo "OK -- see .test/example.pdf"; fi
