
CPU设计实验
===========

主要改动
--------

* `SR`和`DR`用4位表示，所以`mux_4_to_1`和`decoder_2_to_4`都有相应改动
* 添加了一些指令，`op_code`增为5位，参见`op_codes.md`，
  主要改动在`decoder_unit`和`exe_unit`里
* 添加了用于debug的相应代码，主要改动在`regfile`和`exp_cpu`里


请注意
------

芯片型号选择为Cyclone II，尾号为240C8


TODO
----

* 上传pin配置说明


备注
----

当前warning数为46个

