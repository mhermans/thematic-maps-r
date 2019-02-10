library(dplyr)
library(readr)
library(assertr)
library(lubridate)
library(tidyr)
library(here)
library(readxl)
library(janitor)
library(readr)
library(BelgiumMaps.StatBel)
library(sf)

# read-in and clean muncipal income data
# ======================================
data("BE_ADMIN_MUNTY")
be_munip <- st_as_sf(BE_ADMIN_MUNTY)

read_excel(
  here::here('data/fisc2016_C_NL.xls'), sheet = 'Totaal', skip = 5) %>%
  clean_names() %>%
  select(administratieve_eenheid, nis_code, aantal_inwoners, x_8) %>%
  rename(munip_label = administratieve_eenheid, munip_nis = nis_code, 
         n_inhabitants = aantal_inwoners, income_mean = x_8) %>%
  filter(munip_nis %in% be_munip$CD_MUNTY_REFNIS) %>%
  mutate(
    n_inhabitants = as.integer(n_inhabitants),
    income_mean = as.integer(income_mean),
    munip_nis = as.character(munip_nis)) %>%
  verify(sum(income_mean) == 10883674) %>%
  write_csv(here::here('data/fiscal_incomes_2016.csv'))
rm(be_munip, BE_ADMIN_MUNTY)



pop.actief <- read_csv(
  #here::here('data/processed/pop_rsz_dibiss_actieven_2010-2017_long_verrijkt_overheidstype.csv'),
  file.path(Sys.getenv('PROJECTDIR_WORK'), 'ledenonderzoek', 'data/processed/pop_rsz_dibiss_actieven_2010-2017_long_verrijkt_overheidstype.csv'),
  col_types = cols(
    maand = col_character(),
    woonplaats_gemeente_nis = col_character(),
    woonplaats_gemeente_label = col_character(),
    paritair_subcomite = col_character(),
    statuut = col_character(),
    geslacht = col_character(),
    leeftijdsklasse = col_character(),
    aantal = col_integer(),
    overheidstype_code = col_character(),
    overheidsgroep_code = col_character(),
    overheidsgroep_label = col_character(),
    overheidstype_label = col_character(),
    databron = col_character(),
    paritair_comite = col_integer(),
    woonplaats_binnenland = col_character(),
    woonplaats_arrond_nis = col_character(),
    woonplaats_provincie_nis = col_character(),
    woonplaats_regio_nis = col_character(),
    woonplaats_regio_nis_lbl = col_character(),
    leeftijdsklasse_c3 = col_character(),
    paritair_comite_overheidstype = col_character(),
    acv_centrale_code = col_character(),
    acv_centrale_lbl = col_character(),
    woonplaats_gemeente_nis_be = col_character(),
    woonplaats_gemeente_verbond_2016_lbl = col_character() )) %>%
  verify(dim(.) == c( 5589937, 25)) %>%
  verify(sum(aantal) == 30743184) %>%
  mutate(datum = ymd(paste0(maand, '15')))

pop.actief %>% glimpse()

d.statuut <- pop.actief %>%
  filter(maand == '201706') %>%
  filter(woonplaats_binnenland == 'binnenland') %>%
  group_by(woonplaats_gemeente_nis, statuut) %>%
  tally(aantal) %>%
  spread(statuut, n) %>%
  mutate(totaal = ambtenaar + arbeider + bediende) %>%
  mutate(pct_arbeider = arbeider / totaal)

