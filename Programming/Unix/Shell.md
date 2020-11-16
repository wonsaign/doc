## Shell学习
> 编程的核心是数据结构，而不是算法。

### 语法篇
* mac OS 查看命令文档 man [command] 比如 man find
* linux 直接使用 find -help

#### 第一行
> shell脚本的第一行，一般以`#!bin/bash`开始，其作用是，告诉linux内核系统选择一个`bash进程`，以此类推，python可以写成`#!/usr/bin/python`

#### 执行方式
* ./xxx.sh 
  * 这种执行方式，会创建一个父进程的copy，然后在这个copy里执行，里面修改的内容并不能影响父进程
* shell xxx.sh
* source xxx.sh
  * 直接在父进程中执行，会影响父进程，这就是区别所在。

#### 语法
##### {},[],()区别
* {}，变量使用，可以使用${}进行取值
* []，test条件表达式
* ()，$(cmd),可以调用命令，比如a=$(ls -lthr)


##### 变量赋值
* 变量赋值的语法非常简单，并且shell是弱类型语言，不用指明变量类型。
* **shell语言的一切变量都是字符串的**
* 注意，等号两边，**必须没有空格**
  ```
    your_nikename=oldwang
    如果变量内有空格，需要加引号
    your_whole_name="wang sai"
  ```
* 获取变量的值,通过取值符号`$`
  ```
    $your_name
    如果变量内有空格，推荐使用下面的方式
    ${your_whole_name}
    注意，下面是单引号和双引号的区别。
    name=10
    echo $name           #10
    echo ${name}         #10
    echo '${name}'       #${name}
    echo "${name}"       #10
  ```
* 变量类型，局部变量，全局变量（环境变量是全局变量的一种）
  * 在函数内，使用`local`修饰的变量，只在函数内生效，不会影响到全局变量。见下面例子。
  ```
  name=10
    fun1 (){
        name=20
	    echo "fun1 ${name}"
    }
    fun1 #函数调用
    echo ${name}

    fun2 (){
        local name=30
        echo "fun2 ${name}"
    }
    fun2 #函数调用
    echo ${name}
  ```
* 变量自增的5中方式
  1. i=`expr $i + 1`;
  2. let i+=1;
  3. ((i++));
  4. i=$[$i+1];
  5. i=$(( $i + 1 ))
* 变量算数times=$((times+1))，要使用双括号
* unset,可以删除函数或者变量的值 
  * -v 删除变量，默认是-v
  * -f 删除函数
