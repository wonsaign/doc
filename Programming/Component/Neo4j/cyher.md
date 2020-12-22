### Cypher

* Cypher 是 借鉴了sql语句的 Neo4j 数据库操作语句
```
MATCH:匹配图模式,从图中获取数据的常见方式
WHERE:不是独立的语句,而是MATCH,OPTION MATCH 和 WITH 的一部分,用于给模式添加约束或者过滤传递给WITH的中间结果
CREATE和DELETE:创建和删除节点关系
SET和REMOVE:使用SET设置属性值和给节点添加标签,使用REMOVE移除他们
MERGE:匹配已经存在的或者创建新节点和模式,对于有唯一性约束的时候非常有用
RETURN: 定义返回的结果
```
示例:查找john和john朋友的朋友
```
MATCH (john {name:"john"}) -[:friend] ->()-[:friend]->(friend)
RETURN john.name,friend.name
```
示例二:添加过滤条件的查询
找到所有关注过朋友的用户,并返回他们关注的朋友中以S开头的人的名字
```
MATCH (user)-[:friend]->(follwer)
WHERE user.name IN ['Joe', 'John', 'Sara'] AND
follwer.name =~ 'S.*'
RETURN user.name, follwer.name
```
* 模式讲解:
在Neo4j数据库中,图由节点和关系构成.节点有标签和属性.关系有类型和属性.节点表达的是实体,关系连接一对一节点.节点可以类似看做mysql的表(具体是不一样的),标签就相当于是表名,属性相当于表中的列.一个节点的数据类似于mysql中的一行数据.不同的是相同标签的节点可以拥有自定义的属性,他们可以有相似的属性结构,也可以不相似.通过关系的连接可以得到深层次的查询

* 节点语法:
```
Cypher采用一对()来表示节点.
():匿名节点,匹配所有的节点,如果想要操作匹配到的节点,需要加变量(matrix)
(matrix):赋有变量的节点,matrix将包含匹配到的所有节点,通过matrix变量可以对它们进行操作
(matrix:Movie): 指定了标签的节点,只会匹配标签为Moive的节点
(matrix:Movie {title:"Haha"}):指定了标签和属性的节点,只有节点标签是Movie,标题为Haha的节点会被匹配
```
* 关系语法:
```
-- :表示无方向关系
-->:有方向关系
-[rale]->:给关系赋予一个变量,方便对其操作
-[rale:friend]->:匹配关系类型为friend类型的关系,并赋予rale变量接收
-[rale:friend {long_time:2}]->:给关系加条件,匹配friend类型的关系且属性long_time为2

同时如果想要关系语法不想重复写,想要多个语句写的时候减少重复写,可以将关系语法赋予一个变量
acted_in = (people:Person)-[:acted_in]->(movie:Movie)
这样acted_in 就可以写到多个查询语句中,减少重复编写
```
* 更新语句
```
一个Cypher查询部分不能同时匹配和更新图数据,每个部分要么读取和匹配图,要么更新它,如果需要读取并且更新图
它需要两部分:读取和更新.
对于读取,Cypher采用惰性加载,直到需要返回结果的时候才实际的去匹配数据.
with用来连接这两部分

使用with语句进行聚合过滤查询,示例:
MATCH (n {name:"John"})-[:friend]-(friend)
WITH n, count(friend) as friendsCount
WHERE friendsCount>3
RETURN n, friendsCount

使用with语句进行聚合更新,示例:
MATCH (n {name:'John'})-[:friend]-(friend)
WITH n,count(friend) as friendsCount
SET n.friendsCount = friendsCount
RETURN n.friendsCount
```

* 返回数据
```
任何查询都可以返回数据.RETURN语句有三个子句,分别为SKIP,LIMIT和ORDER BY
```
* 事务
```
任何更新图的查询都运行在一个事务中,一个更新查询要么全部成功,要么全部失败
Cypher要么新创建一个事务,要么运行在一个已有的事务中:
如果上下文中没有事务,Cypher将会创建一个,一旦查询完成就提交该事务
如果运行上下文中已有事务,查询就会运行在该事务之中.直到事务成功提交之后,数据才会被存储

可以将多个查询作为单个事务去运行,保证数据正常
注意:事务中的查询结果是放在内存中的,一个事务如果查询量巨大会造成内存的大量使用
```
* 唯一性
```
进行模式匹配时,默认不会多次匹配同一个图关系.比如匹配John朋友的朋友,不会将John自己也返回给John

示例:
1.先准备数据
CREATE (john:Person {name:"John"}),(nick:Person {name:"Nick"}),(hello:Person{name:"Hello"}),
john-[:friend]->(nick),(nick)-[:friend]->(hello)

2.查询数据
MATCH (john:Person {name:"John"})-[:friend]-(friend1)-[:friend]-(friend2)
RETURN john.name,friend2.name

3.返回结果是
Hello标签的节点

如果想要更改默认的返回方式,比如我想要返回john自己本身.这个时候可以这样做:
将上面的一个查询给拆分成两个(因为同一个查询不会查询同一个关系,所以拆成两个查询)
MATCH(john:Person{name:"john"})-[:friend]-(friend1)
MATCH(friend1)-[:friend]-(friend2)
RETURN friend2.name
```

