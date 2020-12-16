# Load Library
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

# Data Preprocessing for EDA
act_info = act_info %>%
  mutate(act_opn_ym=ym(act_opn_ym))
act_info = act_info %>%
  filter(is.na(act_opn_ym)==FALSE)
act_info = merge(x=act_info, y=act_info %>%
                   count(cus_id, name='act_num'), by='cus_id', all.x=TRUE)

cus_info = cus_info %>%
  mutate(gen_cd=ifelse(cus_age >= 40, 'X',
                       ifelse(cus_age >= 30, 'Y',
                              ifelse(cus_age >=20 & cus_age < 30, 'Z', 'M'))))

iem_info = iem_info %>%
  mutate(iem_cd=str_trim(iem_cd, side='right'),
         iem_eng_nm=str_trim(iem_eng_nm, side='right'),
         iem_krl_nm=str_trim(iem_krl_nm, side='right'))

trd_kr = trd_kr %>%
  mutate(iem_cd=str_trim(iem_cd, side='right'))
trd_kr = trd_kr %>%
  mutate(orr_dt=ymd(orr_dt))
trd_kr = trd_kr %>%
  mutate(orr_pr_tt=orr_pr*cns_qty)

trd_oss = trd_oss %>%
  mutate(iem_cd=str_trim(iem_cd, side='right'))
trd_oss = trd_oss %>%
  mutate(orr_dt=ymd(orr_dt))
trd_oss = trd_oss %>%
  mutate(orr_pr_krw=orr_pr*trd_cur_xcg_rt,
         orr_pr_tt=orr_pr_krw*cns_qty)

trd_kr_merged = merge(x=trd_kr, y=act_info, by='act_id', all.x=TRUE)
trd_kr_merged = merge(x=trd_kr_merged, y=cus_info, by='cus_id', all.x=TRUE)
trd_kr_merged = merge(x=trd_kr_merged, y=iem_info, by='iem_cd', all.x=TRUE)
trd_kr_merged = merge(x=trd_kr_merged, y=wics, by='iem_cd', all.x=TRUE)
trd_kr_merged = trd_kr_merged %>%
  filter(gen_cd!='M')
trd_kr_merged = trd_kr_merged %>%
  mutate(tco_cus_grd_cd=ifelse(tco_cus_grd_cd %in% c('_', '09'), '06', tco_cus_grd_cd))

trd_oss_merged = merge(x=trd_oss, y=act_info, by='act_id', all.x=TRUE)
trd_oss_merged = merge(x=trd_oss_merged, y=cus_info, by='cus_id', all.x=TRUE)
trd_oss_merged = merge(x=trd_oss_merged, y=iem_info, by='iem_cd', all.x=TRUE)
trd_oss_merged = merge(x=trd_oss_merged, y=wics, by='iem_cd', all.x=TRUE)
trd_oss_merged = trd_oss_merged %>%
  filter(gen_cd!='M')
trd_oss_merged = trd_oss_merged %>%
  mutate(tco_cus_grd_cd=ifelse(tco_cus_grd_cd %in% c('_', '09'), '06', tco_cus_grd_cd))

trd_info = rbind(trd_kr_merged %>%
                   mutate(orr_pr_krw=NA, cur_cd=NA, trd_cur_xcg_rt=NA), trd_oss_merged)
trd_info = trd_info %>%
  mutate(kr_oss_cd=ifelse(is.na(orr_pr_krw), 'KR', 'OSS'))
trd_info = trd_info %>%
  filter(gen_cd!='M')
trd_info = trd_info %>%
  mutate(tco_cus_grd_cd=ifelse(tco_cus_grd_cd %in% c('_', '09'), '06', tco_cus_grd_cd))

cus_info = cus_info %>%
  filter(gen_cd!='M')
cus_info = cus_info %>%
  mutate(tco_cus_grd_cd=ifelse(tco_cus_grd_cd %in% c('_', '09'), '06', tco_cus_grd_cd))

