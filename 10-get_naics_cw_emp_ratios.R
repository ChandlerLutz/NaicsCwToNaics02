## c:/Dropbox/PublicData/NaicsCwToNaics97/10-get_naics_cw_emp_ratios.R

##    Chandler Lutz
##    Questions/comments: cl.eco@cbs.dk
##    $Revisions:      1.0.0     $Date:  2019-02-24

##Clear the workspace
##Delete all objects and detach packages
rm(list = ls())
suppressWarnings(CLmisc::detach_all_packages())

##Set working directory
wd <- "c:/Dropbox/PublicData/NaicsCwToNaics97/"
if (dir.exists(wd)) {
  setwd(wd)
} else {
  ##wd has the wrong path, Assume only the first folder (e.g. c) is wrong
  temp.wd <- getwd()
  base.folder <- substr(temp.wd, 1, 1)
  wd <- paste0(base.folder, substring(wd, 2))
  setwd(wd)
  rm(temp.wd, base.folder)
}
rm(wd)

suppressMessages({library(CLmisc); library(rvest); library(stringr)})

##See https://www.bls.gov/ces/cesnaics.htm

##Note that the BLS did not use the first naics, NAICS1997, but started with NAICS2002:
##see https://www.bls.gov/ces/cesnaics.htm#1


cw.naics.07.to.02.emp.ratios <- "https://www.bls.gov/ces/cesnaics07.htm" %>%
  read_html %>%
  html_nodes(xpath = '//*[@id="ratiotablesforwebd"]') %>%
  html_table(., fill = TRUE) %>%
  .[[1]] %>%
  setNames(c("naics07", "naics07.name", "naics02", "naics02.name", "emp.ratio")) %>%
  as.data.table %>%
  .[, emp.ratio := emp.ratio / 100] %>%
  .[, naics07 := str_extract(naics07, "[0-9]{6}$")] %>%
  .[, naics02 := str_extract(naics02, "[0-9]{6}$")]

cw.naics.12.to.07.emp.ratios <- "https://www.bls.gov/ces/cesnaics12.htm" %>%
  read_html %>%
  html_nodes(xpath = '//*[@id="for_web_naics_announcement"]') %>%
  html_table(., fill = TRUE) %>%
  .[[8]] %>%
  setNames(c("naics12", "naics12.name", "naics07", "naics07.name", "emp.ratio")) %>%
  as.data.table %>%
  .[, emp.ratio := emp.ratio / 100] %>%
  .[, naics12 := str_extract(naics12, "[0-9]{6}$")] %>%
  .[, naics07 := str_extract(naics07, "[0-9]{6}$")]



cw.naics.17.to.12.emp.ratios <- "https://www.bls.gov/ces/cesnaics17.htm" %>%
  read_html %>%
  html_nodes(xpath = '//*[@id="Revrat_AE_NAICS"]') %>%
  html_table(., fill = TRUE) %>%
  .[[1]] %>%
  setNames(c("naics17", "naics17.name", "naics12", "naics12.name", "emp.ratio")) %>%
  as.data.table %>%
  .[2:.N] %>%
  .[, emp.ratio := as.numeric(emp.ratio) / 100] %>%
  .[, naics17 := str_extract(naics17, "[0-9]{6}$")] %>%
  .[, naics12 := str_extract(naics12, "[0-9]{6}$")]


saveRDS(cw.naics.07.to.02.emp.ratios, "RdsFiles/10-cw_naics_07_to_02_emp_ratios.rds")
saveRDS(cw.naics.12.to.07.emp.ratios, "RdsFiles/10-cw_naics_12_to_07_emp_ratios.rds")
saveRDS(cw.naics.17.to.12.emp.ratios, "RdsFiles/10-cw_naics_17_to_12_emp_ratios.rds")

