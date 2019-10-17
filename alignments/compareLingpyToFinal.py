from lingpy import *
from lingpy.evaluate.acd import bcubes
lex = LexStat('../lingpy/output/Lingpy_vs_Final_cognates.tsv')
b = bcubes(lex, gold='COGNATES', test='ORIG')
print(b)