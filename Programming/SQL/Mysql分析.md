## MySQL选择合适的索引

> 使用Trace工具来分析.
* select * from student where name > 'a';**name字段是索引列**,有可能不走索引


* 可能原因是:辅助索引查找到后(其叶子节点是聚集索引的主键地址),因为搜索列是`*`,还会再次扫一遍聚集索引树来补全剩余的字段,简称回表.`两遍扫树的成本又可能超过全表扫描`,所以会执行type类型是all的全表扫描.
```
    优化:select `a` from student where name > 'a';可以使用覆盖扫描.
```
> Trace工具来分析步骤.
1. 开启Trace`set session optimizer_trace="enabled=on",end_markers_in_json=on;`
2. 执行要分析的查询语句select * from student where name > 'a';
3. 执行select * from information_schema.OPTIMIZER_TRACE;查看Trace执行的结果.
4. 注意第二步和第三步最好一起执行.
```
Trace日志分析Json格式.
关键字段:
steps步骤
join_preparation: 准备Sql阶段
join_optimization: Sql优化阶段(条件排序,条件冗余,条件去重等简单的优化)
rows_estimation:预估表的访问成本(重点)
range_analysis 范围分析
    table_scan 全表扫描
    potential_range_indexs: 可能使用的索引
    analyzing_range_alternatives 分析各个索引使用的成本.
    index_only 覆盖索引
join_execution sql执行阶段.
filesort_summary 文件排序信息.
    sort_mode 排序模式
        packed_additional_fields // 单路排序
        additional_fields // 单路排序
        rowid // 多路排序
```