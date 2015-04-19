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


d <- function(p) {
if(2/9>p) return(0)
if(3/9>p) return(1)
if(6/9>p) return(4)
if(1>p) return(7)
else return(9)
}


r <- function(n) {
x <- c(1, 1, 4, 7, 7, 7, 9, 9, 9)
sample(x, n, replace = T)
}