* 设置Cypher查询的版本
```
Neo4j数据库的Cypher也是会进行版本变化的.
可以在neo4j.conf配置中cypher.default_language_version 参数来设置Neo4j数据库使用哪个版本的Cypher语言

如果只是想在一个查询中指定版本,可以在查询语句的开头地方写上版本
比如:
Cypher 2.3
match(n) return(n)

目前的版本有3.1  3.0 2.3
```
* Cypher的基本类型
```
数值
字符串
布尔
节点
关系
路径
映射(map)
列表(list)
```
* 转义字符
```
\t 制表符
\b 退格
\n 换行
\r 回车
\f 换页
\\ 反斜杠
\uxxxx Unicode UTF-16 编码
\uxxxxxxxx Unicode UTF-32 编码
```
* 表达式
```
十进制
十六进制 : 0x开头
八进制:0开头
字符串
布尔 True true False false
变量  n
属性 n.prop
动态属性 n["prop"]  map[coll[0]]  rel[n.city + n.zip]
参数 $0 $param
表达式列表  []
函数调用 length(p) nodes(p)
聚合函数 avg(x.prop) count(*)
正则表达式  a.name =~ 'Tob.*'
路径 (a) -()->(b)
计算式   1+2 and 3>4
断言表达式 a.prop = 4  length(a)>10
大小写敏感的字符串匹配表达式  a.prop STARTS WITH 'Hello' , a.prop1 ENDS WITH 'World',a.name CONTAINS 'N'
```
* CASE表达式
```
示例:

MATCH(n)
RETURN  
CASE n.eyes
WHEN 'blue'
THEN 1
WHEN 'brown'
THEN 2
ELSE 3 
END 
AS result

返回结果:
result
2
1
3
2
1
```
* 变量
```
变量的命名必须是字母,数字,下划线,且字母开头.如果想要用到其他字符,就需要将变量用`` 包括起来,比如!
match(`!`) return `!`
```
* 参数
```
{"name":"nick"}
方式一:
MATCH(n)
WHERE n.name = $name
RETURN n

方式二:
MATCH(n {name:"nick"})
RETURN n


正则表达式
{"regex":"N.*"}

MATCH(n)
where n.name =~ $regex
return n


对大小写敏感的字符串模式匹配
match(n)
where n.name starts with "N"
return n
```
* 创建带有属性的节点
```
{
   "student_a":{
      "name":"Nick",
      "num_list":["1","2","3"]
  }
}

方式一:
create(:Student $student_a)

方式二:
create(student_a:Student {"name":"Nick", "num_list":["1","2","3"]})
```
* set 设置节点的所有属性
```
注意这将替换当前的所有属性

match(n)
where n.name = 'Nick'
set n.name = "nick"
```
* skip 和limit
```
match(n)
return n.name
skip 1
limit 1
```
* in
```
match(n)
where n.id in [1,2,3,4]
return n
```
* 运算符
```
数学运算符 +, -, *, /, %, ^
比较运算符 = ,<>,  <, >, <=, >= , is null , is not null 
布尔运算符 and  or  nor xor(异或) 
字符串运算符 连接运算符+   正则匹配运算 =~
列表运算符  in
```
* 注释
```
Neo4j数据库采用//表示注释
```
* 模式:
```
节点

(a)
```
* 关联节点
```
(a)-->(b)
(a)-->()<--(c)
箭头表示方向,查询的时候不指定箭头就是匹配任意方向的关系
节点的命名仅当后续的模式或者Cypher查询中需要引用时才需要.如果不需要引用可以省略
```
* 标签
```
(a:User)
节点可以有多个标签
(a:User:People:Person)
```
* 关系
```
不关心方向的关系
(a)--(b)
若需要引用关系,起个变量
(a)-[r]-()
给关系增加类型约束
(a)-[r:rela]-(b)
注意节点可以有多个标签,但是关系只有一个类型,如果你在match的时候想要查询多个类型的关系,他们必须是或的关系,可以使用 |

match (a)-[r:real1|real2]->(b) return r
```
* 匹配路径长度的关系
```
(a)-[*2]->(b)  指定了关系数量为2 的3个节点的匹配, 等价于
(a)-[]->()-[]->(b)  或 (a)-->()-->(b)

指定可变长度的关系
(a)-[*2..4]->(b)  匹配路径长度为 2 到4 之间 的路径
(a)-[*2..]->(b) 匹配路径长度大于2的路径
(a)-[*..2]->(b) 匹配路径长度小于2的路径
(a)-[*]->(b) 匹配任意长度的路径

示例:
match (me)-[:know*1..2]-(remote_friend)
where me.name = "Nick"
return remote_friend.name
```
* 列表
```
创建列表
return [0,1,2,3,4] as list
>>  [0,1,2,3,4] 
return range(0,4)   注意range左边和右边都是开区间
>> [0,1,2,3,4] 
```
* 列表的索引
```
return range(0,4)[1]
>>1
return range(0,4)[-1]
>>4
return range(0,4)[0..3]   注意索引是左开又闭区间
>>[0,1,2]
单个索引越界返回null
return range(0,4)[5]
>>null

多个索引越界从越界的地方截断
return range(0,4)[3..7]
>>[3,4]
```
* 列表推导式
```
return [x in range(0,4) where x % 2 =0 | x^2 ] as result
>> [0,4,16]
```
* 模式推导式
```
模式推导式也可以理解为去匹配结果,将结果作为列表展示
比如: 匹配与nick有关的所有电影的发行年限
match(nick:People {name:"nick"})
return [(nick)-->(m)  where m:Movie | m.year] as years
```
* map字典投射
```
    返回map
    return {key:"value",listkey:[{inner:"map1"},{inner:"map2"}]}

    复杂的投射举例
    找到nick和他参演过的所有电影
    match(actor:Person {name:"nick"})-[:acted_in]->(m:Movie)
    return actor {.name, .realname, movies:collect(movie {.title, .year})}
    >> {name->"nick",realname->"hello nick",movies->[{title->"taitannike",year->"long_ago"},...]}

    找到所有的演员以及他们参演过的电影的数量
    match(p:Person) -[:acted_in] ->(m:Movie)
    with p,count(m) as num
    return p {.name, num}

    找到nick,并返回他所有的属性,nick没有age属性,所以age对应的值是null
    match(p:Person {name:"nick"})
    return p {.*, .age}  
    >> {name->"nick",gender->"boy",age-><null>}
```
* 空值
```
    空值null意味着一个未找到的未知值.null 不等于null 两个未知的值并不意味着它们是同一个值.因此 null=null 返回null 而不是true. null 只能用 is null 和 is not null 判断.

    空值进行逻辑运算时,当成一个未知值去处理,比如:
    null and true 值是null
    null and false 值是false
    null or flase 值是null

    空值与in
    如果列表中有null,那么in运算的时候如果没有找到值,就返回null
    如果列表中没有null,那么in运算如果没有找到值,返回false
    比如:
    2 in [1,2,3] true
    2 in [1,3] false
    2 in [1,null,3] null

    下面这些情况将返回null

    从列表中获取不存在的元素 [][0]
    试图访问节点或者关系的不存在 x.prop1
    与null 做比较 1 < null
    包含null 的算术运算 1 + null
    包含null参数的函数调用 : count(null)
```
* match
```
    简单匹配

    match(n) return n
    匹配标签

    match(n:lable) return n

    match(n:lable1:lable2) return n
    匹配关系

    match(n) --(m) return n,m

    match(n) -->(m) return n,m

    match(n) -[]-> (m) return n,m

    match(n) -[r]->(m)  return n,m,r

    match(n)-[r:rela]->(m) return n,m,r

    match(n)-[r:rela1 | :rela2 | :rela3]->(m) return n,m,r,type(r)  # type 是返回关系是哪个类型, | 代表或的意思

    match(n) -[r:`r e l a 1`]->(m) return n,m,r,type(r)  # 用` 包括含有特殊字符的关系名 或者标签名

    深度匹配(路径长度匹配)
    match(n) -[r:TYPE*minHops..maxHops]->(m) return r  # 注意变长匹配返回字典组成的列表,定长匹配返回字典
    minHops不写默认1 , maxHops不写默认关系的最大深度
    最小边界写0,意味着自己本身,所以自身也会被返回

    最短路径匹配 shortestPath() 函数
    match (martin:Person {name:"name1"}),(oliver:Perspn{name:"name2"}),p = shortestPath((martin)-[*..15]-(oliver)) 
    return p

    找到所有最短路径 allShortestPaths()
    match (martin:Person {name:"name1"}),(oliver:Perspn{name:"name2"}),p= allShortestPaths((martin)-[*]-(oliver)) 
    return p
    通过id 查询 id()函数

    可以在断言中使用id()函数来根据id查询节点
    match(n) where id(n) = 1 return n

    match () -[r]- () where id(r) = 1 return r

    match(n) where id(n) in [1,2,3] return n
    optinal match
    optinal match 类似于match ,不同之处在于 如果没有匹配到 optinal match将用null作为未匹配到不分的值.可以理解为mysql中的inner join 如果没有就用null.

    这里a 节点没有外向关系,所以x会返回null,因为x不存在,对应的属性name也会返回null
    match(a:Movie {title:"haha"})  optinal match (a)-->(x) return x,x.name
