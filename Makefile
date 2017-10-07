#!/usr/bin/make -f

fontpath=/usr/share/fonts/opentype/malayalam
fonts=Manjari-Regular Manjari-Thin Manjari-Bold
PY=python3
version=`cat VERSION`
buildscript=tools/build.py
webfontscript=tools/webfonts.py
sources=sources
builddir=build
default: compile
all: compile webfonts test
compile: otf ttf
otf:
	@mkdir -p $(builddir)
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t otf -i $(sources)/$$font.ufo -v $(version);\
		mv master_otf/*.otf $(builddir)/;\
	done;
	@rm -rf  master_otf
ttf:
	@mkdir -p $(builddir)
	@for font in `echo ${fonts}`;do \
		$(PY) $(buildscript) -t ttf -i $(sources)/$$font.ufo -v $(version);\
		mv master_ttf/*.ttf $(builddir)/;\
	done;
	@rm -rf master_ttf

webfonts: ttf
	@rm -rf *.woff
	@for font in `echo ${fonts}`;do \
		$(PY) $(webfontscript) -i $(builddir)/$$font.ttf;\
	done;

install: otf
	@for font in `echo ${fonts}`;do \
		install -D -m 0644 $${font}.otf ${DESTDIR}/${fontpath}/$${font}.otf;\
	done;

ifeq ($(shell ls -l $(builddir)/*.ttf 2>/dev/null | wc -l),0)
test: ttf run-test
else
test: run-test
endif

run-test:
	@for font in `echo ${fonts}`; do \
		echo "Testing font $${font}";\
		hb-view $(builddir)/$${font}.ttf --font-size 14 --margin 100 --line-space 1.5 --foreground=333333  --text-file tests/tests.txt --output-file tests/$${font}.pdf;\
	done;
clean:
	@rm -rf $(builddir)/*.* tests/*.pdf
