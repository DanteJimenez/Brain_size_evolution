
brainsize<- read.csv("pre_csv/brainmain2.csv",header = T)



#This is for the brain size database that has problems with variable names
vnames$D0 <- gsub(" ", ".", vnames$D0)
vnames$D0 <- gsub("\\(", ".", vnames$D0)
vnames$D0 <- gsub("\\)", ".", vnames$D0)

#For brain size
keep.vars <- na.omit(vnames$D0) 
brainsize<- brainsize[,keep.vars]

names(brainsize) <- vnames$Code[match(names(brainsize), vnames$D0)]

write.csv(brainsize, "csv/brainmain2.csv",row.names = F)

#For the amniote database
amniote<- read.csv("pre_csv/amniotefinal.csv")
keep.vars <- na.omit(vnames$D1) 

amniote<- amniote[,keep.vars]

names(amniote) <- vnames$Code[match(names(amniote), vnames$D1)]

# TEMP: sort out duplicates!! this is not needed, just for now!!

amniote <- amniote[!duplicated(amniote$species),]

write.csv(amniote, "csv/amniote2.csv",row.names = F)




# amniote references
amniote<- read.csv("pre_csv/Amniote_Database_References_Aug_2015.csv")


vnames$R1 <- gsub(" ", ".", vnames$R1)
vnames$R1 <- gsub("\\(", ".", vnames$R1)
vnames$R1 <- gsub("\\)", ".", vnames$R1)



keep.vars <- na.omit(vnames$R1)

amniote<- amniote[,keep.vars]

names(amniote) <- vnames$Code[match(names(amniote), vnames$R1)]

# TEMP: sort out duplicates!! this is not needed, just for now!!

amniote <- amniote[!duplicated(amniote$species),]

write.csv(amniote, "ref/amniote2.csv",row.names = F)
