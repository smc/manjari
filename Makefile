#!/usr/bin/make -f

fontpath=/usr/share/fonts/truetype/malayalam
font=Spiral

default: all
all: compile test webfonts

compile:
	@echo "Generating ${font}.ttf"
	@fontforge -lang=ff -c "Open('${font}.sfd'); Generate('${font}.ttf')";

webfonts:compile
	@echo "Generating webfonts"
	@sfntly -w ${font}.ttf ${font}.woff;
	@sfntly -e -x ${font}.ttf ${font}.eot;
	woff2_compress ${font}.ttf;

test: compile
# Test the fonts
	@echo "Testing font ${font}";
	@hb-view ${font}.ttf --text-file tests/tests.txt --output-file tests/${font}.pdf;
install:
	@install -D -m 0644  ${font}.ttf ${DESTDIR}/${fontpath}/$${font}.ttf;
