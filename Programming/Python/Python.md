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


#### 字符串

* 字符串支持切片，如下图
    ```
    +---+---+---+---+---+---+
    | P | y | t | h | o | n |
    +---+---+---+---+---+---+
    0   1   2   3   4   5   6
    -6  -5  -4  -3  -2  -1
    ```
* Python 中的字符串不能被修改，它们是immutable的

#### 列表

* squares = [1, 4, 9, 16, 25]
* 支持切片
* 是mutable的，可以修改
* 结尾append加新元素
* list.insert(i, x)，i=位置，x元素，所以a.insert(0, x)插入列表头部，a.insert(len(a), x)等同于a.append(x)。
* remove（x）删除
* pop（[i]）弹出指定位置元素并返回。
* del（[i]）删除第i个元素
* remove(x)删除x
* clear()清空
* count(x)x出现的次数
* sort排序
* reverse()反转
* copy，浅copy
* 常规操作letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
  * 替换letters[2:5] = ['C', 'D', 'E']
  * 删除letters[2:5] = []
  * 清空letters[:] = []
* 列表推导式
  * 表达式的形式：[(表达式) for子句]

#### 集合

* 集合是由不重复元素组成的无序的集=》Set
* seta={'a','b','c','d',1,2}或者setb = set('abcde2f123')

#### 字典

* dict =》 Map
* tel = {'jack': 4098, 'sape': 4139},格式{K1:V1,K2:V2,...}
* 可以使用字典推导式创建：{x: x**2 for x in (2, 4, 6)}
* 字典的for循环： for k, v in knights.items():
* 字典的for循环： for i, v in enumerate(['tic', 'tac', 'toe']): 获取索引的index和value
* 当同时在两个或更多序列中循环时，可以用 zip() 函数将其内元素一一匹配。
    ```
    >>> questions = ['name', 'quest', 'favorite color']
    >>> answers = ['lancelot', 'the holy grail', 'blue']
    >>> for q, a in zip(questions, answers):
    ...     print('What is your {0}?  It is {1}.'.format(q, a))
    ``` 
* sorted函数进行排序
* set去除重复的元素 basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana'] ; for f in sorted(set(basket)):

#### 流程控制

* if
* for
* for i in range(5)
* break,continue
* pass什么都不做。

#### 函数更多形式

* `参数默认值`def ask_ok(prompt, retries=4, reminder='Please try again!')，prompt参数必传，其他参数选填
* 元组和字典参数：cheeseshop(kind, *arguments, **keywords)，注意当两个参数同时存在，元组参数一定要在字典参数之前。
  * *arguments 元组
  * **keywords 字典
* 关键字形参，`/`,`*`，比如def f(pos1, pos2, /, pos_or_kwd, *, kwd1, kwd2)
  * `/`，pos_only_arg(1)正确，pos_only_arg(arg=1)错误
  * `*`，kwd_only_arg(3)错误，kwd_only_arg(arg=3)正确
* lambda表达式
* 函数可以作为参数，f = make_incrementor(42)，这里当f就是函数。

#### 模块

* import导入模块
* 如果你想经常使用某个函数，你可以把它赋值给一个局部变量: fib = fibo.fib 或者 写成 from fibo import fib, fib2
* import fibo as fib
* from fibo import fib as fibonacci
* 内置模块builtins
* sys系统模块，它被内嵌到每一个Python解释器中
* dir 内置函数 dir() 用于查找模块定义的名称。 它返回一个排序过的字符串列表。
* **必须要有__init__.py文件才能让Python将包含该文件的目录当作包**
* 当执行python xxx.py的时候，模块里的代码会被执行，

#### python注意点

* py没有i++,可以写成i+1，或者i++1

[^1]:利用多重赋值的技巧,分别获取key和value