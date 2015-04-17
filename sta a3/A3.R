curve <- function(x) {
y = x^7 + x^4 + (cos(x))^7
return(y)
}


matrix1 <- c(0, 0, 1/6, 0, 1/6, 1/3, 1/3, 0, 0, 0,
		1/6, 0, 1/6, 0, 1/6, 1/6, 1/3, 0, 0, 0, 
		1/6, 0, 0, 0, 1/3, 1/6, 1/3, 0, 0, 0, 
		1/6, 0, 0, 0, 1/3, 1/6, 1/6, 0, 0, 1/6, 
		1/6, 0, 0, 0, 1/3, 1/6, 1/6, 0, 0, 1/6, 
		1/6, 0, 0, 0, 1/6, 1/3, 1/6, 0, 0, 1/6, 
		1/6, 0, 0, 0, 1/6, 0, 1/2, 0, 0, 1/6, 
		4/6, 0, 0, 0, 1/6, 0, 0, 0, 0, 1/6, 
		0, 0, 0, 0, 5/6, 0, 0, 0, 0, 1/6, 
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1)

matrix2 <- c(0, 1/6, 1/6, 0, 1/6, 1/6, 1/3, 0, 0, 0,
		 0, 0, 1/6, 0, 1/6, 1/6, 1/3, 1/6, 0, 0,
		 0, 1/6, 0, 0, 1/6, 1/6, 1/3, 1/6, 0, 0,
		 0, 1/6, 0, 0, 1/6, 1/6, 1/6, 1/6, 0, 1/6,
		 0, 1/6, 0, 0, 1/6, 1/6, 1/6, 1/6, 0, 1/6,
		 0, 1/6, 0, 0, 0, 1/3, 1/6, 1/6, 0, 1/6,
		 0, 1/6, 0, 0, 0, 0, 1/2, 1/6, 0, 1/6,
		 0, 1/6, 0, 0, 0, 0, , 2/3, 0, 1/6,
		 0, 5/6, 0, 0, 0, 0, , 0, 0, 1/6,
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)