```
* 对于where的理解
```
    如果where 是 和 match , optinal match结合 是添加约束的作用
    如果where 和 with ,start 结合 则是过滤结果的作用
    添加约束和过滤结果是不一样的,一个是查询的过程中起作用,一个是查询完之后起作用

    match (n) where n.name="nick" and n.age = 23 return n

    match (n) where n:Person return n

    match(n) where n.age > 20 return n

    match(n)-[r]->(m) where r.action = "have" return r

    match(n) -[r] ->(m) where r:acted_in return r

    动态节点属性过滤:以方括号语法形式使用动态计算的值来过滤属性

    match (n) where n[toLower("Name")] = "nick" return n
    属性存在性检查exists()函数

    match(n) where exists(n.name)  return n, n.name
    字符串匹配 starts with , ends with , contains

    match(n) where n.name starts with "N" return n

    match(n) where n.name ends with "k" return n

    match(n) where n.name contains "ick" return n

    match(n) where not n.name starts with "N" return n  
    注意 not 是对整个结果取反,不能写成n.name not starts with
    正则表达式匹配
    语法: =~ 'regexp'

    match(n) where n.name =~ 'Ni.*'  return n
    在约束中添加关系约束

    match (one:Person {name:"nick"}) ,(other) where other.name in ["zhudi"] and (one) -- (other) 
    return other

    match (one:Person {name:"nick"}), (two) where not (one) --> (two) return two

    match(n) where (n) -- ({name:"nick"}) return n

    match(n) -[r]-> (m) where n.name = "nick" and type(r) =~ "lik."

    match(n) where n.name = "nick" or n.name is null return n

    match(n) where n.name = "nick" and n.age is null return n

    match(n) where n.age > 20 return n

    match(n) where n.age > 20 and n.age < 25 return n

    match(n) where 20 < n.age < 25 return n
