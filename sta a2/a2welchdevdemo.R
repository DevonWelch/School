source ( "a2welchdevfunc.r" )

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

a <- r(1)
a
b <- r(2)
b
c <- r(3)
c
d <- r(4)
d
e <- r(5)
e
f <- r(6)
f
g <- r(7)
g
h <- r(8)
h
i <- r(9)
i
j <- r(10)
j
k <- r(11)
k
l <- r(12)
l
m <- r(13)
m
n <- r(14)
n
o <- r(15)
o
p <- r(16)
p
q <- r(17)
q
s <- r(18)
s
t <- r(19)
t
u <- r(20)
u

means <- c(mean(a), mean(b), mean(c), mean(d), mean(e), mean(f), mean(g), mean(h), mean(i), mean(j), mean(k), mean(l), mean(m), mean(n), mean(o), mean(p), mean(q), mean(s), mean(t), mean(u))
samples <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
plot(means, samples)

b <- r(2)
b
c <- r(3)
c
d <- r(4)
d
e <- r(5)
e
f <- r(6)
f
g <- r(7)
g
h <- r(8)
h
i <- r(9)
i
j <- r(10)
j
k <- r(11)
k
l <- r(12)
l
m <- r(13)
m
n <- r(14)
n
o <- r(15)
o
p <- r(16)
p
q <- r(17)
q
s <- r(18)
s
t <- r(19)
t
u <- r(20)
u

vars <- c(var(b), var(c), var(d), var(e), var(f), var(g), var(h), var(i), var(j), var(k), var(l), var(m), var(n), var(o), var(p), var(q), var(s), var(t), var(u))
samples <- c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
plot(vars, samples)
