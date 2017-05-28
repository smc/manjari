#!/usr/bin/make -f

fontpath=/usr/share/fonts/truetype/malayalam
fonts=Manjari-Regular Manjari-Thin Manjari-Bold
features=features
PY=python2.7
version=1.1
buildscript=tools/build.py
default: otf
all: compile webfonts test
compile: ttf otf
otf:
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t otf -i $$font.sfd -f $(features)/$$font.fea -v $(version);\
	done;

ttf:
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t ttf -i $$font.sfd -f $(features)/$$font.fea -v $(version);\
	done;

webfonts:woff woff2
woff: ttf
	@rm -rf *.woff
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t woff -i $$font.ttf;\
	done;
woff2: ttf
	@rm -rf *.woff2
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t woff2 -i $$font.ttf;\
	done;

install: compile
	@for font in `echo ${fonts}`;do \
		install -D -m 0644 $${font}.otf ${DESTDIR}/${fontpath}/$${font}.otf;\
	done;

ifeq ($(shell ls -l *.ttf 2>/dev/null | wc -l),0)
test: ttf run-test
else
test: run-test
endif

run-test:
	@for font in `echo ${fonts}`; do \
		echo "Testing font $${font}";\
		hb-view $${font}.ttf --font-size 14 --margin 100 --line-space 1.5 --foreground=333333  --text-file tests/tests.txt --output-file tests/$${font}.pdf;\
	done;
clean:
	@rm -rf *.otf *.ttf *.woff *.woff2 *.sfd-*
