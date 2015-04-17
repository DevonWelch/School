x = 1:100
a = 0
for(item in x) a = a + playuntilwin(item)
a = a/100
print(a)

b = 0
for(item in x) b = b + playuntilwin2(item)
b = b/100
print(b)

y = 1:10000
p = 0
for(item in y) p = p + playuntilwin(item)
p = p/10000
print(p)

q = 0
for(item in y) q = q + playuntilwin2(item)
q = q/10000
print(q)

area = h_integral(1) - h_integral(0)
print(area)
area2 = h_integral2(1) - h_integral2(0)
print(area2)

nums <- c(1, 5, 10, 50, 100, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 20000, 30000, 40000, 50000, 100000, 150000, 200000)

for(item in nums) {
total = 0
thousand <- 1:100
for(item3 in thousand) {
x <- runif(item, 0, 1)
y <- runif(item, 0, h(1))
second_nums <- 1:item
for(item2 in second_nums) {
if(h(x[item2])>=y[item2]) total = total + 1
}
}
print((total/(item*100))*h(1))
}

one_average = 0
two_average = 0
three_average = 0
four_average = 0
five_average = 0
six_average = 0
found_one = 0
found_two = 0
found_three = 0
found_four = 0
found_five = 0
found_six = 0
for(item in 1:100){
total = 0
one = 1<0
two = 1>0
three = 1>0
four = 1>0
five = 1>0
six = 1>0
for(item in 1:30000) {
x <- runif(item, 0, 1)
y <- runif(item, 0, h(1))
if(h(x[item])>=y[item]) total = total + 1
if(!one) {
if(floor(((total*h(1))/item)*10)==7) {
one = 1>0
two = 1<0
one_average = one_average + item
found_one = found_one + 1
}
}
if(!two) {
if(floor(((total*h(1))/item)*100)==78) {
two = 1>0
three = 1<0
two_average = two_average + item
found_two = found_two + 1
}
}
if(!three) {
if(floor(((total*h(1))/item)*1000)==781) {
three = 1>0
four = 1<0
three_average = three_average + item
found_three = found_three + 1
}
}
if(!four) {
if(floor(((total*h(1))/item)*10000)==7811) {
four = 1>0
five = 1<0
four_average = four_average + item
found_four = found_four + 1
}
}
if(!five) {
if(floor(((total*h(1))/item)*100000)==78110) {
five = 1>0
six = 1<0
five_average = five_average + item
found_five = found_five + 1
}
}
if(!six) {
if(floor(((total*h(1))/item)*1000000)==781104) {
six = 1>0
six_average = six_average + item
found_six = found_six + 1
}
}
}
}
print(one_average/found_one)
print(two_average/found_two)
print(three_average/found_three)
print(four_average/found_four)
print(five_average/found_five)
print(six_average/found_six)

initial <- c('empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty',
		 'empty', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'empty',
		 'empty', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'empty',
		 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty')

lot = start_2(initial)

lot

random_num = runif(1, 0, 1)

num_cars_leaving = how_many(random_num)

changed_lot = remove(num_cars_leaving, lot)

changed_lot

num_cars_leaving

changed_lot = move(changed_lot)

changed_lot

initial <- c('empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty',
		 'empty', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'empty',
		 'empty', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'car', 'empty',
		 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty', 'empty')

x <- 1:1000
p = 0
for(item in x) {
lot = start_2(initial)
p = p + how_long_move(lot)
}
print(p/1000)
