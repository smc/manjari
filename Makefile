#!/usr/bin/make -f

NAME=Manjari
FONTS=Regular Bold Thin
INSTALLPATH=/usr/share/fonts/opentype/malayalam
PY=python3
version=`cat VERSION`
TOOLDIR=tools
SRCDIR=sources
webfontscript=$(TOOLDIR)/webfonts.py
designspace=$(SRCDIR)/Manjari.designspace
tests=tests/tests.txt
BLDDIR=build
default: otf
all: clean otf ttf webfonts test
OTF=$(FONTS:%=$(BLDDIR)/$(NAME)-%.otf)
TTF=$(FONTS:%=$(BLDDIR)/$(NAME)-%.ttf)
WOFF2=$(FONTS:%=$(BLDDIR)/$(NAME)-%.woff2)
PDF=$(FONTS:%=$(BLDDIR)/$(NAME)-%.pdf)

$(BLDDIR)/%.otf: $(SRCDIR)/%.ufo
	@echo "  BUILD    $(@F)"
	@mkdir -p $(BLDDIR)
	@fontmake --verbose=WARNING -o otf -u $<
	@mv master_otf/*.otf $(BLDDIR)/
	@rm -rf master_otf

$(BLDDIR)/%.ttf: $(SRCDIR)/%.ufo
	@echo "  BUILD    $(@F)"
	@mkdir -p $(BLDDIR)
	@fontmake --verbose=WARNING -o ttf -u $<
	@mv master_ttf/*.ttf $(BLDDIR)/
	@rm -rf master_ttf

$(BLDDIR)/%.woff2: $(BLDDIR)/%.otf
	@echo "WEBFONT    $(@F)"
	@$(PY) $(webfontscript) -i $<

$(BLDDIR)/%.pdf: $(BLDDIR)/%.otf $(tests)
	@echo "   TEST    $(@F)"
	@hb-view $< --font-size 14 --margin 100 --line-space 1.5 \
		--foreground=333333 --text-file $(tests) \
		--output-file $(BLDDIR)/$(@F);

ttf: $(TTF)
otf: $(OTF)
webfonts: $(WOFF2)

install: otf
	@mkdir -p ${DESTDIR}${INSTALLPATH}
	install -D -m 0644 $(BLDDIR)/*.otf ${DESTDIR}${INSTALLPATH}/

test: otf $(PDF)

clean:
	@rm -rf $(BLDDIR)
