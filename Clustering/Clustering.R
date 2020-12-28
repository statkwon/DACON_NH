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
plot(1:10, wss, type='b', xlab='Number of Clusters', ylab='Within Group Sum of Squares')

set.seed(2020)
km.out = kmeans(fa.result, 4, nstart=20)

fa.result$Cluster = factor(km.out$cluster, levels=c(1, 2, 3, 4),
                           labels=c('가난자주', '가난가끔', '부자가끔', '부자자주'))

fa.result %>% 
  ggplot(aes(MR1, MR2, color=Cluster)) + geom_point() +
  geom_vline(xintercept=0) + geom_hline(yintercept=0) + xlab('MR1') + ylab('MR2') +
  labs(title='Y&Z세대 군집 분류', color='군집')

# EDA with Clsuters
cus_info_merged %>% 
  filter(gen_cd=='Y' | gen_cd=='Z') %>% 
  mutate(Cluster=factor(km.out$cluster, levels=c(1, 2, 3, 4),
                        labels=c('가난자주', '가난가끔', '부자가끔', '부자자주'))) %>% 
  ggplot(aes(~, group=Cluster, fill=Cluster)) + geom_boxplot(notch=TRUE) +
  scale_x_log10() + labs(title='군집별 비교 포맷', fill='군집')