multiply <- function(x) {
matrix <- c(0, 0, 1/6, 0, 1/6, 1/3, 1/3, 0, 0, 0,
		1/6, 0, 1/6, 0, 1/6, 1/6, 1/3, 0, 0, 0, 
		1/6, 0, 0, 0, 1/3, 1/6, 1/3, 0, 0, 0, 
		1/6, 0, 0, 0, 1/3, 1/6, 1/6, 0, 0, 1/6, 
		1/6, 0, 0, 0, 1/3, 1/6, 1/6, 0, 0, 1/6, 
		1/6, 0, 0, 0, 1/6, 1/3, 1/6, 0, 0, 1/6, 
		1/6, 0, 0, 0, 1/6, 0, 1/2, 0, 0, 1/6, 
		4/6, 0, 0, 0, 1/6, 0, 0, 0, 0, 1/6, 
		0, 0, 0, 0, 5/6, 0, 0, 0, 0, 1/6, 
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1)
y = x-1
if(x==1) return(matrix)
if(x>1) z <- multiply(y)
aa = (z[1])*(matrix[1]) + (z[2])*(matrix[11]) + (z[3])*(matrix[21]) + (z[4])*(matrix[31]) + (z[5])*(matrix[41]) + (z[6])*(matrix[51]) + (z[7])*(matrix[61]) + (z[8])*(matrix[71]) + (z[9])*(matrix[81]) + (z[10])*(matrix[91])
ab = (z[1])*(matrix[2]) + (z[2])*(matrix[12]) + (z[3])*(matrix[22]) + (z[4])*(matrix[32]) + (z[5])*(matrix[42]) + (z[6])*(matrix[52]) + (z[7])*(matrix[62]) + (z[8])*(matrix[72]) + (z[9])*(matrix[82]) + (z[10])*(matrix[92])
ac = (z[1])*(matrix[3]) + (z[2])*(matrix[13]) + (z[3])*(matrix[23]) + (z[4])*(matrix[33]) + (z[5])*(matrix[43]) + (z[6])*(matrix[53]) + (z[7])*(matrix[63]) + (z[8])*(matrix[73]) + (z[9])*(matrix[83]) + (z[10])*(matrix[93])
ad = (z[1])*(matrix[4]) + (z[2])*(matrix[14]) + (z[3])*(matrix[24]) + (z[4])*(matrix[34]) + (z[5])*(matrix[44]) + (z[6])*(matrix[54]) + (z[7])*(matrix[64]) + (z[8])*(matrix[74]) + (z[9])*(matrix[84]) + (z[10])*(matrix[94])
ae = (z[1])*(matrix[5]) + (z[2])*(matrix[15]) + (z[3])*(matrix[25]) + (z[4])*(matrix[35]) + (z[5])*(matrix[45]) + (z[6])*(matrix[55]) + (z[7])*(matrix[65]) + (z[8])*(matrix[75]) + (z[9])*(matrix[85]) + (z[10])*(matrix[95])
af = (z[1])*(matrix[6]) + (z[2])*(matrix[16]) + (z[3])*(matrix[26]) + (z[4])*(matrix[36]) + (z[5])*(matrix[46]) + (z[6])*(matrix[56]) + (z[7])*(matrix[66]) + (z[8])*(matrix[76]) + (z[9])*(matrix[86]) + (z[10])*(matrix[96])
ag = (z[1])*(matrix[7]) + (z[2])*(matrix[17]) + (z[3])*(matrix[27]) + (z[4])*(matrix[37]) + (z[5])*(matrix[47]) + (z[6])*(matrix[57]) + (z[7])*(matrix[67]) + (z[8])*(matrix[77]) + (z[9])*(matrix[87]) + (z[10])*(matrix[97])
ah = (z[1])*(matrix[8]) + (z[2])*(matrix[18]) + (z[3])*(matrix[28]) + (z[4])*(matrix[38]) + (z[5])*(matrix[48]) + (z[6])*(matrix[58]) + (z[7])*(matrix[68]) + (z[8])*(matrix[78]) + (z[9])*(matrix[88]) + (z[10])*(matrix[98])
ai = (z[1])*(matrix[9]) + (z[2])*(matrix[19]) + (z[3])*(matrix[29]) + (z[4])*(matrix[39]) + (z[5])*(matrix[49]) + (z[6])*(matrix[59]) + (z[7])*(matrix[69]) + (z[8])*(matrix[79]) + (z[9])*(matrix[89]) + (z[10])*(matrix[99])
aj = (z[1])*(matrix[10]) + (z[2])*(matrix[20]) + (z[3])*(matrix[30]) + (z[4])*(matrix[40]) + (z[5])*(matrix[50]) + (z[6])*(matrix[60]) + (z[7])*(matrix[70]) + (z[8])*(matrix[80]) + (z[9])*(matrix[90]) + (z[10])*(matrix[100])
ba = (z[11])*(matrix[1]) + (z[12])*(matrix[11]) + (z[13])*(matrix[21]) + (z[14])*(matrix[31]) + (z[15])*(matrix[41]) + (z[16])*(matrix[51]) + (z[17])*(matrix[61]) + (z[18])*(matrix[71]) + (z[19])*(matrix[81]) + (z[20])*(matrix[91])
bb = (z[11])*(matrix[2]) + (z[12])*(matrix[12]) + (z[13])*(matrix[22]) + (z[14])*(matrix[32]) + (z[15])*(matrix[42]) + (z[16])*(matrix[52]) + (z[17])*(matrix[62]) + (z[18])*(matrix[72]) + (z[19])*(matrix[82]) + (z[20])*(matrix[92])
bc = (z[11])*(matrix[3]) + (z[12])*(matrix[13]) + (z[13])*(matrix[23]) + (z[14])*(matrix[33]) + (z[15])*(matrix[43]) + (z[16])*(matrix[53]) + (z[17])*(matrix[63]) + (z[18])*(matrix[73]) + (z[19])*(matrix[83]) + (z[20])*(matrix[93])
bd = (z[11])*(matrix[4]) + (z[12])*(matrix[14]) + (z[13])*(matrix[24]) + (z[14])*(matrix[34]) + (z[15])*(matrix[44]) + (z[16])*(matrix[54]) + (z[17])*(matrix[64]) + (z[18])*(matrix[74]) + (z[19])*(matrix[84]) + (z[20])*(matrix[94])
be = (z[11])*(matrix[5]) + (z[12])*(matrix[15]) + (z[13])*(matrix[25]) + (z[14])*(matrix[35]) + (z[15])*(matrix[45]) + (z[16])*(matrix[55]) + (z[17])*(matrix[65]) + (z[18])*(matrix[75]) + (z[19])*(matrix[85]) + (z[20])*(matrix[95])
bf = (z[11])*(matrix[6]) + (z[12])*(matrix[16]) + (z[13])*(matrix[26]) + (z[14])*(matrix[36]) + (z[15])*(matrix[46]) + (z[16])*(matrix[56]) + (z[17])*(matrix[66]) + (z[18])*(matrix[76]) + (z[19])*(matrix[86]) + (z[20])*(matrix[96])
bg = (z[11])*(matrix[7]) + (z[12])*(matrix[17]) + (z[13])*(matrix[27]) + (z[14])*(matrix[37]) + (z[15])*(matrix[47]) + (z[16])*(matrix[57]) + (z[17])*(matrix[67]) + (z[18])*(matrix[77]) + (z[19])*(matrix[87]) + (z[20])*(matrix[97])
bh = (z[11])*(matrix[8]) + (z[12])*(matrix[18]) + (z[13])*(matrix[28]) + (z[14])*(matrix[38]) + (z[15])*(matrix[48]) + (z[16])*(matrix[58]) + (z[17])*(matrix[68]) + (z[18])*(matrix[78]) + (z[19])*(matrix[88]) + (z[20])*(matrix[98])
bi = (z[11])*(matrix[9]) + (z[12])*(matrix[19]) + (z[13])*(matrix[29]) + (z[14])*(matrix[39]) + (z[15])*(matrix[49]) + (z[16])*(matrix[59]) + (z[17])*(matrix[69]) + (z[18])*(matrix[79]) + (z[19])*(matrix[89]) + (z[20])*(matrix[99])
bj = (z[11])*(matrix[10]) + (z[12])*(matrix[20]) + (z[13])*(matrix[30]) + (z[14])*(matrix[40]) + (z[15])*(matrix[50]) + (z[16])*(matrix[60]) + (z[17])*(matrix[70]) + (z[18])*(matrix[80]) + (z[19])*(matrix[90]) + (z[20])*(matrix[100])
ca = (z[21])*(matrix[1]) + (z[22])*(matrix[11]) + (z[23])*(matrix[21]) + (z[24])*(matrix[31]) + (z[25])*(matrix[41]) + (z[26])*(matrix[51]) + (z[27])*(matrix[61]) + (z[28])*(matrix[71]) + (z[29])*(matrix[81]) + (z[30])*(matrix[91])
cb = (z[21])*(matrix[2]) + (z[22])*(matrix[12]) + (z[23])*(matrix[22]) + (z[24])*(matrix[32]) + (z[25])*(matrix[42]) + (z[26])*(matrix[52]) + (z[27])*(matrix[62]) + (z[28])*(matrix[72]) + (z[29])*(matrix[82]) + (z[30])*(matrix[92])
cc = (z[21])*(matrix[3]) + (z[22])*(matrix[13]) + (z[23])*(matrix[23]) + (z[24])*(matrix[33]) + (z[25])*(matrix[43]) + (z[26])*(matrix[53]) + (z[27])*(matrix[63]) + (z[28])*(matrix[73]) + (z[29])*(matrix[83]) + (z[30])*(matrix[93])
cd = (z[21])*(matrix[4]) + (z[22])*(matrix[14]) + (z[23])*(matrix[24]) + (z[24])*(matrix[34]) + (z[25])*(matrix[44]) + (z[26])*(matrix[54]) + (z[27])*(matrix[64]) + (z[28])*(matrix[74]) + (z[29])*(matrix[84]) + (z[30])*(matrix[94])
ce = (z[21])*(matrix[5]) + (z[22])*(matrix[15]) + (z[23])*(matrix[25]) + (z[24])*(matrix[35]) + (z[25])*(matrix[45]) + (z[26])*(matrix[55]) + (z[27])*(matrix[65]) + (z[28])*(matrix[75]) + (z[29])*(matrix[85]) + (z[30])*(matrix[95])
cf = (z[21])*(matrix[6]) + (z[22])*(matrix[16]) + (z[23])*(matrix[26]) + (z[24])*(matrix[36]) + (z[25])*(matrix[46]) + (z[26])*(matrix[56]) + (z[27])*(matrix[66]) + (z[28])*(matrix[76]) + (z[29])*(matrix[86]) + (z[30])*(matrix[96])
cg = (z[21])*(matrix[7]) + (z[22])*(matrix[17]) + (z[23])*(matrix[27]) + (z[24])*(matrix[37]) + (z[25])*(matrix[47]) + (z[26])*(matrix[57]) + (z[27])*(matrix[67]) + (z[28])*(matrix[77]) + (z[29])*(matrix[87]) + (z[30])*(matrix[97])
ch = (z[21])*(matrix[8]) + (z[22])*(matrix[18]) + (z[23])*(matrix[28]) + (z[24])*(matrix[38]) + (z[25])*(matrix[48]) + (z[26])*(matrix[58]) + (z[27])*(matrix[68]) + (z[28])*(matrix[78]) + (z[29])*(matrix[88]) + (z[30])*(matrix[98])
ci = (z[21])*(matrix[9]) + (z[22])*(matrix[19]) + (z[23])*(matrix[29]) + (z[24])*(matrix[39]) + (z[25])*(matrix[49]) + (z[26])*(matrix[59]) + (z[27])*(matrix[69]) + (z[28])*(matrix[79]) + (z[29])*(matrix[89]) + (z[30])*(matrix[99])
cj = (z[21])*(matrix[10]) + (z[22])*(matrix[20]) + (z[23])*(matrix[30]) + (z[24])*(matrix[40]) + (z[25])*(matrix[50]) + (z[26])*(matrix[60]) + (z[27])*(matrix[70]) + (z[28])*(matrix[80]) + (z[29])*(matrix[90]) + (z[30])*(matrix[100])
da = (z[31])*(matrix[1]) + (z[32])*(matrix[11]) + (z[33])*(matrix[21]) + (z[34])*(matrix[31]) + (z[35])*(matrix[41]) + (z[36])*(matrix[51]) + (z[37])*(matrix[61]) + (z[38])*(matrix[71]) + (z[39])*(matrix[81]) + (z[40])*(matrix[91])
db = (z[31])*(matrix[2]) + (z[32])*(matrix[12]) + (z[33])*(matrix[22]) + (z[34])*(matrix[32]) + (z[35])*(matrix[42]) + (z[36])*(matrix[52]) + (z[37])*(matrix[62]) + (z[38])*(matrix[72]) + (z[39])*(matrix[82]) + (z[40])*(matrix[92])
dc = (z[31])*(matrix[3]) + (z[32])*(matrix[13]) + (z[33])*(matrix[23]) + (z[34])*(matrix[33]) + (z[35])*(matrix[43]) + (z[36])*(matrix[53]) + (z[37])*(matrix[63]) + (z[38])*(matrix[73]) + (z[39])*(matrix[83]) + (z[40])*(matrix[93])
dd = (z[31])*(matrix[4]) + (z[32])*(matrix[14]) + (z[33])*(matrix[24]) + (z[34])*(matrix[34]) + (z[35])*(matrix[44]) + (z[36])*(matrix[54]) + (z[37])*(matrix[64]) + (z[38])*(matrix[74]) + (z[39])*(matrix[84]) + (z[40])*(matrix[94])
de = (z[31])*(matrix[5]) + (z[32])*(matrix[15]) + (z[33])*(matrix[25]) + (z[34])*(matrix[35]) + (z[35])*(matrix[45]) + (z[36])*(matrix[55]) + (z[37])*(matrix[65]) + (z[38])*(matrix[75]) + (z[39])*(matrix[85]) + (z[40])*(matrix[95])
df = (z[31])*(matrix[6]) + (z[32])*(matrix[16]) + (z[33])*(matrix[26]) + (z[34])*(matrix[36]) + (z[35])*(matrix[46]) + (z[36])*(matrix[56]) + (z[37])*(matrix[66]) + (z[38])*(matrix[76]) + (z[39])*(matrix[86]) + (z[40])*(matrix[96])
dg = (z[31])*(matrix[7]) + (z[32])*(matrix[17]) + (z[33])*(matrix[27]) + (z[34])*(matrix[37]) + (z[35])*(matrix[47]) + (z[36])*(matrix[57]) + (z[37])*(matrix[67]) + (z[38])*(matrix[77]) + (z[39])*(matrix[87]) + (z[40])*(matrix[97])
dh = (z[31])*(matrix[8]) + (z[32])*(matrix[18]) + (z[33])*(matrix[28]) + (z[34])*(matrix[38]) + (z[35])*(matrix[48]) + (z[36])*(matrix[58]) + (z[37])*(matrix[68]) + (z[38])*(matrix[78]) + (z[39])*(matrix[88]) + (z[40])*(matrix[98])
di = (z[31])*(matrix[9]) + (z[32])*(matrix[19]) + (z[33])*(matrix[29]) + (z[34])*(matrix[39]) + (z[35])*(matrix[49]) + (z[36])*(matrix[59]) + (z[37])*(matrix[69]) + (z[38])*(matrix[79]) + (z[39])*(matrix[89]) + (z[40])*(matrix[99])
dj = (z[31])*(matrix[10]) + (z[32])*(matrix[20]) + (z[33])*(matrix[30]) + (z[34])*(matrix[40]) + (z[35])*(matrix[50]) + (z[36])*(matrix[60]) + (z[37])*(matrix[70]) + (z[38])*(matrix[80]) + (z[39])*(matrix[90]) + (z[40])*(matrix[100])
ea = (z[41])*(matrix[1]) + (z[42])*(matrix[11]) + (z[43])*(matrix[21]) + (z[44])*(matrix[31]) + (z[45])*(matrix[41]) + (z[46])*(matrix[51]) + (z[47])*(matrix[61]) + (z[48])*(matrix[71]) + (z[49])*(matrix[81]) + (z[50])*(matrix[91])
eb = (z[41])*(matrix[2]) + (z[42])*(matrix[12]) + (z[43])*(matrix[22]) + (z[44])*(matrix[32]) + (z[45])*(matrix[42]) + (z[46])*(matrix[52]) + (z[47])*(matrix[62]) + (z[48])*(matrix[72]) + (z[49])*(matrix[82]) + (z[50])*(matrix[92])
ec = (z[41])*(matrix[3]) + (z[42])*(matrix[13]) + (z[43])*(matrix[23]) + (z[44])*(matrix[33]) + (z[45])*(matrix[43]) + (z[46])*(matrix[53]) + (z[47])*(matrix[63]) + (z[48])*(matrix[73]) + (z[49])*(matrix[83]) + (z[50])*(matrix[93])
ed = (z[41])*(matrix[4]) + (z[42])*(matrix[14]) + (z[43])*(matrix[24]) + (z[44])*(matrix[34]) + (z[45])*(matrix[44]) + (z[46])*(matrix[54]) + (z[47])*(matrix[64]) + (z[48])*(matrix[74]) + (z[49])*(matrix[84]) + (z[50])*(matrix[94])
ee = (z[41])*(matrix[5]) + (z[42])*(matrix[15]) + (z[43])*(matrix[25]) + (z[44])*(matrix[35]) + (z[45])*(matrix[45]) + (z[46])*(matrix[55]) + (z[47])*(matrix[65]) + (z[48])*(matrix[75]) + (z[49])*(matrix[85]) + (z[50])*(matrix[95])
ef = (z[41])*(matrix[6]) + (z[42])*(matrix[16]) + (z[43])*(matrix[26]) + (z[44])*(matrix[36]) + (z[45])*(matrix[46]) + (z[46])*(matrix[56]) + (z[47])*(matrix[66]) + (z[48])*(matrix[76]) + (z[49])*(matrix[86]) + (z[50])*(matrix[96])
eg = (z[41])*(matrix[7]) + (z[42])*(matrix[17]) + (z[43])*(matrix[27]) + (z[44])*(matrix[37]) + (z[45])*(matrix[47]) + (z[46])*(matrix[57]) + (z[47])*(matrix[67]) + (z[48])*(matrix[77]) + (z[49])*(matrix[87]) + (z[50])*(matrix[97])
eh = (z[41])*(matrix[8]) + (z[42])*(matrix[18]) + (z[43])*(matrix[28]) + (z[44])*(matrix[38]) + (z[45])*(matrix[48]) + (z[46])*(matrix[58]) + (z[47])*(matrix[68]) + (z[48])*(matrix[78]) + (z[49])*(matrix[88]) + (z[50])*(matrix[98])
ei = (z[41])*(matrix[9]) + (z[42])*(matrix[19]) + (z[43])*(matrix[29]) + (z[44])*(matrix[39]) + (z[45])*(matrix[49]) + (z[46])*(matrix[59]) + (z[47])*(matrix[69]) + (z[48])*(matrix[79]) + (z[49])*(matrix[89]) + (z[50])*(matrix[99])
ej = (z[41])*(matrix[10]) + (z[42])*(matrix[20]) + (z[43])*(matrix[30]) + (z[44])*(matrix[40]) + (z[45])*(matrix[50]) + (z[46])*(matrix[60]) + (z[47])*(matrix[70]) + (z[48])*(matrix[80]) + (z[49])*(matrix[90]) + (z[50])*(matrix[100])
fa = (z[51])*(matrix[1]) + (z[52])*(matrix[11]) + (z[53])*(matrix[21]) + (z[54])*(matrix[31]) + (z[55])*(matrix[41]) + (z[56])*(matrix[51]) + (z[57])*(matrix[61]) + (z[58])*(matrix[71]) + (z[59])*(matrix[81]) + (z[60])*(matrix[91])
fb = (z[51])*(matrix[2]) + (z[52])*(matrix[12]) + (z[53])*(matrix[22]) + (z[54])*(matrix[32]) + (z[55])*(matrix[42]) + (z[56])*(matrix[52]) + (z[57])*(matrix[62]) + (z[58])*(matrix[72]) + (z[59])*(matrix[82]) + (z[60])*(matrix[92])
fc = (z[51])*(matrix[3]) + (z[52])*(matrix[13]) + (z[53])*(matrix[23]) + (z[54])*(matrix[33]) + (z[55])*(matrix[43]) + (z[56])*(matrix[53]) + (z[57])*(matrix[63]) + (z[58])*(matrix[73]) + (z[59])*(matrix[83]) + (z[60])*(matrix[93])
fd = (z[51])*(matrix[4]) + (z[52])*(matrix[14]) + (z[53])*(matrix[24]) + (z[54])*(matrix[34]) + (z[55])*(matrix[44]) + (z[56])*(matrix[54]) + (z[57])*(matrix[64]) + (z[58])*(matrix[74]) + (z[59])*(matrix[84]) + (z[60])*(matrix[94])
fe = (z[51])*(matrix[5]) + (z[52])*(matrix[15]) + (z[53])*(matrix[25]) + (z[54])*(matrix[35]) + (z[55])*(matrix[45]) + (z[56])*(matrix[55]) + (z[57])*(matrix[65]) + (z[58])*(matrix[75]) + (z[59])*(matrix[85]) + (z[60])*(matrix[95])
ff = (z[51])*(matrix[6]) + (z[52])*(matrix[16]) + (z[53])*(matrix[26]) + (z[54])*(matrix[36]) + (z[55])*(matrix[46]) + (z[56])*(matrix[56]) + (z[57])*(matrix[66]) + (z[58])*(matrix[76]) + (z[59])*(matrix[86]) + (z[60])*(matrix[96])
fg = (z[51])*(matrix[7]) + (z[52])*(matrix[17]) + (z[53])*(matrix[27]) + (z[54])*(matrix[37]) + (z[55])*(matrix[47]) + (z[56])*(matrix[57]) + (z[57])*(matrix[67]) + (z[58])*(matrix[77]) + (z[59])*(matrix[87]) + (z[60])*(matrix[97])
fh = (z[51])*(matrix[8]) + (z[52])*(matrix[18]) + (z[53])*(matrix[28]) + (z[54])*(matrix[38]) + (z[55])*(matrix[48]) + (z[56])*(matrix[58]) + (z[57])*(matrix[68]) + (z[58])*(matrix[78]) + (z[59])*(matrix[88]) + (z[60])*(matrix[98])
fi = (z[51])*(matrix[9]) + (z[52])*(matrix[19]) + (z[53])*(matrix[29]) + (z[54])*(matrix[39]) + (z[55])*(matrix[49]) + (z[56])*(matrix[59]) + (z[57])*(matrix[69]) + (z[58])*(matrix[79]) + (z[59])*(matrix[89]) + (z[60])*(matrix[99])
fj = (z[51])*(matrix[10]) + (z[52])*(matrix[20]) + (z[53])*(matrix[30]) + (z[54])*(matrix[40]) + (z[55])*(matrix[50]) + (z[56])*(matrix[60]) + (z[57])*(matrix[70]) + (z[58])*(matrix[80]) + (z[59])*(matrix[90]) + (z[60])*(matrix[100])
ga = (z[61])*(matrix[1]) + (z[62])*(matrix[11]) + (z[63])*(matrix[21]) + (z[64])*(matrix[31]) + (z[65])*(matrix[41]) + (z[66])*(matrix[51]) + (z[67])*(matrix[61]) + (z[68])*(matrix[71]) + (z[69])*(matrix[81]) + (z[70])*(matrix[91])
gb = (z[61])*(matrix[2]) + (z[62])*(matrix[12]) + (z[63])*(matrix[22]) + (z[64])*(matrix[32]) + (z[65])*(matrix[42]) + (z[66])*(matrix[52]) + (z[67])*(matrix[62]) + (z[68])*(matrix[72]) + (z[69])*(matrix[82]) + (z[70])*(matrix[92])
gc = (z[61])*(matrix[3]) + (z[62])*(matrix[13]) + (z[63])*(matrix[23]) + (z[64])*(matrix[33]) + (z[65])*(matrix[43]) + (z[66])*(matrix[53]) + (z[67])*(matrix[63]) + (z[68])*(matrix[73]) + (z[69])*(matrix[83]) + (z[70])*(matrix[93])
gd = (z[61])*(matrix[4]) + (z[62])*(matrix[14]) + (z[63])*(matrix[24]) + (z[64])*(matrix[34]) + (z[65])*(matrix[44]) + (z[66])*(matrix[54]) + (z[67])*(matrix[64]) + (z[68])*(matrix[74]) + (z[69])*(matrix[84]) + (z[70])*(matrix[94])
ge = (z[61])*(matrix[5]) + (z[62])*(matrix[15]) + (z[63])*(matrix[25]) + (z[64])*(matrix[35]) + (z[65])*(matrix[45]) + (z[66])*(matrix[55]) + (z[67])*(matrix[65]) + (z[68])*(matrix[75]) + (z[69])*(matrix[85]) + (z[70])*(matrix[95])
gf = (z[61])*(matrix[6]) + (z[62])*(matrix[16]) + (z[63])*(matrix[26]) + (z[64])*(matrix[36]) + (z[65])*(matrix[46]) + (z[66])*(matrix[56]) + (z[67])*(matrix[66]) + (z[68])*(matrix[76]) + (z[69])*(matrix[86]) + (z[70])*(matrix[96])
gg = (z[61])*(matrix[7]) + (z[62])*(matrix[17]) + (z[63])*(matrix[27]) + (z[64])*(matrix[37]) + (z[65])*(matrix[47]) + (z[66])*(matrix[57]) + (z[67])*(matrix[67]) + (z[68])*(matrix[77]) + (z[69])*(matrix[87]) + (z[70])*(matrix[97])
gh = (z[61])*(matrix[8]) + (z[62])*(matrix[18]) + (z[63])*(matrix[28]) + (z[64])*(matrix[38]) + (z[65])*(matrix[48]) + (z[66])*(matrix[58]) + (z[67])*(matrix[68]) + (z[68])*(matrix[78]) + (z[69])*(matrix[88]) + (z[70])*(matrix[98])
gi = (z[61])*(matrix[9]) + (z[62])*(matrix[19]) + (z[63])*(matrix[29]) + (z[64])*(matrix[39]) + (z[65])*(matrix[49]) + (z[66])*(matrix[59]) + (z[67])*(matrix[69]) + (z[68])*(matrix[79]) + (z[69])*(matrix[89]) + (z[70])*(matrix[99])
gj = (z[61])*(matrix[10]) + (z[62])*(matrix[20]) + (z[63])*(matrix[30]) + (z[64])*(matrix[40]) + (z[65])*(matrix[50]) + (z[66])*(matrix[60]) + (z[67])*(matrix[70]) + (z[68])*(matrix[80]) + (z[69])*(matrix[90]) + (z[70])*(matrix[100])
ha = (z[71])*(matrix[1]) + (z[72])*(matrix[11]) + (z[73])*(matrix[21]) + (z[74])*(matrix[31]) + (z[75])*(matrix[41]) + (z[76])*(matrix[51]) + (z[77])*(matrix[61]) + (z[78])*(matrix[71]) + (z[79])*(matrix[81]) + (z[80])*(matrix[91])
hb = (z[71])*(matrix[2]) + (z[72])*(matrix[12]) + (z[73])*(matrix[22]) + (z[74])*(matrix[32]) + (z[75])*(matrix[42]) + (z[76])*(matrix[52]) + (z[77])*(matrix[62]) + (z[78])*(matrix[72]) + (z[79])*(matrix[82]) + (z[80])*(matrix[92])
hc = (z[71])*(matrix[3]) + (z[72])*(matrix[13]) + (z[73])*(matrix[23]) + (z[74])*(matrix[33]) + (z[75])*(matrix[43]) + (z[76])*(matrix[53]) + (z[77])*(matrix[63]) + (z[78])*(matrix[73]) + (z[79])*(matrix[83]) + (z[80])*(matrix[93])
hd = (z[71])*(matrix[4]) + (z[72])*(matrix[14]) + (z[73])*(matrix[24]) + (z[74])*(matrix[34]) + (z[75])*(matrix[44]) + (z[76])*(matrix[54]) + (z[77])*(matrix[64]) + (z[78])*(matrix[74]) + (z[79])*(matrix[84]) + (z[80])*(matrix[94])
he = (z[71])*(matrix[5]) + (z[72])*(matrix[15]) + (z[73])*(matrix[25]) + (z[74])*(matrix[35]) + (z[75])*(matrix[45]) + (z[76])*(matrix[55]) + (z[77])*(matrix[65]) + (z[78])*(matrix[75]) + (z[79])*(matrix[85]) + (z[80])*(matrix[95])
hf = (z[71])*(matrix[6]) + (z[72])*(matrix[16]) + (z[73])*(matrix[26]) + (z[74])*(matrix[36]) + (z[75])*(matrix[46]) + (z[76])*(matrix[56]) + (z[77])*(matrix[66]) + (z[78])*(matrix[76]) + (z[79])*(matrix[86]) + (z[80])*(matrix[96])
hg = (z[71])*(matrix[7]) + (z[72])*(matrix[17]) + (z[73])*(matrix[27]) + (z[74])*(matrix[37]) + (z[75])*(matrix[47]) + (z[76])*(matrix[57]) + (z[77])*(matrix[67]) + (z[78])*(matrix[77]) + (z[79])*(matrix[87]) + (z[80])*(matrix[97])
hh = (z[71])*(matrix[8]) + (z[72])*(matrix[18]) + (z[73])*(matrix[28]) + (z[74])*(matrix[38]) + (z[75])*(matrix[48]) + (z[76])*(matrix[58]) + (z[77])*(matrix[68]) + (z[78])*(matrix[78]) + (z[79])*(matrix[88]) + (z[80])*(matrix[98])
hi = (z[71])*(matrix[9]) + (z[72])*(matrix[19]) + (z[73])*(matrix[29]) + (z[74])*(matrix[39]) + (z[75])*(matrix[49]) + (z[76])*(matrix[59]) + (z[77])*(matrix[69]) + (z[78])*(matrix[79]) + (z[79])*(matrix[89]) + (z[80])*(matrix[99])
hj = (z[71])*(matrix[10]) + (z[72])*(matrix[20]) + (z[73])*(matrix[30]) + (z[74])*(matrix[40]) + (z[75])*(matrix[50]) + (z[76])*(matrix[60]) + (z[77])*(matrix[70]) + (z[78])*(matrix[80]) + (z[79])*(matrix[90]) + (z[80])*(matrix[100])
ia = (z[81])*(matrix[1]) + (z[82])*(matrix[11]) + (z[83])*(matrix[21]) + (z[84])*(matrix[31]) + (z[85])*(matrix[41]) + (z[86])*(matrix[51]) + (z[87])*(matrix[61]) + (z[88])*(matrix[71]) + (z[89])*(matrix[81]) + (z[90])*(matrix[91])
ib = (z[81])*(matrix[2]) + (z[82])*(matrix[12]) + (z[83])*(matrix[22]) + (z[84])*(matrix[32]) + (z[85])*(matrix[42]) + (z[86])*(matrix[52]) + (z[87])*(matrix[62]) + (z[88])*(matrix[72]) + (z[89])*(matrix[82]) + (z[90])*(matrix[92])
ic = (z[81])*(matrix[3]) + (z[82])*(matrix[13]) + (z[83])*(matrix[23]) + (z[84])*(matrix[33]) + (z[85])*(matrix[43]) + (z[86])*(matrix[53]) + (z[87])*(matrix[63]) + (z[88])*(matrix[73]) + (z[89])*(matrix[83]) + (z[90])*(matrix[93])
id = (z[81])*(matrix[4]) + (z[82])*(matrix[14]) + (z[83])*(matrix[24]) + (z[84])*(matrix[34]) + (z[85])*(matrix[44]) + (z[86])*(matrix[54]) + (z[87])*(matrix[64]) + (z[88])*(matrix[74]) + (z[89])*(matrix[84]) + (z[90])*(matrix[94])
ie = (z[81])*(matrix[5]) + (z[82])*(matrix[15]) + (z[83])*(matrix[25]) + (z[84])*(matrix[35]) + (z[85])*(matrix[45]) + (z[86])*(matrix[55]) + (z[87])*(matrix[65]) + (z[88])*(matrix[75]) + (z[89])*(matrix[85]) + (z[90])*(matrix[95])
ik = (z[81])*(matrix[6]) + (z[82])*(matrix[16]) + (z[83])*(matrix[26]) + (z[84])*(matrix[36]) + (z[85])*(matrix[46]) + (z[86])*(matrix[56]) + (z[87])*(matrix[66]) + (z[88])*(matrix[76]) + (z[89])*(matrix[86]) + (z[90])*(matrix[96])
ig = (z[81])*(matrix[7]) + (z[82])*(matrix[17]) + (z[83])*(matrix[27]) + (z[84])*(matrix[37]) + (z[85])*(matrix[47]) + (z[86])*(matrix[57]) + (z[87])*(matrix[67]) + (z[88])*(matrix[77]) + (z[89])*(matrix[87]) + (z[90])*(matrix[97])
ih = (z[81])*(matrix[8]) + (z[82])*(matrix[18]) + (z[83])*(matrix[28]) + (z[84])*(matrix[38]) + (z[85])*(matrix[48]) + (z[86])*(matrix[58]) + (z[87])*(matrix[68]) + (z[88])*(matrix[78]) + (z[89])*(matrix[88]) + (z[90])*(matrix[98])
ii = (z[81])*(matrix[9]) + (z[82])*(matrix[19]) + (z[83])*(matrix[29]) + (z[84])*(matrix[39]) + (z[85])*(matrix[49]) + (z[86])*(matrix[59]) + (z[87])*(matrix[69]) + (z[88])*(matrix[79]) + (z[89])*(matrix[89]) + (z[90])*(matrix[99])
ij = (z[81])*(matrix[10]) + (z[82])*(matrix[20]) + (z[83])*(matrix[30]) + (z[84])*(matrix[40]) + (z[85])*(matrix[50]) + (z[86])*(matrix[60]) + (z[87])*(matrix[70]) + (z[88])*(matrix[80]) + (z[89])*(matrix[90]) + (z[90])*(matrix[100])
ja = (z[91])*(matrix[1]) + (z[92])*(matrix[11]) + (z[93])*(matrix[21]) + (z[94])*(matrix[31]) + (z[95])*(matrix[41]) + (z[96])*(matrix[51]) + (z[97])*(matrix[61]) + (z[98])*(matrix[71]) + (z[99])*(matrix[81]) + (z[100])*(matrix[91])
jb = (z[91])*(matrix[2]) + (z[92])*(matrix[12]) + (z[93])*(matrix[22]) + (z[94])*(matrix[32]) + (z[95])*(matrix[42]) + (z[96])*(matrix[52]) + (z[97])*(matrix[62]) + (z[98])*(matrix[72]) + (z[99])*(matrix[82]) + (z[100])*(matrix[92])
jc = (z[91])*(matrix[3]) + (z[92])*(matrix[13]) + (z[93])*(matrix[23]) + (z[94])*(matrix[33]) + (z[95])*(matrix[43]) + (z[96])*(matrix[53]) + (z[97])*(matrix[63]) + (z[98])*(matrix[73]) + (z[99])*(matrix[83]) + (z[100])*(matrix[93])
jd = (z[91])*(matrix[4]) + (z[92])*(matrix[14]) + (z[93])*(matrix[24]) + (z[94])*(matrix[34]) + (z[95])*(matrix[44]) + (z[96])*(matrix[54]) + (z[97])*(matrix[64]) + (z[98])*(matrix[74]) + (z[99])*(matrix[84]) + (z[100])*(matrix[94])
je = (z[91])*(matrix[5]) + (z[92])*(matrix[15]) + (z[93])*(matrix[25]) + (z[94])*(matrix[35]) + (z[95])*(matrix[45]) + (z[96])*(matrix[55]) + (z[97])*(matrix[65]) + (z[98])*(matrix[75]) + (z[99])*(matrix[85]) + (z[100])*(matrix[95])
jf = (z[91])*(matrix[6]) + (z[92])*(matrix[16]) + (z[93])*(matrix[26]) + (z[94])*(matrix[36]) + (z[95])*(matrix[46]) + (z[96])*(matrix[56]) + (z[97])*(matrix[66]) + (z[98])*(matrix[76]) + (z[99])*(matrix[86]) + (z[100])*(matrix[96])
jg = (z[91])*(matrix[7]) + (z[92])*(matrix[17]) + (z[93])*(matrix[27]) + (z[94])*(matrix[37]) + (z[95])*(matrix[47]) + (z[96])*(matrix[57]) + (z[97])*(matrix[67]) + (z[98])*(matrix[77]) + (z[99])*(matrix[87]) + (z[100])*(matrix[97])
jh = (z[91])*(matrix[8]) + (z[92])*(matrix[18]) + (z[93])*(matrix[28]) + (z[94])*(matrix[38]) + (z[95])*(matrix[48]) + (z[96])*(matrix[58]) + (z[97])*(matrix[68]) + (z[98])*(matrix[78]) + (z[99])*(matrix[88]) + (z[100])*(matrix[98])
ji = (z[91])*(matrix[9]) + (z[92])*(matrix[19]) + (z[93])*(matrix[29]) + (z[94])*(matrix[39]) + (z[95])*(matrix[49]) + (z[96])*(matrix[59]) + (z[97])*(matrix[69]) + (z[98])*(matrix[79]) + (z[99])*(matrix[89]) + (z[100])*(matrix[99])
jj = (z[91])*(matrix[10]) + (z[92])*(matrix[20]) + (z[93])*(matrix[30]) + (z[94])*(matrix[40]) + (z[95])*(matrix[50]) + (z[96])*(matrix[60]) + (z[97])*(matrix[70]) + (z[98])*(matrix[80]) + (z[99])*(matrix[90]) + (z[100])*(matrix[100])
new <- c(aa, ab, ac, ad, ae, af, ag, ah, ai, aj, 
	   ba, bb, bc, bd, be, bf, bg, bh, bi, bj, 
	   ca, cb, cc, cd, ce, cf, cg, ch, ci, cj, 
	   da, db, dc, dd, de, df, dg, dh, di, dj, 
 	   ea, eb, ec, ed ,ee, ef, eg, eh, ei, ej, 
	   fa, fb, fc, fd, fe, ff, fg, fh, fi, fj, 
	   ga, gb, gc, gd, ge, gf, gg, gh ,gi, gj, 
	   ha, hb, hc, hd, he, hf, hg, hh, hi, hj, 
	   ia, ib, ic, id, ie, ik, ig, ih, ii, ij, 
	   ja, jb, jc, jd, je, jf, jg, jh, ji, jj)
return(new)
}

