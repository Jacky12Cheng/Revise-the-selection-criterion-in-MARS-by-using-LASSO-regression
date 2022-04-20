
x  <- runif(1000,-5,5)
y <- sin(x)+ 0.5*x + rnorm(1000,0,0.2)

plot(x,y)

realx <- seq(-5,5,length.out = 1000)
realy <- sin(realx )+ 0.5*realx 
plot(realx,realy)
plot(x, y, col = "cornflowerblue", pch = 20, main = "MARS--pruned(backward)",xlab ="", ylab="")
lines(realx,realy , col = "black", lwd = 3)
lines(realx, y_pred2 , col = "red", lwd = 3)
lines(realx, y_hat , col = "red", lwd = 3)
##########
#MARS
##########


library(earth)
library(glmnet)

mar_sim1 <- earth(y ~ x , pmethod = "none")
mar_sim1 <- earth(y ~ x , nk = 50, thresh = 0.000001, pmethod = "backward")
summary(mar_sim1, style = "max")
summary(mar_sim1, decomp = "none")
#plotmo(mar_sim1, caption="", col = "red", lwd = 3, col.response="blue", pch = 20, clip=0, xlab="x", ylab="y", main="")

plotmo(mar_sim1, col = "red", col.response="black", pch = 20, lwd = 3, xlab="x", ylab="y", main="")

plot(mar_sim1)
print(mar_sim1)

y_hat <- predict(mar_sim1, realx )

y_pred <- c()

for (i in 1:length(realx)){
  y_pred[i] =(
    -1.7
  + 0.25 * max(0, -2.6 -    realx[i]) 
  - 0.17 * max(0,    realx[i] - -2.6) 
  +  1.5 * max(0,    realx[i] - -1.5) 
  - 0.76 * max(0,    realx[i] -  1.2) 
  - 0.91 * max(0,    realx[i] -    2) 
  + 0.67 * max(0,    realx[i] -  4.1) )
}


