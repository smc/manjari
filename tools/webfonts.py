#!/usr/bin/env python
# encoding: utf-8
#
# Webfont build utility
#

from fontTools.ttLib import TTFont
from fontTools.ttx import makeOutputFileName
import argparse


def webfonts(infont, type):
    font = TTFont(infont, recalcBBoxes=0)
    woffFileName = makeOutputFileName(
        infont, outputDir=None, extension='.' + type)
    print("Generating webfont %s => %s" % (infont, woffFileName))
    font.flavor = type
    font.save(woffFileName, reorderTables=False)
    font.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Build webfonts')
    parser.add_argument('-i', '--input', help='Input font', required=True)

    args = parser.parse_args()

    webfonts(args.input, 'woff')
    webfonts(args.input, 'woff2')
