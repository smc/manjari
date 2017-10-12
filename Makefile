#!/usr/bin/make -f

fontpath=/usr/share/fonts/opentype/malayalam
PY=python3
version=`cat VERSION`
buildscript=tools/build.py
webfontscript=tools/webfonts.py
designspace=sources/Manjari.designspace
builddir=build
default: compile
all: clean compile webfonts test
compile: otf ttf
otf:
	@mkdir -p $(builddir)
	@$(PY) $(buildscript) -t otf -d $(designspace) -v $(version)
	@mv master_otf/*.otf $(builddir)/
	@rm -rf master_otf
ttf:
	@mkdir -p $(builddir)
	@$(PY) $(buildscript) -t ttf -d $(designspace) -v $(version)
	@mv master_ttf/*.ttf $(builddir)/
	@rm -rf master_ttf

webfonts: ttf
	@for font in $(builddir)/*.ttf; do \
		$(PY) $(webfontscript) -i $${font};\
	done;

install: otf
	install -D -m 0644 $(builddir)/*.otf ${DESTDIR}/${fontpath}/

ifeq ($(shell ls -l $(builddir)/*.otf 2>/dev/null | wc -l),0)
test: otf run-test
else
test: run-test
endif

run-test:
	@for font in $(builddir)/*.otf; do \
		echo "Testing font $${font}";\
		hb-view $${font} --font-size 14 --margin 100 --line-space 1.5 --foreground=333333  --text-file tests/tests.txt --output-file $${font%.otf}.pdf;\
	done;

clean:
	@rm -rf $(builddir)/*.*