```
* start 搜索
```
start 是通过索引搜索
语法: node:index-name("query")

start n = node:nodes("name:A")  return n   索引名为nodes 条件是name:A 也可以下面这样
start n = node:nodes(name="A") return n

start r = relationship:rels(name="address") return r
```
* 聚合Aggregation
```
Cypher支持使用聚合Aggregation 类似于sql中的group by,聚合函数有多个输入值,然后基于它们计算出一个聚合值.例如 avg 函数计算多个数值的平均值. min 函数用于找到一组值中最小的那个值
简单的聚合:

return n,count(n)
上面这个示例有两个表达式:n 和 count(*) ,前者n 是一个分组键.后者count()是一个聚合函数,根据不同的分组键,聚合不同的分组
count 统计次数

统计朋友的朋友的数量
match (me:Person) -->(friend:Person) --> (friend_of_friend:Person)
where me.name = "nick"
return count(DISTINCT friend_of_friend) , count(friend_of_friend)

计算节点的数量(连接一个节点的其他节点个数)
match(n {name:"nick"})-->(x) return n,count(*)
match(n {name:"nick"})-->(x) return count(x)

根据关系类型分组统计每个类型出现的次数
match(n {name:"nick"}) -[r]->()
return type(r),count(*)

计算非空值的数量
match(n:Person) return count(n.prop)  返回prop属性不为空的总数

sum 统计之和

match(n:Person) return sum(n.age)
avg 计算平均值

match(n:Person) return avg(n.age)
percentileDisc计算给定值在一个组中的百分比

match(n:Person) return percentileDisc(n.age, 0.5)
percentileCont 计算加权平均数

match (n:Person) return percentileCont(n.age ,0.4)
stdev 计算标准差(部分样本)

match(n) where n.name in ["a","b","c"] return stdev(n.age)
stdevp 计算标准差(整个样本)

match(n) where n.name in ["a","b","c"] return stdevp(n.age)
max查找数值列中的最大值

match(n:Person) return max(n.age)
min查找数值列中的最小值

match(n:Person) return min(n.age)
collect将所有的值收集起来放入一个列表,空值null将被忽略

match(n:Person) return collect(n.age)   # 返回列表
distinct所有聚合函数都可以使用的聚合修饰符,去除重复值

match(n:Person {name:"nick"})--(m:Person) return collect(distinct m.eyes_color)
```
* create
```
创建节点

create (n)

create(n), (m)

create (n:Person)

create(n:Person:People)

create(n:Person {name:"Nick"})

create(n:Person {name:"Nick"}) return n
创建关系

create(n:Person {name:"nick"}),(m:Person {name:"judy"}),(n)-[:Like {real:"like"}]->(m)
```
* MERGE
```
MERGE 匹配已存在的节点. 如果节点不存在就创建新的绑定它.可以理解为match和create的组合
比如如果你想要一个节点,若不存在就创建一个出来,这个时候就可以用MERGE