play1 <- function(x) {
n <- c(2, 3, 5, 6, 7, 7)
if(x==1) return(sample(n, 1, replace = F))
n <- c(3, 5, 6, 7, 7, 8)
if(x==2) return(sample(n, 1, replace = F))
n <- c(2, 5, 6, 7, 7, 8)
if(x==3) return(sample(n, 1, replace = F))
n <- c(2, 5, 6, 7, 8, 10)
if(x==4) return(sample(n, 1, replace = F))
n <- c(2, 5, 6, 7, 8, 10)
if(x==5) return(sample(n, 1, replace = F))
n <- c(2, 6, 6, 7, 8, 10)
if(x==6) return(sample(n, 1, replace = F))
n <- c(2, 7, 7, 7, 8, 10)
if(x==7) return(sample(n, 1, replace = F))
n <- c(2, 8, 8, 8, 8, 10)
if(x==8) return(sample(n, 1, replace = F))
n <- c(2, 2, 2, 2, 2, 10)
if(x==9) return(sample(n, 1, replace = F))
if(x==10) return(10)
}

playuntilwin <- function(x) {
count = 0
square = 1
while(square!=10) {square = play1(square) 
count = count + 1}
return(count)
} 

play2 <- function(x) {
n <- c(3, 5, 6, 6, 7, 7)
if(x==1) return(sample(n, 1, replace = F))
n <- c(1, 3, 5, 6, 7, 7)
if(x==2) return(sample(n, 1, replace = F))
n <- c(1, 5, 5, 6, 7, 7)
if(x==3) return(sample(n, 1, replace = F))
n <- c(1, 5, 5, 6, 7, 10)
if(x==4) return(sample(n, 1, replace = F))
n <- c(1, 5, 5, 6, 7, 10)
if(x==5) return(sample(n, 1, replace = F))
n <- c(1, 5, 6, 6, 7, 10)
if(x==6) return(sample(n, 1, replace = F))
n <- c(1, 5, 7, 7, 7, 10)
if(x==7) return(sample(n, 1, replace = F))
n <- c(1, 1, 1, 1, 5, 10)
if(x==8) return(sample(n, 1, replace = F))
n <- c(5, 5, 5, 5, 5, 10)
if(x==9) return(sample(n, 1, replace = F))
if(x==10) return(10)
}

