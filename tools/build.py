#!/usr/bin/env python
# encoding: utf-8

import argparse
from defcon import Font
from fontmake.font_project import FontProject
from mutatorMath.ufo.document import DesignSpaceDocumentReader


def setInfo(info, version):
    """Sets various font metadata fields."""

    info.versionMajor, info.versionMinor = map(int, version.split("."))
    info.openTypeOS2VendorID = "SMC"
    info.openTypeOS2Version = 4
    info.openTypeNameVersion = version
    if info.openTypeOS2Selection is None:
        info.openTypeOS2Selection = []
    # Set use typo metrics bit
    info.openTypeOS2Selection += [7]

    # Make sure fsType is set to 0, i.e. Installable Embedding
    info.openTypeOS2Type = []


def build(args):
    designspace = args.designspace
    reader = DesignSpaceDocumentReader(designspace, ufoVersion=3)
    ufoPaths = reader.getSourcePaths()
    ufos = []
    for ufoPath in ufoPaths:
        ufo = Font(ufoPath)
        setInfo(ufo.info, args.version)
        ufos.append(ufo)

    project = FontProject()
    project.run_from_ufos(ufos,
                          output=args.output_type,
                          remove_overlaps=True,
                          reverse_direction=True,
                          subroutinize=True
                          )


def main():
    parser = argparse.ArgumentParser(description="Build fonts.")
    parser.add_argument(
        "-d", "--designspace", metavar="designspace",
        help="Designspace file", required=True)
    parser.add_argument("-t", "--output-type", metavar="type",
                        help="Output format. otf or ttf", required=True)
    parser.add_argument(
        "-v", "--version", metavar="version", help="version number",
        required=True)

    args = parser.parse_args()

    build(args)


if __name__ == "__main__":
    main()
