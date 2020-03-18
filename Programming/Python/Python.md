## Python3 语法
###基本语法
* 字符串过长的换行,java是+"",python是 + \
* python 字符串可以用*,表示复制几倍
* import X 是引入`X`整个包;from a import X ,是引入`X的class->a`X包内的类a;
* input() 等于 java中System.in
* len() 返回字`符串、列表、字典、元组`长度  与 `range()`不同,range()只能是整数
* 类型转换函数str(),int(),float()
* <font color=Crimson>&&=and</font><font color=LightSeaGreen> ||=or</font><font color=GoldenRod> !=not</font>
* `类假`:0,0.0,'',""被认为是Flase,其他则为True,if条件中判断Boolean 要使用<font color=Crimson> is </font>
* 函数:`def 函数名()`  不需要声明返回值
* None 表示没有值,是NoneType ,函数没有返回值的时候就是返回的None
* print("",end="",sep="")
* 局部变量和全局变量名称相同,优先使用局部变量
* global,使全局变量在一个`函数`内可以被修改
* 列表<font color=Crimson>[]</font>,就是java中的数组,<font color=Orchid>是可变的</font>
    * `可以是负数,代表了倒序取`
    * 切片,表示如下list[1:3],是`左开右闭`的取值范围
    * 两个列表链接,使用`+`
    * in / not in ,`在列表中`,包含/不包含中
    * <font color=SpringGreen>多重赋值</font>,在一行代码中,用列表中的值为多个变量赋值.如: size,color,sex = ["S码","red","Woman"],`变量长度与列表长度必须严格相等`
    * 增加列表元素的方法,append()/insert();删除是remove,当元素相同的时候,只有第一次出现的会被移除
    * sort(),数组排序,只能是纯数字才可以
    * tuple(),将列表变为元组<=>list()将元组变为列表
* 元组<font color=Crimson>()</font>,字符串类似列表,但是是<font color=Orchid>不可变的</font>,因此不可以删除(字符串可以使用切片,切开后重新组合一个新的字符串),如果元组只有一个值,则表示为(value,)需要用`,`分割来代表是一个元组,而不是一个变量
* 字典<font color=Crimson>{}</font>,数据结构类似JSON
    * 字典内数据不排序
    * `keys(),values(),items()`键集合,值集合,k-v集合[^1]
    * get(key,default),如果key不存在,值是default
    * setdefault(key,value),只会给`不存在的key`赋值
* 字符串,可以直接通过下标获取单个char,但是不能修改
    * 转义
    * ''' coding`tools ''' 三重引号,无须转义
    * in / not in支持
    * upper(),lower(),isupper(),islower(),大小写转换,但是不会修改原来值
    * isX , is开头的方法,返回的都是boolean值
    * startwith(),endwith()
    * join(),将列表转换为字符串;split(),正好相反
    * rjust(),ljust(),center()方法对齐文本
    * strip(),rstrip(),lstrip()删除空白字符
    * 使用`pyperclip模块`,拷贝(copy)粘贴(paste)字符串 
###自动化扩展



[^1]:利用多重赋值的技巧,分别获取key和value