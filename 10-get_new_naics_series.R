## c:/Dropbox/PublicData/NaicsCwToNaics97/10-get_new_naics_series.R

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

##Note that the BLS did not use the first naics, NAICS1997, but started with NAICS2002:
##see https://www.bls.gov/ces/cesnaics.htm#1


naics.new.2007 <- "https://www.bls.gov/ces/cesnaics07.htm" %>%
  read_html %>%
  html_nodes(xpath = '//*[@id="naics07webtablesnew"]') %>%
  html_table(., fill = TRUE) %>%
  .[[1]] %>%
  as.data.table %>%
  setnames("CES NAICS 2007 Tabcode", "new.naics.code") %>%
  .[, new.naics.code := str_extract(new.naics.code, "[0-9]{6}$")] %>%
  .[, .(year = 2007, new.naics.code)]

naics.new.2012 <- "https://www.bls.gov/ces/cesnaics12.htm" %>%
  read_html %>%
  html_nodes(xpath = '//*[@id="for_web_naics_announcement"]') %>%
  html_table(., fill = TRUE) %>%
  .[[1]] %>%
  as.data.table %>%





