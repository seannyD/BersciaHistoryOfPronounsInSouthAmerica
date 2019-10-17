# Need to run in sudo mode, also with python3

from lingpy import *
import os


scorerMethod = "shuffle" # "markov" or "shuffle"
scorerRuns = 100 # default 1000
randomScorerRuns = 100 # default 1000
markovLimit = 10000 # default 10000
scorerThreshold = 0.7 # default 0.7

clustMethod = 'lexstat'
cluster_threshold = 0.7 # default = 0.3

align_method = 'library'
align_tree_calc = 'upgma'

mergeVowels = False

tokenizer_file = "../soundClassModels/AllSegs.prf"
tokenizer_column = "IPA"

def buildCustomModel():

	soundClassFolder_origin = "../soundClassModels/Berscia/"
	soundClassFolder_dest = "/Library/Frameworks/Python.framework/Versions/3.5/lib/python3.5/site-packages/lingpy-2.4-py3.5.egg/lingpy/data/models/berscia/"

	os.system("mkdir "+soundClassFolder_dest)
	os.system("cp "+soundClassFolder_origin+"* "+soundClassFolder_dest+"/")

	data.derive.compile_model(soundClassFolder_dest)
	return(Model("berscia"))

BersciaSca = Model("sca")
alignSoundClassModel = "sca"

#BersciaSca = buildCustomModel()
#alignSoundClassModel = "berscia"
	

##########

qlcFile = "../qlc_raw/pronouns.qlc"


#wl = Wordlist(qlcFile)
#wl.tokenize(tokenizer_file,column=tokenizer_column)
#wl.output("qlc",filename="../qlc_raw/pronouns_tokenized")

lex = LexStat("../qlc_raw/pronouns.qlc", 
	model = BersciaSca,
	merge_vowels = mergeVowels,
	check=True)

lex.get_scorer(force=True,
	runs=scorerRuns,
	method=scorerMethod,
	rands=randomScorerRuns,
	limit=markovLimit,
	threshold=scorerThreshold)
	
# Run the clustering method
# For the original paper, this was run using the "lexstat" method. 
# However, Johan Mattis List commented:
# "If you have less then 100 mutual pairs of words on average per pair of languages in your sample, you should never use the lexstat proper method, since it has a smoothing factor that will set all matches beyond that factor to zero, so the method simply refuses, in some sense, to detect cognates, because it was told not to (similar to a linguist who would demand two sound correspondence examples at least, before calling something regular).
# Instead of method='lexstat', simply write method='sca', and go with a threshold of 0.45. I am convinced, the bcubes will yield a much higher recall then."
lex.cluster(method="lexstat", threshold=cluster_threshold, ref="cognates")

lex.output('qlc', filename="../qlc_cluster/pronouns_cluster")

alm = Alignments(lex, ref='cognates')
alm.align(
		method=align_method,
		output = True,
		tree_calc = align_tree_calc,
		model = alignSoundClassModel#refLexSca
		)

alm.output('html', filename="../output/alignments/pronouns_alignment")
alm.output('tsv', filename="../output/alignments/pronouns_alignment",
	ignore="all", 
	cols = ["ID","DOCULECT","IPA","COUNTERPART",'CONCEPT','TOKENS','COGNATES','ALIGNMENT'])
	
lex.calculate('tree', ref='cognates')
tree = lex.tree.asciiArt()
o = open("../output/trees/pronouns_cognate_tree.txt",'w')
o.write(tree)
o.close()

lex.output("nwk", filename="../output/trees/pronouns_alignment_tree")


#lex.calculate('tree', ref='cognates')