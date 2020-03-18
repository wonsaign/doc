## SQL语法基础

* CASE WHEN
* ORDER BY 可以跟多列，多列排序是根据顺序的

* SUM 求和
* GROUP BY 分组 （可以与聚合函数一起使用）
* MIN和MAX
* AVG
* COUNT
* LIMIT 分页

* UNION ALL 相同列出现多次， UNION相同列出现一次
* INTERSECT 交集  EXCEPT 差集 

## 磁盘基础知识与MySql
* 扇区,扇区是磁盘中最小的存贮单位.一般是512b大小.
* 块/簇,windows系统之中叫簇;Linux中叫块(block),每个块/簇都可以包括2、4、8、16、32、64…2的n次方个扇区
* MySql类似,只不过是16kb是最小单位称为`页`,连续的页称为`区`,整个ibd(实际上就是一个表)称为一个`段`
* mysql中information_scheme包含了mysql中全局数据信息,其中的tables表包含了引擎,库名,表名等一系列的信息.


## SQL索引
* 索引是什么?简单来讲就是书的目录,实际上是指排好序的数据机构(二叉树,B-Tree,Hash,红黑树)
* 索引类型
  * B树(二叉树,B-Tree,红黑树)
  * Hash
  * GIS(地理位置索引)
  * Full Text(myisam支持的char,varchar,text数据类型,代替Like %% 效率低下的问题.)
* 二叉树不能做索引的原因是,因为边缘数字(最左,最右)是最大数值log以2为底n底对数,而中间又是最小的1,是不平衡树.
* B+Tree,不仅可以提供平衡的树高度,而且支持范围查询(<>,<,>,<=,=>)
* 索引的存贮结构是kv结构的,k代表了索引代表的值,v是磁盘那条数据结构的地址.
* 存储引擎是最终落实到表上的(Innodb,Myisam等),是指的是这个表在磁盘上的存贮方式.
  * 比如Myisam存贮引擎会有3个文件,分别是frm,MYD和MYI,第一个是表结构,第二个存贮引擎结构(Myisam Data),第三个是存贮数据(Myisam Index);
  * Innodb,会有两个frm和ibd文件,第一个是表结构,第二个是索引加数据的存贮文件.
* 聚集索引和非聚集索引(辅助索引)重新听一下
  * 聚集索引是硬盘上存贮的有序的数据页(Page 16Ksize),因此会很快,直接关系到磁盘空间地址的,并且唯一,非Null
  * 辅助索引可以创建很多.
* 使用DESC或者EXPLAIN查看SQL的执行计划时候,会有几个关键`列`
  * type(从上至下,越来越好)
    * all 未执行索引.
    * index 查询全部索引中的数据 (不加条件直接查询索引列 select index_id from table;) 
    * range 检索指定范围的行，查找一个范围内的数据，where后面是一个范围查询 （between,in,or,> < >=); 
    * ref 非唯一性索引：对于每个索引键的查询，返回匹配的所有行（可以是0，或多
    * eq_ref 一般是where condi = param 常见于唯一索引和主键索引
    * const 只是理想类型，基本达不到
    * system 只是理想类型，基本达不到
  * key 执行索引 会显示索引名字
  * key_len 执行索引的长度(如果是联合索引,可以根据key_len执行的长度,判断执行了几个索引条件)
  * extra 额外的; 如果使用排序的时候,这里会出现: `filesort`,filesort是非常耗时的,所以常用的优化手段是:将排序列与查询条件列做连个索引,并且条件列放在联合索引的后面,比如index(condiA, orderB)
* NOT IN 对于辅助索引是不执行的,但是对于聚集索引依然执行.
* Innodb推荐使用数字,因为数字的排序要比UUID的排序简单,占用空间少.
* Innodb推荐自增主键,因为B+Tree是排序树(Balance Tree),叶子节点是经过排序的,使用自增新增的数据会放在后面,不会分叉,可以提高索引的插入速度.
* 联合索引,`最左法则`.如果搜索条件没有第一个条件,则无法使用联合索引.
* 原因是因为,B+Tree是平衡树,是排序树,缺少了第一个条件,第二个条件无法排序,缺少了第一个条件,相当于前面的条件没有,就会全表扫面.
  * 如果有(a,bc,)三个列组成的联合作引,搜索条件有
    * a 走索引 a
    * c 全表扫描
    * b 全表扫描
    * ab 走索引 ab
    * ac 走索引 a
    * bc 全表扫描 
    * abc 走索引

## SQL索引优化
* 使用union all 来代替 IN 或者 OR 是因为将 range 变为 ref,从而加快速度.
* 如果有`order by` 或者 `group by` 或者 `distinct`时,那么会额外的使用filesort进行排序浪费性能,最好的方式是使用`联合索引`,将排序字段作为联合索引的后面
  ```
    如: select * from table1 where a = '' order by b; 
    那么建立索引就要使用 
    alter table table1 add key 'combineIndex'('a','b');
  ```
* group by having , having后面的条件是不会走索引的.所以优化是,,,
* 联合索引如果有范围索引（between,in,or,> < >=),只会走range索引,后面的索引条件不会走,所以range索引条件放在最后面执行.
* 查询条件上进行运算是不会走索引的,另外`使用函数`也是不走索引的.
  ```
    比如:
    select * from table1 where id - 1 = 9;
  ```

## 数据库分库
* 数据库分片,修改scheme.xml文件.
* 如果有关联表操作,那么分片的表有两种方式:全局表或者ER分片(父子分片)