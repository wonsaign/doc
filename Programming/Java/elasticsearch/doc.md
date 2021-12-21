# Elasticsearch 
### Part Zero
1. 啥是score？ 搜索引擎？ 分数最高的放在前面？ 代表了最匹配？

### Part One 基本概念

* Elasticsearch与关系数据库对应关系
    ```
    Relational DB -> Databases -> Tables -> Rows -> Columns
    Elasticsearch -> Indices -> Types -> Documents -> Fields
    ```
* 元数据
    * _Index索引
    > 提示：
    > 事实上，我们的数据被存储和索引在分片(shards)中，索引只是一个把一个或多个分片分组在一起的逻辑空间。然而，这只是一些内部细节——我们的程序完全不用关心分片。对于我们的程序而言，文档存储在索引(index)中。剩下的细节由Elasticsearch关心既可。
    * _Type
    > 在应用中，我们使用对象表示一些“事物”，例如一个用户、一篇博客、一个评论，或者一封邮件。每个对象都属于一个类(class)，这个类定义属性或与对象关联的数据。user类的对象可能包含姓名、性别、年龄和Email地址。
    ![版本变成](https://raw.githubusercontent.com/wonsaign/pics/main/note-picses-type-changed.png)
    ![7.x中Type被移除的原因](https://raw.githubusercontent.com/wonsaign/pics/main/note-picses-type-removed-reason.png)

    * _Id
    > id仅仅是一个字符串，它与 _index 和 _type 组合时，就可以在Elasticsearch中唯一标识一个文档。当创建一个文档，你可以自定义 _id ，也可以让Elasticsearch帮你自动生成。
    * _Version（clickhouse中的冲突version与之类似）
    > 乐观并发控制，可以在更新时指定版本，如：PUT /website/blog/1?version=1 ，当版本变换的时候返回409。
    * _Source
    > 默认情况下，Elasticsearch用JSON字符串来表示文档主体保存在_source 字段中。像其他保存的字段一样,_source字段也会在写入硬盘前压缩。Souce类似于MongoDB，可以随意增加新字段在里面，文档型数据库。
* 分片
    * 一个分片可以是**主**分片或者**副本**分片。 索引内任意一个文档都归属于一个主分片，所以主分片的数目决定着索引能够保存的最大数据量。
    * 技术上来说，一个主分片最大能够存储 Integer.MAX_VALUE - 128 个文档，但是实际最大值还需要参考你的使用场景：包括你使用的硬件， 文档的大小和复杂程度，索引和查询文档的方式以及你期望的响应时长。
    * 一个副本分片只是一个主分片的拷贝。副本分片作为硬件故障时保护数据不丢失的冗余备份，**并为搜索和返回文档等读操作提供服务**。


* bulk批量操作的时候不是事务性的，非原子性原则。
* 映射(mapping)机制用于进行字段类型确认，将每个字段匹配为一种确定的数据类型(string,number,booleans,date等)。
* 分析(analysis)机制用于进行全文文本(Full Text)的分词，以建立供搜索用的反向索引。
* 倒排索引

* 工作原理
  * 倒排索引
    * 不可变性，写入磁盘的倒排索引是不可变的，它有如下好处：
        * 不需要锁。如果从来不需要更新一个索引，就不必担心多个程序同时尝试修改。
        * 一旦索引被读入文件系统的缓存(译者:在内存)，它就一直在那儿，因为不会改变。只要文件系统缓存有足够的空间，大部分的读会直接访问内存而不是磁盘。这有助于性能提升。
        * 在索引的声明周期内，所有的其他缓存都可用。它们不需要在每次数据变化了都重建，因为数据不会变。
        * 写入单个大的倒排索引，可以压缩数据，较少磁盘IO和需要缓存索引的内存大小。
    * 更新：使用多个索引。不是重写整个倒排索引，而是增加额外的索引反映最近的变化。每个倒排索引都可以按顺序查询，从最老的开始，最后把结果聚合。
    * 持久化变更，借助了日志系统来进行事务式的提交。
  * 不变性。倒排索引被写入磁盘后是 不可改变 的:它永远不会修改。 不变性有重要的价值：
      * 不需要锁。如果你从来不更新索引，你就不需要担心多进程同时修改数据的问题。
      * 一旦索引被读入内核的文件系统缓存，便会留在哪里，由于其不变性。只要文件系统缓存中还有足够的空间，那么大部分读请求会直接请求内存，而不会命中磁盘。这提供了很大的性能提升。
      * 其它缓存(像filter缓存)，在索引的生命周期内始终有效。它们不需要在每次数据改变时被重建，因为数据不会变化。
      * 写入单个大的倒排索引允许数据被压缩，减少磁盘 I/O 和 需要被缓存到内存的索引的使用量。
  * 在 Elasticsearch 中，写入和打开一个新段的轻量的过程叫做 refresh 。 默认情况下每个分片会每秒自动刷新一次。这就是为什么我们说 Elasticsearch 是 近 实时搜索: 文档的变化并不是立即对搜索可见，但会在**一秒**之内变为可见
  * 日志：https://www.elastic.co/guide/cn/elasticsearch/guide/current/translog.html
* elasticsearch中更新是**检索-修改-重建索引** 
* Lunuce中的索引，在Elasticsearch中叫分片，而Elasticsearch为了区分索引的概念，使用分片这个词，就是等于Lunece中索引。而Elasticsearch中的索引是分片的逻辑概念。
* [内存分配](https://www.elastic.co/guide/cn/elasticsearch/guide/current/heap-sizing.html%23heap-sizing)，elasticsearch内存使用分为两部分
    1. es调取lucene的java程序（我们认为的es）；
    2. Lucene本身，也是一个内存大户。至少有一半以上的内存给Lucene使用。
    3. 建议
        1. 不要超过32g，最好是31安全
        2. 关闭Swapping。
            1. `sudo swapoff -a 暂时关闭` 
            2. 对于大部分Linux操作系统，可以在 sysctl 中这样配置：`vm.swappiness = 1 `
                ```
                swappiness 设置为 1 比设置为 0 要好，因为在一些内核版本 swappiness 设置为 0 会触发系统 OOM-killer（注：Linux 内核的 Out of Memory（OOM）killer 机制）。
                ```
* fielddata预热（）
    > Elasticsearch 加载内存 fielddata 的默认行为是 延迟 加载 。 当 Elasticsearch 第一次查询某个字段时，它将会完整加载这个字段所有 Segment 中的倒排索引到内存中，以便于以后的查询能够获取更好的性能。  
* 聚合内的聚合，aggs{aggs{}}... 这种，是呈现指数增长的，比如`查询出演影片最多的十个演员以及与他们合作最多的演员`
    * 默认使用深度优先
    * 可以选择使用广度优先
*  Elasticsearch 不支持 ACID 事务。 对单个文件的变更是 ACIDic 的，但包含多个文档的变更不支持。  
    * 关系型数据库先变更，es同步，只做搜索作用。  
    * 自带锁
        * 全局锁
        * 文档锁
        * 树锁      
* 语法
    * match => where id `=` 1 （类比sql中=）
    * range
    ```
    {
        "range": {
            "age": {
                "gte":  20,
                "lt":   30
            }
        }
    }
    ```
    * term 数字时间布尔精确查找
    * exists 和 missing
    * 组合查询 bool
        * must ->  所有的语句都 必须（must） 匹配，与 AND 等价
        * must_not -> 所有的语句都 不能（must not） 匹配，与 NOT 等价
        * should ... 其查询子句应该被满足，也就是不一定都满足，逻辑相当于 or。
        * filter -> = 与 must 作用一样，但是不会计算分数。在 filter context 下的查询子句不会计算分数且会被缓存。建议直接无脑使用filter
    ```
    {
    "bool": {
            "must":     { "match": { "title": "how to make millions" }},
            "must_not": { "match": { "tag":   "spam" }},
            "should": [
                { "match": { "tag": "starred" }}
            ],
            "filter": {
              "bool": { 
                  "must": [
                      { "range": { "date": { "gte": "2014-01-01" }}},
                      { "range": { "price": { "lte": 29.99 }}}
                  ],
                  "must_not": [
                      { "term": { "category": "ebooks" }}
                  ]
              }
            }
        }
    }
    ```
    * sort 排序
        ```
        "sort": { "date": { "order": "desc" }}
        多级排序
        "sort": [
            { "date":   { "order": "desc" }},
            { "_score": { "order": "desc" }}
        ]
        
        "sort": {
            "dates": {
                "order": "asc",
                "mode":  "min"
            }
        }
        ```
     * 非评分模式constant_score 语法跟上面类似
  * 精确相等的方案
  ![精确相等](https://raw.githubusercontent.com/wonsaign/pics/main/note-picses-exact-equal.png)
 
### Part Two 官方手册
* 开始
  * 探索你的集群
    * 集群健康
      * /_cat/health?v
      * /_cat/nodes?v
    * 遍历所有的Index
      * /_cat/indices?v
    * 创建Index(注意,6版本的es,一个index只能对应一个type)
      * `PUT` /indexname
    * 修正你的数据
      * 增删改略
      * 批量更新
        * `POST` /yourindex/_doc/_bulk  后跟Json串
  * 探索你的数据
    * 直接在URL上获取
    * 使用Query语言(Query DSL),支持Json请求.请求 `GET` /yourindex/_doc/`_search` {"query":{"match":{}}},`match`表示模糊查询
    * 指定返回字段 `GET` /yourindex/_doc/_search {"query":{},"_source":["param1","param2"]},其中`_source`中指定的字段即使返回的字段,类似SQL SELECT FROM field list.
    * 使用Query DSL , query:bool:must:[match1,match2] 其中match1和match2是'AND'关系. query:bool:should:[match1,match2]其中match1和match2是'OR'关系.query:bool:must_not:[match1,match2]代表'NOR'关系
    * 执行Filters,query:bool:must,filter:range:param1:gte,lte 其中param1代表参数, 类似sql中 param1 between gte and lte; `Between And`
    * 聚合查询(Group by) aggs:group_by_state:terms:filed:"param1.keyword",order:"param2":"desc" 类似SQL中的 select param1,count(*) from xxx group by param1 order param2 desc limit 10;
* API 习俗
  * 多倍的索引,目前所有的请求都是/test/_doc/1,/test1/_doc/1,/test2/_doc/1,那么现在可以使用test*/doc/1 来代替前面所有
  * 时间格式 GET /<logstash-{now/d}>/_search
  * 通用设置
    * _settings?flat_settings=true
* 文档API
  * 增删改查
  * 使用Query DSL语言删除,例如:POST /yourindex/`_delete_by_query` query:match
  * 使用Query DSL语言更新,例如:POST /yourindex/`_update_by_query` 
  * mget , 多倍获取 , 需要使用`docs` 如 GET/_mget  docs[{},{}]
  * bulk批量操作.
  * Reindex,重命名 POST _redindex {"source":{"index":"old"},"dest":{"index":"new"}}
* 版本变更
    * 6 - 7版本
    ```
    Vesion6:
    _parent
    _retry_on_conflict
    _routing
    _version
    _version_type
    
    Vesion7: 去掉下划线
    parent
    retry_on_conflict
    routing
    version
    version_type
    
    =================
    
    Version6:
    string
    
    Version7:
    text
    
    =================
    
    Version6:
    put es_test
    {
         "mappings":{    
          "books":{     
            "properties":{        
                "title":{"type":"text"},
                "name":{"type":"text","index":false},
                "publish_date":{"type":"date","index":false},           
                "price":{"type":"double"},           
                "number":{
                    "type":"object",
                    "dynamic":true
                }
            }
        }
     }

     Version7:
     
     put /test
     {
      "mappings":{
        "properties":{
          "id":{"type":"long"},
          "name":{"type":"text","analyzer":"ik_smart"},
          "text":{"type":"text","analyzer":"ik_max_word"}
        }
      }
      
     =============
     Version6:
     PUT /gb/_doc/_mapping?include_type_name=true
        {
          "properties" : {
            "tag" : {
              "type" :    "text",
              "index":    "not_analyzed"
            }
          }
        }
     Version7:
     PUT /gb/_doc/_mapping?include_type_name=true?include_type_name=true 
        {
          "properties" : {
            "tag" : {
              "type" :    "text",
              "index":    "not_analyzed"
            }
          }
        }
    
    ==========
    Failed to parse value [not_analyzed] as only [true] or [false] are allowed
    Version5: 
    支持not_analyzed
    
    Version6:
    ES 5开始  not_analyzed不能使用
    text:会被分析的字符串
    keyword:不会被分析的字符串。
    
    
    ===========
    Version6:
    not_analyzed，如：
                "productID" : {
                    "type" : "string",
                    "index" : "not_analyzed" 
                }
    Version7:
    keyword， 如：
              "productID": {
                "type": "keyword"
              }
              
              
    ===========
    Version6:
    "genTime":{
        "format":"YYYY-MM-dd HH:mm:ss",
        "type":"date"
    }
    Version7:
    "genTime": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss"
    }
    也可以写成
    "genTime": {
        "type": "date",
        "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
    }
    ```
![不支持自定义类型](https://raw.githubusercontent.com/wonsaign/pics/main/note-picses-index-no-surport-customtype.png)




### Docker安装
#### elasticsearch
> docker官方镜像不支持latest版本，所以以7.16.1版本为例
1. 下载镜像
```
docker pull elasticsearch:7.16.1
```
2. 创建网络环境
```
主要是可以用于链接kibana（将他们至于同一个网络，可以互相通信）
docker network create somenetwork 
```
3. 启动镜像
```
docker run -d --name elasticsearch --net somenetwork -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.16.1
```
4. [elasticsearch中文文档](https://www.elastic.co/guide/cn/elasticsearch/guide/current/index.html)

#### kibana
> docker官方镜像不支持latest版本，所以以7.16.1版本为例
1. 下载镜像
```
docker pull kibana:7.16.1
```
2. 创建网络环境(如果已经创建则跳过)
```
主要是可以用于链接kibana（将他们至于同一个网络，可以互相通信）
docker network create somenetwork 
3. 启动镜像
```
 链接到同一个网络环境
 docker run -d --name kibana --net somenetwork -p 5601:5601 kibana:7.16.1
 或者通过link链接，若使用此种方式
 需进入elasticsearch容器中
  docker exec -it elasticsearch /bin/bash
  cd /usr/share/elasticsearch/config/
  vi elasticsearch.yml
 再配置中加上
  http.cors.enabled: true
  http.cors.allow-origin: "*"
 重启容器 
  docker restart elasticsearch

 docker run -d --name kibana --link=elasticsearch:7.16.1  -p 5601:5601 -d kibana:7.16.1
4. [kibana官方中文文档](https://www.elastic.co/guide/cn/kibana/current/index.html)


### elasticsearch语法
> 基础技巧
```

# 加数据
PUT /megacorp/employee/1
{
    "first_name" : "John",
    "last_name" :  "Smith",
    "age" :        25,
    "about" :      "I love to go rock climbing",
    "interests": [ "sports", "music" ]
}

PUT /megacorp/employee/2
{
    "first_name" :  "Jane",
    "last_name" :   "Smith",
    "age" :         32,
    "about" :       "I like to collect rock albums",
    "interests":  [ "music" ]
}

PUT /megacorp/employee/3
{
    "first_name" :  "Douglas",
    "last_name" :   "Fir",
    "age" :         35,
    "about":        "I like to build cabinets",
    "interests":  [ "forestry" ]
}

# 根据id获取
GET /megacorp/employee/1
# 获取全部
GET /megacorp/employee/_search
# 快速搜索，根据last_name搜索
GET /megacorp/employee/_search?q=last_name:Smith
# json格式搜索
GET /megacorp/employee/_search
{
    "query" : {
        "match" : {
            "last_name" : "Smith"
        }
    }
}

# last_name = "smith" and age > 30
GET /megacorp/employee/_search
{
    "query" : {
        "bool": {
            "must": {
                "match" : {
                    "last_name" : "smith" 
                }
            },
            "filter": {
                "range" : {
                    "age" : { "gt" : 30 } 
                }
            }
        }
    }
}

# 全文检索 rock climbing
GET /megacorp/employee/_search
{
    "query" : {
        "match" : {
            "about" : "rock climbing"
        }
    }
}

# 全文检索 短语 rock climbing
GET /megacorp/employee/_search
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    }
}

# 全文检索 rock climbing 高量显示
GET /megacorp/employee/_search
{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing"
        }
    },
    "highlight": {
        "fields" : {
            "about" : {}
        }
    }
}

# group by interests
GET /megacorp/employee/_search
{
  "aggs": {
    "all_interests": {
      "terms": { "field": "interests" }
    }
  }
}

# where last_name = "smith"  group by interests 
GET /megacorp/employee/_search
{
  "query": {
    "match": {
      "last_name": "smith"
    }
  },
  "aggs": {
    "all_interests": {
      "terms": {
        "field": "interests"
      }
    }
  }
}

# 创建索引
PUT /megacorp/_mapping
{
  "properties": {
    "interests": { 
      "type":     "text",
      "fielddata": true
    }
  }
}

GET /megacorp/employee/_search
{
    "aggs" : {
        "all_interests" : {
            "terms" : { "field" : "interests" },
            "aggs" : {
                "avg_age" : {
                    "avg" : { "field" : "age" }
                }
            }
        }
    }
}

GET /_cluster/health

PUT /blogs
{
   "settings" : {
      "number_of_shards" : 3,
      "number_of_replicas" : 1
   }
}
# 只返回部分数据 select first_name,last_name from megacorp.employee where id = 1;
GET /megacorp/employee/1?_source=last_name,first_name

# 创建
PUT /website/blog/123?op_type=create
PUT /website/blog/123/_create

# 删除文档
DELETE /website/blog/123

# 创建文档
PUT /website/blog/1/_create
{
  "title": "My first blog entry",
  "text":  "Just trying this out..."
}
# 获取文档
GET /website/blog/1
# 乐观锁，指定版本号更新，低于6版本的用这个
PUT /website/blog/1?version=1 
{
  "title": "My first blog entry",
  "text":  "Starting to get the hang of this..."
}
# 乐观锁，指定版本号更新，高于6版本的用这个
# if_primary_term记录的就是具体的哪个主分片
# if_seq_no这个参数起的作用和旧版本中的_version是一样的
PUT /website/blog/1?if_seq_no=0&if_primary_term=1
{
  "title": "My first blog entry",
  "text":  "Starting to get the hang of this..."
}
## 新的字段已被添加到 _source 中。
POST /website/blog/1/_update
{
   "doc" : {
      "tags" : [ "testing" ],
      "views": 0
   }
}
## CAS跟新，重试次数5
# CAS通过_seq_no(_version) t1线程获取_seq_no=1，t2线程获取_seq_no=1，当t1完成更新计算后，update的时候，也会将版本，if_seq_no=1作为请求参数，如果es的if_seq_no=1，匹配成功更新；t2带着if_seq_no=1再次更新的时候，此时es已经是if_seq_no=2了，不匹配，则进行重试，重新取if_seq_no=2的值再次计算，再次提交
POST /website/pageviews/1/_update?retry_on_conflict=5 
{
   "script" : "ctx._source.views+=1",
   "upsert": {
       "views": 0
   }
}

# batch请求，减少网络延迟，返回结果相同，顺序相同
GET /_mget
{
   "docs" : [
      {
         "_index" : "website",
         "_type" :  "blog",
         "_id" :    2
      },
      {
         "_index" : "website",
         "_type" :  "pageviews",
         "_id" :    1,
         "_source": "views"
      }
   ]
}

GET /website/blog/_mget
{
   "docs" : [
      { "_id" : 2 },
      { "_type" : "pageviews", "_id" :   1 }
   ]
}

GET /website/blog/_mget
{
   "ids" : [ "2", "1" ]
}
# bulk操作
POST /_bulk
{ "delete": { "_index": "website", "_type": "blog", "_id": "123" }} 
{ "create": { "_index": "website", "_type": "blog", "_id": "123" }}
{ "title":    "My first blog post" }
{ "index":  { "_index": "website", "_type": "blog" }}
{ "title":    "My second blog post" }
{ "update": { "_index": "website", "_type": "blog", "_id": "123", "retry_on_conflict" : 3} }
{ "doc" : {"title" : "My updated blog post"} }


# 上述bulk操作有过多的指定index type ，抽取
POST /website/_bulk
{ "index": { "_type": "blog" }}
{ "event": "User logged in" }

# 再抽取
POST /website/log/_bulk
{ "index": {}}
{ "event": "User logged in" }
{ "index": { "_type": "blog" }}
{ "title": "Overriding the default type" }

# 空检索，返回所有 ，keys *
GET /_search

# 分页
GET /_search?size=5&from=10

# 分析映射类型
GET /megacorp/_mapping
GET /megacorp/employee/_search

# 词条分析器，用于倒排索引测试
GET /_analyze
{
  "analyzer": "standard",
  "text": "Text to analyze"
}

DELETE /gb

# 创建“索引”（数据库）
PUT /gb 
{
  "mappings": {
      "properties" : {
        "tweet" : {
          "type" :    "text",
          "analyzer": "english"
        },
        "date" : {
          "type" :   "date"
        },
        "name" : {
          "type" :   "text"
        },
        "user_id" : {
          "type" :   "long"
        }
      }
  }
}
# 新增“索引”（数据库）字段
PUT /gb/_doc/_mapping?include_type_name=true
{
  "properties" : {
    "tag" : {
      "type" :    "text",
      "index":    "not_analyzed"
    }
  }
}
# 分析字符串Black-cats在tweet的那个列被拆分的情况
GET /gb/_analyze
{
  "field": "tweet",
  "text": "Black-cats" 
}
# 分析字符串Black-cats在tag的那个列被拆分的情况
GET /gb/_analyze
{
  "field": "tag",
  "text": "Black-cats" 
}
# 空查询，keys *
GET /_search
{} 

# 查询多个数据库index_2014中表type1，type2的数据
GET /index_2014*/type1,type2/_search
{}
# 分页
GET /_search
{
  "from": 30,
  "size": 10
}

# 空查询，查询全部
GET /_search
{
    "query": {
        "match_all": {}
    }
}

GET /_search
{
    "query": {
        "match": {
            "tweet": "elasticsearch"
        }
    }
}

GET /_search
{
    "bool": {
        "must": { "match":   { "email": "business opportunity" }},
        "should": [
            { "match":       { "starred": true }},
            { "bool": {
                "must":      { "match": { "folder": "inbox" }},
                "must_not":  { "match": { "spam": true }}
            }}
        ],
        "minimum_should_match": 1
    }
}

# 验证是否合法
GET /gb/tweet/_validate/query
{
   "query": {
      "tweet" : {
         "match" : "really powerful"
      }
   }
}

# 解释为啥错了
GET /gb/tweet/_validate/query?explain 
{
   "query": {
      "tweet" : {
         "match" : "really powerful"
      }
   }
}

GET /_validate/query?explain
{
   "query": {
      "match" : {
         "tweet" : "really powerful"
      }
   }
}


PUT /my_index
{
    "mappings": {
            "dynamic":      "strict", 
            "properties": {
                "title":  { "type": "text"},
                "stash":  {
                    "type":     "object",
                    "dynamic":  true 
                }
            }
      
    }
}

PUT /my_index/1
{
    "title":   "This doc adds a new field",
    "stash": { "new_field": "Success!" }
}

# 因为日期会设置成date，但是有时候日期可能是string，所以用这个设置
PUT /my_index2
{
    "mappings": {
      "date_detection": false
    }
}

# 动态模版设置
PUT /my_index3
{
    "mappings": {
      "dynamic_templates": [
          { "es": {
                "match":              "*_es", 
                "match_mapping_type": "string",
                "mapping": {
                    "type":           "string",
                    "analyzer":       "spanish"
                }
          }},
          { "en": {
                "match":              "*", 
                "match_mapping_type": "string",
                "mapping": {
                    "type":           "string",
                    "analyzer":       "english"
                }
          }}
      ]
}}


PUT /my_index_v1  
# 索引别名，ln -s ... 好处就不说了
PUT /my_index_v1/_alias/my_alias_idx
# 索引别名 指向的位置
GET /*/_alias/my_alias_idx
# 当前索引，都有哪些别名
GET /my_index_v1/_alias/*

# 新建索引2
PUT /my_index_v2
{
    "mappings": {
        "properties": {
            "tags": {
                "type":   "text"
            }
        }
    }
}
# 重建索引
POST /_aliases
{
    "actions": [
        { "remove": { "index": "my_index_v1", "alias": "my_alias_idx" }},
        { "add":    { "index": "my_index_v2", "alias": "my_alias_idx" }}
    ]
}
# 刷新（Refresh）所有的索引
POST /_refresh 
# 刷新（Refresh）所有的索引
POST /blogs/_refresh 
# 索引刷新时间修改，默认1秒
PUT /my_logs
{
  "settings": {
    "refresh_interval": "30s" 
  }
}
# 生产环境，关闭自动更新
PUT /my_logs/_settings
{ "refresh_interval": -1 } 
# 每秒自动刷新。
PUT /my_logs/_settings
{ "refresh_interval": "1s" } 


/_search
在所有的索引中搜索所有的类型
/gb/_search
在 gb 索引中搜索所有的类型
/gb,us/_search
在 gb 和 us 索引中搜索所有的文档
/g*,u*/_search
在任何以 g 或者 u 开头的索引中搜索所有的类型
/gb/user/_search
在 gb 索引中搜索 user 类型
/gb,us/user,tweet/_search
在 gb 和 us 索引中搜索 user 和 tweet 类型
/_all/user,tweet/_search
在所有的索引中搜索 user 和 tweet 类型

分析分词器
https://www.elastic.co/guide/cn/elasticsearch/guide/current/analysis-intro.html
```

> 高级技巧
```
# 阿草，支持以前6的写法，7中，自定义了mapping可就不行了
POST /my_store/products/_bulk
{ "index": { "_id": 1 }}
{ "price" : 10, "productID" : "XHDK-A-1293-#fJ3" }
{ "index": { "_id": 2 }}
{ "price" : 20, "productID" : "KDKE-B-9947-#kL5" }
{ "index": { "_id": 3 }}
{ "price" : 30, "productID" : "JODL-X-1937-#pV7" }
{ "index": { "_id": 4 }}
{ "price" : 30, "productID" : "QQPX-R-3956-#aD8" }

# SELECT document FROM  products WHERE  price = 20
GET /my_store/products/_search
{
    "query" : {
        "constant_score" : { 
            "filter" : {
                "term" : { 
                    "price" : 20
                }
            }
        }
    }
}
# 我自己写的，用的复合模式
GET /my_store/products/_search
{
  "query":{
    "bool": {
        "filter": { "match": { "price": 20 }}
    }
  }
}

# SELECT product FROM   products WHERE  productID = "XHDK-A-1293-#fJ3"，发现查询不到
GET /my_store/products/_search
{
    "query" : {
        "constant_score" : {
            "filter" : {
                "term" : {
                    "productID" : "XHDK-A-1293-#fJ3"
                }
            }
        }
    }
}

GET /my_store/_analyze
{
  "field": "productID",
  "text": "XHDK-A-1293-#fJ3"
}
# 删除索引
DELETE /my_store
# 获取
PUT /my_store 
{
    "mappings" : {
        "properties" : {
            "productID" : {
                "type": "keyword"
            }
        }
    }
}


PUT /my_store/products
{
    "mappings" : {
        "properties" : {
            "productID" : {
                "type": "keyword"
            }
        }
    }
}

# 阿草，支持以前6的写法，7中，自定义了mapping可就不行了，下面是7的写法
POST /my_store/_bulk
{ "index": { "_id": 1 }}
{ "price" : 10, "productID" : "XHDK-A-1293-#fJ3" }
{ "index": { "_id": 2 }}
{ "price" : 20, "productID" : "KDKE-B-9947-#kL5" }
{ "index": { "_id": 3 }}
{ "price" : 30, "productID" : "JODL-X-1937-#pV7" }
{ "index": { "_id": 4 }}
{ "price" : 30, "productID" : "QQPX-R-3956-#aD8" }

# 默认的是_doc
GET /my_store/_doc/_search
{
    "query" : {
        "constant_score" : {
            "filter" : {
                "term" : {
                    "productID" : "XHDK-A-1293-#fJ3"
                }
            }
        }
    }
}
# 默认的是_doc ，可以不写
GET /my_store/_search
{
    "query" : {
        "constant_score" : {
            "filter" : {
                "term" : {
                    "productID" : "XHDK-A-1293-#fJ3"
                }
            }
        }
    }
}

# 多条件过滤
#SELECT product FROM   products WHERE  (price = 20 OR productID = "XHDK-A-1293-#fJ3") AND  (price != 30)
GET /my_store/_search
{
    "query" : {
        "bool" : {
            "should" : [
                  {"term":{  "productID" : "XHDK-A-1293-#fJ3"}},
                  {"term" : {"price" : "20"}}
            ],
            "must_not": [
              {"term": {"price": "30"}}
            ]
        }
    }
}
# 在7中过期了，不能这么写了，上面写的就是对的
GET /my_store/_search
{
   "query" : {
      "filtered" : { 
         "filter" : {
            "bool" : {
              "should" : [
                 { "term" : {"price" : 20}}, 
                 { "term" : {"productID" : "XHDK-A-1293-#fJ3"}} 
              ],
              "must_not" : {
                 "term" : {"price" : 30} 
              }
           }
         }
      }
   }
}

#SELECT document FROM   products WHERE  productID = "KDKE-B-9947-#kL5"
#  OR ( productID = "JODL-X-1937-#pV7" AND price     = 30 )
# 我的
GET /my_store/_search
{
  "query": {
    "bool": {
      "filter": [
        {"term": {
          "productID": "KDKE-B-9947-#kL5"
        }}
      ],
      "should": {
        "bool":{
          "filter":[
            {"term": {"productID": "JODL-X-1937-#pV7"}},
            {"term": {"price": 30}}
          ]
        }
      }
    }
  }
}

# 正解
GET /my_store/_search
{
  "query": {
    "bool": {
      "should": [
        {"term": {"productID": "KDKE-B-9947-#kL5"}},
        {
          "bool":{
            "filter":[
              {"term": {"productID": "JODL-X-1937-#pV7"}},
              {"term": {"price": 30}}
            ]
          }
        }
      ]
    }
  }
}

# 多个精确查找
GET /my_store/_search
{
  "query": {
    "terms": {
      "price": [
        20,
        30
      ]
    }
  }
}
# 也可以写成这个
GET /my_store/_search
{
  "query": {
    "bool": {
      "filter":{
        "terms": {
          "price": [
            20,
            30
          ]
        }
      }
    }
  }
}

# 范围 SELECT document FROM   products WHERE  price BETWEEN 20 AND 40
GET /my_store/_search
{
  "query": {
    "range": {
      "price": {
        "gte": 20,
        "lte": 40
      }
    }
  }
}

POST /my_index_1/_bulk
{ "index": { "_id": "1"              }}
{ "tags" : ["search"]                }  
{ "index": { "_id": "2"              }}
{ "tags" : ["search", "open_source"] }  
{ "index": { "_id": "3"              }}
{ "other_field" : "some data"        }  
{ "index": { "_id": "4"              }}
{ "tags" : null                      }  
{ "index": { "_id": "5"              }}
{ "tags" : ["search", null]          }  
GET /my_index_1/_search
{
    "query" : {
        "constant_score" : {
            "filter" : {
                "exists" : { "field" : "tags" }
            }
        }
    }
}

DELETE cars

PUT /cars 
{
    "mappings" : {
        "properties" : {
            "color" : {
                "type": "keyword"
            },
            "make" : {
                "type": "keyword"
            },
            "sold" : {
                "type": "date"
            }
        }
    }
}

##group by 注意text字段不支持 group by
POST /cars/_bulk
{ "index": {}}
{ "price" : 10000, "color" : "red", "make" : "honda", "sold" : "2014-10-28" }
{ "index": {}}
{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
{ "index": {}}
{ "price" : 30000, "color" : "green", "make" : "ford", "sold" : "2014-05-18" }
{ "index": {}}
{ "price" : 15000, "color" : "blue", "make" : "toyota", "sold" : "2014-07-02" }
{ "index": {}}
{ "price" : 12000, "color" : "green", "make" : "toyota", "sold" : "2014-08-19" }
{ "index": {}}
{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
{ "index": {}}
{ "price" : 80000, "color" : "red", "make" : "bmw", "sold" : "2014-01-01" }
{ "index": {}}
{ "price" : 25000, "color" : "blue", "make" : "ford", "sold" : "2014-02-12" }

# "size" : 0 代表了是否返回group by 时候的item，0代表了不返回，1就是返回第一条，以此类推
# "size" : 0 我们并不关心搜索结果的具体内容
GET /cars/_search
{
    "size" : 0,
    "aggs" : { 
        "popular_colors" : { 
            "terms" : { 
              "field" : "color"
            }
        }
    }
}
# 约等于
GET /cars/_search
{
    "size" : 0,
    "query" : {
        "match_all" : {}
    },
    "aggs" : {
        "colors" : {
            "terms" : {
              "field" : "color"
            }
        }
    }
}

# WHERE make = "ford" GROUP BY color 
GET /cars/_search
{
    "size" : 0,
    "query" : {
        "match" : {
            "make" : "ford"
        }
    },
    "aggs" : {
        "colors" : {
            "terms" : {
              "field" : "color"
            }
        }
    }
}

## 全局桶
# all的汇总，使用了关键字global，代表了全局汇总。为什么这么写。背就行了
GET /cars/_search
{
    "size" : 0,
    "query" : {
        "match" : {
            "make" : "ford"
        }
    },
    "aggs" : {
        "single_avg_price": {
            "avg" : { "field" : "price" } 
        },
        "all": {
            "global" : {}, 
            "aggs" : {
                "avg_price": {
                    "avg" : { "field" : "price" } 
                }
            }
        }
    }
}

GET /cars/_search
{
    "size" : 0,
    "query" : {
        "match" : {
            "make" : "ford"
        }
    },
    "aggs" : {
        "avg_price": {
            "avg" : { "field" : "price" } 
        }
    }
}


# 更高级的用法 SELECT count(color), AVG(price) AS avg_price  FROM car  GROUP BY color;
GET /cars/_search
{
   "size" : 0,
   "aggs": {
      "colors": {
         "terms": {
            "field": "color"
         },
         "aggs": { 
            "avg_price": { 
               "avg": {
                  "field": "price" 
               }
            }
         }
      }
   }
}

# group by (group by) 这个在sql中非常的复杂
GET /cars/_search
{
   "size" : 0,
   "aggs": {
      "colors": {
         "terms": {
            "field": "color"
         },
         "aggs": {
            "avg_price": { 
               "avg": {
                  "field": "price"
               }
            },
            "make": { 
                "terms": {
                    "field": "make" 
                }
            }
         }
      }
   }
}

# 越来越变态 sql我不会写了。。。
GET /cars/_search
{
   "size" : 0,
   "aggs": {
      "colors": {
         "terms": {
            "field": "color"
         },
         "aggs": {
            "avg_price": { "avg": { "field": "price" }
            },
            "make" : {
                "terms" : {
                    "field" : "make"
                },
                "aggs" : { 
                    "min_price" : { "min": { "field": "price"} }, 
                    "max_price" : { "max": { "field": "price"} } 
                }
            }
         }
      }
   }
}

# 直方图 interval步长20000
# 理解这个很重要： 聚合，先聚合最外层aggs->filed(price)->acition(histogram),然后外层的结果再去聚合里面的aggs,里面aggs->filed(revenue)->acition(sum)
# 最终理解为，先按照售卖价格0-2w，2-4w，4-6w...group分组，每个group内再按照price进行sum求和
# histogram 函数只能是数字
GET /cars/_search
{
   "size" : 0,
   "aggs":{
      "price":{
         "histogram":{ 
            "field": "price",
            "interval": 20000
         },
         "aggs":{
            "revenue": {
               "sum": { 
                 "field" : "price"
               }
             }
         }
      }
   }
}

# 完犊子了 不会了
# 这个按照上面的解释aggs->filed(makes)->action(terms)，先根绝“make”进行group，其中的size，类似于sql中的limit，size = 10 ，就是limit 10,然后再次agg->filed(stats)->action(extended_stats)。extended_stats是es中特有的非常有用的函数，可以对聚合的结果进行更近一步的分析
GET /cars/_search
{
  "size" : 0,
  "aggs": {
    "makes": {
      "terms": {
        "field": "make",
        "size": 10
      },
      "aggs": {
        "stats": {
          "extended_stats": {
            "field": "price"
          }
        }
      }
    }
  }
}

# 时间分区aggs->filed(sales)->action(date_histogram)。interval以月区分。format时间格式
# 但是只是到有数据到区间，2014-12-01这个月的数据是没有的
GET /cars/_search
{
   "size" : 0,
   "aggs": {
      "sales": {
         "date_histogram": {
            "field": "sold",
            "interval": "month", 
            "format": "yyyy-MM-dd" 
         }
      }
   }
}

# 跟上面一样，补全了空桶，2014-12-01添加上了
# extended_bounds也是非常有用的函数参数
GET /cars/_search
{
   "size" : 0,
   "aggs": {
      "sales": {
         "date_histogram": {
            "field": "sold",
            "interval": "month",
            "format": "yyyy-MM-dd",
            "min_doc_count" : 0, 
            "extended_bounds" : { 
                "min" : "2014-01-01",
                "max" : "2014-12-31"
            }
         }
      }
   }
}

# 上面的高级拓展例子，这个需要熟练度
GET /cars/_search
{
   "size" : 0,
   "aggs": {
      "sales": {
         "date_histogram": {
            "field": "sold",
            "interval": "quarter", 
            "format": "yyyy-MM-dd",
            "min_doc_count" : 0,
            "extended_bounds" : {
                "min" : "2014-01-01",
                "max" : "2014-12-31"
            }
         },
         "aggs": {
            "per_make_sum": {
               "terms": {
                  "field": "make"
               },
               "aggs": {
                  "sum_price": {
                     "sum": { "field": "price" } 
                  }
               }
            },
            "total_sum": {
               "sum": { "field": "price" } 
            }
         }
      }
   }
}

#  WHERE price <= 10000 GROUP BY price
GET /cars/_search
{
    "size" : 0,
    "query" : {
        "constant_score": {
            "filter": {
                "range": {
                    "price": {
                        "gte": 10000
                    }
                }
            }
        }
    },
    "aggs" : {
        "single_avg_price": {
            "avg" : { "field" : "price" }
        }
    }
}

#  我不明白这个了，我想获得sold > 2014-06 这边es匹配的更多信息
# WHERE make = "ford" AND sold > 2014-06 GROUP BY price
GET /cars/_search
{
   "size" : 0,
   "query":{
      "match": {
         "make": "ford"
      }
   },
   "aggs":{
      "recent_sales": {
         "filter": { 
            "range": {
               "sold": {
                  "from": "2014-01"
               }
            }
         },
         "aggs": {
            "average_price":{
               "avg": {
                  "field": "price" 
               }
            }
         }
      }
   }
}
# 纯种搜索 WHERE make = "ford" AND sold > 2014-06 GROUP BY price 
GET /cars/_search
{
   "size" : 0,
   "query":{
     "bool":{
       "filter": [
         {"match": {"make": "ford"}},
         {"range": {"sold": {"from": "2014-01"}}}
       ]
      }
    },
   "aggs": {
      "average_price":{
         "avg": {
            "field": "price" 
         }
      }
   }
}




# 性能问题
# WHERE make = "ford" GROUP BY price HAVING sold > now() - 1month
GET /cars/_search
{
    "size" : 0,
    "query": {
        "match": {
            "make": "ford"
        }
    },
    "post_filter": {    
        "term" : {
            "color" : "green"
        }
    },
    "aggs" : {
        "all_colors": {
            "terms" : { "field" : "color" }
        }
    }
}

#  内置排序
GET /cars/_search
{
    "size" : 0,
    "aggs" : {
        "colors" : {
            "terms": {
              "field" : "color",
              "order": {
                "_count" : "asc" 
              }
            }
        }
    }
}

# 颜色排序 "collect_mode" : "breadth_first"广度优先模式
# 广度优先仅仅适用于每个组的聚合数量远远小于当前总组数的情况下，因为广度优先会在内存中缓存裁剪后的仅仅需要缓存的每个组的所有数据，以便于它的子聚合分组查询可以复用上级聚合的数据。

#广度优先的内存使用情况与裁剪后的缓存分组数据量是成线性的。对于很多聚合来说，每个桶内的文档数量是相当大的。 想象一种按月分组的直方图，总组数肯定是固定的，因为每年只有12个月，这个时候每个月下的数据量可能非常大。这使广度优先不是一个好的选择，这也是为什么深度优先作为默认策略的原因。

#针对上面演员的例子，如果数据量越大，那么默认的使用深度优先的聚合模式生成的总分组数就会非常多，但是预估二级的聚合字段分组后的数据量相比总的分组数会小很多所以这种情况下使用广度优先的模式能大大节省内存，从而通过优化聚合模式来大大提高了在某些特定场景下聚合查询的成功率。
GET /cars/_search
{
    "size" : 0,
    "aggs" : {
        "colors" : {
            "terms" : {
              "field" : "color", 
              "collect_mode" : "breadth_first",
              "order": {
                "avg_price" : "asc"
              }
            },
            "aggs": {
                "avg_price": {
                    "avg": {"field": "price"} 
                }
            }
        }
    }
}

# 嵌套排序
GET /cars/_search
{
    "size" : 0,
    "aggs" : {
        "colors" : {
            "terms" : {
              "field" : "color",
              "order": {
                "stats.variance" : "asc" 
              }
            },
            "aggs": {
                "stats": {
                    "extended_stats": {"field": "price"}
                }
            }
        }
    }
}

# 按照子聚合red_green_cars的结果进行排序
GET /cars/_search
{
    "size" : 0,
    "aggs" : {
        "colors" : {
            "histogram" : {
              "field" : "price",
              "interval": 20000,
              "order": {
                "red_green_cars>stats.variance" : "asc" 
              }
            },
            "aggs": {
                "red_green_cars": {
                    "filter": { "terms": {"color": ["red", "green"]}}, 
                    "aggs": {
                        "stats": {"extended_stats": {"field" : "price"}} 
                    }
                }
            }
        }
    }
}


# cardinality 是近似算法
# SELECT COUNT(DISTINCT color) FROM cars
GET /cars/_search
{
    "size" : 0,
    "aggs" : {
        "distinct_colors" : {
            "cardinality" : {
              "field" : "color"
            }
        }
    }
}

# 日期区间柱状图分区
GET /cars/_search
{
  "size" : 0,
  "aggs" : {
      "months" : {
        "date_histogram": {
          "field": "sold",
          "interval": "month"
        },
        "aggs": {
          "distinct_colors" : {
              "cardinality" : {
                "field" : "color"
              }
          }
        }
      }
  }
}

# precision_threshold 接受 0–40,000 之间的数字，更大的值还是会被当作 40,000 来处理。
# 在实际应用中， 100 的阈值可以在唯一值为百万的情况下仍然将误差维持 5% 以内。
GET /cars/_search
{
    "size" : 0,
    "aggs" : {
        "distinct_colors" : {
            "cardinality" : {
              "field" : "color",
              "precision_threshold" : 100 
            }
        }
    }
}

DELETE /cars/

# 查看安装的插件
GET _cat/plugins?v
# 安装插件murmur3
# bin/elasticsearch-plugin install mapper-murmur3

# 指定murmur3
PUT /cars/
{
  "mappings": {
    "properties": {
      "color": {
        "type": "text",
        "fields": {
          "hash": {
            "type": "murmur3" 
          }
        }
      }
    }
  }
}

# 插入
POST /cars/_bulk
{ "index": {}}
{ "price" : 10000, "color" : "red", "make" : "honda", "sold" : "2014-10-28" }
{ "index": {}}
{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
{ "index": {}}
{ "price" : 30000, "color" : "green", "make" : "ford", "sold" : "2014-05-18" }
{ "index": {}}
{ "price" : 15000, "color" : "blue", "make" : "toyota", "sold" : "2014-07-02" }
{ "index": {}}
{ "price" : 12000, "color" : "green", "make" : "toyota", "sold" : "2014-08-19" }
{ "index": {}}
{ "price" : 20000, "color" : "red", "make" : "honda", "sold" : "2014-11-05" }
{ "index": {}}
{ "price" : 80000, "color" : "red", "make" : "bmw", "sold" : "2014-01-01" }
{ "index": {}}
{ "price" : 25000, "color" : "blue", "make" : "ford", "sold" : "2014-02-12" }

# 使用hash聚合，而非原始字段
# 单个文档节省的时间是非常少的，但是如果你聚合一亿数据，每个字段多花费 10 纳秒的时间，那么在每次查询时都会额外增加 1 秒，如果我们要在非常大量的数据里面使用 cardinality ，我们可以权衡使用预计算的意义，是否需要提前计算 hash，从而在查询时获得更好的性能，做一些性能测试来检验预计算哈希是否适用于你的应用场景。
GET /cars/_search
{
    "size" : 0,
    "aggs" : {
        "distinct_colors" : {
            "cardinality" : {
              "field" : "color.hash" 
            }
        }
    }
}

DELETE website

PUT /website 
{
    "mappings" : {
        "properties" : {
            "latency" : {
                "type": "integer"
            },
            "zone" : {
                "type": "keyword"
            },
            "timestamp" : {
                "type": "date"
            }
        }
    }
}

POST /website/_bulk
{ "index": {}}
{ "latency" : 100, "zone" : "US", "timestamp" : "2014-10-28" }
{ "index": {}}
{ "latency" : 80, "zone" : "US", "timestamp" : "2014-10-29" }
{ "index": {}}
{ "latency" : 99, "zone" : "US", "timestamp" : "2014-10-29" }
{ "index": {}}
{ "latency" : 102, "zone" : "US", "timestamp" : "2014-10-28" }
{ "index": {}}
{ "latency" : 75, "zone" : "US", "timestamp" : "2014-10-28" }
{ "index": {}}
{ "latency" : 82, "zone" : "US", "timestamp" : "2014-10-29" }
{ "index": {}}
{ "latency" : 100, "zone" : "EU", "timestamp" : "2014-10-28" }
{ "index": {}}
{ "latency" : 280, "zone" : "EU", "timestamp" : "2014-10-29" }
{ "index": {}}
{ "latency" : 155, "zone" : "EU", "timestamp" : "2014-10-29" }
{ "index": {}}
{ "latency" : 623, "zone" : "EU", "timestamp" : "2014-10-28" }
{ "index": {}}
{ "latency" : 380, "zone" : "EU", "timestamp" : "2014-10-28" }
{ "index": {}}
{ "latency" : 319, "zone" : "EU", "timestamp" : "2014-10-29" }

# percentiles 度量会返回一组预定义的百分位数值： [1, 5, 25, 50, 75, 95, 99]
GET /website/_search
{
    "size" : 0,
    "aggs" : {
        "load_times" : {
            "percentiles" : {
                "field" : "latency" 
            }
        },
        "avg_load_time" : {
            "avg" : {
                "field" : "latency" 
            }
        }
    }
}

# 高级查询 "percents" : [50, 95.0, 99.0]  指定百分比
GET /website/_search
{
    "size" : 0,
    "aggs" : {
        "zones" : {
            "terms" : {
                "field" : "zone" 
            },
            "aggs" : {
                "load_times" : {
                    "percentiles" : { 
                      "field" : "latency",
                      "percents" : [50, 95.0, 99.0] 
                    }
                },
                "load_avg" : {
                    "avg" : {
                        "field" : "latency"
                    }
                }
            }
        }
    }
}

PUT /music/_mapping
{
  "properties": {

      "type": "text",
      "fielddata": { 
        "filter": {
          "frequency": { 
            "min":              0.01, 
            "min_segment_size": 500  
          }
        }
      
    }
  }
}

# 创建全局锁
PUT /fs/lock/global/_create
{}
# 删除全局锁
DELETE /fs/lock/global

# 被锁文档的id，"_id": 1。被锁住
PUT /fs/lock/_bulk
{ "create": { "_id": 1}} 
{ "process_id": 123    } 
{ "create": { "_id": 2}}
{ "process_id": 123    }
# 删除锁
PUT /fs/lock/_bulk
{ "delete": { "_id": 1}}
{ "delete": { "_id": 2}}

# 嵌套对象
PUT /my_index_ws/_doc/1
{
  "title": "Nest eggs",
  "body":  "Making your money work...",
  "tags":  [ "cash", "shares" ],
  "comments": [ 
    {
      "name":    "John Smith",
      "comment": "Great article",
      "age":     28,
      "stars":   4,
      "date":    "2014-09-01"
    },
    {
      "name":    "Alice White",
      "comment": "More like this please",
      "age":     31,
      "stars":   5,
      "date":    "2014-10-22"
    }
  ]
}
DELETE  /my_index_ws

# 查询不到
GET /my_index_ws/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "name": "Alice" }},
        { "match": { "age":  31      }} 
      ]
    }
  }
}

# 类型为："type": "nested"
PUT /my_index_ws
{
  "mappings": {
    "properties": {
      "comments": {
        "type": "nested", 
        "properties": {
          "name":    { "type": "text"  },
          "comment": { "type": "text"  },
          "age":     { "type": "short"   },
          "stars":   { "type": "short"   },
          "date":    { "type": "date"    }
        }
      }
    }
  }
}

# 嵌套对象
PUT /my_index_ws/_doc/1
{
  "title": "Nest eggs",
  "body":  "Making your money work...",
  "tags":  [ "cash", "shares" ],
  "comments": [ 
    {
      "name":    "John Smith",
      "comment": "Great article",
      "age":     28,
      "stars":   4,
      "date":    "2014-09-01"
    },
    {
      "name":    "Alice White",
      "comment": "More like this please",
      "age":     31,
      "stars":   5,
      "date":    "2014-10-22"
    }
  ]
}

# 官方没查到。。
GET /my_index_ws/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "eggs" 
          }
        },
        {
          "nested": {
            "path": "comments", 
            "query": {
              "bool": {
                "must": [ 
                  {
                    "match": {
                      "comments.name": "john"
                    }
                  },
                  {
                    "match": {
                      "comments.age": 28
                    }
                  }
                ]
              }
            }
          }
        }
      ]
}}}

PUT /my_index_ws/_doc/2
{
  "title": "Investment secrets",
  "body":  "What they don't tell you ...",
  "tags":  [ "shares", "equities" ],
  "comments": [
    {
      "name":    "Mary Brown",
      "comment": "Lies, lies, lies",
      "age":     42,
      "stars":   1,
      "date":    "2014-10-18"
    },
    {
      "name":    "John Smith",
      "comment": "You're making it up!",
      "age":     28,
      "stars":   2,
      "date":    "2014-10-16"
    }
  ]
}

```

###  7.16版本英文文档

### 安装配置
1. 尽量选择jdk8，
2. 不要调整jvm虚拟机参数
3. 64g完美，32g和16g很常见，但是只有它自己一个应用，不要有别的了。
4. 硬盘能上固态最好
5. 配置修改，切记，开发团队已经优化到最优，没有修改一个配置性能飞起来的情况
    1. elasticsearch.yml
        1. 集群名cluster.name: elasticsearch_production
        2. 节点名node.name: elasticsearch_005_data
        3. 数据路径
            ```
            path.data: /path/to/data1,/path/to/data2 
            # Path to log files:
            path.logs: /path/to/logs
            # Path to where plugins are installed:
            path.plugins: /path/to/plugins
            ```
        4. minimum_master_nodes 最小master节点数，防止脑裂（一种两个主节点同时存在于一个集群的现象）。默认算法( master 候选节点个数 / 2) + 1 
            ```
            可以通过API在线修改数字，当增加/删除节点的时候
            PUT /_cluster/settings
            {
                "persistent" : {
                    "discovery.zen.minimum_master_nodes" : 2
                }
            }
            ```
6. 不要碰的配置Elasticsearch 
    1. 默认的垃圾回收器（ GC ）是 CMS
        ```
        CMS垃圾回收器可以和应用并行处理，以便它可以最小化停顿。 然而，它有两个 stop-the-world 阶段，处理大内存也有点吃力
        G1 垃圾回收器（ G1GC ）。 这款新的 GC 被设计，旨在比 CMS 更小的暂停时间，以及对大内存的处理能力。 它的原理是把内存分成许多区域，并且预测哪些区域最有可能需要回收内存。通过优先收集这些区域（ garbage first ），产生更小的暂停时间，从而能应对更大的内存.听起来很棒！遗憾的是，G1GC 还是太新了，经常发现新的 bugs。这些错误通常是段（ segfault ）类型，便造成硬盘的崩溃
        ```
    2. 线程池。默认为 `int（（ 核心数 ＊ 3 ）／ 2 ）＋ 1 `
        ```
        你可能会认为某些线程可能会阻塞（如磁盘上的 I／O 操作），所以你才想加大线程的。对于 Elasticsearch 来说这并不是一个问题：因为大多数 I／O 的操作是由 Lucene 线程管理的，而不是 Elasticsearch。

        此外，线程池通过传递彼此之间的工作配合。你不必再因为它正在等待磁盘写操作而担心网络线程阻塞， 因为网络线程早已把这个工作交给另外的线程池，并且网络进行了响应。
        
        最后，你的处理器的计算能力是有限的，拥有更多的线程会导致你的处理器频繁切换线程上下文。 一个处理器同时只能运行一个线程。所以当它需要切换到其它不同的线程的时候，它会存储当前的状态（寄存器等等），然后加载另外一个线程。 如果幸运的话，这个切换发生在同一个核心，如果不幸的话，这个切换可能发生在不同的核心，这就需要在内核间总线上进行传输。
        
        这个上下文的切换，会给 CPU 时钟周期带来管理调度的开销；在现代的 CPUs 上，开销估计高达 30 μs。也就是说线程会被堵塞超过 30 μs，如果这个时间用于线程的运行，极有可能早就结束了。
        
        人们经常稀里糊涂的设置线程池的值。8 个核的 CPU，我们遇到过有人配了 60、100 甚至 1000 个线程。 这些设置只会让 CPU 实际工作效率更低。
        
        所以，下次请不要调整线程池的线程数。如果你真 想调整 ， 一定要关注你的 CPU 核心数，最多设置成核心数的两倍，再多了都是浪费。
        ```
1. 内存，启动默认1g
    * `./bin/elasticsearch -Xmx10g -Xms10g` 确保堆内存最小值（ Xms ）与最大值（ Xmx ）的大小是相同的，防止程序在运行时改变堆内存大小， 这是一个很耗系统资源的过程
    * [内存分配](https://www.elastic.co/guide/cn/elasticsearch/guide/current/heap-sizing.html%23heap-sizing)，elasticsearch内存使用分为两部分
        1. es调取lucene的java程序（我们认为的es）；
        2. Lucene本身，也是一个内存大户。至少有一半以上的内存给Lucene使用。
        3. 建议
            1. 不要超过32g，最好是31安全
            2. 关闭Swapping。
                1. `sudo swapoff -a 暂时关闭` 
                2. 对于大部分Linux操作系统，可以在 sysctl 中这样配置：`vm.swappiness = 1 `
                    ```
                    swappiness 设置为 1 比设置为 0 要好，因为在一些内核版本 swappiness 设置为 0 会触发系统 OOM-killer（注：Linux 内核的 Out of Memory（OOM）killer 机制）。
                    ```
2. 文件描述符
    1. 多现代的 Linux 发行版本，每个进程默认允许一个微不足道的 1024 文件描述符。太小了。设置为64,000。咋设置呢？
        ```
        GET /_nodes/process
        {
           "cluster_name": "elasticsearch__zach",
           "nodes": {
              "TGn9iO2_QQKb0kavcLbnDw": {
                 "name": "Zach",
                 "transport_address": "inet[/192.168.1.131:9300]",
                 "host": "zacharys-air",
                 "ip": "192.168.1.131",
                 "version": "2.0.0-SNAPSHOT",
                 "build": "612f461",
                 "http_address": "inet[/192.168.1.131:9200]",
                 "process": {
                    "refresh_interval_in_millis": 1000,
                    "id": 19808,
                    "max_file_descriptors": 64000, # 确保这个
                    "mlockall": true # 交换内存，调优为false bootstrap.mlockall: true
                 }
              }
           }
        }
        ```
3. MMaps设置最大.`sysctl -w vm.max_map_count=262144`
    ```
    Elasticsearch 对各种文件混合使用了 NioFs（ 注：非阻塞文件系统）和 MMapFs （ 注：内存映射文件系统）。请确保你配置的最大映射数量，以便有足够的虚拟内存可用于 mmapped 文件。这可以暂时设置：
    可以在 /etc/sysctl.conf 通过修改 vm.max_map_count 永久设置它。
    ```
### 生产配置
1. 日志
    1. 级别设置
    ```
    Debug级别，默认info
    PUT /_cluster/settings
    {
        "transient" : {
            "logger.discovery" : "DEBUG"
        }
    }
    ```
    2. 慢日志
    ```
    PUT /my_index/_settings
    {
        "index.search.slowlog.threshold.query.warn" : "10s", # 查询慢于 10 秒输出一个 WARN 日志
        "index.search.slowlog.threshold.fetch.debug": "500ms", # 获取慢于 500 毫秒输出一个 DEBUG 日志
        "index.indexing.slowlog.threshold.index.info": "5s" # 索引慢于 5 秒输出一个 INFO 日志
    }
    
    
    PUT /_cluster/settings
    {
        "transient" : {
            "logger.index.search.slowlog" : "DEBUG", #设置搜索慢日志为 DEBUG 级别
            "logger.index.indexing.slowlog" : "WARN" # 设置索引慢日志为 WARN 级别
        }
    }
    ```
### 调优
![优化](https://raw.githubusercontent.com/wonsaign/pics/main/note-picses-optimizing-config.png)
