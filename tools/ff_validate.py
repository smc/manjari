import fontforge
import argparse

def validate_font(font_name):
    font = fontforge.open(font_name)
    glyphs = font.glyphs()
    flipped_ref = 0x10
    wrong_dir = 0x8
    for glyph in glyphs:
        state = glyph.validate(True)
        if state & flipped_ref:
                print( 'Flipped reference in glyph: ' +  glyph.glyphname)
        elif state & wrong_dir:
                print('Wrong direction in glyph: ' +  glyph.glyphname)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Validate ttf font using fontforge')
    parser.add_argument('-i', '--input', help='Input font', required=True)
    args = parser.parse_args()
    validate_font(args.input)