假设没有nick这个节点,下面的语句会创建一个出来
merge (n:Person {name:"nick"}) return n,labels(n)

match(people:Person) merge(city:City {name:people.bornIn}) return city
重复的只会创建一次,因为创建之后就存在了,可以匹配到,就不会再创建

MERGE 和 CREATE搭配 ,即MERGE匹配不存在的节点去创建的时候设置属性
merge(nick:Person {name:"Nick"})
on create set nick.like = "Judy", nick.created = timestamp()
return nick

MERGE 和 MATCH 搭配,即MERGE匹配已存在的节点匹配的时候设置属性
merge(nick:Person {name:"Nick"})
on match set nick.age = 23
return nick

注意MERGE的语句无论多长,只要语句中不存在的都会被创建
使用MERGE创建唯一性约束

create constraint on (n:Person) assert n.name is unique
上面这个语句给Person标签的所有节点的name属性设置了唯一性约束.如果已经存在不唯一的值会失败
还有如果给同一个标签设置了多个属性的唯一性约束,那么匹配的时候如果匹配不到会报错,
因为设置了唯一性约束的时候部分匹配无法新建节点,与唯一性约束冲突
```
* set
```
设置节点或者关系的属性

match (n:Person {name:"nick"}) set n.age = 23 return n

match(n:Person) -[r:acted_in]->(m:Movie) set r.created = timestamp() return r
设置标签

match(n {name:"nick"})
set n:Person
return n,labels(n)
```
* remove
```
删除节点或者关系的属性,也可以用另外一种方式 set 属性 = null

match(n:Person {name:"nick"}) set n.age = null return n
match(n:Person {name:"nick"}) remove n.age return n
删除标签

match(n:Person {name:"h1"})
remove n:Person
return n

match(n:Person:People {name:"h1"})
remove n:Person:People
return n
```
* 复制属性
```
match(a {name:"h1"}),(b {name:"h2"})
set a = b
return a,b
这样会把b的所有属性全部设置到a上面,a上面的所有属性都会被删除
```
* 以map的方式添加属性
```
match (a:Person {name:"nick"})
set a+={age:23,gender:"boy"}
return a
```
* 以覆盖的方式设置属性
```
match(n:Person {name:"h1"})
set n = {name:"h2",gender:"boy"}
return n
```
* delete 和 detach delete
```
删除节点,关系,路径

match (n:Person)
delete n


match(n)
detach delete n    
上面detach 是删除节点的同时并删除其所有的关系
```
* FOREACH
```
给所有节点设置一个属性值

MATCH (n:Person)
FOREACH (p in nodes(n)) | SET p.age = 20  
注意数据的传递要用到管道符
将列表中的人全部添加为A的朋友

MATCH(A {name:"A"})
FOREACH (name IN ["Mike","B","C"]) | CREATE (A)-[:FRIEND]->({name: name})
注意数据的传递要用到管道符
```
* CREATE UNIQUE
```
CREATE UNIQUE 相当于match 和create 的混合体.类似于MERGE,尽可能的匹配,然后创建未匹配到的
再保证唯一性这方面 CREATE UNIQUE 比MERGE更强.
CREATE UNIQUE 尽可能的减少对图的改变,充分利用已有的图
还有很重要的一点是 CREATE UNIQUE 假设模式是唯一性的,如果有多个匹配的子图可以找到,会报错

MATCH(nick {name:"Nick"})
CREATE UNIQUE  (nick) -[:love]->(judy {name:"Judy"})
return judy

MATCH (nick {name:"Nick"}), (judy:{name:"Judy"})
CREATE UNIQUE (nick)-[l:love]->(judy)
return l
```
* RETURN
```
返回匹配到的节点
match(n:Person {name:"Nick"}) return n

返回所有节点,关系和路径
match (n) rerurn *

