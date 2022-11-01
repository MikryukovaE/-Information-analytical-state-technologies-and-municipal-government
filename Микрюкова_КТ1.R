x <- runif(100,1,1000000)
y <- c(1:500)
median(x)
mean(y) - length(y) / sum(1/y)
x[(x >= 5) & (x < 7000)]
y[y%%2 == 0]
save(x,y,file="first")


