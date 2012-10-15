#
# Build XeTeX PDF files
#
# Versions
#   2011-11-27    first version
#

SHELL = /bin/bash

TEX_FILES = $(wildcard *.tex)
PDF_FILES = $(patsubst %.tex,%.pdf,$(TEX_FILES))

.SUFFIXES:
.POSIX:


all: $(PDF_FILES)

clean:
	rm -f $(foreach f,$(basename $(PDF_FILES)), $s.out $s.aux)

%.pdf: %.aux
	xelatex $<

%.aux: %.tex
	xelatex $<