也可以制造数据返回
return "haha"
```
* 反引号`
```
特殊字符可以使用反引号包括起来
```
* 别名 as
```
象sql一样可以使用as 起别名
```
* ORDER BY
```
ORDER BY 用于对输出进行排序,紧跟再RETURN和WITH后面
注意 空值进行排序的时候.对于升序null是排在最后面的,对于降序 null是排在最前面的,这一点要注意,所以最好还是使用升序

根据属性进行排序,默认升序
match (n) return n order by n.name

根据多个属性进行排序  对于年龄相等的采用名字来排序
MATCH(n) RETURN n ORDER BY n.age, n.name

降序排序
MATCH(n) RETURN n ORDER BY n.age DESC
```
* SKIP 和 LIMIT
```
SKIP: 跳过多少条数据
LIMIT: 限制返回多少条数据
```
* WITH
```
WITH语句将分段的查询部分链接在一起.将查询结果从一部分以管道形式传递给另外一部分作为开始点
使用WITH可以在将结果传递到后续查询之前对结果进行操作.操作可以是改变结果的形式或者数量.常见的一个用法就是限制传递给其他MATCH语句的结果数
WITH聚合之后可以通过WHERE语句进行过滤

MATCH  (nick {name:"Nick"}) -- (others) -- ()
WITH others,count(*)  as other_count
WHERE other_count > 2
RETURN others
上面的语句是返回nick的朋友和朋友的朋友关系中,朋友出现次数两次以上的返回
WITH 配合 排序,进行数据的限制

MATCH(n)
WITH n
ORDER BY n.age ASC LIMIT 3
RETURN collect(n.name)
限制路径搜索的分支

MATCH(n {name:"Nick"}) -- (m)
WITH m
ORDER BY m.name ASC LIMIT 1
MATCH (m) -- (0)
RETURN m.name
```
* UNWIND
```
将一个列表展开为一个行的序列
将一个常量列表转为名为x的行返回

UNWIND [1,2,3] as x
RETURN x

结果:
x
1
2
3
将一个重复值列表转为一个集合

UNWIND [1,1,1,2,2,3] as x
WITH DISTINCT x
RETURN collect(x) as set

结果
set
[1,2,3]
```
* UNION 和 UNION ALL
```
UNION 和 UNION ALL 都是将多个查询结果组合起来
不同的是UNION会移除重复的行.UNION ALL会包含所有的结果不会移除重复的行
注意:无论是使用UNION 还是 UNION ALL 都要保证查询到的列的名称和列的数量要完全一致

MATCH(n:Actor)
RETURN n.name AS name
UNION ALL MATCH (m:Movie)
RETURN m.title AS name
将包含重复行
结果:
A
B
C
C


MATCH(n:Actor)
RETURN n.name AS name
UNION MATCH (m:Movie)
RETURN m.title AS name
不包含重复行
结果:
A
B
C
```
### 函数

