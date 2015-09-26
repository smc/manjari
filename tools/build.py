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
font.appendSFNTName('English (US)', 'Version', sys.argv[3] + '+' + time.strftime('%Y%m%d'))
font.selection.all()
font.simplify()
font.round()
font.generate(sys.argv[1].replace(".sfd",".otf"), flags=("omit-instructions", "round", "opentype"))
font.close() 
