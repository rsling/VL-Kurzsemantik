# Roland's Make system for LaTeX.

# Compile system.
LX = xelatex
BX = biber

# Project name and file name parts.
PROJECT = SchaeferFormaleSemantik
HANDOUTSUFF = _Handout_
SLIDESUFF = _Folien_
FULL = Komplett
SUFFSUFF = .pdf
BIBSUFF = .bbl
OUTDIR = output
BIBFILE = /Users/roland/Workingcopies/Bibtex/rs.bib

# TeX Sources to watch.
SOURCEDIR = includes/
MAINS = main.tex localpackages.tex localcommands.tex
SOURCES = $(MAINS) $(wildcard $(SOURCEDIR)/*.tex)

# Stuff passed to XeLaTeX.
HANDOUTDEF = \def\HANDOUT{}
SLIDEDEF =
MAININCLUDE = \input{main}

# XeLaTeX flags.
PREFLAGS = -no-pdf
TEXFLAGS = -output-directory=$(OUTDIR)

# Create output dir if needed.
$(info $(shell [ ! -d $(OUTDIR) ] && mkdir -p ./$(OUTDIR)/includes))

# Complete handout BBL.
$(OUTDIR)/$(PROJECT)$(HANDOUTSUFF)$(FULL)$(BIBSUFF): $(SOURCES) $(BIBFILE) 
	$(LX) $(TEXFLAGS) -jobname=$(PROJECT)$(HANDOUTSUFF)$(FULL) $(PREFLAGS) "$(HANDOUTDEF)$(MAININCLUDE)"
	cd ./$(OUTDIR); $(BX) $(PROJECT)$(HANDOUTSUFF)$(FULL)

# Complete handout PDF.
$(OUTDIR)/$(PROJECT)$(HANDOUTSUFF)$(FULL)$(SUFFSUFF): $(OUTDIR)/$(PROJECT)$(HANDOUTSUFF)$(FULL)$(BIBSUFF)
	$(LX) $(TEXFLAGS) -jobname=$(PROJECT)$(HANDOUTSUFF)$(FULL) "$(HANDOUTDEF)$(MAININCLUDE)"

# Individual handout BBL and PDF.
$(OUTDIR)/%$(HANDOUTSUFF)$(PROJECT)$(BIBSUFF): $(MAINS) $(SOURCEDIR)/%.tex $(BIBFILE)
	$(LX) $(TEXFLAGS) $(PREFLAGS) -jobname=$*$(HANDOUTSUFF)$(PROJECT) "$(HANDOUTDEF)\edef\TITLE{$*}$(MAININCLUDE)"
	cd ./$(OUTDIR); $(BX) $*$(HANDOUTSUFF)$(PROJECT)

$(OUTDIR)/%$(HANDOUTSUFF)$(PROJECT)$(SUFFSUFF): $(MAINS) $(SOURCEDIR)%.tex $(OUTDIR)/%$(HANDOUTSUFF)$(PROJECT)$(BIBSUFF)
	$(LX) $(TEXFLAGS) -jobname=$*$(HANDOUTSUFF)$(PROJECT) "$(HANDOUTDEF)\edef\TITLE{$*}$(MAININCLUDE)"

# Individual slides BBL and PDF.
$(OUTDIR)/%$(SLIDESUFF)$(PROJECT)$(BIBSUFF): $(MAINS) $(SOURCEDIR)%.tex $(BIBFILE)
	$(LX) $(TEXFLAGS) $(PREFLAGS) -jobname=$*$(SLIDESUFF)$(PROJECT) "$(SLIDEDEF)\edef\TITLE{$*}$(MAININCLUDE)"
	cd ./$(OUTDIR); $(BX) $*$(SLIDESUFF)$(PROJECT)

$(OUTDIR)/%$(SLIDESUFF)$(PROJECT)$(SUFFSUFF): $(MAINS) $(SOURCEDIR)%.tex $(OUTDIR)/%$(SLIDESUFF)$(PROJECT)$(BIBSUFF)
	$(LX) $(TEXFLAGS) -jobname=$*$(SLIDESUFF)$(PROJECT) "$(SLIDEDEF)\edef\TITLE{$*}$(MAININCLUDE)"

# Phony shit.

.PHONY: full handout01 handout02 handout03 handout04 handout05 slides01 slides02 slides03 slides04 slides05 allhandouts allslides all clean realclean edit test

test:
	echo $(OUTDIR)/$(PROJECT)$(HANDOUTSUFF)$(FULL)$(BIBSUFF)
	echo $(OUTDIR)/%$(HANDOUTSUFF)$(PROJECT)$(BIBSUFF)

full: $(OUTDIR)/$(PROJECT)$(HANDOUTSUFF)$(FULL)$(SUFFSUFF)

handout01: $(OUTDIR)/01.+Inferenz+und+Bedeutung$(HANDOUTSUFF)$(PROJECT)$(SUFFSUFF)
handout02: $(OUTDIR)/02.+Mengen+und+Funktionen$(HANDOUTSUFF)$(PROJECT)$(SUFFSUFF)
handout03: $(OUTDIR)/03.+Aussagenlogik$(HANDOUTSUFF)$(PROJECT)$(SUFFSUFF)
handout04: $(OUTDIR)/04.+Pr-adikatenlogik$(HANDOUTSUFF)$(PROJECT)$(SUFFSUFF)
handout05: $(OUTDIR)/05.+Typen+und+Lambdas$(HANDOUTSUFF)$(PROJECT)$(SUFFSUFF)

allhandouts: handout01 handout02 handout03 handout04 handout05

slides01: $(OUTDIR)/01.+Inferenz+und+Bedeutung$(SLIDESUFF)$(PROJECT)$(SUFFSUFF)
slides02: $(OUTDIR)/02.+Mengen+und+Funktionen$(SLIDESUFF)$(PROJECT)$(SUFFSUFF)
slides03: $(OUTDIR)/03.+Aussagenlogik$(SLIDESUFF)$(PROJECT)$(SUFFSUFF)
slides04: $(OUTDIR)/04.+Pr-adikatenlogik$(SLIDESUFF)$(PROJECT)$(SUFFSUFF)
slides05: $(OUTDIR)/05.+Typen+und+Lambdas$(SLIDESUFF)$(PROJECT)$(SUFFSUFF)

allslides: slides01 slides02 slides03 slides04 slides05

complete: $(OUTDIR)/$(PROJECT)$(HANDOUTSUFF)$(FULL)$(SUFFSUFF)

all: allhandouts allslides complete

clean:
	cd ./$(OUTDIR)/; \rm -f *.adx *.and *.aux *.bbl *.blg *.idx *.ilg *.ldx *.lnd *.log *.out *.rdx *.run.xml *.sdx *.snd *.toc *.wdx *.xdv *.nav *.snm *.bcf *.vrb
	cd ./$(OUTDIR)/includes/; \rm -f *.aux

edit:
	mvim -c ':set spell spelllang=en' -c ':nnoremap <F15> ]s' -c ':nnoremap <F14> [s' main.tex includes/*.tex