* 大括号操作符${}还内置了很多高级方法。
  * 替换运算符
    * ${varname:-word}  #varname!=null?varname:word  变量未定义，返回默认值
    * ${varname:=word}  #varname!=null?varname:varname = word 变量未定义，设置为默认值
    * ${varname:?word}  #varname!=null?varname:print[word];exit(0) 用来捕捉变量未定义而导致的错误
    * ${varname:+word}  #varname!=null?word:null 变量存在，返回word，用于测试变量的存在
  * 模式运算符（path=/Users/wangsai/Downloads/ReentrantLock.png）
    * ${varname#pattern} 取开头匹配最短的部分，返回剩余的部分,如 ${path#/*/} -> "/Users/" 被命中，返回剩下的wangsai/Downloads/ReentrantLock.png
    * ${varname##pattern} 取开头匹配最长的部分，返回剩余的部分,如 ${path##/*/} -> "/Users/wangsai/Downloads/" 被命中，返回剩下的ReentrantLock.png
    * ${varname%pattern} 取结尾匹配最短的部分，返回剩余的部分  ？？？
    * ${varname%%pattern} 取结尾匹配最长的部分，返回剩余的部分 ？？？
    * ${varname/pattern/str} 只有匹配的第一部分被替换  ${path/s/S},第一次匹配的“s”被替换为"S" ,**推荐这种写法${path/'s'/'111'}清晰**
    * ${varname//pattern/str} 所有匹配的都被替换 ${path//s/S},所有的“s”都被替换为"S"
  * 注意
    * 以下的例子
    ```
    varname=beijing
    echo ${varname%\=*}
    echo ${varname#*=}
  * ```
##### 输出
* echo 输出`一行`文本
  * echo输出的转义字符
      ```
      \a, 报警符号
      \b, 空格
      \c, 禁止尾随
      \f, 换页符
      \n, 换行符
      \r, 回车符
      \t, 水平制表符
      \v, 垂直制表符
      \\, 反斜线
      ```
* export，可有将变量export到其的子进程中。子进程是不可以通过export变量到父进程到。`其作用是将当前变量设置到环境变量,但是有效期为当前进程消亡。`
  * 注意，如果使用source命令，没有产生子进程，所以export是可以影响父进程的。
  * 主要选项[fnp]
* env 可以临时改变环境变量的值

##### 参数
```
使用demo
./hello.sh 1 2 3 4
其中1 2 3 4 代表了传入的参数
```
* 特殊的参数
  * `$#` 代表了参数的个数
  * `$@` 代表了具体的参数
  * `$0,$1,$2....` 获取参数，注意$0代表了bash命令名称
  * `$$` 代表了当前进程Id
  * `$!` 代表了最后运行的进程Id
  * `$?` 代表了最后命令退出的状态，0代表没有错误
  * `$-` 代表了shell使用的当前选项，与set差不多


##### IO流
* 管道和重定向
  * 重定向
    * `>` 将内容输入到指定到文件，如果文件存在会覆盖
    * `>>` 将内容输入到指定到文件，如果文件存在尾行追加
    * `<`
    * `<<`
  * 管道，pipeline
    * 理论上将，管道完全可以被`<>`来代替，比如下面的例子
    ```
    cat shell.sh > temp1.txt ; grep funp < temp1.txt
    等价于
    cat shell.sh | grep funp
    ```
##### 基本文本检索
* grep
  * 在一个文件或者多个文件查找字符串
  * 注意如果查找包含空格，必须使用“”。
  * 支持正则，使用参数`-E`
##### 文件
* 通过ls 可以查看文件，
    ```
    例如
    drwxr-xr-x 
    -rw-r--r--@
    第一位代表了文件类型，
    '-'代表普通文件，
    'd'代表了目录，
    'c'表示字符设备文件,
    'b'代表了设备，比如光驱，硬盘，
    'l'代表链接文件
    's'代表了套接口文件，比如mysql.sock
    ```
##### 特殊字符
* `～` Home
* **`**   命令替换
* `#` shell注释
* `$` 变量取值符号
* `&` 后台作业，后台运行
* `*` 通配符
* `(` 启动子shell
* `)` 结束子shell
* `\` 转义字符
* `|` 管道
* `[` 开始字符集通配符
* `]` 结束字符集通配符
* `{` 开始命令块
* `}` 结束命令块
* `;` shell命令分隔符
* `'` 强引用
* `"` 弱引用
* `<` 输入重定向
* `>` 输出重定向
* `/` 目录分隔符
* `?` 单个任意字符
* `!` 管道行逻辑NOT

##### 启动文件
* 无论什么情况下，启动文件的顺序都是/etc/environment
* 其次不同的shell，启动第二加载文件不太一样，单一般都是启动/etc/profile
* 第三会加载 $HOME/.bash_profile或者$HOME/.profile

##### 函数
* 同名时，函数的优先级高于脚本。当重名时候，type命令可以查看类别。
* shell函数注意点：
  * **必须先定义，再使用**
  * 函数共享当前脚本变量
  * 函数退出用return，返回函数最后一条语句的状态；脚本退出用exit(0)， 注意`0`代表了成功，其他代表了错误。
  * export -f 可以将函数导入到子shell中。
  * **如果函数保存在其他文件中，可以使用source装载当前脚本。**
  * 函数的定义
    * function hello(){}
    * hello(){}


##### 条件控制
* if
  * 语法,if唯一可以检查的是退出的状态
  ```
    if condition
    then
        statement
    fi
  ```
* test
  * 语法
  ```
    test 3 -gt 2
    或
    [ 3 -gt 2 ] # 注意使用“【】”时，要有空格，容易错
  ```
  * 比较数字
    * test 整数1 **–eq** 整数2 整数相等
    * test 整数1 **–ge** 整数2 整数1大于等于整数2
    * test 整数1 **–gt** 整数2 整数1大于整数2
    * test 整数1 **–le** 整数2 整数1小于等于整数2
    * test 整数1 **–lt** 整数2 整数1小于整数2
    * test 整数1 **–ne** 整数2 整数1不等于整数2
  * 字符串比较
    * `=` 匹配
    * `!=`  不匹配
    * `>` str1大于str2
    * `<` str1小于str2
    * `-n` str 非空
    * `-z` str 为空
    * `=~` 正则匹配
  * 文件检测
    * test File1 –ef File2 两个文件具有同样的设备号和i结点号
    * test File1 –nt File2 文件1比文件2 新
    * test File1 –ot File2 文件1比文件2 旧
    * test –b File 文件存在并且是块设备文件
    * test –c File 文件存在并且是字符设备文件
    * test –d File 文件存在并且是目录
    * test –e File 文件存在
    * test –f File 文件存在并且是正规文件
    * test –g File 文件存在并且是设置了组ID
    * test –G File 文件存在并且属于有效组ID
    * test –h File 文件存在并且是一个符号链接（同-L）
    * test –k File 文件存在并且设置了sticky位
    * test –b File 文件存在并且是块设备文件
    * test –L File 文件存在并且是一个符号链接（同-h）
    * test –o File 文件存在并且属于有效用户ID
    * test –p File 文件存在并且是一个命名管道
    * test –r File 文件存在并且可读
    * test –s File 文件存在并且是一个套接字
    * test –t FD 文件描述符是在一个终端打开的
    * test –u File 文件存在并且设置了它的set-user-id位
    * test –w File 文件存在并且可写
    * test –x File 文件存在并且可执行
* case
  * 语法 
  ```
  case expression in
    pattern1) statements;;
    pattern2) statements;;
    pattern3) statements;;
  esac
  ```
##### 循环控制
* for
  * 语法
  ```
  for item [in list]; do
    statement #可以使用${item}进行相关的操作
  done
  例如
  for item in $(ls -ltrh | grep shell.sh); do
	  echo ${item}
  done
  ```
* while/until
  * 语法
  ```
  where的表达式，condition为false退出循环
  while condition ; do
    statement #可以使用${item}进行相关的操作
  done
  例如
  num=$1
  while [[ num -gt 0 ]]; do
    echo ${num}
    num=$[$num-1];
  done
  ---------------------------------------
  until的表达式，condition为true退出循环，
  until condition ; do
    statement #可以使用${item}进行相关的操作
  done
  例如
  num=$1
  while [[ num -gt 0 ]]; do
    echo ${num}
    num=$[$num-1];
  done

  ```
* continue/break
  * 语法：使用方式与其他语言一样，但是当有多个循环嵌套的时候，可以通过`break(2)`这种方式，代表了跳出几层循环，注意**break == break(1)**

##### 文本处理
* sort 排序
  * 语法 sort [arg] [files...]
  * sort**行**排序 例如sort -d xxx.txt , sort -d -f xxx.txt 
* uniq 文本去重
  * 语法 uniq [ -c | -d | -u ] [Infile [OutFile]]
  * **当重复的行不相邻时，uniq 命令是不起作用的，所以一般配合sort使用** 比如：sort -d fruit.txt | uniq -c
* wc (word count?)统计文本行数，字数以及字符数
  * 语法 wc [ -l | -w | -c ] xxx.txt 
    * -l 行数
    * -w 单词树
    * -c 字符个数
* pr 打印
* fmt 格式化
  * 语法 fmt -[cstu] -w 每列字符数
* fold 
* head和tail
  * 语法head/tail -c -n
* cut
* join 连接两个文件
* tr 文本替换
  * 语法格式
  ```
  tr str1 str2
  或者
  tr {-d | -s} str1
  例如
  tr 'a-z' 'A-Z' < xxx.txt > xxxUpperCase.txt # 就是将xxx.txt里全部的小写字母全部修改为大写字母并写入xxxUpperCase.txt
  ```
  * tr工具比较简单，可以使用更高级的工具，sed，awk

##### 文件
* ls 列表
* chown 修改文件所有
* chmod 修改权限
  * -rwx---rwx ,每3位为一组，分别代表了`属主`，`属组`，`其他用户`。比如-rwx------，代表了只有当前用户有访问权限。
* chgrp 修改所在组
* find 实时查找，速度慢，精确匹配
  * 语法 find pathname -option [-print | -exec | -ok ....] 下面列举所有的选项（option）
    * 以下是查找条件
      * -name 名称
      * -perm 权限
      * -user 按照文件属主
      * -group 按照分组
      * -mtime -n +n (-n表示文件修改距现在n天以内 +n表示文件修改距现在n天以外)
      * -depth 首先找到当前目录，再查找子目录
      * -mount 查找文件时不跨文件系统的mount点
      * -follow 如果查找到符号文件，就跟随符号文件指向的文件
      * -cpio
    * 以下是组合条件
      * -a 与
      * -o 或
      * -not 非 比如 find . -not -name "shell.sh" # 注意 -not 和 -name 的顺序不能反
      * -type（b块文件，d目录，c字符设备文件，p管道文件，l符号连接文件，f普通文件）
      * -size n （n代表了字节） 比如 find . -size -1M |grep "shell.sh" 查找小于1M的文件（n可以写符号，+代表超过，-代表少于）
    * 以下是处理动作
      * -exec或ok  是类似command模式，意在执行文件
      * xargs
      ```
      比如 下面 按照名字查找， 找到后执行 cp 命令
      find . -name  "shell.sh" -exec cp {} /Users/wangsai/Downloads/  \;
      注意exec的命令格式是 -exec [cmd] {} [cmdstatement] \; 注意空格
      ```
  * find 正则
  ```
  Mac上 
  find  -E . -regex  "(.+)\.jpg"
  或者 使用管道grep+正则  
  find . -type f | grep -E  "(.+)\.jpg" 
  Linux 
  find . -regextype 'posix-egrep' -regex  "(.+)\.jpg"
  注意上面两种正则表达式的“path”的位置，mac是-E后写path，linux是path后跟-regextype 'posix-egrep'，这点一定要注意。
  ```
* xargs（英文全拼： eXtended ARGuments）是给命令传递参数的一个过滤器，也是组合多个命令的一个工具。
  * 选项如下
    * -a file 从文件中读入作为sdtin
    * -e flag ，注意有的时候可能会是-E，flag必须是一个以空格分隔的标志，当xargs分析到含有flag这个标志的时候就停止。
    * -p 当每次执行一个argument的时候询问一次用户。
    * -n num 后面加次数，表示命令在执行的时候一次用的argument的个数，默认是用所有的。
    * -t 表示先打印命令，然后再执行。
    * -i 或者是-I，这得看linux支持了，将xargs的每项名称，一般是一行一行赋值给 {}，可以用 {} 代替。
    * -r no-run-if-empty 当xargs的输入为空的时候则停止xargs，不用再去执行了。
    * -s num 命令行的最大字符数，指的是 xargs 后面那个命令的最大命令行字符数。
    * -L num 从标准输入一次读取 num 行送给 command 命令。
    * -l 同 -L。
    * -d delim 分隔符，默认的xargs分隔符是回车，argument的分隔符是空格，这里修改的是xargs的分隔符。
    * -x exit的意思，主要是配合-s使用。。
    * -P 修改最大的进程数，默认是1，为0时候为as many as it can ，这个例子我没有想到，应该平时都用不到的吧。
  ```
  find /sbin -perm +700 |ls -l       #这个命令是错误的
  find /sbin -perm +700 |xargs ls -l   #这样才是正确的
  比如 find . -type f | xargs grep "shell.sh" 可以配合find命令，执行额外的命令。
  ```
  * xargs与exec的区别。
    * exec参数是一个一个传递的，传递一个参数执行一次命令；xargs一次将参数传给命令，可以使用-n控制参数个数
    * exec文件名有空格等特殊字符也能处理；xargs不能处理特殊文件名，如果想处理特殊文件名需要特殊处理
* diff 文件比较，逐行比较

##### 文件系统
* 支持的文件格式ext3，ext4，ZFS，reiserfs,windows只支持Fat32和NTFS
* fdisk 分区工具
* 文件和目录树居住在磁盘中，所以一般感受不到磁盘的存在。
* mkfs 格式化硬盘
* mount 挂载磁盘

##### 流编辑
* sed，对于用户的输入，执行用户指定的编辑，sed是基于行的，**比如可以对一个文件的第五行插入你想操作的数据**
  * 语法 sed [-hnV] [-e<scipt>] [-f<scipt文件>]  文本文件  (普通参数：e,f,h,n,V)(动作参数->a新增,c取代,d删除,i插入,p打印,s取代）
  ```
  sed的动作参数非常强大，可以执行一些操作
  动作参数
    a新增,c取代,d删除,i插入,p打印,s取代
  =代表了输出行号，两部分动作可以使用分隔符【;】隔开 比如 【sed -n -e '=;p' fruit.txt】
  ```
  * 注意，sed不会修改源数据 如 sed -e '5d' fruit.txt ，源数据不会被改变  动作参数`5d`最好用''包住。
  * sed是将所有的行一行一行的读入缓存，执行对应的命令（比如 -e '5d' ）
  * sed 范围使用，sed -e '1,5d' fruit.txt
  * sed规则表达式,规则表达式可以使用正则表达式(原生的那种，不是通配符的那种。)
  ```
  比如使用 grep '^#' /etc/hosts
  那么sed的语法是  sed '/^#/' /etc/hosts 使用'//'包含住表达式内容
  例子二：
  sed -n -e '/^#/p' shell.sh 此例子说明，-e<script>可以加动作参数，此列就使用了 -e '/^#/p',就是规则表达式+动作参数。
  ```

##### awk未完待续
* 文本处理利器,简单demo；ls -ltrh | awk '{print $1}' 注意单引号
* awk [options] 'pattern {action}' file...  可以用汉字的表述就是，`用什么方式找，找到了后干什么`。
  * 注意，如果是正则表达式，需要使用'//'包住表达式，与上面的sed是一样的。
* awk 有几个概念 NR(number record),RS(record separator)，一行一行的叫record记录，通过分隔符将一行划分为多个field，叫做域
* awk可以单独写成xxx.awk文件执行，不过语法方面略微不同。
* awk就是另外一种语言啊,与c语言很像。
  * 参数
  ```
  -F 指定分隔符
  a='abc,123'
  a1=$(echo "$a" | awk -F "," '{print $1}')
  a2=$(echo "$a" | awk -F "," '{print $2}')
  echo '拆分后第一部分:'$a1
  echo '拆分后第二部分:'$a2
  语法规则： awk [options] 'pattern {action}' file... 
  awk -F":" '/app^/{print $0}' # 正则表达式，如果有多个正则，使用逗号隔开，比如【/[a-z]+/,/[A-Z]+/】
  awk -F":" '$2==2{print $0}' # 这种叫条件表达式
  awk 'NF==2{print $0}'
  awk 'NR>=2&&NR<=5/{print $0}' #范围表达式
  awk '$1~/[a-z]+/{print $0}' #范围表达式,这里【$1~/[a-z]+/】意思是$1参数匹配正则，【～】代表了匹配正则。

  ```
  * 模式匹配 /正则/ {匹配后的操作}
  * 变量，分为内建变量和用户自定义变量，awk的变量无需声明使用，最开始都会设置为空。

##### 进程
* ps



### 实战篇
> 下面是shell使用过程中的案例。
1. 情景一 : replaced
```
replaced=$(echo "${jarfullname}" | sed -E "s/${jarname}/dump-api-${releasestr}.jar/g")
注意：正则不支持(?<=...) or *? or (?=...)
```
2. 情景二: 查找最近6H内修改的CSV文件。
```
find ~/projects/  -mmin -360 -name "*.csv"
```
3. 情景三 find然后xargs
```
find /var/lib/jenkins/workspace/ -type f | grep -E 'dump-api.*.jar' | xargs -I jar echo jar
找到工作目录下的文件，按照正则表达式查找，将找到的参数命名为“jar”，然后通过echo输出jar变量
```
4. 情景四 处理jps程序
```
# for循环是把每一个输入的流，按照空格分开赋值给变量的的
javapid=""
for item in $(jps -l); do
	# echo "${item}"
	
    if [[ "$item" =~ ^[0-9]+$ ]]  ; then
		javapid=$item
		echo "im in"
		continue
	fi
	# find 对应的 jps 程序， jps这里需要修改
	if [[ $(echo "${item}" | grep -E "Jps" )  != "" ]]; then
		break
	fi
done
```
5. 情景五 awk使用
```
对于变量，必须使用echo编程流，然后在才可以使用awk，因为awk处理的是file
item0=$(echo "${itme}" | awk  '{print $1}' )
```
