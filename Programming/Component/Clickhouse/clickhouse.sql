create table if not exists tb_user(
    uid UInt64,
    name String,
    age UInt8,
    sal Float64
) engine=TinyLog;
-- 字段类型必须，表引擎必须。

insert into tb_user values (1,'zs',18,'10000.0'),(2,'ls',28,'20000.0')

-- 特殊类型 Nested 类似对象结构体
-- Tuple scala中的的元祖
-- 简单函数支持 
    -- any
    -- anyLast
    -- min
    -- max
    -- sum
    -- sumWithOverflow
    -- groupBitAnd
    -- groupBitOr
    -- groupBitXor
    -- groupArrayArray
    -- groupUniqArrayArray
    -- sumMap
    -- minMap
    -- maxMap
-- 类型转换 toInt(8)orNull toInt(8)orZero 类似go语言的。
-- 引擎分类
    -- TinyLog 小表数据
-- engine=    stripeLog 一次插入，会在一个数据block中。


-- Test
CREATE TABLE ontime
( Year UInt16,
    Quarter UInt8,
    Month UInt8,
    DayofMonth UInt8,
    DayOfWeek UInt8,
    FlightDate Date,
    UniqueCarrier FixedString(7),
    AirlineID Int32,
    Carrier FixedString(2),
    TailNum String,
    FlightNum String,
    OriginAirportID Int32,
    OriginAirportSeqID Int32,
    OriginCityMarketID Int32,
    Origin FixedString(5),
    OriginCityName String,
    OriginState FixedString(2),
    OriginStateFips String,
    OriginStateName String,
    OriginWac Int32,
    DestAirportID Int32,
    DestAirportSeqID Int32,
    DestCityMarketID Int32,
    Dest FixedString(5),
    DestCityName String,
    DestState FixedString(2),
    DestStateFips String,
    DestStateName String,
    DestWac Int32,
    CRSDepTime Int32,
    DepTime Int32,
    DepDelay Int32,
    DepDelayMinutes Int32,
    DepDel15 Int32,
    DepartureDelayGroups String,
    DepTimeBlk String,
    TaxiOut Int32,
    WheelsOff Int32,
    WheelsOn Int32,
    TaxiIn Int32,
    CRSArrTime Int32,
    ArrTime Int32,
    ArrDelay Int32,
    ArrDelayMinutes Int32,
    ArrDel15 Int32,
    ArrivalDelayGroups Int32,
    ArrTimeBlk String,
    Cancelled UInt8,
    CancellationCode FixedString(1),
    Diverted UInt8,
    CRSElapsedTime Int32,
    ActualElapsedTime Int32,
    AirTime Int32,
    Flights Int32,
    Distance Int32,
    DistanceGroup UInt8,
    CarrierDelay Int32,
    WeatherDelay Int32,
    NASDelay Int32,
    SecurityDelay Int32,
    LateAircraftDelay Int32,
    FirstDepTime String,
    TotalAddGTime String,
    LongestAddGTime String,
    DivAirportLandings String,
    DivReachedDest String,
    DivActualElapsedTime String,
    DivArrDelay String,
    DivDistance String,
    Div1Airport String,
    Div1AirportID Int32,
    Div1AirportSeqID Int32,
    Div1WheelsOn String,
    Div1TotalGTime String,
    Div1LongestGTime String,
    Div1WheelsOff String,
    Div1TailNum String,
    Div2Airport String,
    Div2AirportID Int32,
    Div2AirportSeqID Int32,
    Div2WheelsOn String,
    Div2TotalGTime String,
    Div2LongestGTime String,
    Div2WheelsOff String,
    Div2TailNum String,
    Div3Airport String,
    Div3AirportID Int32,
    Div3AirportSeqID Int32,
    Div3WheelsOn String,
    Div3TotalGTime String,
    Div3LongestGTime String,
    Div3WheelsOff String,
    Div3TailNum String,
    Div4Airport String,
    Div4AirportID Int32,
    Div4AirportSeqID Int32,
    Div4WheelsOn String,
    Div4TotalGTime String,
    Div4LongestGTime String,
    Div4WheelsOff String,
    Div4TailNum String,
    Div5Airport String,
    Div5AirportID Int32,
    Div5AirportSeqID Int32,
    Div5WheelsOn String,
    Div5TotalGTime String,
    Div5LongestGTime String,
    Div5WheelsOff String,
    Div5TailNum String
) ENGINE = MergeTree(FlightDate, (Year, FlightDate), 8192);
CREATE TABLE ontimetest AS ontime ENGINE = Distributed(perftest_3shards_1replicas, test, ontime, rand());



CREATE TABLE Order ENGINE = ReplacingMergeTree
ORDER BY Id AS
SELECT *
FROM mysql('103.61.153.18:3306', 'dp_ordm4_t' ,'bus_order' ,'pengbo', '123456') 


CREATE TABLE FactSaleOrders ENGINE = MergeTree ORDER BY OrderID AS 
SELECT * FROM postgresql('10.42.134.136:4000', 'dbname', 'tableName', 'root', 'password');


CREATE TABLE "transactionlog" (
  "transactionlogid" UInt8,
  "machinecode" Nullable(String),
  "param" Nullable(String),
  "barcode" Nullable(String),
  "unitcode" Nullable(String),
  "txdtype" Nullable(String),
  "quantity" Nullable(Int8),
  "price" Nullable(Float64),
  "type" Nullable(String),
  "txddate" Int8,
  "txdtime" Nullable(Int8),
  "bacode" Nullable(String),
  "countercode" Nullable(String),
  "flag" Nullable(Int8),
  "puttime" Nullable(DateTime),
  "modifytime" Nullable(DateTime),
  "promotion" Nullable(String),
  "couponcode" Nullable(String),
  "confirmstate" Nullable(Int8),
  "pointvalue" Nullable(Int8),
  "bak_int" Nullable(Int8),
  "amountportion" Nullable(Float64),
  "inventorytypecode" Nullable(String),
  "itemtag" Nullable(Int8),
  "billid" Nullable(String),
  "billidpre" Nullable(String),
  "bakint1" Nullable(Int8),
  "bakint2" Nullable(Int8),
  "bakchar1" Nullable(String),
  "bakchar2" Nullable(String),
  "bakdec1" Nullable(Float64),
  "bakdec2" Nullable(Float64),
  "original_price" Nullable(Float64),
  "uniquecode" Nullable(String),
  "productid" Nullable(Int8),
  "reason_code" Nullable(String),
  "sdspqdportion" Nullable(Float64),
  "sdspjfportion" Nullable(Float64),
  "zdqdportion" Nullable(Float64),
  "zdhyportion" Nullable(Float64),
  "sccxportion" Nullable(Float64),
  "sctzportion" Nullable(Float64),
  "mainquantity" Nullable(Int8),
  "counter_ticket_code" Nullable(String),
  "itemquantity" Nullable(Float64),
  "diffqtyprice" Nullable(Float64)
)ENGINE = ReplacingMergeTree() Order By transactionlogid;