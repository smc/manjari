#!/usr/bin/make -f

fontpath=/usr/share/fonts/truetype/malayalam
fonts=Manjari ManjariThin
feature=features/features.fea
PY=python2.7

define SCRIPT
import sys
import time
import fontforge
font = fontforge.open(sys.argv[1])
# Remove all GSUB lookups
for lookup in font.gsub_lookups:
	font.removeLookup(lookup)

# Remove all GPOS lookups 
for lookup in font.gpos_lookups:
	font.removeLookup(lookup)        

# Merge the new featurefile 
font.mergeFeature(sys.argv[2])
font.version = time.strftime('%Y%m%d')
font.generate(sys.argv[1].replace(".sfd",".ttf"), flags=("omit-instructions", "round", "opentype"))
font.close()
endef
export SCRIPT

default: compile
all: compile webfonts

compile:
	@for font in `echo ${fonts}`;do \
		echo "Generating $$font.ttf";\
		$(PY) -c "$$SCRIPT" $< $$font.sfd $(feature);\
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
