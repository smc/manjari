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
font.simplify()
font.autoInstr()
font.generate(sys.argv[1].replace(".sfd",".ttf"), flags=("omit-instructions", "round", "opentype"))
font.close() 
