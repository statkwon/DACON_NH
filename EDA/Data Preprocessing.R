# Load Library
library(psych)
library(tidytext)
library(tidyverse)
library(lubridate)
library(gridExtra)
library(extrafont)
library(data.table)
library(operator.tools)
theme_set(theme_gray(base_family='NanumGothic'))

# Load Data
act_info = fread('./Raw_Data/2_act_info.csv')
cus_info = fread('./Raw_Data/2_cus_info.csv')
iem_info = fread('./Raw_Data/2_iem_info.csv')
trd_kr = fread('./Raw_Data/2_trd_kr.csv')
trd_oss = fread('./Raw_Data/2_trd_oss.csv')
wics = fread('./Data/wics.csv')
kospi = fread('./Data/kospi.csv')

# Data Preprocessing for EDA
act_info = act_info %>% 
  filter(act_opn_ym!=0)
act_info = act_info %>% 
  mutate(act_opn_ym=ym(act_opn_ym))

cus_info = cus_info %>% 
  filter(cus_age!=0)
cus_info = cus_info %>% 
  mutate(gen_cd=ifelse(cus_age >= 40, 'X',
                       ifelse(cus_age >= 30, 'Y', 'Z')))
cus_info = cus_info %>% 
  mutate(tco_cus_grd_cd=ifelse(tco_cus_grd_cd %in% c('_', '09'), '06', tco_cus_grd_cd))

iem_info = iem_info %>% 
  mutate(iem_cd=str_trim(iem_cd, side='right'),
         iem_eng_nm=str_trim(iem_eng_nm, side='right'),
         iem_krl_nm=str_trim(iem_krl_nm, side='right'))

trd_kr = trd_kr %>% 
  mutate(iem_cd=str_trim(iem_cd, side='right'))
trd_kr = trd_kr %>% 
  mutate(orr_dt=ymd(orr_dt))
trd_kr = trd_kr %>% 
  mutate(orr_ymdh=ymd_h(paste(orr_dt, orr_rtn_hur, sep='-')))
trd_kr = trd_kr %>% 
  mutate(orr_pr_tt=orr_pr*cns_qty)
trd_kr = trd_kr %>% 
  mutate(orr_fee=orr_pr_tt*0.0001) %>% 
  mutate(orr_fee=ifelse(orr_fee>=10, orr_fee, 0))

trd_oss = trd_oss %>% 
  mutate(iem_cd=str_trim(iem_cd, side='right'))
trd_oss = trd_oss %>% 
  mutate(orr_dt=ymd(orr_dt))
trd_oss = trd_oss %>% 
  mutate(orr_ymdh=ymd_h(paste(orr_dt, orr_rtn_hur, sep='-')))
trd_oss = trd_oss %>% 
  mutate(orr_pr=orr_pr*trd_cur_xcg_rt,
         orr_pr_tt=orr_pr*cns_qty)
trd_oss = trd_oss %>% 
  mutate(orr_fee=orr_pr_tt*0.0025)

kospi = kospi %>% 
  mutate(orr_dt=ymd(orr_dt))

trd_kr_merged = merge(x=trd_kr, y=act_info, by='act_id', all.x=TRUE)
trd_kr_merged = merge(x=trd_kr_merged, y=cus_info, by='cus_id', all.x=TRUE)
trd_kr_merged = merge(x=trd_kr_merged, y=iem_info, by='iem_cd', all.x=TRUE)
trd_kr_merged = merge(x=trd_kr_merged, y=wics, by='iem_cd', all.x=TRUE)
trd_kr_merged = trd_kr_merged %>% 
  filter(!is.na(gen_cd))

trd_oss_merged = merge(x=trd_oss, y=act_info, by='act_id', all.x=TRUE)
trd_oss_merged = merge(x=trd_oss_merged, y=cus_info, by='cus_id', all.x=TRUE)
trd_oss_merged = merge(x=trd_oss_merged, y=iem_info, by='iem_cd', all.x=TRUE)
trd_oss_merged = merge(x=trd_oss_merged, y=wics, by='iem_cd', all.x=TRUE)
trd_oss_merged = trd_oss_merged %>% 
  filter(!is.na(gen_cd))

trd_info = rbind(trd_kr_merged %>% 
                   mutate(cur_cd=NA, trd_cur_xcg_rt=NA), trd_oss_merged)
trd_info = trd_info %>% 
  mutate(kr_oss_cd=ifelse(is.na(cur_cd), 'KR', 'OSS'))

