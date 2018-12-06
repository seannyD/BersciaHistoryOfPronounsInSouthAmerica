library(openxlsx)
setwd("~/Documents/MPI/LuisM_K_Pronoun/public/alignments/")
langs = c()
d = data.frame()

languagesToExclude = c("sara1340","sech1236")

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
d$ID = 1:nrow(d)
d = d[,!names(d) %in% c("EXCLUDE","SPLITWORD")]
names(d)[names(d)=="COGNATES"] = "COGID"
write.table(d,"SAP_alignments.tab",sep="\t", fileEncoding = "UTF-8", quote = F,row.names = F)