playuntilwin2 <- function(x) {
count = 0
square = 1
while(square!=10) {square = play2(square) 
count = count + 1}
return(count)
} 


h <- function(x) {
return(x^7 + x^4 + (cos(x))^7)
}

h_integral <- function(x) {
return((x^8)/8 + (x^5)/5 + (sin(x)*((cos(x))^6))/7 + (6/35)*(sin(x)*((cos(x))^4)) + (8/35)*(sin(x)*((cos(x))^2)) + (16/35)*sin(x))
}

h_integral2 <- function(x) {
return((x^8)/8 + (x^5)/5 + (35*sin(x)/64 + 7*sin(3*x)/64 + 7*sin(5*x)/320 + sin(7*x)/448))
}


start_2 <- function(initial) {
spaces <- c(1:23, 44, 45, 66:88)
places <- sample(spaces, 2, replace = F)
for(item in places) initial[item] = 'car'
return(initial)
}

poisson <- function(x) {
return(((2^x)/factorial(x))*(exp(1)^-2))
}


how_many <- function(x) {
if(x<poisson(1)) return(1)
if(x<(poisson(1)+poisson(2))) return(2)
if(x<(poisson(1)+poisson(2)+poisson(3))) return(3)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4))) return(4)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5))) return(5)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6))) return(6)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7))) return(7)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8))) return(8)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9))) return(9)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10))) return(10)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11))) return(11)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12))) return(12)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13))) return(13)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14))) return(14)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15))) return(15)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16))) return(16)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17))) return(17)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18))) return(18)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19))) return(19)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20))) return(20)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21))) return(21)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22))) return(22)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23))) return(23)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24))) return(24)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25))) return(25)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26))) return(26)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27))) return(27)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28))) return(28)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29))) return(29)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30))) return(30)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31))) return(31)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32))) return(32)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33))) return(33)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33)+poisson(34))) return(34)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33)+poisson(34)+poisson(35))) return(35)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33)+poisson(34)+poisson(35)+poisson(36))) return(36)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33)+poisson(34)+poisson(35)+poisson(36)+poisson(37))) return(37)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33)+poisson(34)+poisson(35)+poisson(36)+poisson(37)+poisson(38))) return(38)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33)+poisson(34)+poisson(35)+poisson(36)+poisson(37)+poisson(38)+poisson(39))) return(39)
if(x<(poisson(1)+poisson(2)+poisson(3)+poisson(4)+poisson(5)+poisson(6)+poisson(7)+poisson(8)+poisson(9)+poisson(10)+poisson(11)+poisson(12)+poisson(13)+poisson(14)+poisson(15)+poisson(16)+poisson(17)+poisson(18)+poisson(19)+poisson(20)+poisson(21)+poisson(22)+poisson(23)+poisson(24)+poisson(25)+poisson(26)+poisson(27)+poisson(28)+poisson(29)+poisson(30)+poisson(31)+poisson(32)+poisson(33)+poisson(34)+poisson(35)+poisson(36)+poisson(37)+poisson(38)+poisson(39)+poisson(40))) return(40)
else return(0)
}