* all()
```
判断一个断言是否适用于列表中的所有元素
语法:
all(variable IN list WHERE predicate)
list:返回列表的表达式
variable:用于断言中的变量
predicate: 用于测试列表中所有元素的断言

返回路径中的所有节点都有一个至少大于30的age属性
MATCH p = (a)-[*1..3] ->(b)
WHERE a.name = "Alice" AND b.name = "Daniel" AND ALL (x IN nodes(p) WHERE x.age >30)
RETURN p
```
* any()
```
判断一个断言是否至少适用于列表中的一个元素
语法:
any(variable IN list WHERE predicate)
参数意义见all

MATCH(a)
WHERE a.name = "Eskil" AND ANY(x IN a.array WHERE x = "one")
RETURN a
返回路径中的所有节点的array数组属性中至少有一个值为"one"
```
* none()
```
如果断言不适用于列表中的任何元素,则返回true
语法:
none(variable IN list WHERE predicate)
参数意义见all

MATCH p = (n)- [*1..3]->(b)
WHERE n.name= "Alice" AND NONE(x IN nodes(p) WHERE x.age = 25)
RETURN p
```
* single()
```
如果断言刚好只适用于列表中的某一个元素,则返回true
语法:
single(variable IN list WHERE predicate)
参数意义见all

MATCH p =(n) --> (b)
WHERE n.name = "Alice" AND SINGLE(x IN nodes(p) WHERE x.eyes = "blue")
RETURN p
返回路径中刚好只有一个节点的eyes属性值为"blue"
```
* exists()
```
如果数据库中存在该模式或者节点中存在该属性时,则返回true
语法:
exists(pattern-or-property)
pattern-or-property:模式或者属性

返回所有节点的name属性和一个指示是否已婚的true/false值
MATCH(n)
WHERE EXISTS(n.name)
RETURN n.name as Name, EXISTS((n)-[:MARRIED]->()) AS is_married
```
* size()
```
使用size()返回表中元素的个数
语法:
size(list) size(pattern expression)
list:返回列表的表达式
pattern expression : 返回列表的模式表达式

RETURN size(["1","2"]) AS col
返回列表中元素的个数

MATCH(a)
WHERE a.name = "Alice"
RETURN size((a)-->()-->()) AS num
返回了模式表达式匹配到的路径的个数(也可以理解为最终有多少个子图)
```
* length()
```
使用length()函数返回路径的长度
语法:
length(path) length(string)
path:返回路径的表达式
string:返回字符串的表达式

MATCH p = (a)-->(b)-->(c)
WHERE a.name='nick'
RETURN length(p) 
返回所有路径的各自长度(深度)

MATCH(a)
WHERE a.name = "nick"
RETURN length(a.name)
返回名字的长度
```
* type()
```
返回关系的类型
语法:
type(relationship)
relationship:关系的变量名

MATCH (a)-[r:Like]->(b)
WHERE a.name="nick",b.name="judy"
RETURN type(r)
返回关系的类型,这里就是Like
```
* id()
```
返回关系或者节点的id
语法:
id(property-container)
property-container:一个节点或者关系

MATCH(a)
RETURN id(a) as id
```
* coalesce()
```
返回表达式列表中的第一个非空的值.如果所有的实参都为空,则返回null
语法:
coalesce(expression[,expression]*)

MATCH(a)
WHERE a.name ="nick"
RETURN coalesce(a.hairColor,a.eyes)
返回nick的头发颜色或者眼睛颜色,两个表达式都是字符串类型的值.
所以相当于参数组成的列表,而不是放一个列表进去
```
* head()
```
返回列表中第一个元素
语法:
head(expression)
参数:
expression:返回列表的表达式

match(a)
where a.name = "nick"
return a.array, head(a.array)
返回列表中的一个元素
```
* last()
```
返回列表中的最后一个元素
语法:
last(expression)
参数:
expression:返回列表的表达式

MATCH(a)
where a.name = "nick"
return a.array, last(a.array)
* timestamp()
返回当前时间与1970年1月1日午夜之间的差值,单位以毫秒计算.它在整个查询中始终返回同一个值,即使是在一个运行时间很长的查询中
语法:
```
* timestamp()
```
参数:无

return timestamp()
```
* startNode()
```
返回一个关系的开始节点
语法:
startNode(relationship)
relationship:返回关系的表达式

match(x:foo)-[r]-()
return startNode(r)
```
* endNode()
```
返回一个关系的结束节点
语法:
endNode(relationship)
参数:
relationship:返回关系的表达式

match(a)-[r:Like]->(b)
return endNode(r)
```
* properties()
```
如果实参是一个节点或者关系,返回的就是节点或者关系的属性的map,如果实参已经是一个map了,原样返回结果
语法:
properties(expression)
expression:节点或者关系或者字典

match(a:Person {name:"nick"})
return properties(a)
```
* toInt()
```
将参数转换为一个整数,字符串解析为整数的时候如果解析失败将返回null,浮点数强制将被转换为整数
语法:
```
* toInt(expression)
```
return toInt("1") as num1 , toInt("not a num") as NaN
toFloat()
参考toInt
```
* nodes()
```
返回模式中的所有节点
语法:
nodes(path)
参数:
path:路径

match p = (a:Person {name:"nick"})-[r:Like]->(b:Person {name:"judy"})
return nodes(p)
返回路径中的所有节点,因为上面的路径只有一条,所以返回a 节点和 b 节点
```
* relationships()
```
返回模式中的所有关系
语法:
relationships(path)

match p = (a)-->(b)
return relationships(p)
```
* labels()
```
返回一个节点的所有标签
语法:
labels(node)

match(a)
where a.name = "nick"
return labels(a)
```
* keys()
```
以字符串列表的形式返回一个节点或关系或者map的所有属性的键
语法:
keys(节点or关系 or map)

match(a:Person {name:"nick"})
return keys(a)

match(a:Person name{name:"nick"})-[r:Like]-(b:Person {name:"Judy"})
return keys(r)

return keys({name:"nick",age:23})
```
* extract()
```
类似于python中的高阶函数map,遍历一个列表,对列表中的每个值都运行一个表达式,将运行的结果组成列表返回
语法:
extract(variable IN list | expression)

match p = (a)-->(b)
return extract(n IN nodes(p) |  n.age)  as age_list
```
* filter()
```
类似于python中的filter,返回满足表达式的结果列表
语法:
filter(variable In list WHERE predicate)
predicate:断言表达式

match(a)
where a.name = "nick"
return filter(str in keys(a) where length(str) > 3) 
返回a节点的array属性中的字符串长度大于3 的元素列表
```
* tail()
```
tail()返回列表中除了首元素之外的所有元素
语法:
tail(列表)

match(a)
where a.name = "nick"
return a.array, tail(a.array)
```
* range()
```
返回某个范围内的数值,步长默认为1,范围包含起始边界值
语法:
range(start,end[,step])

return range(0,10), range(0,10,2)
```
* reduce()
```
类似于 python的reduce,将列表中的每个元素都执行一次表达式,将结果累加
语法:
reduce(accumulator=initial,variable IN list | expression)
参数:
accumulator:用于累加每次迭代的部分结果
initial:累加结果的初始值
variable :变量名
list:列表
expression:表达式

match  p = (a)-->(b)-->(c)
where a.name = "Alice" and b.name = "Bob" and c.name = "Daniel"
return reduce(totalAge = 0, n IN nodes(p) | totalAge + n.age) AS reduction
```
* abs()
```
返回数值的绝对值

match(a),(e)
where a.name = "Alice" and e.name = "Eskil"
return a.age , e.age , abs(a.age - e.age)
```
* ceil()
```
返回大于或等于实参的最小整数

return ceil(0.1)   返回结果为1
```
* floor()
```
返回小于或等于表达式的最大整数

return floor(0.9)  结果是0
return floor(-1.2) 结果是 -2
```
* round()
```
返回距离表达式值最近的整数

return round(3.141592)  结果是3
```
* sign()
```
返回一个数值的正负,如果值为0,则返回0,如果值为负数,则返回-1,如果值为整数,返回1

return sign(-2)
```
* rand()
```
返回[0,1]之间的一个随机数,返回的数值在整个区间遵循均匀分布

return rand()
```
* log()
```
返回自然对数,以2为底
```
* log10()
```
返回对数,以10为底
```
* exp(n)
```
返回e的n次方
```
* sqrt()
```
返回数值的平方根
```
* sin(角度)
```
返回正弦值
```
* cos()
```
余弦值
```
* tan()
```
返回正切值
```
* cot()
```
返回余切值
```
* asin()
```
反正弦值
```
* acos()
```
反余弦值
```
* atan()
```
反正切值
```
* pi()
```
返回常数的Π值
```
* replace(original,search,replace)
```
返回替换后的字符串,注意:会替换所有出现过的要替换的字符串
original:源字符串
search:期望被替换的字符串
replace:用于替换的字符串

return replace("hello", "l" , "w")  结果 hewwo
```
* substring(original,start[,length])
```
返回原字符串的字串
参数:
original:原字符串
start:子串的开始位置,索引从0开始
length:子串的长度,长度不写默认从开始位置到最后

return substring("hello",1,3) , subtring("hello",2)
```
* left(original,length)
```
返回原字符串左边指定长度的子串
original:原字符串
length:左边子字符串的长度
```
* right(original,length)
```
返回源字符串右边指定长度的子串
```
* ltrim(str)
```
移除字符串左侧的空白字符串返回,不改变原字符串
```
* rtrim(str)
```
移除字符串右侧的空白字符
```
* trim(str)
```
移除两侧的空白字符
```
* lower(str)
```
返回小写的原字符串
```
* upper(str)
```
返回大写的原字符串

split(original,splitPattern)
以指定的字符分隔字符串返回列表
```
* reverse()
```
返回原字符串的倒序字符串
```
* toString()
```
将整型浮点型布尔型转换为字符串,如果已经是字符串,则按原样返回
```
* 创建索引
```
使用CREATE INDEX ON在拥有某个标签的所有节点的某个属性上创建索引

create index on :Person(name)
在拥有Person标签的所有节点的name属性上创建了索引
```
* 删除索引
```
DROP INDEX ON :Person(name)
删除在拥有Person标签的所有节点的name属性索引
```
* 使用索引
```
当用到索引的列的时候,索引会自动使用,无须指明
```
* 创建约束
```
Neo4j通过约束来保证数据的完整性
唯一性约束是对一类节点的一个属性设置的
```
* 创建唯一性约束
```
使用IS UNIQUE语法创建约束,它能确保数据库中拥有特定标签和属性值的节点是唯一的

CREATE CONSTRAINT ON (book:Book) ASSERT book.isbn IS UNIQUE
```
* 删除唯一性约束
```
DROP CONSTRAINT ON {book:Book} ASSERT book.isbn IS UNIQUE
需要注意:在创建唯一性约束之前,如果数据库中已经存在了不唯一的数据,将会报错,创建唯一性约束将失败.在创建唯一性约束之后,如果再次添加已经存在的数据,那么会报错,添加失败
```
* 创建存在性约束
```
唯一性是保证属性值唯一.存在性是保证属性key是唯一且必须存在的,即标签下的所有节点都应该含有这个属性

CREATE CONSTRAINT ON (book:Book) ASSERT exists(book.isbn)
```
* 删除存在性约束
```
CREATE CONSTRAINT ON (book:Book) ASSERT exists(book.isbn)
注意:使用REMOVE 不能删除有存在性制约的属性.删除会报错,同样在创建存在性约束之前已经存在不存在该属性的节点创建存在性约束会失败.
```
* 创建关系属性存在性约束
```
使用 ASSERT exists() 创建关系属性存在性约束,可确保特定类型的所有关系都有一个特定的属性

CREATE CONSTRAINT ON ()-[like:LIKED]-() ASSERT exists(like.day)
```
* 删除关系存在性约束
```
DROP CONSTRAINT ON ()-[like:LIKED]-() ASSERT exists(like.day)
```
* 查询指定索引
```
指定索引的时候会更改默认的开始查询点

MATCH(a:Person{name:"nick"})-[r:like]->(b:Person {name:"judy"})
USING INDEX 
```