library(ape)
library(phytools)
library(dendextend)
library(phangorn)
try(setwd("~/Documents/MPI/LuisM_K_Pronoun/public/genetics/"))

g = read.csv("../../../Glottolog/glottolog-languoid.csv/languoid.csv", stringsAsFactors = F)

popLangs = read.csv("../data/gelato/samples.csv",stringsAsFactors = F)

popLangs[popLangs$populationName=="Quechua",]$glottocode = "ayac1239"

# Calculate tree from Neighbour joining of pop distances.
#popDifferences = read.csv("../data/gelato/PopDistance.csv",stringsAsFactors = F,sep="\t")
#popDifferences = as.dist(as.matrix(popDifferences))
#genetics.tree = nj(popDifferences)
#genetics.tree$tip.label = popLangs[match(genetics.tree$tip.label,popLangs$populationName),]$glottocode
# (However, this has a different result from the paper)

# Directly from diagram in paper:
genetics.tree = read.newick(text="((sout2996,wayu1243),((kari1311,kain1272),(arhu1242,east2555)));")

lang.tree = read.nexus("../Beast/relaxedClock_Long_10k_MCCT.trees")

glmatch = data.frame(
  lang=lang.tree$tip.label,
  glotto=g[match(lang.tree$tip.label,g$id),]$name
)

commonLangs = intersect(lang.tree$tip.label, genetics.tree$tip.label)

lang.tree = drop.tip(lang.tree,lang.tree$tip.label[!lang.tree$tip.label %in% commonLangs])
genetics.tree = drop.tip(genetics.tree,genetics.tree$tip.label[!genetics.tree$tip.label %in% commonLangs])

lang.tree$tip.label = g[match(lang.tree$tip.label,g$id),]$name
genetics.tree$tip.label = g[match(genetics.tree$tip.label,g$id),]$name

lang.tree = compute.brlen(lang.tree)
genetics.tree = compute.brlen(genetics.tree)

lang.tree = as.dendrogram(lang.tree)
genetics.tree = as.dendrogram(genetics.tree)

pdf("../results/Lang_Genetics_Tanglegram.pdf")
par(mar=c(0,1,3,1))
tanglegram(lang.tree,genetics.tree, margin_inner = 10, sort=T, edge.lwd = 2,axes=F)
text(0.11,0.15,"Pronouns",xpd=T,cex=2)
text(0.89,0.15,"Genetics",xpd=T,cex=2)
dev.off()


####
lang.tree = read.nexus("../Beast/relaxedClock_Long_10k_MCCT.trees")

reichData = read.csv("../data/Reich_2013_Population.csv",stringsAsFactors = F)

t2 =readLines("../data/Reich_2013_Tree.nwk")
t2 = paste0(gsub("[\t\n ]","",t2),collapse = "")

genetics.tree = read.newick(text = t2)

genetics.tree$tip.label = reichData[match(genetics.tree$tip.label, reichData$Population),]$Glottocode
genetics.tree = drop.tip(genetics.tree,"")
#
commonLangs = intersect(lang.tree$tip.label, genetics.tree$tip.label)

lang.tree = drop.tip(lang.tree,lang.tree$tip.label[!lang.tree$tip.label %in% commonLangs])
genetics.tree = drop.tip(genetics.tree,genetics.tree$tip.label[!genetics.tree$tip.label %in% commonLangs])

lang.tree$tip.label = g[match(lang.tree$tip.label,g$id),]$name
genetics.tree$tip.label = g[match(genetics.tree$tip.label,g$id),]$name

lang.tree = compute.brlen(lang.tree)
genetics.tree = compute.brlen(genetics.tree)

lang.tree = as.dendrogram(lang.tree)
genetics.tree = as.dendrogram(genetics.tree)

pdf("../results/Lang_Genetics_Tanglegram_reich2013.pdf", width=10)
par(mar=c(0,1,3,1))
tanglegram(lang.tree,genetics.tree, margin_inner = 10, sort=T, edge.lwd = 2,axes=F)
text(0.11,0.1,"Pronouns",xpd=T,cex=2)
text(0.89,0.1,"Genetics",xpd=T,cex=2)
dev.off()