cus_info_merged = merge(x=cus_info, y=act_info %>% 
                          group_by(cus_id) %>% 
                          summarize(act_opn_ym_1st=min(act_opn_ym)),
                        by='cus_id', all.x=TRUE)
cus_info_merged = merge(x=cus_info_merged, y=trd_info %>% 
                          group_by(cus_id) %>% 
                          summarize(orr_dt_rct=max(orr_ymdh)), by='cus_id', all.x=TRUE)
cus_info_merged = cus_info_merged %>% 
  mutate(orr_brk_prd=(ymd_h('2020-07-01-0')-orr_dt_rct))
cus_info_merged = merge(x=cus_info_merged, y=trd_info %>%
                          group_by(cus_id) %>%
                          distinct(orr_ymdh) %>%
                          arrange(cus_id, orr_ymdh) %>%
                          group_by(cus_id) %>%
                          mutate(diff=orr_ymdh-lag(orr_ymdh)) %>% 
                          summarize(orr_cyl=round(median(diff, na.rm=TRUE))) %>% 
                          mutate(orr_cyl=round(orr_cyl/3600, 2)), by='cus_id', all.x=TRUE)
cus_info_merged = cus_info_merged %>% 
  mutate(orr_cyl=ifelse(is.na(orr_cyl), orr_brk_prd, orr_cyl))
cus_info_merged = merge(x=cus_info_merged, y=trd_info %>% 
                          group_by(cus_id) %>% 
                          summarize(orr_ymdh_max=max(orr_ymdh), orr_ymdh_min=min(orr_ymdh)) %>% 
                          mutate(orr_prd=(orr_ymdh_max-orr_ymdh_min)/3600+1) %>% 
                          select(cus_id, orr_prd), by='cus_id', all.x=TRUE)
cus_info_merged = merge(x=cus_info_merged, y=trd_info %>% 
                          group_by(cus_id) %>% 
                          distinct(orr_ymdh) %>% 
                          count(name='orr_num'), by='cus_id', all.x=TRUE)
cus_info_merged = cus_info_merged %>% 
  mutate(orr_exp_num=round(orr_prd/orr_cyl, 2)) %>% 
  mutate(orr_idx_1=round(orr_brk_prd/orr_cyl, 2), orr_idx_2=round(orr_exp_num/orr_num, 2)) %>% 
  mutate(run_away_cd=ifelse(orr_brk_prd >= 1464 & orr_idx_1>=100 & orr_idx_2>=2, 1, 0))
cus_info_merged = merge(x=cus_info_merged, y=trd_info %>% 
                          mutate(orr_dt_ym=ym(paste(year(orr_dt), month(orr_dt), sep=''))) %>% 
                          group_by(cus_id, orr_dt_ym) %>% 
                          summarize(orr_fee_sum=sum(orr_fee)) %>% 
                          group_by(cus_id) %>% 
                          summarize(orr_fee_mean=mean(orr_fee_sum)), by='cus_id', all.x=TRUE)

trd_kr_tmp = trd_kr_merged %>% 
  distinct(cus_id, orr_dt, sby_dit_cd, iem_cd, iem_krl_nm, cat_1, cat_2, cat_3,
           cus_age, gen_cd, sex_dit_cd, tco_cus_grd_cd) %>% 
  arrange(cus_id, orr_dt, sby_dit_cd, iem_cd, iem_krl_nm, cat_1, cat_2, cat_3,
          cus_age, gen_cd, sex_dit_cd, tco_cus_grd_cd)

trd_oss_tmp = trd_oss_merged %>% 
  distinct(cus_id, orr_dt, sby_dit_cd, iem_cd, iem_krl_nm, cat_1, cat_2, cat_3,
           cus_age, gen_cd, sex_dit_cd, tco_cus_grd_cd) %>% 
  arrange(cus_id, orr_dt, sby_dit_cd, iem_cd, iem_krl_nm, cat_1, cat_2, cat_3,
          cus_age, gen_cd, sex_dit_cd, tco_cus_grd_cd)

trd_info_tmp = trd_info %>% 
  distinct(cus_id, orr_dt, sby_dit_cd, iem_cd, iem_krl_nm, kr_oss_cd, cat_1, cat_2,
           cat_3, cus_age, gen_cd, sex_dit_cd, tco_cus_grd_cd) %>% 
  arrange(cus_id, orr_dt, sby_dit_cd, iem_cd, iem_krl_nm, kr_oss_cd, cat_1, cat_2,
          cat_3, cus_age, gen_cd, sex_dit_cd, tco_cus_grd_cd)