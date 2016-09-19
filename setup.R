

### Packages ##############################################################

source(paste(script.folder, "pkgs.R", sep = ""))
if (!require("pacman")) install.packages("pacman")
pacman::p_load(pkgs, character.only = T)

