
CPU设计实验
===========
Make a CPU with Cyclone II which supports basic operations.


主要改动
--------

* `SR`和`DR`用4位表示，所以`mux_4_to_1`和`decoder_2_to_4`都有相应改动。
* 添加了一些指令，`op_code`增为5位，参见`操作指令`，主要改动在`decoder_unit`和`exe_unit`里。
* 添加了用于debug的相应代码，主要改动在`regfile`和`exp_cpu`里。

引脚配置
--------

|Node Name|Location|Node Name|Location|Node Name      |Location|
|---------|:------:|:-------:|:------:|:-------------:|--------|
|AR[0]    |PIN_51  |OB[0]    |PIN_238 |reg_content[0] |PIN_87  |
|AR[1]    |PIN_50  |OB[1]    |PIN_237 |reg_content[1] |PIN_86  |
|AR[2]    |PIN_49  |OB[2]    |PIN_236 |reg_content[2] |PIN_84  |
|AR[3]    |PIN_47  |OB[3]    |PIN_235 |reg_content[3] |PIN_80  |
|AR[4]    |PIN_46  |OB[4]    |PIN_234 |reg_content[4] |PIN_79  |
|AR[5]    |PIN_44  |OB[5]    |PIN_233 |reg_content[5] |PIN_78  |
|AR[6]    |PIN_42  |OB[6]    |PIN_232 |reg_content[6] |PIN_73  |
|AR[7]    |PIN_41  |OB[7]    |PIN_231 |reg_content[7] |PIN_72  |
|AR[8]    |PIN_39  |OB[8]    |PIN_230 |reg_content[8] |PIN_70  |
|AR[9]    |PIN_38  |OB[9]    |PIN_228 |reg_content[9] |PIN_68  |
|AR[10]   |PIN_37  |OB[10]   |PIN_226 |reg_content[10]|PIN_67  |
|AR[11]   |PIN_21  |OB[11]   |PIN_223 |reg_content[11]|PIN_66  |
|AR[12]   |PIN_20  |OB[12]   |PIN_222 |reg_content[12]|PIN_65  |
|AR[13]   |PIN_18  |OB[13]   |PIN_218 |reg_content[13]|PIN_64  |
|AR[14]   |PIN_16  |OB[14]   |PIN_216 |reg_content[14]|PIN_58  |
|AR[15]   |PIN_15  |OB[15]   |PIN_214 |reg_content[15]|PIN_57  |

|Node Name      |Location|Node Name|Location|
|---------------|:------:|:-------:|--------|
|reg_sell[0]    |PIN_113 |WE       |PIN_6   |
|reg_sell[1]    |PIN_114 |c_flag   |PIN_131 |
|reg_sell[2]    |PIN_116 |z_flag   |PIN_130 |
|reg_sell[3]    |PIN_117 |clk      |PIN_95  |
|reg_sell[4]    |PIN_118 |reset    |PIN_94  |
|reg_sell[5]    |PIN_119 |         |        |

操作指令
-------

### 运算指令

#### 影响cf, zf

*   加减法

|指令        |xxx|modify|single|usecarry|sub|logic|最终形式  |
|------------|:-:|:----:|:----:|:------:|:-:|:---:|----------|
|`add dr, sr`|000|1     |0     |0       |0  |0    |`00010000`|
|`inc dr`    |000|1     |1     |0       |0  |0    |`00011000`|
|`adc dr, sr`|000|1     |0     |1       |0  |0    |`00010100`|
|`sub dr, sr`|000|1     |0     |0       |1  |0    |`00010010`|
|`cmp dr, sr`|000|0     |0     |0       |1  |0    |`00000010`|
|`dec dr`    |000|1     |1     |0       |1  |0    |`00011010`|
|`sbb dr, sr`|000|1     |0     |1       |1  |0    |`00010110`|


*   移位

|指令        |xxx|x  |single|hascarry|direction|logic|最终形式  |
|------------|:-:|:-:|:----:|:------:|:-------:|:---:|----------|
|`shl dr, sr`|000| 0 |0     |1       |0        |1    |`00000101`|
|`shr dr, sr`|000| 0 |0     |1       |1        |1    |`00000111`|
|`shl dr`    |000| 0 |1     |1       |0        |1    |`00011101`|
|`shr dr`    |000| 0 |1     |1       |1        |1    |`00011110`|

#### 影响zf

*   位运算指令

|指令         |xxx|modify|single|y  |add|logic|最终形式  |
|-------------|:-:|:----:|:----:|:-:|:-:|:---:|----------|
|`and  dr, sr`|000|1     |0     |0  |0  |1    |`00010001`|
|`test dr, sr`|000|0     |0     |0  |0  |1    |`00000001`|
|`or   dr, sr`|000|1     |0     |0  |1  |1    |`00010011`|
|`xor  dr, sr`|000|1     |0     |1  |1  |1    |`00010111`|
|`not  dr`    |000|1     |1     |0  |0  |1    |`00011001`|

#### 不影响

*   访存指令

|指令         |xxx|modify|yyyy|最终形式  |
|-------------|:-:|:----:|:--:|----------|
|`mvrr dr, sr`|000| 1    |1111|`00011111`|

### 跳转指令

|指令       |xxxx|y  |carry|zero|not|最终形式          |
|-----------|:--:|:-:|:---:|:--:|:-:|------------------|
|`jr addr`  |0100|0  |0    |0   |0  |`01000000`        |
|`jrc addr` |0100|0  |1    |0   |0  |`01000100`        |
|`jrnc addr`|0100|0  |1    |0   |1  |`01000101`        |
|`jrz addr` |0100|0  |0    |1   |0  |`01000010`        |
|`jrnz addr`|0100|0  |0    |1   |1  |`01000011`        |
|`jmpa addr`|0100|1  |1    |1   |1  |`0100111100000000`|

### 访存指令

|指令           |xxxx|yyyy|最终形式      |
|---------------|:--:|:--:|--------------|
|`ldrr dr, sr`  |1000|0010|`10000010`    |
|`strr dr, sr`  |1000|0011|`10000011`    |
|`mvrd dr, data`|1000|0001|`100000010000`|

请注意
------

芯片型号选择为Cyclone II，尾号为240C8。

备注
----

当前warning数为46个。

