# packages #####################################################################

library("tidyverse")

# visualization ################################################################

set.seed(1)
Gruppe1 <- rnorm(1000)   
set.seed(2)
Gruppe2 <- rnorm(1000)

p_val <- function(a,b,c) {
  t.test((Gruppe1[1:c]*b),(Gruppe2[1:c]*b+a), alternative = "two.sided")$p.value }

p_val(1,5,200)

variables <- list(
  d = seq(0,2,0.1),
  sd = c(0.1,seq(1,10,1)),
  n = seq(50,1000,1)
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

## write / read csv ############################################################

write.csv(df,"t_Test_ohne_submit/df.csv", row.names = FALSE)

df <- read.csv("t_Test_ohne_submit/df.csv")

## ggplot ######################################################################

### 1 ##########################################################################

df_orderby_dnsd <- df[order(df$d,df$n,-df$sd),]

df_orderby_dnsd <- df_orderby_dnsd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_dnsd)]))

df_orderby_dnsd$t <- ifelse(df_orderby_dnsd$pp >= df_orderby_dnsd$p,0,1)

d_n <- df_orderby_dnsd %>%
  group_by(d,n) %>%
  summarise(dn=sum(t))

d_n %>% ggplot() +
  geom_point(mapping = aes(n,dn,colour = factor(d)))

### 2 ##########################################################################

df_orderby_sdnd <- df[order(-df$sd,df$n,df$d),]

df_orderby_sdnd <- df_orderby_sdnd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_sdnd)]))

df_orderby_sdnd$t <- ifelse(df_orderby_sdnd$pp >= df_orderby_sdnd$p,0,1)

sd_n <- df_orderby_sdnd %>%
  group_by(sd,n) %>%
  summarise(sdn=sum(t))

sd_n %>% ggplot() +
  geom_point(mapping = aes(n,sdn,colour = factor(sd)))

### 3 ##########################################################################

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

# try different seeds ##########################################################

for (i in seq(1,50,1)) {
  set.seed(i)
  Gruppe1 <- rnorm(1250)
  set.seed(i+1)
  Gruppe2 <- rnorm(1250)
  
  p_val <- function(a,b,c) {
    t.test((Gruppe1[1:c]*b),(Gruppe2[1:c]*b+a), alternative = "two.sided")$p.value }
  
  variables <- list(
    d = seq(0,5,0.5),
    sd = seq(1,15,1),
    n = seq(250,1250,50)
  )
  df <- expand.grid(variables)
  
  p <- apply(df,1,FUN = function(x) {
    round(t.test(
      (Gruppe1[1:x[3]]*x[2]),
      (Gruppe2[1:x[3]]*x[2]+x[1]),
      alternative="two.sided")$p.value,3)})
  
  df <- cbind(df,p)
  
  df_orderby <- df[order(df$d,-df$sd,df$n),]
  
  df_orderby <- df_orderby %>% 
    transform(pp = c(NA,p[-nrow(df_orderby)]))
  
  df_orderby$t <- ifelse(df_orderby$pp >= df_orderby$p,0,1)
  
  db <- df_orderby %>%
    group_by(d,sd) %>%
    summarise(dsd=sum(t),
              nn=n())
  if (max(db$dsd,na.rm = TRUE) <= 2) {
    j <- i
  }
}

# adding 50 data points ########################################################

seed_1 <- 1
set.seed(seed_1)
Gruppe1 <- rnorm(n=250,m=0,sd=1)   
mean(Gruppe1)
sd(Gruppe1)

seed_2 <- 1002673
set.seed(seed_2)
Gruppe2 <- rnorm(n=250,m=0,sd=1)
mean(Gruppe2)
sd(Gruppe2)

round(mean(Gruppe1),3) == round(mean(Gruppe2),3)
round(sd(Gruppe1),3) == round(sd(Gruppe2),3)

while ((round(mean(Gruppe1),3) != round(mean(Gruppe2),3)) | (round(sd(Gruppe1),3) != round(sd(Gruppe2),3))) {
  set.seed(seed_2)
  Gruppe2 <- rnorm(n=250,m=0,sd=1)
  seed_2 <- seed_2 + 1 
}

print(seed_2-1)

# g1_attach <- {}
# j <- 1
# i <- 2
# while (j<22 & i<1000000) {
#   set.seed(i)
#   g1_attach[[j]] <- rnorm(n=50,m=0,sd=1)
#   if (
#     (round(mean(Gruppe1),3) == round(mean(g1_attach[[j]]),3)) & (round(sd(Gruppe1),3) == round(sd(g1_attach[[j]]),3))
#   ){
#     j <- j+1
#     i <- i+1
#   } else {
#     i <- i+1
#     print(i)
#   }
# }

# g2_attach <- {}
# j <- 1
# i <- 1002674
# while (j<22 & i<2002674) {
#   set.seed(i)
#   g2_attach[[j]] <- rnorm(n=50,m=0,sd=1)
#   if (
#     (round(mean(Gruppe2),3) == round(mean(g2_attach[[j]]),3)) & (round(sd(Gruppe2),3) == round(sd(g2_attach[[j]]),3))
#   ){
#     j <- j+1
#     i <- i+1
#   } else {
#     i <- i+1
#     print(i)
#   }
# }

Gruppe1 <- c(Gruppe1,unlist(g1_attach))
mean(Gruppe1)
sd(Gruppe1)
Gruppe2 <- c(Gruppe2,unlist(g2_attach))
mean(Gruppe2)
sd(Gruppe2)

write.csv(Gruppe1,"t_Test_ohne_submit/Gruppe1.csv", row.names = FALSE)
write.csv(Gruppe2,"t_Test_ohne_submit/Gruppe2.csv", row.names = FALSE)

Gruppe1 <- read.csv("t_Test_ohne_submit/Gruppe1.csv")$x
Gruppe2 <- read.csv("t_Test_ohne_submit/Gruppe2.csv")$x

p_val <- function(a,b,c) {
  t.test((Gruppe1[1:c]*b),(Gruppe2[1:c]*b+a), alternative = "two.sided")$p.value }

p_val(1,8,500)

variables <- list(
  d = seq(0,2,0.5),
  sd = seq(1,20,1),
  n = seq(250,800,50)
)

df <- expand.grid(variables)

p <- apply(df,1,FUN = function(x) {
  round(t.test(
    (Gruppe1[1:x[3]]*x[2]),
    (Gruppe2[1:x[3]]*x[2]+x[1]),
    alternative="two.sided")$p.value,3)})

df <- cbind(df,p)
