### Neo4j

#### Cyher语法

#### 元素

* 节点Node，类似关系型数据库中的一条记录
* 关系Relationship，关系，也称为边
* 属性Property，节点和关系都可以有自己的属性
* 标签Label,一组拥有相同属性的节点
* 路径Path，任意两个节点之间的路径，有长短之分

#### 概念

* () 代表节点
  * Cypher采用一对()来表示节点.
    ():匿名节点,匹配所有的节点,如果想要操作匹配到的节点,需要加变量(matrix)
    (matrix):赋有变量的节点,matrix将包含匹配到的所有节点,通过matrix变量可以对它们进行操作
    (matrix:Movie): 指定了标签的节点,只会匹配标签为Moive的节点
    (matrix:Movie {title:"Haha"}):指定了标签和属性的节点,只有节点标签是Movie,标题为Haha的节点会被匹配
* [] 代表关系
  * -- :表示无方向关系
    -->:有方向关系
    -[rale]->:给关系赋予一个变量,方便对其操作
    -[rale:friend]->:匹配关系类型为friend类型的关系,并赋予rale变量接收
    -[rale:friend {long_time:2}]->:给关系加条件,匹配friend类型的关系且属性long_time为2
    同时如果想要关系语法不想重复写,想要多个语句写的时候减少重复写,可以将关系语法赋予一个变量acted_in = (people:Person)-[:acted_in]->(movie:Movie)
这样acted_in 就可以写到多个查询语句中,减少重复编写
* {} 代表属性

#### 基本类型
数值
字符串
布尔
节点
关系
路径
映射(map)
列表(list)

#### 语句
* create (:pig{name:"猪爸爸",age:12}); `创建标签语句`
* match (a:pig{name:"猪爸爸"}) return a; `查询语句`
* match (a:pig{name:"猪爸爸"}) match (b:pig{name:"猪妈妈"}) create (a) -[r:夫妻]->(b) return r; `创建关系` 
* match (a:pig{name:"猪爸爸"}) match (b:pig{name:"猪妈妈"}) create (a) -[r:夫妻{marriage_age:"2"}]->(b) return r; `创建带属性带关系` 
* match (a:pig{name:"猪爸爸"}) set a.age = 99; `set`
* match p = shortestpath((a:pig{name:"猪爸爸"})-[*..5]->(b:pig{name:"猪妈妈"})) return p; `匹配最短路径`
* return (:Movie{title:"The Birdcage"})-->() 所有关系
* MATCH (john {name:"john"}) -[:friend] ->()-[:friend]->(friend)
RETURN john.name,friend.name 查找约翰和他朋友的名字
* 使用with语句进行聚合过滤查询,示例:
    MATCH (n {name:"John"})-[:friend]-(friend)
    WITH n, count(friend) as friendsCount
    WHERE friendsCount>3
    RETURN n, friendsCount
* match (n) where n.name in["猪爸爸","猪妈妈"] return n;
* 事务
* 唯一性
