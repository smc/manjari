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
tests=tests
BLDDIR=build
default: otf
all: clean lint otf ttf webfonts test
OTF=$(FONTS:%=$(BLDDIR)/$(NAME)-%.otf)
TTF=$(FONTS:%=$(BLDDIR)/$(NAME)-%.ttf)
WOFF2=$(FONTS:%=$(BLDDIR)/$(NAME)-%.woff2)
PDFS=$(FONTS:%=$(BLDDIR)/$(NAME)-%-ligatures.pdf)  \
	$(FONTS:%=$(BLDDIR)/$(NAME)-%-content.pdf)  \
	$(FONTS:%=$(BLDDIR)/$(NAME)-%-numbers.pdf)

$(BLDDIR)/%.otf: $(SRCDIR)/%.ufo
	@echo "  BUILD    $(@F)"
	@fontmake --verbose=WARNING -o otf --output-dir $(BLDDIR) -u $<

$(BLDDIR)/%.ttf: $(SRCDIR)/%.ufo
	@echo "  BUILD    $(@F)"
	@fontmake --verbose=WARNING -o ttf --output-dir $(BLDDIR) -u $<

$(BLDDIR)/%.woff2: $(BLDDIR)/%.otf
	@echo "WEBFONT    $(@F)"
	@fonttools ttLib.woff2 compress  $<

 $(BLDDIR)/%-ligatures.pdf: $(BLDDIR)/%.ttf
	@echo "   TEST    $(@F)"
	@hb-view $< --font-size 14 --margin 100 --line-space 1.5 \
		--foreground=333333 --text-file $(tests)/ligatures.txt \
		--output-file $(BLDDIR)/$(@F);

$(BLDDIR)/%-content.pdf: $(BLDDIR)/%.ttf
	@echo "   TEST    $(@F)"
	@hb-view $< --font-size 14 --margin 100 --line-space 1.5 \
		--foreground=333333 --text-file $(tests)/content.txt \
		--output-file $(BLDDIR)/$(@F);

$(BLDDIR)/%-numbers.pdf: $(BLDDIR)/%.ttf
	@echo "   TEST    $(@F)"
	@hb-view $< --font-size 14 --margin 100 --line-space 1.5 \
		--foreground=333333 --text-file $(tests)/numbers.txt \
		--features="tnum,zero" --output-file $(BLDDIR)/$(@F);

ttf: $(TTF)
otf: $(OTF)
webfonts: $(WOFF2)
lint: ufonormalizer ufolint
ufolint: $(SRCDIR)/*.ufo
	$@ $^

ufonormalizer: $(SRCDIR)/*.ufo
	@for variant in $^;do \
		ufonormalizer -m $$variant;\
	done;

install: otf
	@mkdir -p ${DESTDIR}${INSTALLPATH}
	install -D -m 0644 $(BLDDIR)/*.otf ${DESTDIR}${INSTALLPATH}/

test: otf $(PDFS)

clean:
	@rm -rf $(BLDDIR)