remove <- function(x, initial) {
y = runif(x, 0.000001, 40)
for(item in y) {
while(item>0) {
if(ceiling(item)<21) {
if(initial[ceiling(item)+23]=='car') {
initial[ceiling(item)+23]='empty'
item = 0 }
else item=runif(1, 0.000001, 40) }
if(ceiling(item)>20) {
if(initial[ceiling(item)+25]=='car') {
initial[ceiling(item)+25]='empty'
item = 0 }
else item=runif(1, 0.000001, 40) }
}
}
return(initial)
}

move <- function(initial) {
potential <- c(1:23, 44, 45, 66:88)
for(item in potential) {
if(initial[item]=='car') {
if(item<22) {
initial[item] = 'empty'
initial[item+1] = 'car'
}
if(item==22) {
initial[item] = 'empty'
initial[44] = 'car'
}
if(item==23) {
initial[item] = 'empty'
initial[1] = 'car'
}
if(item==44) {
initial[item] = 'empty'
initial[66] = 'car'
}
if(item==45) {
initial[item] = 'empty'
initial[23] = 'car'
}
if(item==66) {
initial[item] = 'empty'
initial[88] = 'car'
}
if(item==67) {
initial[item] = 'empty'
initial[45] = 'car'
}
if(item>67) {
initial[item] = 'empty'
initial[item-1] = 'car'
}
}
}
return(initial)
}
 
take_spot <- function(lot) {
for(item in 2:21) {
if(lot[item]=='car' & lot[item+22]=='empty') {
lot[item] = 'empty'
lot[item+22] = 'car'
}
}
for(item in 68:87) {
if(lot[item]=='car' & lot[item-22]=='empty') {
lot[item] = 'empty'
lot[item-22] = 'car'
}
}
return(lot)
}

how_long_move <- function(lot) {
turns = 0
num_cars = 1
while(num_cars) {
num_cars = 0
random_num = runif(1, 0, 1)
num_cars_leaving = how_many(random_num)
lot = remove(num_cars_leaving, lot)
lot = take_spot(lot)
lot = move(lot)
potential <- c(1:23, 44, 45, 66:88)
for(item in potential) {
if(lot[item]=='car') num_cars = num_cars + 1
}
turns = turns + 1
}
return(turns)
}


