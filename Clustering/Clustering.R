# Clustering
x = cus_info_merged %>% 
  filter(gen_cd=='Y' | gen_cd=='Z') %>% 
  select(orr_pr_tt_max, orr_pr_tt_med, orr_cyl, orr_num_mean) %>%
  mutate(orr_pr_tt_max=log(orr_pr_tt_max), orr_pr_tt_med=log(orr_pr_tt_med),
         orr_cyl=log(as.numeric(orr_cyl)+0.1), orr_num_mean=log(orr_num_mean+0.1))

fa(x, nfactors=2, rotate='varimax')

fa.varimax = fa(x, nfactors=2, rotate='varimax')
fa.diagram(fa.varimax)

fa.result = data.frame(fa.varimax$scores)

wss = 0
for(i in 1:10){
  wss[i] = sum(kmeans(fa.result, i)$withinss)
}
result = data.frame(cluster_num=1:10, withinss=wss)
result %>% 
  ggplot(aes(cluster_num, withinss)) + geom_point() + geom_line() +
  xlab('군집 갯수') + ylab('그룹 내 오차제곱합') + labs(title='최적 군집 갯수 선정')

set.seed(2020)
km.out = kmeans(fa.result, 4, nstart=20)

fa.result$Cluster = factor(km.out$cluster, levels=c(2, 1, 3, 4),
                           labels=c('Group 1', 'Group 2', 'Group 3', 'Group 4'))
fa.result = cbind(fa.result, cus_info_merged %>% 
                    filter(gen_cd=='Y' | gen_cd=='Z') %>% 
                    select(cus_id))

fa.result %>% 
  ggplot(aes(MR1, MR2, color=Cluster)) + geom_point() +
  geom_vline(xintercept=0) + geom_hline(yintercept=0) + xlab('MR1') + ylab('MR2') +
  labs(title='Y&Z세대 군집 분류', color='군집')

## cus_info_merged_yz
cus_info_merged_yz = merge(x=cus_info_merged %>% 
        filter(gen_cd=='Y' | gen_cd=='Z'), y=fa.result %>% 
        select(cus_id, Cluster), by='cus_id', all.x=TRUE)

## trd_kr_tmp_yz
trd_kr_tmp_yz = merge(x=trd_kr_tmp %>% 
                        filter(gen_cd=='Y' | gen_cd=='Z'), y=cus_info_merged_yz %>% 
                        select(cus_id, Cluster), by='cus_id', all.x=TRUE)

## trd_oss_tmp_yz
trd_oss_tmp_yz = merge(x=trd_oss_tmp %>% 
                        filter(gen_cd=='Y' | gen_cd=='Z'), y=cus_info_merged_yz %>% 
                        select(cus_id, Cluster), by='cus_id', all.x=TRUE)
