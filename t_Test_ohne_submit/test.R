# finding two populations and steps for slider inputs which a decrease or an increase
# in difference, standard deviation and sample size leads an expected decrease or increase
# in the p value of the t test

library("tidyverse")

# creating Gruppe1 with n=250 of a population with m=0 sd=1
seed_1 <- 1
set.seed(seed_1)
Gruppe1 <- rnorm(n=250,m=0,sd=1)   
mean(Gruppe1)
sd(Gruppe1)

# creating Gruppe2 with n=250 of a population with m=0 sd=1
seed_2 <- 2000000
set.seed(seed_2)
Gruppe2 <- rnorm(n=250,m=0,sd=1)
mean(Gruppe2)
sd(Gruppe2)

# checking if the m and sd of Gruppe2 are equal to the m and sd of Gruppe1 or not
round(mean(Gruppe1),3) == round(mean(Gruppe2),3)
round(sd(Gruppe1),3) == round(sd(Gruppe2),3)

# finding a seed when the m and sd of Gruppe2 are equal to the m and sd of Gruppe1
while ((round(mean(Gruppe1),3) != round(mean(Gruppe2),3)) | (round(sd(Gruppe1),3) != round(sd(Gruppe2),3))) {
  set.seed(seed_2)
  Gruppe2 <- rnorm(n=250,m=0,sd=1)
  seed_2 <- seed_2 + 1 
}

# replacing Gruppe2 with a sample which its m and sd are equal to the m and sd of Gruppe1
seed_2 <- seed_2-1
set.seed(seed_2)
Gruppe2 <- rnorm(n=250,m=0,sd=1)
mean(Gruppe2)
sd(Gruppe2)

# checking afain if the m and sd of Gruppe2 are equal to the m and sd of Gruppe1 or not
round(mean(Gruppe1),3) == round(mean(Gruppe2),3)
round(sd(Gruppe1),3) == round(sd(Gruppe2),3)

# finding 20 samples with 50 rows and same m and sd to add to Gruppe1
g1_attach <- {}
j <- 1
i <- 2
while (j<21 & i<2000000) {
  set.seed(i)
  g1_attach[[j]] <- rnorm(n=50,m=0,sd=1)
  if (
    (round(mean(Gruppe1),3) == round(mean(g1_attach[[j]]),3)) & (round(sd(Gruppe1),3) == round(sd(g1_attach[[j]]),3))
  ){
    j <- j+1
    i <- i+1
  } else {
    i <- i+1
    print(i)
  }
}

# finding 20 samples with 50 rows and same m and sd to add to Gruppe2
g2_attach <- {}
j <- 1
i <- 3000000
while (j<21 & i<6000000) {
  set.seed(i)
  g2_attach[[j]] <- rnorm(n=50,m=0,sd=1)
  if (
    (round(mean(Gruppe2),3) == round(mean(g2_attach[[j]]),3)) & (round(sd(Gruppe2),3) == round(sd(g2_attach[[j]]),3))
  ){
    j <- j+1
    i <- i+1
  } else {
    i <- i+1
    print(i)
  }
}

# adding 20 samples to Gruppe1
Gruppe1 <- c(Gruppe1,unlist(g1_attach))
mean(Gruppe1)
sd(Gruppe1)
# adding 20 samples to Gruppe2
Gruppe2 <- c(Gruppe2,unlist(g2_attach))
mean(Gruppe2)
sd(Gruppe2)

# save Gruppe1 and Gruppe2
write.csv(Gruppe1,"t_Test_ohne_submit/Gruppe1.csv", row.names = FALSE)
write.csv(Gruppe2,"t_Test_ohne_submit/Gruppe2.csv", row.names = FALSE)

# load Gruppe1 and Gruppe2
Gruppe1 <- read.csv("t_Test_ohne_submit/Gruppe1.csv")$x
Gruppe2 <- read.csv("t_Test_ohne_submit/Gruppe2.csv")$x

# a function to get the p value of a t-test for samples from Gruppe1 and Gruppe2
p_val <- function(a,b,c) {
  t.test((Gruppe1[1:c]*b),(Gruppe2[1:c]*b+a), alternative = "two.sided")$p.value }

# check a combination which p value is around 0.5 and by decreasing or increasing m, sd or n the h0 will be accepted or rejected 
p_val(1,8,500)

# save all combinations of slider inputs
variables <- list(
  d = seq(0,2,0.1),
  sd = seq(1,15,1),
  n = seq(250,1250,50)
)
df <- expand.grid(variables)

# calculate p value for all combinations of slider inputs
p <- apply(df,1,FUN = function(x) {
  round(t.test(
    (Gruppe1[1:x[3]]*x[2]),
    (Gruppe2[1:x[3]]*x[2]+x[1]),
    alternative="two.sided")$p.value,3)})
df <- cbind(df,p)

# sort the slider inputs combinations based on difference, standard deviation and sample size

df_orderby_dnsd <- df[order(df$d,df$n,-df$sd),]
df_orderby_dnsd <- df_orderby_dnsd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_dnsd)]))

df_orderby_sdnd <- df[order(-df$sd,df$n,df$d),]
df_orderby_sdnd <- df_orderby_sdnd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_sdnd)]))

df_orderby_dsd <- df[order(df$d,-df$sd,df$n),]
df_orderby_dsd <- df_orderby_dsd %>% 
  transform(pp = c(NA,p[-nrow(df_orderby_dsd)]))

# calculate if we get expected increase or decrease in the p value

df_orderby_dnsd$t <- ifelse(df_orderby_dnsd$pp >= df_orderby_dnsd$p,0,1)

df_orderby_sdnd$t <- ifelse(df_orderby_sdnd$pp >= df_orderby_sdnd$p,0,1)

df_orderby_dsd$t <- ifelse(df_orderby_dsd$pp >= df_orderby_dsd$p,0,1)

# create visualizations to see the number of unexpected increase or decrease in the p value

d_n <- df_orderby_dnsd %>%
  group_by(d,n) %>%
  summarise(dn=sum(t))

d_n %>% ggplot() +
  geom_point(mapping = aes(n,dn,colour = factor(d)))

sd_n <- df_orderby_sdnd %>%
  group_by(sd,n) %>%
  summarise(sdn=sum(t))

sd_n %>% ggplot() +
  geom_point(mapping = aes(n,sdn,colour = factor(sd)))

d_sd <- df_orderby_dsd %>%
  group_by(d,sd) %>%
  summarise(dsd=sum(t))

d_sd %>% ggplot() +
  geom_point(mapping = aes(d,dsd,colour = factor(sd)))

d_sd %>% ggplot() +
  geom_point(mapping = aes(sd,dsd,colour = factor(d)))
