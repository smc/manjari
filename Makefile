#!/usr/bin/make -f

fontpath=/usr/share/fonts/truetype/malayalam
fonts=Manjari ManjariThin
feature=features/features.fea
PY=python2.7
buildscript=tools/build.py
default: compile
all: compile webfonts

compile:
	@for font in `echo ${fonts}`;do \
		echo "Generating $$font.ttf";\
		$(PY) $(buildscript) $$font.sfd $(feature);\
	done;

webfonts:compile
	@echo "Generating webfonts";
	@for font in `echo ${fonts}`;do \
		sfntly -w $${font}.ttf $${font}.woff;\
		sfntly -e -x $${font}.ttf $${font}.eot;\
		[ -x `which woff2_compress` ] && woff2_compress $${font}.ttf;\
	done;

install: compile
	@for font in `echo ${fonts}`;do \
		install -D -m 0644 $${font}.ttf ${DESTDIR}/${fontpath}/$${font}.ttf;\
	done;

test: compile
# Test the fonts
	@for font in `echo ${fonts}`; do \
		echo "Testing font $${font}";\
		hb-view $${font}.ttf --text-file tests/tests.txt --output-file tests/$${font}.pdf;\
	done;
