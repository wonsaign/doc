## Java Core
> java核心类库相关的

* 什么是XML
    * XML 指可扩展标记语言（EXtensible Markup Language）
    * XML 是一种标记语言，很类似 HTML
    * XML 的设计宗旨是传输数据，而非显示数据
    * XML 标签没有被预定义。您需要自行定义标签。
    * XML 被设计为具有自我描述性。
    * XML 是 W3C 的推荐标准)
* XML常用的解析方式SAX(simple API for XML)，DOM(文档对象模型：Document Object Model)
  * 二者的却别
    * DOM：把所有内容一次性的装载入内存，并构建一个驻留在内存中的树状结构（节点数）。如果需要解析的XML文档过大，或者我们只对该文档中的一部分感兴趣，这样就会引起性能问题
    * SAX:对文档进行顺序扫描，当扫描到文档（document）开始与结束、元素（element）开始与结束、文档（document）结束等地方时通知事件处理函数，由事件处理函数做相应动作，然后继续同样的扫描，直至文档结束
  * SAX处理过程中包含的事件步骤：
      1.在文档的开始和结束时触发文档处理事件。
      2.在文档内每一XML元素接受解析的前后触发元素事件。
      3.任何元数据通常由单独的事件处理
      4.在处理文档的DTD或Schema时产生DTD或Schema事件。
      5.产生错误事件用来通知主机应用程序解析错误。
  * 编程步骤
    （1）.创建事件处理程序（也就是编写ContentHandler的实现类，一般继承自DefaultHandler类，采用adapter模式）
    （2）.创建SAX解析器
    （3）.将事件处理程序分配到解析器
    （4）.对文档进行解析，将每个事件发送给事件处理程序
  * 接口介绍：
    * ContentHandler接口 （主要用到的接口）
    ContentHandler是Java类包中一个特殊的SAX接口，位于org.xml.sax包中。该接口封装了一些对事件处理的方法，当XML解析器开始解析XML输入文档时，它会遇到某些特殊的事件，比如文档的开头和结束、元素开头和结束、以及元素中的字符数据等事件。当遇到这些事件时，XML解析器会调用ContentHandler接口中相应的方法来响应该事件。
    ContentHandler接口的方法有以下几种：
    void startDocument()//文件打开时调用
    void endDocument()//当到文档的末尾调用
    void startElement(String uri, String localName, String qName, Attributes atts)//当遇到开始标记时调用
    void endElement(String uri, String localName, String qName)//当遇到节点结束时调用
    void characters(char[ ] ch, int start, int length)//当分析器遇到无法识别为标记或者指令类型字符时调用
    * DTDHandler接口
    DTDHandler用于接收基本的DTD相关事件的通知。该接口位于org.xml.sax包中。此接口仅包括DTD事件的注释和未解析的实体声明部分。SAX解析器可按任何顺序报告这些事件，而不管声明注释和未解析实体时所采用的顺序；但是，必须在文档处理程序的startDocument()事件之后，在第一个startElement()事件之前报告所有的DTD事件。
    DTDHandler接口包括以下两个方法
    void startDocumevoid notationDecl(String name, String publicId, String systemId) nt()
    void unparsedEntityDecl(String name, String publicId, String systemId, String notationName)
    * EntityResolver接口
    EntityResolver接口是用于解析实体的基本接口，该接口位于org.xml.sax包中。
    该接口只有一个方法，如下：
    public InputSource resolveEntity(String publicId, String systemId)
    解析器将在打开任何外部实体前调用此方法。此类实体包括在DTD内引用的外部DTD子集和外部参数实体和在文档元素内引用的外部通用实体等。如果SAX应用程序需要实现自定义处理外部实体，则必须实现此接口。
    * ErrorHandler接口
    ErrorHandler接口是SAX错误处理程序的基本接口。如果SAX应用程序需要实现自定义的错误处理，则它必须实现此接口，然后解析器将通过此接口报告所有的错误和警告。
    该接口的方法如下：
    void error(SAXParseException exception)
    void fatalError(SAXParseException exception)
    void warning(SAXParseException exception)
* XML验证方式：DTD,XSD。
  * DTD:
    * DTD即文档类型定义，是一种XML约束模式语言，是XML文件的验证机制,属于XML文件组成的一部分.
    * DTD 是一种保证XML文档格式正确的有效方法，可以通过比较XML文档和DTD文件来看文档是否符合规范，元素和标签使用是否正确.
    * DTD使用是非xml语法编写，不支持扩展，不支持命名空间，只提供非常有限的数据类型
  * XSD:
    * XML Schemal语言就是XSD，XML Schema描述了XML文档的结构，可以用一个指定的XML Schema来验证某个XML.
    * 文档设计者可以通过XML Schema指定一个XML文档所允许的结构和内容，并可据此检查一个XML文档是否是有效的。
    * XML Schema本身是一个XML文档，它符合XML语法结构。可以用通用的XML解析器解析它
  * 相比DTD，XSD的优点是：
  * `XML Schema的优点`:
    * XML Schema基于XML,没有专门的语法
    * XML Schema可以象其他XML文件一样解析和处理
    * XML Schema比DTD提供了更丰富的数据类型.
    * XML Schema提供可扩充的数据模型。
    * XML Schema支持综合命名空间
    * XML Schema支持属性组。

* 什么是SPI
> 在java.util.ServiceLoader的文档里有比较详细的介绍。
> &nbsp;&nbsp;&nbsp;&nbsp;简单的总结下java spi机制的思想。我们系统里抽象的各个模块，往往有很多不同的实现方案，比如日志模块的方案，xml解析模块、jdbc模块的方案等。
&nbsp;&nbsp;&nbsp;&nbsp;面向对象的设计里，我们一般推荐模块之间基于接口编程，模块之间不使用实现类进行硬编码。一旦代码里涉及具体的实现类，就违反了可拔插的原则，如果需要替换一种实现，就需要修改代码。
> &nbsp;&nbsp;&nbsp;&nbsp;为了实现在模块装配的时候动态指定具体实现类，这就需要一种服务发现机制。java spi就是提供这种功能的机制：为某个接口寻找服务实现的机制。有点类似IOC的思想，将装配的控制权移到程序之外，在模块化设计中这个机制尤其重要。 
> &nbsp;&nbsp;&nbsp;&nbsp;java SPI应用场景很广泛，在Java底层和一些框架中都很常用，比如java数据驱动加载和Dubbo。
Java底层定义加载接口后，由不同的厂商提供驱动加载的实现方式，当我们需要加载不同的数据库的时候，只需要替换数据库对应的驱动加载jar包，就可以进行使用。

* 要使用Java SPI，需要遵循如下约定：
  * 当服务提供者提供了接口的一种具体实现后，在jar包的META-INF/services目录下创建一个以“接口全限定名”为命名的文件，内容为实现类的全限定名；
  * 接口实现类所在的jar包放在主程序的classpath中；
  * 主程序通过java.util.ServiceLoder动态装载实现模块，它通过扫描META-INF/services目录下的配置文件找到实现类的全限定名，把类加载到JVM；
  * SPI的实现类必须携带一个不带参数的构造方法.