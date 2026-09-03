# Použití:
#   make ... přeloží všechny zpěvníky (sériově)
#   make orizni ... vyrobí ořezané "tablet" verze PDF pro čtení na tabletu
#   make clean ... smaže všechny vygenerované soubory
#   make view ... otevře kb_zpevnik.pdf

Zpevniky = $(patsubst Snakefile.%,%,$(wildcard Snakefile.*))
Pdfs = $(patsubst %,%.pdf,$(Zpevniky))
TabletPdfs = $(patsubst %.pdf,%.tablet.pdf,$(Pdfs))

.PHONY:	all clean orizni $(Zpevniky) view

all:	$(Zpevniky)

$(Zpevniky):
	snakemake -p -s Snakefile.$@ --cores all

orizni: $(TabletPdfs)

%.tablet.pdf: %.pdf
	set -x;\
	tmp=$$(mktemp -d);\
	cp $< $${tmp}/1.pdf;\
	(\
	cd $$tmp;\
	pdfcrop --margins '0 -25 0 0' 1.pdf 2.pdf;\
	/usr/bin/env gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=3.pdf 2.pdf;\
	);\
	cp $${tmp}/3.pdf $@;

clean:
	rm -fr cache/* .snakemake
	rm -f *.pdf *.tablet.pdf
	rm -fr *_singles

view:
	open kb_zpevnik.pdf
