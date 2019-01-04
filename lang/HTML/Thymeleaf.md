### Thymeleaf说明使用文档
* 实现IGTVGController接口,此条不适合SpringBoot
* 返回值的方式：
  *  ${x} will return a variable x stored into the Thymeleaf context or as a request attribute.
  *  ${param.x} will return a request parameter called x (which might be multivalued).
  *  ${session.x} will return a session attribute called x .
  *  ${application.x} will return a servlet context attribute called x .
#### 表达式
  * Simple expressions(简单表达式):
      * Variable Expressions: ${...}  <==> ctx.getVariable(...); 
      * Selection Variable Expressions: *{...}
      * Message Expressions: #{...}
      * Link URL Expressions: @{...}
      * Fragment Expressions: ~{...}
  * Literals(常量):
      * Text literals: 'one text' , 'Another one!' ,…
      * Number literals: 0 , 34 , 3.0 , 12.3 ,…
      * Boolean literals: true , false
      * Null literal: null
      * Literal tokens: one , sometext , main ,…
  * Text operations(文本操作符):
      * String concatenation: +
      * Literal substitutions: |The name is ${name}|
  * Arithmetic operations(数学操作符):
      * Binary operators: + , - , * , / , %
      * Minus sign (unary operator): -
  * Boolean operations(布尔操作符):
      * Binary operators: and , or
      * Boolean negation (unary operator): ! , not
  * Comparisons and equality(比较、等于操作符):
      * Comparators: > , < , >= , <= ( gt , lt , ge , le )
      * Equality operators: == , != ( eq , ne )
  * Conditional operators(条件操作符):
      * If-then: (if) ? (then)
      * If-then-else: (if) ? (then) : (else)
      * Default: (value) ?: (defaultvalue)
  * Message消息
    * #{...}
#### Thymeleaf内置对象
* Expression Basic Objects(基本)
   * `#ctx`: the context object.
   * `#vars`: the context variables.
   * `#locale` : the context locale.
   * `#request` : (only in Web Contexts) the HttpServletRequest object.
   * `#response` : (only in Web Contexts) the HttpServletResponse object.
   * `#session` : (only in Web Contexts) the HttpSession object.
   * `#servletContext` : (only in Web Contexts) the ServletContext object.
* Expression Utility Objects(扩展工具)
   * `#execInfo` : information about the template being processed.
   * `#messages` : methods for obtaining externalized messages inside variables expressions, in the same way as they would be obtained using #{…} syntax.
   *`#uris` : methods for escaping parts of URLs/URIs
   *`#conversions` : methods for executing the configured conversion service (if any).
   *`#dates` : methods for java.util.Date objects: formatting, component extraction, etc.
   *`#calendars` : analogous to #dates , but for java.util.Calendar objects.
   *`#numbers` : methods for formatting numeric objects.
   *`#strings` : methods for String objects: contains, startsWith, prepending/appending, etc.
   *`#objects` : methods for objects in general.
   *`#bools` : methods for boolean evaluation.
   *`#arrays` : methods for arrays.
   *`#lists` : methods for lists.
   *`#sets` : methods for sets.
   *`#maps` : methods for maps.
   *`#aggregates` : methods for creating aggregates on arrays or collections.
   *`#ids` : methods for dealing with id attributes that might be repeated (for example, as a result of an iteration).
#### 基本操作
* `${...}`  <==> `ctx.getVariable(...)`;
* `*{...}`   代表属性
  * `th:text="${session.user.firstName}"`  <==> `th:object="${session.user}" , th:text="*{firstName}">`
* Link URLs -> `th:href`
  * 'localhost:8080/gtvg/order/details?orderId=3'
    * `<a href="details.html" th:href="@{http://localhost:8080/gtvg/order/details(orderId=${o.id})}">view</a>`
  * '/gtvg/order/details?orderId=3'
    * `<a href="details.html" th:href="@{/order/details(orderId=${o.id})}">view</a>`
  * '/gtvg/order/3/details' (plus rewriting)
    * `<a href="details.html" th:href="@{/order/{orderId}/details(orderId=${o.id})}">view</a>`
* Literals 常量
  * text Literals =>  'hi world'
  * number Literals => 123
  * boolean Literals => true , false  e.x.: `th:if="${user.isAdmin()} == false"`
  * null Literals => null
