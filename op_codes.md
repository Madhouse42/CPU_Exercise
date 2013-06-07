
运算指令
========

影响cf, zf
----------

## 加减法
            xxx modify single hascarry sub logic
add dr, sr "000 1      0      0        0   0    " "00010000"
inc dr     "000 1      1      0        0   0    " "00011000"
adc dr, sr "000 1      0      1        0   0    " "00010100"
sub dr, sr "000 1      0      0        1   0    " "00010010"
cmp dr, sr "000 0      0      0        1   0    " "00000010"
dec dr     "000 1      1      0        1   0    " "00011010"
sbb dr, sr "000 1      0      1        1   0    " "00010110"

## 移位
            xxx modify double hascarry direction logic
shl dr, sr "000 1      1      1        0         0    " "00011100"
shr dr, sr "000 1      1      1        0         1    " "00011101"
shl dr     "000 1      0      1        1         0    " "00011110"
shr dr     "000 1      0      1        1         1    " "00011111"

影响zf
------

             xxx modify single y add logic
and  dr, sr "000 1      0      0 0   1    " "00010001"
test dr, sr "000 0      0      0 0   1    " "00000001"
or   dr, sr "000 1      0      0 1   1    " "00010011"
xor  dr, sr "000 1      0      1 1   1    " "00010111"
not  dr     "000 1      1      0 0   1    " "00011001"

不影响
------

mvrr dr, sr "000 1      1      0 1   1    " "00011011"


跳转指令
========
           xxxx y carry zero not
jr   addr "0100 0 0     0    0  " "01000000"
jrc  addr "0100 0 1     0    0  " "01000100"
jrnc addr "0100 0 1     0    1  " "01000101"
jrz  addr "0100 0 0     1    0  " "01000010"
jrnz addr "0100 0 0     1    1  " "01000011"
jmpa addr "0100 1 1     1    1  " "0100111100000000"

访存指令
========

ldrr dr, sr   "1000 0010" "10000010"
strr dr, sr   "1000 0011" "10000011"
mvrd dr, data "1000 0001" "100000010000"



