<font size=6 color=orange>重</font>构的意义，不必再说，写的代码是给人看的，为了给自己留点脸面。
<font size=6 color=orange>重</font>构的原则：在不改变其功能的情况下进行重构。
#### 代码的坏味道
* `Duplicated Code`，重复代码。
* `Long Method`，过长的方法，寻找通过注解注释的代码块/条件表达式/循环，提炼出函数。
* `Large Class`，过大的类。
* `Long Parameter List`，参数列表太长。
* `Divergent Change`，发散式变化，一个修改引起多处变化。
* `Shotgun Surgery`，分散式修改，当添加/修改一个功能，要修改三个以上的函数。
* `Feature Envy`，依恋情结，为了计算某个值，从另外一个类取了一半的函数帮助计算。
* `Data Clumps`，数据泥团，类中相同的字段/多个函数参数都一样
* `Primitive Obsession`，基本类型偏执，很多时候，可以使用对象来代替数组。
* `Switch Statements`，使用多态来解决。
* `Parallel Inheritance Hierarchies`，平行继承，某个类增加一个子类，必须为另外一个类相应的也添加一个子类。
* `Lazy Class`，冗余类，如果一个类价值不符合本身，就应该去掉。
* `Speculative Gennerality`，夸大的作用性，某个抽象类如果没有作用，就去掉。
* `Temporary Field`，令人迷惑的暂时字段，某个类的实例变量仅为某中特殊形况而定。
* `Message Chains`，过度耦合的消息链，使用封装解决，类内应该对自己保持一致。
* `Middle Man`，中间人，封装解决。
* `Inappropriate Intimacy`，狎昵关系，两个类花费太多的时候去获取彼此的private成分。
* `Alternative Classes With Different Interfaces`，异曲同工类，两个函数做同一件事，却有不同的名字。
* `Incomplete Library Class`，不完美类类库，这个由jdk开发团队来解决
* `Data Class`，纯数据类，这个就是要加private，进行封装。
* `Refused Bequest`，被拒绝的馈赠，子类应该继承父类的全部函数和数据，这个味道很淡，依情况改动。
* `Comments`，过多的注释，当然不是指的是注释不好，不过大部分人用注解来当除臭剂，在一端又臭又长的代码上会有一段注释，这种情况非常多。

#### 重构方法:
|Method|When|How|Point|
|---|:---|:---|:---|
|`EM`[^1]|<font color=Crimson>过长的函数,或者需要一段注解才能理解时</font>|<font color=LightSeaGreen>代码独立放在一个函数中,以函数`做什么`命名</font>|`粒度较大,最基本,最终,最重要,下面所有的方法,最终目的都是使用该方法,增加粒度`|
|`IM`[^2]|当函数过于简单清晰易懂或手上有一群组织不合理的函数,可以将它们内联到一起在拆解为合理的函数|检查是否具有`多态性`,在函数调用点插入函数本体,然后移除函数|一般总为`EM`的中间手段|
|`IT`[^3]|只被一个简单的表达式赋值`一次`,唯一单独使用的情况是`作为函数的返回值`|赋值该变量为`final`,找到只被使用一次的地方用表达式替换掉|是`RTWQ`一种特例|
|`RTWQ`[^4]|以临时变量保存某个表达式的运算结果,临时变量是暂时的,如果替换为函数,可增加复用|找出只被赋值一次的临时变量[^5]并声明为final,提炼为private方法,此重构方法针对临时变量|粒度小,并且`局部变量数量少`,并且一般在`EM`方法之前|
|`IEV`[^6]|复杂表达式,较长算法或条件逻辑中的条件|将复杂表达式(或其中一部分)用一个final临时变量声明|超级麻烦,并且`EM`解决不了|
|`STV`[^7]|某个不是循环遍历或结果收集变量[^8]的临时变量被赋值超过一次,这以为它承担一个以上的责任,每个变量只承担一个责任|在该变量第二次赋值的时候,引入新的临时变量|
|`RATP`[^9]|代码对一个变量参数[^10]进行再次赋值|建立一个临时变量,将取替该变量|
|`RMWMO`[^11]|大型函数,对局部变量无法使用`EM`|将该函数放进一个单独的对象(可以是内部类),建立一个final字段保存原先大型函数所在的对象,并将局部变量变为对象的实例变量,如此可在对象中,将大型函数分解为多个小型函数.|与`IEV`相同的是都不能使用`EM`,不同的是<font color=SaddleBrown>`IEV`作用于算法,逻辑;此方法作用于局部变量关系错综复杂</font>.|
|`SA`[^12]|你想替换算法的时候|将函数本体替换为另外一个算法|这个真没啥好说的|


[^1]:Extract Method,函数替代
[^2]:Inline Method,内联方法
[^3]:Inline Temp,内联变量
[^4]:Replace Temp with Query,以查询方法代替临时变量
[^5]:如果临时变量不被赋值一次,就不改使用此方法重构.
[^6]:Introduce Explaining Variable,引入中间解释变量
[^7]:Split Temporary Variable,分割临时变量
[^8]:包含了:i++;str+"abc",IO,Collection
[^9]:Remove Assignments to Parameters,移除参数赋值
[^10]:java只有值传递一种,所谓引用传递只不过传递的是地址的数值.
[^11]:Replace Method with Method Object,用对象方法代发
[^12]:Substitute Algorithm,替换算法