#!/usr/bin/make -f

fontpath=/usr/share/fonts/truetype/malayalam
fonts=Manjari ManjariThin
feature=features/features.fea
PY=python2.7
version=0.1
buildscript=tools/build.py
default: compile
all: compile webfonts

compile:
	@for font in `echo ${fonts}`;do \
		echo "Generating $$font.otf";\
		$(PY) $(buildscript) $$font.sfd $(feature) $(version);\
	done;

webfonts:compile
	@echo "Generating webfonts";
	@for font in `echo ${fonts}`;do \
		sfntly -w $${font}.otf $${font}.woff;\
		[ -x `which woff2_compress` ] && woff2_compress $${font}.otf;\
	done;

install: compile
	@for font in `echo ${fonts}`;do \
		install -D -m 0644 $${font}.otf ${DESTDIR}/${fontpath}/$${font}.otf;\
	done;

test: compile
# Test the fonts
	@for font in `echo ${fonts}`; do \
		echo "Testing font $${font}";\
		hb-view $${font}.otf --font-size 14 --margin 20  --text-file tests/tests.txt --output-file tests/$${font}.pdf;\
	done;