cus_info_merged = merge(x=cus_info, y=trd_info %>%
                          group_by(cus_id) %>%
                          summarize(orr_dt_rct=max(orr_dt)), by='cus_id', all.x=TRUE)
cus_info_merged = cus_info_merged %>%
  mutate(orr_brk_prd=interval(orr_dt_rct, '2020-06-30')/ddays(1))
cus_info_merged = merge(x=cus_info_merged, y=act_info %>%
                          group_by(cus_id) %>%
                          summarize(act_opn_ym_1st=min(act_opn_ym)),
                        by='cus_id', all.x=TRUE)
cus_info_merged = cus_info_merged %>%
  mutate(orr_prd=interval(act_opn_ym_1st, '2020-06-30')/ddays(1))
cus_info_merged = merge(x=cus_info_merged, y=act_info %>%
                          dplyr::select(cus_id, act_num), by='cus_id', all.x=TRUE)

trd_kr_tmp = trd_kr_merged %>%
  group_by(cus_id, orr_dt) %>%
  count(iem_cd, iem_krl_nm, iem_eng_nm, cat_1, cat_2, cat_3, sby_dit_cd, act_opn_ym, act_num, sex_dit_cd,
        cus_age, zip_ctp_cd, tco_cus_grd_cd, gen_cd, name='orr_cnt')

trd_oss_tmp = trd_oss_merged %>%
  group_by(cus_id, orr_dt) %>%
  count(iem_cd, iem_krl_nm, iem_eng_nm, cat_1, cat_2, cat_3, sby_dit_cd, act_opn_ym, act_num, sex_dit_cd,
        cus_age, zip_ctp_cd, tco_cus_grd_cd, gen_cd, name='orr_cnt')

## 투자 위험 종목(미완)
trd_kr_merged %>%
  filter(iem_cd=='A053660') %>%
  View()

warn_2019_info = readxl::read_xls('./Data/warn_2019_info.xls')
warn_2020_info = readxl::read_xls('./Data/warn_2020_info.xls')
warn_info = rbind(warn_2019_info, warn_2020_info)

warn_info = warn_info %>%
  mutate(iem_cd=paste('A', 종목코드, sep=''), dsg_dt=ymd(지정일), iem_krl_nm=종목명) %>%
  dplyr::select(iem_cd, dsg_dt)

trd_kr_merged = merge(x=trd_kr_merged, y=warn_info, by='iem_cd', all.x=TRUE)

# 보류
trd_oss_tmp %>%
  filter(cat_1=='ETF') %>%
  group_by(gen_cd) %>%
  count(cat_3, name='cat_cnt') %>%
  ggplot(aes(cat_3, cat_cnt)) + geom_bar(stat='identity') +
  facet_wrap(~gen_cd, scales='free') + xlab('소분류') + ylab('cat_cnt') +
  labs(title='세대별 ETF 종류 분포')

trd_oss_tmp %>%
  filter(cat_1=='ETF') %>%
  group_by(orr_dt, gen_cd) %>%
  count(cat_1, name='cat_cnt') %>%
  ggplot(aes(orr_dt, cat_cnt, color=gen_cd)) + geom_line() +
  facet_wrap(~gen_cd, scales='free', nrow=3) + xlab('거래일') + ylab('거래횟수') +
  labs('세대별 해외 ETF 거래횟수 추이')

trd_oss_tmp %>%
  filter(cat_1=='ETF') %>%
  group_by(gen_cd) %>%
  count(iem_krl_nm, name='cat_cnt') %>%
  top_n(5) %>%
  ggplot(aes(reorder_within(iem_krl_nm, cat_cnt, gen_cd), cat_cnt, fill=gen_cd)) +
  geom_bar(stat='identity', position='stack') + coord_flip() + 
  facet_wrap(~gen_cd, scales='free') + scale_x_reordered() +
  labs(title='Y&Z세대 해외 ETF 종류 분포', fill='세대') +
  xlab('종목명') + ylab('인원(명)')

trd_oss_merged %>%
  filter(cat_3=='ETF(1배)') %>%
  distinct(iem_krl_nm, iem_cd) %>%
  View()
