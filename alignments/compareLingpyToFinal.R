setwd("~/Documents/MPI/LuisM_K_Pronoun/public/alignments/")


orig = read.delim("../lingpy/output/alignments/pronouns_alignment.tsv",sep="\t",quote='',encoding = "UTF-8",fileEncoding = "UTF-8",skip=3)

languagesToExclude = c("sara1340","sech1236")

langs = c()
d = data.frame()

# Convert Excel sheet to tab delimited
fileList = c("FirstPerson.tab",
             "SecondPerson.tab",
             "ThirdPerson.tab",
             "FourthPerson.tab")


for(i in 1:4){
  dx = read.delim(paste0("../../lingPyAnalysis/qlc_ManuallyCorrected/",fileList[i]),sep="\t")
  langs = unique(c(dx$DOCULECT,langs))
  dx$ALIGNMENT = apply(dx[,8:ncol(dx)],1,function(X){
    X[is.na(X)] = ""
    X[X==" "] = "-"
    X[X==""] = "-"
    paste(X,collapse= " ")
  })
  d = rbind(d,dx[,c(names(dx)[1:7],"ALIGNMENT")])
}

d = d[!is.na(d$IPA),]
d = d[d$IPA!="",]

d = d[! d$DOCULECT %in% languagesToExclude,]

d[d$CONCEPT=="you (singular)",]$CONCEPT = "you"

new = d


new$origCogSet = orig[match(paste(d$DOCULECT,d$CONCEPT,d$IPA),
                         paste(orig$DOCULECT,orig$CONCEPT, orig$IPA)),]$COGNATES

new$origAlignment = orig[match(paste(d$DOCULECT,d$CONCEPT,d$IPA),
                            paste(orig$DOCULECT,orig$CONCEPT, orig$IPA)),]$ALIGNMENT

#############

new = new[!is.na(new$origCogSet),]

write.table(new[,!names(new) %in% c("ID","ALIGNMENT",'origAlignment','EXCLUDE','SPLITWORD')],file="../lingpy/output/Lingpy_vs_Final_cognates.tsv",sep = "\t",quote = F,row.names = F,fileEncoding = "UTF-8")

auto.res = outer(new$origCogSet,new$origCogSet,"==")
auto.res = auto.res[lower.tri(auto.res)]
correct.res = outer(new$COGNATES,new$COGNATES,"==")
correct.res = correct.res[lower.tri(correct.res)]

sum(auto.res==correct.res)/length(auto.res)

# Both agree they are cognates
tp = sum(auto.res==1 & correct.res==1)
# Both agree they are not cognates
tn = sum(auto.res==0 & correct.res==0)
# Automatic method thinks they are cognate, but human does not
fp = sum(auto.res==1 & correct.res==0)
# Human thinks they are cognate, but automatic method does not
fn = sum(auto.res==0 & correct.res==1)


precision = tp / (tp+fp)
recall = tp / (tp+fn)

accuracy = (tp+tn) / (tp+tn + fp+fn)

f1.score = (2*tp)/((2* tp) + fp +fn)

print(tp)
print(tn)
print(fp)
print(fn)

print(precision)
print(recall)
print(accuracy)
print(f1.score)


# number of splits and merges

table(tapply(new$COGNATES,new$origCogSet,function(X){length(unique(X))}))

table(tapply(new$origCogSet,new$COGNATES,function(X){length(unique(X))}))

# number of splits and merges, ignoring changes to a single language
table(tapply(new$COGNATES,new$origCogSet,function(X){sum(table(X)>1)}))

table(tapply(new$origCogSet,new$COGNATES,function(X){sum(table(X)>1)}))




randomCog = function(){
  new$randomCog = sample(1:(length(unique(new$origCogSet))),nrow(new),replace = T)
  new$randomCog = sample(new$origAlignment)
  auto.res = outer(new$randomCog,new$randomCog,"==")
  auto.res = auto.res[lower.tri(auto.res)]
  correct.res = outer(new$COGNATES,new$COGNATES,"==")
  correct.res = correct.res[lower.tri(correct.res)]
  
  sum(auto.res==correct.res)/length(auto.res)
  
  # Both agree they are cognates
  tp = sum(auto.res==1 & correct.res==1)
  # Both agree they are not cognates
  tn = sum(auto.res==0 & correct.res==0)
  # Automatic method thinks they are cognate, but human does not
  fp = sum(auto.res==1 & correct.res==0)
  # Human thinks they are cognate, but automatic method does not
  fn = sum(auto.res==0 & correct.res==1)
  
  
  precision = tp / (tp+fp)
  recall = tp / (tp+fn)
  accuracy = (tp+tn) / (tp+tn + fp+fn)
  f1.score = (2*tp)/((2* tp) + fp +fn)
  return(c(precision,recall,accuracy,f1.score))
}

randomDist = replicate(100,randomCog())
rownames(randomDist) = c("p",'r','a','f')
apply(randomDist,1,mean)


###

cleanW = function(X){
  X = gsub("^(- )+","",X)
  X = gsub("( -)+$","",X)
  return(X)
}

  alignmentChanges = sapply(1:nrow(new),function(i){
    auto = cleanW(new[i,]$ALIGNMENT)
    human = cleanW(new[i,]$origAlignment)
    auto != human
  })
  numAlignmentChanges = sum(alignmentChanges)
  
  numAlignmentChanges / nrow(new)
  
  
  
  
  
