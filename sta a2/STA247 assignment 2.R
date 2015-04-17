f <- function(d){
if(d==9) return (3/9)
if(d==8) return(0)
if(d==7) return(3/9)
if(d==6) return(0)
if(d==5) return(0)
if(d==4) return(1/9)
if(d==3) return(0)
if(d==2) return(0)
if(d==1) return(2/9)
if(d==0) return(0)
}

f(9)
f(8)
f(7)
f(6)
f(5)
f(4)
f(3)
f(2)
f(1)
f(0)

p <- function(d) {
if(d==9) return(1)
if(d==8) return(6/9)
if(d==7) return(6/9)
if(d==6) return(3/9)
if(d==5) return(3/9)
if(d==4) return(3/9)
if(d==3) return(2/9)
if(d==2) return(2/9)
if(d==1) return(2/9)
if(d==0) return(0)
}

p(9)
p(8)
p(7)
p(6)
p(5)
p(4)
p(3)
p(2)
p(1)
p(0)

d <- function(p) {
if(2/9>p) return(0)
if(3/9>p) return(1)
if(6/9>p) return(4)
if(1>p) return(7)
else return(9)
}

d(1)
d(.9)
d(8/9)
d(.8)
d(7/9)
d(.7)
d(6/9)
d(.6)
d(5/9)
d(.5)
d(4/9)
d(.4)
d(3/9)
d(.3)
d(2/9)
d(.2)
d(1/9)
d(.1)
d(.0)

r <- function(n) {
x <- c(1, 1, 4, 7, 7, 7, 9, 9, 9)
sample(x, n, replace = T)
}

r(2)
r(10)
mean(r(100))
mean(r(100))
mean(r(1000))
mean(r(10000))
mean(r(100000))

x <- r(10)
x
mean(x)
x <- c(mean(r(1)), mean(r(2)))
x

means <- c(mean(r(1)), mean(r(2)), mean(r(3)), mean(r(4)), mean(r(5)), mean(r(6)), mean(r(7)), mean(r(8)), mean(r(9)), mean(r(10)), mean(r(11)), mean(r(12)), mean(r(13)), mean(r(14)), mean(r(15)), mean(r(16)), mean(r(17)), mean(r(18)), mean(r(19)), mean(r(20)))
means
samples <- c(1,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
plot(means, samples)
vars <- c(var(r(2)), var(r(3)), var(r(4)), var(r(5)), var(r(6)), var(r(7)), var(r(8)), var(r(9)), var(r(10)), var(r(11)), var(r(12)), var(r(13)), var(r(14)), var(r(15)), var(r(16)), var(r(17)), var(r(18)), var(r(19)), var(r(20)))
samples2 <- c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
plot(vars, samples2)
var(r(10000))