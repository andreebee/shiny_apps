
library("tidyverse")

################################################################################

set.seed(1)
Gruppe1 <- rnorm(1250)   
set.seed(2)
Gruppe2 <- rnorm(1250)

p_val <- function(a,b,c) { t.test((Gruppe1[1:c]*b),(Gruppe2[1:c]*b+a), alternative = "two.sided")$p.value }

p_val(1,5,200)

variables <- list(
  d = seq(0,10,0.5),
  sd = seq(1,20,1),
  n = seq(100,1250,1)
  )
df <- expand.grid(variables)

m_g1 <- apply(df,1,FUN = function(x) {
  round(mean(Gruppe1[1:x[3]]*x[2]),3)})

m_g2 <- apply(df,1,FUN = function(x) {
  round(mean(Gruppe2[1:x[3]]*x[2]+x[1]),3)})

d_g1 <- apply(df,1,FUN = function(x) {
  round(sd(Gruppe1[1:x[3]]*x[2]),2)})

d_g2 <- apply(df,1,FUN = function(x) {
  round(sd(Gruppe2[1:x[3]]*x[2]+x[1]),3)})

p <- apply(df,1,FUN = function(x) {
  round(t.test(
    (Gruppe1[1:x[3]]*x[2]),
    (Gruppe2[1:x[3]]*x[2]+x[1]),
    alternative="two.sided")$p.value,3)})

df <- cbind(df,p,m_g1,m_g2,d_g1,d_g2)

################################################################################

write.csv(df,"t_Test_ohne_submit/df.csv", row.names = FALSE)

################################################################################

df <- read.csv("t_Test_ohne_submit/df.csv")

################################################################################

df_orderby_dnsd <- df[order(df$d,df$n,-df$sd),]

df_orderby_dnsd <- df_orderby_dnsd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_dnsd)]))

df_orderby_dnsd$t <- ifelse(df_orderby_dnsd$pp >= df_orderby_dnsd$p,0,1)

d_n <- df_orderby_dnsd %>%
  group_by(d,n) %>%
  summarise(dn=sum(t))

d_n %>% ggplot() +
  geom_point(mapping = aes(n,dn,colour = factor(d)))

################################################################################

df_orderby_sdnd <- df[order(-df$sd,df$n,df$d),]

df_orderby_sdnd <- df_orderby_sdnd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_sdnd)]))

df_orderby_sdnd$t <- ifelse(df_orderby_sdnd$pp >= df_orderby_sdnd$p,0,1)

sd_n <- df_orderby_sdnd %>%
  group_by(sd,n) %>%
  summarise(sdn=sum(t))

sd_n %>% ggplot() +
  geom_point(mapping = aes(n,sdn,colour = factor(sd)))

################################################################################

df_orderby_dsd <- df[order(df$d,-df$sd,df$n),]

df_orderby_dsd <- df_orderby_dsd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_dsd)]))

df_orderby_dsd$t <- ifelse(df_orderby_dsd$pp >= df_orderby_dsd$p,0,1)

d_sd <- df_orderby_dsd %>%
  group_by(d,sd) %>%
  summarise(dsd=sum(t))

d_sd %>% ggplot() +
  geom_point(mapping = aes(d,dsd,colour = factor(sd)))

d_sd %>% ggplot() +
  geom_point(mapping = aes(sd,dsd,colour = factor(d)))

################################################################################