* 操作符
  * `th:with="isEven=(${prodStat.count} % 2 == 0)"`   或者  `th:with="isEven=${prodStat.count % 2 == 0}"`
* 条件表达式 th:class
  * `th:class="${row.even}? 'even' : 'odd'"`
  * 默认表达式 `th:text="*{age}?: '(no age specified)'"` <==> `th:text="*{age != null}? *{age} : '(no age specified)'"`

#### 设值 
* `th:attr=""`  例如:    
  `th:attr="src=@{/images/gtvglogo.png},title=#{logo},alt=#{logo}"` <=>  
  `th:src="@{/images/gtvglogo.png}" th:title="#{logo}" th:alt="#{logo}"`  <=>   
  `th:src="@{/images/gtvglogo.png}" th:alt-title="#{logo}"`
* `th:value=""`
* form => `th:action="@{/subscribe}">`
* H5 循环：
    ```
        <tr data-th-each="user : ${users}">
            <td data-th-text="${user.login}">...</td>
            <td data-th-text="${user.name}">...</td>
        </tr>
    ```
#### 迭代器
* Using `th:each`
    ```
        <table>
            <tr>
                <th>NAME</th>
                <th>PRICE</th>
                <th>IN STOCK</th>
            </tr>
                <tr th:each="prod : ${prods}">
                <td th:text="${prod.name}">Onions</td>
                <td th:text="${prod.price}">2.41</td>
                <td th:text="${prod.inStock}? #{true} : #{false}">yes</td>
            </tr>
        </table>

    ```
* Using th:if
* Using th:switch   + th:case
#### 模板功能
* 简单使用： `th:fragment` 
  
例如：`定义 Footer` ,Say we want to add a standard copyright footer to all our grocery pages, so we create a /WEBINF/templates/footer.html
```
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
    <body>
        <div th:fragment="copy">
        &copy; 2011 The Good Thymes Virtual Grocery
    </div>
</body>
</html>
```
`引入Footer` ==> "~{templatename::selector}"
```
<body>
    ...
    <div th:insert="~{footer :: copy}"></div>
</body>
```
* 复杂使用  

定义可换title，links
```
<head th:fragment="common_header(title,links)">
    <title th:replace="${title}">The awesome application</title>
    <!-- Common styles and scripts -->
    <link rel="stylesheet" type="text/css" media="all" th:href="@{/css/awesomeapp.css}">
    <link rel="shortcut icon" th:href="@{/images/favicon.ico}">
    <script type="text/javascript" th:src="@{/sh/scripts/codebase.js}"></script>
    <!--/* Per-page placeholder for additional links */-->
    <th:block th:replace="${links}" />
</head>
```
Call This

```
<head th:replace="base :: common_header(~{::title},~{::link})">
    <title>Awesome - Main</title>
    <link rel="stylesheet" th:href="@{/css/bootstrap.min.css}">
    <link rel="stylesheet" th:href="@{/themes/smoothness/jquery-ui.css}">
</head>
```
#### 本地变量
* `th:with`
```
<div th:with="firstPer=${persons[0]},secondPer=${persons[1]}">
    <p>
        The name of the first person is <span th:text="${firstPer.name}">Julius Caesar</span>.
    </p>
    <p>
        But the name of the second person is
        <span th:text="${secondPer.name}">Marcus Antonius</span>.
    </p>
</div>
```  
#### 注释和块儿
* 标准的HTML注释是：`<!-- 注释 -- >`
* Thymeleaf的注释是：`<!--/* 注释   */-->` 
* `th:block`, 隐藏显示，当隐藏时，类似上面的注释
#### Inlining内联
* [[...]] or [(...)]表达式代替a th:text or th:utext 例如： `<p>Hello, [[${session.user.name}]]!</p>`  <==> `<p>Hello, <span th:text="${session.user.name}">Sebastian</span>!</p>`
* JavaScript内联  

例如：
```
<script th:inline="javascript">
...
var username = [[${session.user.name}]];
...
</script>
```
等同于
```
<script th:inline="javascript">
...
var username = "Sebastian \"Fruity\" Applejuice";
...
</script>
```
    