rss <- sum((y - mar_sim1$fitted.values)^2 )
rss
tss <- sum((mar_sim1$fitted.values - mean(mar_sim1$fitted.values)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq

rss <- sum((y - y_hat )^2 )
rss
tss <- sum((y_hat  - mean(y_hat )) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq

head(x)
head(y)
y_hat <- predict(mar_sim1,x[1] )
head(mar_sim1$fitted.values)



mar_sim1 <- earth(y ~ x , nk = 30, pmethod = "none", trace = 5)




head(mar_sim1$bx)
matrix  <- model.matrix(mar_sim1)
matrix[,-1]

lm.model <- lm(y ~ matrix[,-1]) # -1 to drop intercept
summary(lm.model) 




glmnet1<-cv.glmnet(matrix, y, type.measure='mse',nfolds=5,alpha=1)

c<-coef(glmnet1,s='lambda.min',exact=TRUE)
inds<-which(c!=0)
variables<-row.names(c)[inds]


########


lasso = glmnet(matrix , y , alpha = 1, family = "gaussian")

plot(lasso, xvar='lambda', main="Lasso")


cv.lasso = cv.glmnet(matrix, y, alpha = 1, family = "gaussian")
#best.lambda = cv.lasso$lambda.1se
best.lambda = cv.lasso$lambda.min
best.lambda


plot(lasso, xvar='lambda', main="Lasso")
abline(v=log(best.lambda), col="blue", lty=5.5 )


c <- coef(cv.lasso, s = "lambda.min")
sum(c!=0)
select.ind = which(coef(cv.lasso, s = "lambda.min") != 0)
select.ind = select.ind[-1]-1 # remove `Intercept` and 平移剩下的ind
select.ind # 第幾個變數是重要的 (不看 `Intercept`)

# 挑出重要變數的名稱
select.varialbes = colnames(matrix)[select.ind]
select.varialbes


select_bx <- matrix[, c("(Intercept)",select.varialbes)]
dim(select_bx)

lm.model <- lm(y ~ select_bx[,-1]) # -1 to drop intercept
summary(lm.model) 

lm.model$fitted.values

y_hat2 <-predict(lm.model,realx)


matrix_test =  matrix(nrow=1000, ncol=20)

for (i in 1:1000){
  mat <- realx  - x[i]
  mat[mat<=0] <- 0
  mars_matrix_test[,i] = mat
}

predict(lasso,mars_matrix_test, type="response",s=0.1)




y_pred <- c()

for (i in 1:length(realx)){
 y_pred[i] = (
    -0.8683154
  -   0.667125 * max(0,         realx[i] -  -3.968507) 
  +  0.2756756 * max(0,          realx[i] -  -2.800201) *
  -  0.2369597 * max(0,    -2.5546 -          realx[i]) 
  -  0.7635003 * max(0,          realx[i] -    -2.5546) *
  +   2.088274 * max(0,          realx[i] -   -2.35073) *
  -   1.657458 * max(0,          realx[i] -  -2.158129) 
  +   2.685798 * max(0,          realx[i] -   -1.85205) 
  -   2.459431 * max(0,          realx[i] -  -1.702382) 
  +    7.25775 * max(0,          realx[i] -  -1.371175) 
  -   6.643521 * max(0,          realx[i] -  -1.311235) *
  +   1.467226 * max(0,          realx[i] -  -1.111375) 
  -   2.613474 * max(0,          realx[i] - -0.9290309) 
  +     2.5664 * max(0,          realx[i] - -0.8374005) 
  +  0.4256544 * max(0,          realx[i] - 0.08497159) *
  -     1.0833 * max(0,          realx[i] -  0.2794296) 
  +   1.370341 * max(0,          realx[i] -  0.7264055) 
  -    1.07432 * max(0,          realx[i] -  0.8189255) *
  -  0.5237747 * max(0,          realx[i] -     1.1907) 
  -  0.8270549 * max(0,          realx[i] -   1.756695) *
  +  0.1023389 * max(0,          realx[i] -   1.907651) 
  -  0.3673152 * max(0,          realx[i] -   2.493589) 
  +   1.196912 * max(0,          realx[i] -   4.237015) 
  -   1.602434 * max(0,          realx[i] -   4.723314) 
  +   11.89382 * max(0,          realx[i] -   4.904945) 
  -   13.06482 * max(0,          realx[i] -   4.941086) )
}


x_save <- x
y_save <- y
y_pred2 <- c()

for (i in 1:length(realx)){
  y_pred2[i] = (
    -1.00527
    -   0.52753 * max(0,         realx[i] -  -3.968507) 
    -  0.16510 * max(0,    -2.5546 -          realx[i]) 
    +   0.50484 * max(0,          realx[i] -  -2.158129) 
    +   1.21838 * max(0,          realx[i] -   -1.85205) 
    -   1.09120 * max(0,          realx[i] -  -1.702382) 
    +    1.37664 * max(0,          realx[i] -  -1.371175) 
    -   0.57661 * max(0,          realx[i] -  -1.111375) 
    -   1.77537 * max(0,          realx[i] - -0.9290309) 
    +     2.45664 * max(0,          realx[i] - -0.8374005) 
    -     0.51113 * max(0,          realx[i] -  0.2794296) 
    +   0.24508 * max(0,          realx[i] -  0.7264055) 
    -  0.70228 * max(0,          realx[i] -     1.1907) 
    -  0.75195 * max(0,          realx[i] -   1.756695) 
    +  0.06017 * max(0,          realx[i] -   1.907651) 
    -  0.36645 * max(0,          realx[i] -   2.493589) 
    +   1.19679 * max(0,          realx[i] -   4.237015) 
    -   1.60227 * max(0,          realx[i] -   4.723314) 
    +   11.89354 * max(0,          realx[i] -   4.904945) 
    -   13.06461 * max(0,          realx[i] -   4.941086) )
}

x2 <- 5
yyy = (
  -1.00527
  -   0.52753 * max(0,         x2 -  -3.968507) 
  -  0.16510 * max(0,    -2.5546 -          x2) 
  +   0.50484 * max(0,          x2 -  -2.158129) 
  +   1.21838 * max(0,          x2 -   -1.85205) 
  -   1.09120 * max(0,          x2 -  -1.702382) 
  +    1.37664 * max(0,          x2 -  -1.371175) 
  -   0.57661 * max(0,          x2 -  -1.111375) 
  -   1.77537 * max(0,          x2 - -0.9290309) 
  +     2.45664 * max(0,          x2 - -0.8374005) 
  -     0.51113 * max(0,          x2 -  0.2794296) 
  +   0.24508 * max(0,          x2 -  0.7264055) 
  -  0.70228 * max(0,          x2 -     1.1907) 
  +  0.06017 * max(0,          x2 -   1.907651) 
  -  0.36645 * max(0,          x2 -   2.493589) 
  +   1.19679 * max(0,          x2 -   4.237015) 
  -   1.60227 * max(0,          x2 -   4.723314) 
  +   11.89354 * max(0,          x2 -   4.904945) 
  -   13.06461 * max(0,          x2 -   4.941086) )


plot(x,y, col = "cornflowerblue", pch = 20, main = "Revised MARS",xlab ="", ylab="")
lines(realx, y_pred2 , col = "red", lwd = 3)



rss <- sum((y - lm.model$fitted.values)^2 )
rss
tss <- sum((lm.model$fitted.values - mean(lm.model$fitted.values)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq



rss <- sum((y - y_hat)^2 )
rss
tss <- sum((y_hat - mean(y_hat)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq


write.csv(x, file = "x1.csv")
write.csv(y, file = "y1.csv")
write.csv(matrix, file = "matrix1.csv")



#############################################
###############
#22222222
###############






x  <- runif(3000,-10,10)
y <- sin(2*x)+ cos(x) + 0.5*x + rnorm(3000,0,0.7) 

plot(x,y)

realx <- seq(-10,10,length.out = 3000)
realy <- sin(5*realx)+ cos(realx )
plot(realx,realy)
plot(x,y, col = "cornflowerblue", pch = 20)
lines(realx,realy , col = "black", lwd = 3)

#lines(realx, y_pred , col = "red", lwd = 3)
lines(realx, y_hat , col = "red", lwd = 3)




mar_sim2 <- earth(y ~ x , nk = 1000,pmethod = "none", trace =3)
summary(mar_sim2, digits = 2, style = "pmax")
summary(mar_sim2, decomp = "none")
#plotmo(mar_sim1, caption="", col = "red", lwd = 3, col.response="blue", pch = 20, clip=0, xlab="x", ylab="y", main="")

plotmo(mar_sim2, col = "red", col.response="black", pch = 20, lwd = 3, xlab="x", ylab="y", main="")

plot(mar_sim1)
print(mar_sim1)

y_hat <- predict(mar_sim2,realx )


matrix2  <- model.matrix(mar_sim2)

lm.model <- lm(y ~ matrix2[,-1]) # -1 to drop intercept
summary(lm.model) 




lasso = glmnet(matrix2, y, alpha = 1, family = "gaussian")

plot(lasso, xvar='lambda', main="Lasso")


cv.lasso = cv.glmnet(matrix2, y, alpha = 1, family = "gaussian")
best.lambda = cv.lasso$lambda.min
best.lambda


plot(lasso, xvar='lambda', main="Lasso")
abline(v=log(best.lambda), col="blue", lty=5.5 )


c <- coef(cv.lasso, s = "lambda.min")
sum(c==0)
select.ind = which(coef(cv.lasso, s = "lambda.min") != 0)
select.ind = select.ind[-1]-1 # remove `Intercept` and 平移剩下的ind
select.ind # 第幾個變數是重要的 (不看 `Intercept`)

# 挑出重要變數的名稱
select.varialbes = colnames(matrix2)[select.ind]
select.varialbes



lasso.test = predict(lasso, s = best.lambda, newx = realx)






glmnet2<-cv.glmnet(matrix2, y, type.measure='mse',nfolds=5,alpha=1)

c2<-coef(glmnet2,s='lambda.min',exact=TRUE)
c2

inds2<-which(c2!=0)
variables2<-row.names(c2)[inds2]



###############
#3D
###############






x_3d  <- runif(1000,-1,1)
y_3d  <- runif(1000,-1,1)
z_3D <- sin(2*x_3d) + 0.5*x_3d + cos(2*y_3d) - 0.5*y_3d + rnorm(1000,0,0.3) 


xy_data <- data.frame(x_3d,y_3d,z_3D )


fit <- earth(z_3D ~ .,data = xy_data, trace = 1)
plot(fit)
summary(fit)
plotmo(fit)

library(plot3D)
### Compute z = f(a, b)
a <- seq(from=-5,to=5, by=.1)
b <- seq(from=-2.5, to=7.5, by=.1)

X <- c(12,14,14,15,16,18)
Y <- c(25,36,32,30,36,42)

f <- function(a,b) {
  sum((Y - a - b*X)^2)
}

m <- expand.grid(a, b)
z <- mapply(f, m$Var1, m$Var2)


M <- mesh(a, b)
x.plot <- M$x
y.plot <- M$y

z.plot <- matrix(z, nrow=nrow(x.plot))

persp3D(x.plot, y.plot, z.plot)








###############
#LASSO
###############


mars_matrix_train = matrix( nrow=1000, ncol=1000)
mars_matrix_test =  matrix( nrow=1000, ncol=1000)
for (i in 1:1000){
  mat <- x - x[i]
  mat[mat<=0] <- 0
  mars_matrix_train[,i] = mat
}

for (i in 1:1000){
  mat <- realx  - x[i]
  mat[mat<=0] <- 0
  mars_matrix_test[,i] = mat
}

str(mars_matrix_test) 

colnames(mars_matrix_train) <- paste0('V', 1:1000)

data_train <- as.data.frame(mars_matrix_train) 
colnames(data_train)






lasso = glmnet(mars_matrix_train, y, alpha = 1, family = "gaussian")

plot(lasso, xvar='lambda', main="Lasso")


cv.lasso = cv.glmnet(mars_matrix_train, y, alpha = 1, family = "gaussian")
best.lambda = cv.lasso$lambda.min
best.lambda


plot(lasso, xvar='lambda', main="Lasso")
abline(v=log(best.lambda), col="blue", lty=5.5 )


c<-coef(cv.lasso,s='lambda.min',exact=TRUE)
head(c,10)
inds<-which(c!=0)
sum(c!=0)
variables<-row.names(c)[inds]
variables

select.ind = which(coef(cv.lasso, s = "lambda.min") != 0)
select.ind = select.ind[-1]-1 # remove `Intercept` and 平移剩下的ind
select.ind

# 挑出重要變數的名稱
select.varialbes = colnames(mars_matrix_train)[select.ind]
select.varialbes






glmnet1<-cv.glmnet(mars_matrix_train,y,type.measure='mse',nfolds=5,alpha=1)

glmnet1$lambda.min
c<-coef(glmnet1,s='lambda.min',exact=TRUE)
head(c)
inds<-which(c!=0)
variables<-row.names(c)[inds]


lasso1 <- glmnet(mars_matrix_train,y,alpha = 0)
plot(lasso1, xvar='lambda', main="Lasso")
print(lasso1)

c <- coef(lasso1,s=0.0001)
sum(c!=0)
y_pred_0.01 <- predict(lasso1,mars_matrix_test, type="response",s=13.7)
y_pred_0.001 <- predict(lasso1,mars_matrix_test, type="response",s=0.005)
y_pred_0.0001 <- predict(lasso1,mars_matrix_test, type="response",s=0.0001)
y_pred_best <- predict(lasso1,mars_matrix_test, type="response",s=best.lambda)

dim(mars_matrix_test)


ncol(mars_matrix_train) 

dim(select_bx)
select_bx <- mars_matrix_train[, c(select.varialbes)]
lm.model <- lm(y ~ select_bx) # -1 to drop intercept
summary(lm.model) 

lm.model$fitted.values



rss <- sum((y - lm.model$fitted.values)^2 )
rss
tss <- sum((lm.model$fitted.values - mean(lm.model$fitted.values)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq




####################################################
ridge <- glmnet(mars_matrix_train,y,alpha = 0)

ridge.cv<-cv.glmnet(mars_matrix_train,y,alpha=0)
best.lambda = ridge.cv$lambda.min
best.lambda


c <- coef(ridge,s=best.lambda)
sum(c!=0)

plot(ridge , xvar='lambda', main="Ridge")
abline(v=log(best.lambda), col="blue", lty=5.5 )
best.lambda

y_pred_r <- predict(ridge,mars_matrix_test, type="response",s=0.1)

head(coef(ridge.cv, s = "lambda.min"))

select.ind = which(coef(ridge.cv, s = "lambda.min") != 0)
select.ind = select.ind[-1]-1 # remove `Intercept` and 平移剩下的ind
select.ind

# 挑出重要變數的名稱
select.varialbes = colnames(mars_matrix_train)[select.ind]
select.varialbes


select_bx <- mars_matrix_train[, c(select.varialbes)]
lm.model <- lm(y ~ select_bx) # -1 to drop intercept
summary(lm.model) 


rss <- sum((y - lm.model$fitted.values)^2 )
rss
tss <- sum((lm.model$fitted.values - mean(lm.model$fitted.values)) ^ 2)  ## total sum of squares
rsq <- 1 - rss/tss
rsq






####################################################
plot(x,y, col = "cornflowerblue", pch = 20, main = "lambda = 0.1", xlab="", ylab="")
lines(realx,y_pred_r, col = "red", lwd = 3)
#lines(realx,realy , col = "black", lwd = 3)

lines(realx,y_pred_r, col = "red", lwd = 3)
lines(realx,y_pred_0.01, col = "red", lwd = 3)
lines(realx,y_pred_0.001, col = "red", lwd = 3)
lines(realx,y_pred_0.0001, col = "red", lwd = 3)

legend("topleft", legend = c("real", "fit"),lty=c(1,1), lwd=c(2.5,2.5),col=c("black","red"))

###################
#LM EXAMPLE
###################

data(trees)
earth.mod <- earth(Volume ~ ., data = trees)
summary(earth.mod, decomp = "none") # "none" to print terms in same order as lm.mod below

plotmo(earth.mod)

bx <- model.matrix(earth.mod) # equivalent to bx <- earth.mod$bx
lm.mod <- lm(trees$Volume ~ bx[,-1]) # -1 to drop intercept
summary(lm.mod) # yields same coeffs as above summary
# displayed t values are not meaningful










####################################
dim(x)
x=matrix(rnorm(100*20),100,20)
y=rnorm(100)
g2=sample(1:2,100,replace=TRUE)
g4=sample(1:4,100,replace=TRUE)
fit1=glmnet(x,y)
predict(fit1,newx=x[1:5,],s=c(0.01,0.005))
predict(fit1,type="coef")
plot(fit1,xvar="lambda")
fit2=glmnet(x,g2,family="binomial")
predict(fit2,type="response",newx=x[2:5,])
predict(fit2,type="nonzero")
fit3=glmnet(x,g4,family="multinomial")
predict(fit3,newx=x[1:3,],type="response",s=0.01)




















