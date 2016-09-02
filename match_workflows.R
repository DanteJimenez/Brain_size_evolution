# See https://github.com/annakrystalli/bird_trait_networks/blob/master/match%20workflow.R
# for example 

rm(list=ls())

install.pkgs <- F
source("~/Documents/workflows/Brain_size_evolution/setup.R")


# PACKAGES & FUNCTIONS ###############################################################

# source rmacroRDM functions
source(paste(rmacro.folder, "functions.R", sep = ""))
source(paste(rmacro.folder, "wideData_function.R", sep = ""))

# SETTINGS ###############################################################
# master settings
var.vars <- c("var", "value", "data.ID")
match.vars <- c("synonyms", "data.status")
meta.vars = c("qc", "observer", "ref", "n", "notes")
master.vars <- c("species", match.vars, var.vars, meta.vars)

# spp.list settings
taxo.vars <- c("genus", "family", "order")

# var.omit settings, variables in the datafile that you don't want to add to the master
#var.omit <- c("no_sex_maturity_d", "adult_svl_cm", "male_maturity_d")

#Can set up the input folder here
setupInputFolder(input.folder, meta.vars)

setwd(input.folder)

# FILES ###############################################################
list.files()
list.files("csv/")

brainsize<- read.csv("pre_csv/brainmain2.csv",header = T)

amniote<- read.csv("csv/amniotefinal.csv")
anage<- read.csv("csv/anagedatasetf.csv")
lifehtraits<-("csv/lifehistraits.csv")
parentalc<-("csv/parentalcare.csv")

# Load match data.....................................................................


syn.links <- read.csv("~/Documents/Workflows/rmacroRDM/data/input/taxo/syn.links.csv", stringsAsFactors = F)

# WORKFLOW ###############################################################


# CREATE MASTER

# Create taxo.table
taxo.dat <- unique(D0[,c("species", taxo.vars)])


# Assign spp.list from species in brainsize
spp.list <- createSpp.list(species = unique(brainsize$Scientific.name), 
                           taxo.dat = NULL, 
                           taxo.vars = NULL)

# create master shell

master <- list(data = newMasterData(master.vars), 
               spp.list = spp.list, 
               metadata = metadata)

# match and append processed data to master


filename <- "amniote2"

m <- matchObj(data.ID = "D1", spp.list = spp.list, status = "unmatched",
              data = read.csv(paste(input.folder, "csv/", filename, ".csv", sep = ""),
                              stringsAsFactors=FALSE, fileEncoding = "mac"),
              sub = "spp.list", filename = filename, 
              meta = createMeta(meta.vars)) # use addMeta function to manually add metadata.

m <- processDat(m, input.folder, var.omit) %>% 
  separateDatMeta() %>% 
  compileMeta(input.folder = input.folder) %>%
  checkVarMeta(master$metadata) %>%
  dataMatchPrep()

m <- dataSppMatch(m, syn.links = syn.links, addSpp = T)


output <- masterDataFormat(m, meta.vars, match.vars, var.vars)

write.csv(output$data, file =  "csv/D1.long.csv", row.names = F, fileEncoding = "mac")

spp.list <- output$spp.list


dir.create(paste(output.folder, "data/", sep = ""), showWarnings = F)
dir.create(paste(output.folder, "data/match objects/", sep = ""), showWarnings = F)

save(m, file = paste(output.folder, "data/match objects/", m$data.ID, "m.RData", sep = ""))


# MERGE DATASETS

master <- updateMaster(master, data = output$data, spp.list = output$spp.list)
