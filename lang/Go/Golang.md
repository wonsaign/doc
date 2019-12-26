## Go语言
> 优点：流量支撑（大数据排序，推荐，搜索；缓存，容错，按条件分流，大并发能力强）；云平台，分布式。

### 基础篇
* 变量赋值
  * 局部变量
    * var i = 10 //静态变量推导
    * var i int = 10 // 指定声明
    * i := 10 // 语法糖
    * var a, b, c int // 指定都是int
    * var a, b, c // 可以全部是静态推导
  * 全局变量
    * var i
    * var a, b, c
    * var (
        x1 = 1
        y1 = 2
        z1 = 3
    )
* 函数声明
  * func 关键字
  * func 方法名（小驼峰代表了：non-static； 大驼峰代表了 static）
  * func hello(a int, b string)(boolean, int8) // 第一个是括号是入参，第二个括号是出参
* 基本类型
  * int 有符号(根据操作系统)// 等待测试
    * int8 // 等同于 byte
    * int16
    * int32
    * int64
  * uint 无符号
    * uint8
    * uint16
    * unit32
    * uint64
  * byte ：int8的别名 ，实际上golang没有char类型，可以使用int8表示
  * rune ：int32的别名
  * bool 布尔
  * float32，float64
  * string[^1]// 字符串在golang中是基本类型  
    * "abc"
    * `` // 反引号，可以包含大段代码 不用<b>转义</b>
  * complex64，complex128 复数（科学计数法的）
* 基本类型默认值
  * int 0
  * bool false
  * string ""
* 类型转换
  * 与java不同的是，java是（int）i = 2； golang是int32（i）
  * 另外高位数和低位数可以互相转换，但是当高向低级别转的时候会「丢失数据」
  * 其他类型->string的时候，可以使用fmt.Sprinf()或者strconv.FormatInt/FormatFloat....
  * string->其他类型的时候[^2]，可以使用strconv.ParseInt/ParseFloat....
* 复杂类型
  * 指针，存贮的是变量在内存中的地址
  * 声明方式 以int指针为例  var ip *int8  // 注意指针无法显示的赋值地址，暂时我还没学会
  * 为了说明指针，下图说明（指针变量也是‘值’，存贮指针的‘值’，也是有地址的。）
![pointexplain](../../Images/pointexplain.jpeg)
* 运算符
  * 与java不同的是，不支持i=i++，因为golang设计理念比较简介，减少容易产生歧义的地方。并且只支持i++，不支持++i
  * golang不支持三元运算符。
  * switch
    * case后不需要写break
    * case后面可以带多个表达式，如 case SPRING,SUMMER
    * case后使用`fallthrough`关键字，可以穿透到下一个case
  * for循环
    * for{} 与 java中到 for（;;）{} 的效果是一样的 这个是`字节`遍历
    * for range 举例子  <b>for index,val range list{}</b> 这个是`字符`遍历
  * while 和 do while  
    * golang 没有这两个，可以使用for if break 代替
* 包 import
  * 在import包时，路径从`$GOPATH目录下是src`开始
  * 如果包名过长，可以起别名。
![packagealias](../../Images/packagealias.png)
* 值传递和引用传递
  * 不管是值传递还是引用传递，传递的都是变量的copy，不同的是值传递是copy的值，引用传递copy的是地址，地址效率高，因为地址长度小，占用空间小，copy时间短。
* 函数
  * golang不支持重载（Overload）
  * golang没有static关键字，如果引用a包中的工具方法，方法名必须大驼峰（public）,与java面向对象的语言不同的是，java可以new对象之后，使用对象的方法，也可以声明方法为static，此时使用方式则与golang一致。
  * 基本语法 func 函数名 (形参列表) (返回值类型列表) {}
    * 如果返回值多个的时候，如果要忽略某个返回值使用‘_’(下划线)表示站位
    * 返回值只有一个括号可以不写(感觉是非常好用的特性)
    * 返回值列表，可以不声明变量，也可声明变量 比如（x int, y string）=>(int, string)
  * golang中函数也是一种数据类型。使用方式： var 变量名 = 函数名 如： var f = add[^3]
    * 函数可以作为形参。函数式编程。
  * 自定义类型type
    * 语法 type <b>自定义数据名</b>  <b>数据类型</b>
    * 虽然给指定的类型命名了，但是如果要转换类型，还是必须要进行类型转换的
![golangtype](../../images/golangtype.png)
  * init函数 在每个go文件中，都可以定义一个init函数，在golang运行都时候，会先调用init函数
    * 调用顺序  变量定义->init函数->main函数
  * 匿名函数（不是匿名类）
    * 使用方式
![golananonymousfunc](../../images/golananonymousfunc.png)
  * 闭包 ？！ 我没研究透
* defer函数延迟加载：函数执行完毕后会调用。
  * defer后面必须是function。
  * defer可以声明多次，并按照声明的顺序，以`栈`的方式存贮，并且入栈时，相应的值也会copy，类似函数传参
  * 与java中的finally不一样,java中，try-finally，在try区块内，即使使用return，finally也会在return之后执行，与defer差距巨大，但是作用类似，都是为了close流等操作。
* string字符串
  * 常用的工具包buildin，内置工具包
  * strings，string的工具包，包含了index，spilit，contains，equals[^4]等等。
* bulidin
  * new，创建基本类型的指针 如 var x = new(int8)
  * make,返回自身参数类型的引用，而非指针。结果依赖传递的类型。
  * len，可以传递任意类型。
* time包，时间处理工具，具体使用需要查询api，java8的time与之很像
  * time.sleep() 可以休眠，是否与java中的Thread.sleep相同.
* 异常处理
  * defer，panic，errors，recover
    * panic == excepiton
    * defer == finally
    * recover == catch
    * errors.new 可以自定义生成一个panic
  * golang处理异常的方式不太一样,
    * 因为没有try区块,所以java中使用try-catch,在golang中使用的是defer function(){recover()},通过recover()来恢复线程.
* 数组
  * 声明方式
    * var array [3]int = [3]int{1, 2, 3}
    * var array = [3]int{1, 2, 3}
    * var array = [...]int{1, 2, 3}
    * var names = [3]string{1:"tom", 2:"jack", 3:"marry"}
* 切片(动态数组)
  * 切片类似一个结构体{*type[],len,cap},包含了指针数组,长度和容量三个属性
  * 初始化三种方式
    * 数组-> var arr [5]int = [...]int{1,2,3,4,5}  var slice = arr[1,3][^5]  `这种方式,因为事先声明了数组,所以程序可见`
    * make-> var slice []type = make([]type, 5, 10) `数组由切片底层维护么,对程序不可见`
    * 直接声明-> var slice []type = []type{param1, param2, param3}
  * 切片可以使用`append`扩容,具体用法见API.原理与java数组扩容是一样的.
  * 切片定义完,不能立即使用,需要引用到一个数组,或者make一个空间供切片使用.类似指针,刚刚创建出来是nil,需要new一块地址出来一样的.
  * copy,切片可以copy,但是不同的是,copy后的两个切片,都有自己独立的空间,修改互不影响.

[^1]: 使用“+”连接字符串，但是如果字符串过于长的时候，换行的时候，`必须将符号放在末尾`，因为golang会默认在尾部补充“;”
[^2]: 当string不能转换为其他有效当数字时候，如“hello”，则会变成默认值0
[^3]: 注意，这里带函数不能带括号，带括号代表了调用函数，不带括号才是声明函数
[^4]: 注意，区分大小写的比较是==，不区分是EqualFold
[^5]: 左闭右开区
