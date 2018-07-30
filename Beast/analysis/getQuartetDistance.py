from pyTQDist import *
import numpy

filename1 = "../results/SA_Tree_from_pronouns.new"
filename2 = "../results/SA_Tree_from_glottolog.new"

real_qd =  quartetDistance(filename1, filename2) 
print "Quartet Distance =", real_qd

print "Permuted:"

perm_qd = pairsQuartetDistance("../results/SA_Tree_permuted.new", "../results/SA_Tree_from_glottolog_forPermutationTest.new") 


print "p = ", sum([x <= real_qd for x in perm_qd]) / float(len(perm_qd))

sd = numpy.std(perm_qd)
mean = numpy.mean(perm_qd)

print "mean perm", mean
print "sd",sd

print "Z = ", (real_qd - mean)/ sd

print "Permuted within families:"

perm_qd = pairsQuartetDistance("../results/SA_Tree_permuted_withinFams.new", "../results/SA_Tree_from_glottolog_forPermutationTest.new") 


print "p = ", sum([x <= real_qd for x in perm_qd]) / float(len(perm_qd))

sd = numpy.std(perm_qd)
mean = numpy.mean(perm_qd)

print "mean perm", mean
print "sd",sd

print "Z = ", (real_qd - mean)/ sd