#!/usr/bin/make -f

fontpath=/usr/share/fonts/truetype/malayalam
fonts=Manjari-Regular Manjari-Thin Manjari-Bold
features=features
PY=python2.7
version=0.1
buildscript=tools/build.py
default: otf
all: compile webfonts test
compile: ttf otf
otf: clean
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t otf -i $$font.sfd -f $(features)/$$font.fea -v $(version);\
	done;

ttf: clean
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t ttf -i $$font.sfd -f $(features)/$$font.fea -v $(version);\
	done;

webfonts:woff woff2
woff: ttf
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t woff -i $$font.ttf;\
	done;
woff2: ttf
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t woff2 -i $$font.ttf;\
	done;

install: compile
	@for font in `echo ${fonts}`;do \
		install -D -m 0644 $${font}.otf ${DESTDIR}/${fontpath}/$${font}.otf;\
	done;

test: otf
# Test the fonts
	@for font in `echo ${fonts}`; do \
		echo "Testing font $${font}";\
		hb-view $${font}.otf --font-size 14 --margin 100 --line-space 1.5 --foreground=333333  --text-file tests/tests.txt --output-file tests/$${font}.pdf;\
	done;
clean:
	@rm -rf *.otf *.ttf *.woff *.woff2 *.sfd-*