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




CREATE DATABASE dc_member ENGINE = MySQL('172.17.186.106:3306', 'dc_member', 'dbadm', 'dbadmin123$')




SELECT EmployeeCode,
sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
groupArray(BIN_SaleRecordID) as ids,
groupArray(SaleType) as saleTypes,
count(1) AS orderQty
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2021-12-01' AND '2021-12-29'
-- AND BIN_OrganizationID = #{orgId}
-- AND EmployeeCode IN
AND MemberCode IN ('13148278382')
GROUP BY EmployeeCode;



SELECT BIN_SaleRecordID,
       groupArray(UnitCode) as uniCodes,
       groupArray(AmountPortionFinancial) as paies,
       sumKahan(AmountPortionFinancial) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    FROM BIN_SaleRecord_all t
        PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-01-31' --AND EmployeeCode = ( 'CH032002' )
)
    AND UnitCode in ('2010451') GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC limit 0,10;


SELECT BIN_SaleRecordID,
       groupArray(UnitCode) as uniCodes,
       groupArray(AmountPortionFinancial) as paies,
       sumKahan(AmountPortionFinancial) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
'68438587'
)
    AND UnitCode in ('2010451') GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC limit 0,10;


 SELECT
sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) as totalAmount
 FROM BIN_SaleRecord_all
 PREWHERE SaleDate = '2022-01-21' group by SaleDate;

select * from system.metrics where metric like '%Connection%';


SELECT EmployeeCode,
sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
groupArray(BIN_SaleRecordID) as ids,
groupArray(SaleType) as saleTypes,
count(1) AS orderQty
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-21' AND '2022-01-21'
GROUP BY EmployeeCode ;

--- 查看系统进程----
select * from system.processes;

SELECT
    query_id,
    read_rows,
    total_rows_approx,
    memory_usage,
    initial_user,
    initial_address,
    elapsed,
    query,
    client_hostname
FROM system.processes;

SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-28' AND '2022-01-28'
 -- AND BIN_SaleRecord_all.BIN_OrganizationID IN  (    '13183'  )
    )
 AND UnitCode in  (    '2008613'  ,   '2003654'  ,   '2016877'  ,   '2017008'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;


select count(1) FROM BIN_SaleRecordDetail_all prewhere CreateTime between '2021-12-01 00:00:00' and '2022-01-01 00:00:00';

select count(1) FROM BIN_SaleRecord_all prewhere CreateTime between '2021-12-01 00:00:00' and '2022-01-01 00:00:00';


select count(1) FROM BIN_SaleRecordDetail_all prewhere CreateTime between '2021-11-01 00:00:00' and '2021-12-01 00:00:00';

select * FROM BIN_SaleRecord_all prewhere SaleDate = '2022-02-09' and EmployeeCode = 'CH021506';

SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-28' AND '2022-01-28'
 -- AND BIN_SaleRecord_all.BIN_OrganizationID IN  (    '13183'  )
    )
 AND UnitCode in  (    '2008613'  ,   '2003654'  ,   '2016877'  ,   '2017008'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;


select BIN_OrganizationID,
       sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then 0 else 1 end) as orderNums
from BIN_SaleRecord_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID from BIN_SaleRecordDetail_all where BarCode in ('6959436314745'))
and SaleDate BETWEEN '2021-02-01' AND '2022-02-01'
group by BIN_OrganizationID order by amount desc
limit 10;


select BIN_OrganizationID,
       sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount
from BIN_SaleRecord_all PREWHERE SaleDate BETWEEN '2021-02-01' AND '2022-02-01'
                                     --and BIN_OrganizationID in ('13396')
group by BIN_OrganizationID;



SELECT
EmployeeCode as baCode,
sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end)  as achievements
FROM BIN_SaleRecord_all
PREWHERE  BIN_SaleRecordID in ( SELECT BIN_SaleRecordID from BIN_SaleRecordDetail_all where
                                BarCode in ('6959436321385','6959436321439','6959436321446','6959436321460','6959436316121','6959436321996','6959436322085'))
and SaleType IN ('NS','SR') AND SaleDate BETWEEN '2021-02-01' AND '2022-02-15'
GROUP BY EmployeeCode;


SELECT BIN_SaleRecordID,
 groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all d PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all s PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2021-02-01' AND '2022-02-15')
 AND BarCode in  ('6959436321385','6959436321439','6959436321446','6959436321460','6959436316121','6959436321996','6959436322085')    GROUP BY BIN_SaleRecordID ORDER BY totalPrice DESC
FORMAT TabSeparatedWithNamesAndTypes;


SELECT
groupArray(BIN_SaleRecordID) as ids ,EmployeeCode,
groupArray(SaleType) as saleTypes
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-02-01' AND '2022-02-15'
group by EmployeeCode;




SELECT
    EmployeeCode as bacode,
    groupArray(BIN_SaleRecordID) as ids ,
--     groupArray(SaleType) as saleTypes,
--     groupArray(BIN_OrganizationID) as orgIds,
--     groupArray(BillCode) as bills,
--     groupArray(BillCodePre) as billpres,
--     groupArray(Quantity) as qts,
--    groupArray(MemberCode) as memcodes,
    sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end)  as totalAmount,
    sumKahan(case when SaleType = 'SR' then 0 else 1 end) as orderNums
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-02-01' AND '2022-02-15'
group by EmployeeCode;

SELECT
        EmployeeCode as bacode,
        groupArray(BIN_SaleRecordID) as ids ,
        groupArray(SaleType) as saleTypes,
        groupArray(BIN_OrganizationID) as orgIds,
        groupArray(BillCode) as bills,
        groupArray(BillCodePre) as billpres,
        groupArray(Quantity) as qts,
        groupArray(MemberCode) as memcodes,
        sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end)  as totalAmount,
        sumKahan(case when SaleType = 'SR' then 0 else 1 end) as orderNums
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-02-01' AND '2022-02-15' and EmployeeCode = 'CHZ091932'
group by EmployeeCode;


SELECT
count(1)
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-15' AND '2022-02-15';


SELECT
--UnitCode,
       BIN_SaleRecordID,
 groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all d PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all s PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-02-17' AND '2022-02-17')
 AND BarCode in  ('6959436321385','6959436321439','6959436321446','6959436321460','6959436316121','6959436321996','6959436322085')
GROUP BY BIN_SaleRecordID
ORDER BY totalPrice DESC
FORMAT TabSeparatedWithNamesAndTypes;


---- buos接口1-------
SELECT
    EmployeeCode as bacode,
    groupArray(BIN_SaleRecordID) as ids ,
    sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end)  as totalAmount,
    sumKahan(case when SaleType = 'SR' then 0 else 1 end) as orderNums
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-02-01' AND '2022-02-15'
             --and OriginalDataSource =
group by EmployeeCode;
---- buos接口2-------
SELECT
--UnitCode,
 BIN_SaleRecordID,
 groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
 sumKahan(AmountPortion) as totalAmount--,
--     sumKahan(case when BarCode = '6959436321385' then AmountPortion else 0 end)  as p1,
--     sumKahan(case when BarCode = '6959436321439' then AmountPortion else 0 end)  as p2,
--     sumKahan(case when BarCode = '6959436321446' then AmountPortion else 0 end)  as p3,
--     sumKahan(case when BarCode = '6959436321460' then AmountPortion else 0 end)  as p4,
--     sumKahan(case when BarCode = '6959436316121' then AmountPortion else 0 end)  as p5,
--     sumKahan(case when BarCode = '6959436321996' then AmountPortion else 0 end)  as p6,
--     sumKahan(case when BarCode = '6959436322085' then AmountPortion else 0 end)  as p7
FROM BIN_SaleRecordDetail_all d PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all s PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2021-02-01' AND '2022-02-15')
 AND BarCode in  ('6959436321385','6959436321439','6959436321446','6959436321460','6959436316121','6959436321996','6959436322085')
GROUP BY BIN_SaleRecordID
-- ORDER BY totalPrice DESC
FORMAT TabSeparatedWithNamesAndTypes;

SELECT sum(number) FROM numbers(10);

SELECT
groupArray(BIN_SaleRecordID) as ids ,EmployeeCode as baCode,
       groupArray(SaleType) as saleTypes
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-02-17' AND '2022-02-17'
group by EmployeeCode;



select distinct(MemberCode) from BIN_SaleRecord_all prewhere BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    FROM BIN_SaleRecordDetail_all d PREWHERE BIN_SaleRecordID in (
            SELECT BIN_SaleRecordID
            FROM BIN_SaleRecord_all s PREWHERE SaleType IN ('NS', 'SR')
                                                  -- AND SaleDate BETWEEN '2019-01-01' AND '2022-02-15'
             AND  SaleTime BETWEEN '2022-02-01 09:00:00' AND '2022-02-15 10:00:00'
        )AND UnitCode in ('2000387',
                         '2000388',
                         '2000389',
                         '2000390',
                         '2000391',
                         '2000392',
                         '2000393',
                         '2000394',
                         '2009500',
                         '2010113',
                         '2010700',
                         '2016803',
                         '2017636',
                         '2017638',
                         '2017641',
                         '2017643',
                         '2017645',
                         '2024010',
                         '2024012',
                         '2024124',
                         '2024184',
                         '2024027')
    GROUP BY BIN_SaleRecordID
);


-------宝哥接口--------
---1.上---
SELECT
       UnitCode,
       sumKahan(AmountPortion) as totalAmount,
       count(1) as totalQty
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    FROM BIN_SaleRecord_all t
        PREWHERE SaleType IN ('NS') AND SaleDate BETWEEN '2022-01-01' AND '2022-01-31'
)
 GROUP BY UnitCode ORDER BY totalAmount DESC;
---1.下---
SELECT
       UnitCode,
       sumKahan(AmountPortion) as totalAmount,
       count(1) as totalQty
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    FROM BIN_SaleRecord_all t
        PREWHERE SaleType IN ('SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-01-31'
)
 GROUP BY UnitCode ORDER BY totalAmount DESC;

---2---
---上---
SELECT
       UnitCode
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    FROM BIN_SaleRecord_all t
        PREWHERE SaleType IN ('NS') AND SaleDate BETWEEN '2022-01-01' AND '2022-01-01'
) --and not multiMatchAny(UnitCode, 'TZZK')
 GROUP BY UnitCode;

----中---
SELECT
       BIN_SaleRecordID,
       sumKahan(AmountPortion) as totalAmount,
       count(1) as totalQty
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    FROM BIN_SaleRecord_all t
        PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-01-01'
)
AND UnitCode in  ('2024077')
 GROUP BY BIN_SaleRecordID;

---下 排除扣款---
SELECT BIN_OrganizationID,
       groupArray(BIN_SaleRecordID),
       groupArray(SaleType),
       count(1) as totalQty
    FROM BIN_SaleRecord_all t
        PREWHERE BIN_SaleRecordID in (
        SELECT BIN_SaleRecordID
        FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
            SELECT BIN_SaleRecordID
            FROM BIN_SaleRecord_all t
                PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-01-01'
        ) AND UnitCode in ('2024077')
        GROUP BY BIN_SaleRecordID
    ) group by BIN_OrganizationID;


----运维-----
select * from system.processes



SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-01' AND '2022-03-07'
 AND EmployeeCode IN  (    'CH007740'  )      )
 AND UnitCode in  (    '2000387'  ,   '2000388'  ,   '2000389'  ,   '2000390'  ,   '2000391'  ,   '2000392'  ,   '2000393'  ,   '2000394'  ,   '2009500'  ,   '2010113'  ,   '2010700'  ,   '2016803'  ,   '2017636'  ,   '2017638'  ,   '2017641'  ,   '2017643'  ,   '2017645'  ,   '2024010'  ,   '2024012'  ,   '2024124'  ,   '2024184'  ,   '2024027'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;



SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-09' AND '2022-03-09'
    )
 AND UnitCode in  (    '2010700'  ,   '2010113'  ,   '2009500'  ,   '2024027'  ,   '2024012'  ,   '2024010'  ,   '2024124'  ,   '2024184'  ,   '2017645'  ,   '2017643'  ,   '2017641'  ,   '2017638'  ,   '2017636'  ,   '2000394'  ,   '2000392'  ,   '2000393'  ,   '2000390'  ,   '2000391'  ,   '2000388'  ,   '2000389'  ,   '2000387'  ,   '2016803'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;


SELECT EmployeeCode,
sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
groupArray(BIN_SaleRecordID) as ids,
groupArray(SaleType) as saleTypes,
count(1) AS orderQty
FROM BIN_SaleRecord_all
 PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-11' AND '2022-03-11'
 AND EmployeeCode IN  (    'CHZ108642'  )   GROUP BY EmployeeCode
FORMAT TabSeparatedWithNamesAndTypes;

-------hot-----------------

SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-11' AND '2022-03-11'
    )
 AND UnitCode in  (    '2010700'  ,   '2010113'  ,   '2009500'  ,   '2024027'  ,   '2024012'  ,   '2024010'  ,   '2024124'  ,   '2024184'  ,   '2017645'  ,   '2017643'  ,   '2017641'  ,   '2017638'  ,   '2017636'  ,   '2000394'  ,   '2000392'  ,   '2000393'  ,   '2000390'  ,   '2000391'  ,   '2000388'  ,   '2000389'  ,   '2000387'  ,   '2016803'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;

---getReportData
SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-11' AND '2022-03-11'
 AND EmployeeCode IN  (    'CHZ102750'  )      )
 AND UnitCode in  (    '2010700'  ,   '2010113'  ,   '2009500'  ,   '2024027'  ,   '2024012'  ,   '2024010'  ,   '2024124'  ,   '2024184'  ,   '2017645'  ,   '2017643'  ,   '2017641'  ,   '2017638'  ,   '2017636'  ,   '2000394'  ,   '2000392'  ,   '2000393'  ,   '2000390'  ,   '2000391'  ,   '2000388'  ,   '2000389'  ,   '2000387'  ,   '2016803'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;

SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-11' AND '2022-03-11'
    )
 AND UnitCode in  (    '2010700'  ,   '2010113'  ,   '2009500'  ,   '2024027'  ,   '2024012'  ,   '2024010'  ,   '2024124'  ,   '2024184'  ,   '2017645'  ,   '2017643'  ,   '2017641'  ,   '2017638'  ,   '2017636'  ,   '2000394'  ,   '2000392'  ,   '2000393'  ,   '2000390'  ,   '2000391'  ,   '2000388'  ,   '2000389'  ,   '2000387'  ,   '2016803'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;

---getReportData
SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-01' AND '2022-03-11'
 AND EmployeeCode IN  (    'CHZ095006'  )      )
 AND UnitCode in  (    '2010700'  ,   '2010113'  ,   '2009500'  ,   '2024027'  ,   '2024012'  ,   '2024010'  ,   '2024124'  ,   '2024184'  ,   '2017645'  ,   '2017643'  ,   '2017641'  ,   '2017638'  ,   '2017636'  ,   '2000394'  ,   '2000392'  ,   '2000393'  ,   '2000390'  ,   '2000391'  ,   '2000388'  ,   '2000389'  ,   '2000387'  ,   '2016803'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;

SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-11' AND '2022-03-11'
    )
 AND UnitCode in  (    '2010700'  ,   '2010113'  ,   '2009500'  ,   '2024027'  ,   '2024012'  ,   '2024010'  ,   '2024124'  ,   '2024184'  ,   '2017645'  ,   '2017643'  ,   '2017641'  ,   '2017638'  ,   '2017636'  ,   '2000394'  ,   '2000392'  ,   '2000393'  ,   '2000390'  ,   '2000391'  ,   '2000388'  ,   '2000389'  ,   '2000387'  ,   '2016803'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;

---getReportData
SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in ( SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-01' AND '2022-03-11'
 AND EmployeeCode IN  (    'CH024146'  )      )
 AND UnitCode in  (    '2010700'  ,   '2010113'  ,   '2009500'  ,   '2024027'  ,   '2024012'  ,   '2024010'  ,   '2024124'  ,   '2024184'  ,   '2017645'  ,   '2017643'  ,   '2017641'  ,   '2017638'  ,   '2017636'  ,   '2000394'  ,   '2000392'  ,   '2000393'  ,   '2000390'  ,   '2000391'  ,   '2000388'  ,   '2000389'  ,   '2000387'  ,   '2016803'  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;

--- 查看系统进程----
select query,address from system.processes;

--- 退货------
SELECT UnitCode,
       sumKahan(Quantity) as totalQty,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (SELECT BIN_SaleRecordID
                                                            FROM BIN_SaleRecord_all PREWHERE SaleType IN ('SR') AND SaleDate BETWEEN '2022-03-01' AND '2022-03-31'
)GROUP BY UnitCode;


--- 盈利------
SELECT UnitCode,
       sumKahan(Quantity) as totalQty,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (SELECT BIN_SaleRecordID
                                                            FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS') AND SaleDate BETWEEN '2022-03-01' AND '2022-03-01'
                                                                                                 and Channel in ('PKWechatApplet','Pekonws')
)GROUP BY UnitCode;



-----

SELECT  UnitCode uniCode,
count(*) as qty
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-28' AND '2022-01-28'
    )
GROUP BY UnitCode
FORMAT TabSeparatedWithNamesAndTypes;

CREATE USER bgt_r HOST LIKE '47.93.97.194'  IDENTIFIED WITH sha256_password BY 'bgt_r#123456';

show users;



------改版------
SELECT EmployeeCode,
sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
groupArray(BIN_SaleRecordID) as ids,
groupArray(SaleType) as saleTypes,
groupArray(MemberCode) as memberCodes,
count(1) AS orderQty
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-28' AND '2022-01-28'
--AND BIN_OrganizationID = #{orgId}
AND EmployeeCode IN ('CH037033')
GROUP BY EmployeeCode;



SELECT
EmployeeCode as baCode,
sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end)  as achievements
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-28' AND '2022-01-28'
GROUP BY EmployeeCode;


SELECT
    count(distinct(EmployeeCode)) as totalNum
FROM BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-04-01' AND '2022-04-30';


SELECT BIN_SaleRecordID as id,
                    sum(AmountPortion) AS amount,
                    sum(Quantity ) as orderQty
                  FROM BIN_SaleRecordDetail_all
                  WHERE BIN_SaleRecordID IN (
                           SELECT BIN_SaleRecordID from BIN_SaleRecord_all
                           PREWHERE SaleDate BETWEEN '2022-05-06' AND '2022-05-06'
                            )
                    AND UnitCode IN  ('2008529','2009551','2010296','2024855','2024717','2024720')
                    GROUP BY BIN_SaleRecordID;






SELECT BIN_SaleRecordID from BIN_SaleRecord_all
PREWHERE SaleDate BETWEEN '2022-06-01' AND '2022-06-01' and EmployeeCode = 'CHZ087585';


SELECT BIN_SaleRecordID from BIN_SaleRecord_all PREWHERE SaleDate BETWEEN '2022-06-01' AND '2022-06-01' and EmployeeCode = 'CHZ087585';

SELECT * FROM BIN_SaleRecordDetail_all WHERE BIN_SaleRecordID IN (
                           SELECT BIN_SaleRecordID from BIN_SaleRecord_all PREWHERE SaleDate BETWEEN '2022-06-01' AND '2022-06-01' and EmployeeCode = 'CHZ087585'
                            );



SELECT BIN_OrganizationID as orgid, sum(Amount)  AS xiaozhi, null as all from BIN_SaleRecord_all
PREWHERE SaleDate BETWEEN '2021-01-01' AND '2021-12-31' and Channel in ('PKWechatApplet','Pekonws') group by BIN_OrganizationID

union all

SELECT BIN_OrganizationID as orgid, null as xiaozhi ,sum(Amount) as all  from BIN_SaleRecord_all
PREWHERE SaleDate BETWEEN '2021-01-01' AND '2021-12-31'  group by BIN_OrganizationID;




SELECT BIN_OrganizationID as orgid ,sum(Amount) as all, count(1) as qty  from BIN_SaleRecord_all
PREWHERE SaleDate BETWEEN '2021-01-01' AND '2021-12-31'  group by BIN_OrganizationID order by all desc;


SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-06-16' AND '2022-06-16'
    )
 AND UnitCode in  (    '2025246'  ,   '2024720'  ,   '2010296'  ,   '2009551' ,'2024855' )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;



SELECT sum(Amount) as amount, count(1) as qty, amount/qty as per  from BIN_SaleRecord_all
PREWHERE SaleDate BETWEEN '2022-01-01' AND '2022-12-31';



SELECT BarCode,AmountPortion,Quantity,BIN_SaleRecordID
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('18518642112','15812044547')
    )  and AmountPortion > 0 ORDER BY BIN_SaleRecordID DESC;




SELECT EmployeeCode,
       arrayElement(groupArray(BIN_OrganizationID),-1) as orgId,
       sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderQty,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderNums
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-08-01' AND '2022-08-31' and EmployeeCode = 'CH027866'
group by EmployeeCode,BIN_OrganizationID;


SELECT *
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-08-01' AND '2022-08-31' and MemberCode = '15869282829';


----8月24----
SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-01' AND '2022-03-07'
 AND EmployeeCode IN  ('CH007740'))
 AND UnitCode in  (    '2000387'  ,   '2000388'  ,   '2000389'  ,   '2000390'  ,   '2000391'  ,   '2000392'  ,   '2000393'  ,   '2000394'  ,   '2009500'  ,   '2010113'  ,   '2010700'  ,   '2016803'  ,   '2017636'  ,   '2017638'  ,   '2017641'  ,   '2017643'  ,   '2017645'  ,   '2024010'  ,   '2024012'  ,   '2024124'  ,   '2024184'  ,   '2024027'  )
GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;


SELECT BIN_SaleRecordID,UnitCode,AmountPortion,Quantity
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-03-01' AND '2022-03-07'
 AND EmployeeCode IN  ('CH007740'))
 AND UnitCode in  (    '2000387'  ,   '2000388'  ,   '2000389'  ,   '2000390'  ,   '2000391'  ,   '2000392'  ,   '2000393'  ,   '2000394'  ,   '2009500'  ,   '2010113'  ,   '2010700'  ,   '2016803'  ,   '2017636'  ,   '2017638'  ,   '2017641'  ,   '2017643'  ,   '2017645'  ,   '2024010'  ,   '2024012'  ,   '2024124'  ,   '2024184'  ,   '2024027'  )
 ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;


SELECT count(1)
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS', 'SR') AND SaleDate BETWEEN '2022-07-01' AND '2022-08-01'
)
FORMAT TabSeparatedWithNamesAndTypes;


SELECT count(1)
FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS', 'SR') AND SaleDate BETWEEN '2022-07-01' AND '2022-08-01'
FORMAT TabSeparatedWithNamesAndTypes;


SELECT BIN_SaleRecordID, groupArray(UnitCode) as uniCodes,
 groupArray(AmountPortion) as amountItems,
groupArray(Quantity) as qtyItems,
sumKahan(AmountPortion) as totalPrice
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-09-01' AND '2022-09-01' and BIN_SaleRecord_all.EmployeeCode = 'CH027150'
    )
 AND UnitCode in  (
    '2025052',
	'2025753',
	'2025050',
	'2025053',
	'2025054',
	'2025055',
	'2025357',
	'2025049'
                  )    GROUP BY BIN_SaleRecordID ORDER BY BIN_SaleRecordID DESC
FORMAT TabSeparatedWithNamesAndTypes;





SELECT sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount  from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-09-01' AND '2022-09-31' and Channel in ('PKWechatApplet','Pekonws')
and BIN_OrganizationID = '13876';

SELECT sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount  from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-09-01' AND '2022-09-31'
             -- and Channel in ('PKWechatApplet','Pekonws')
and BIN_OrganizationID = '13876';



SELECT sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount  from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-09-14' AND '2022-09-14' and EmployeeCode in ('CHZ111217') ;

SELECT * from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-09-14' AND '2022-09-14' and EmployeeCode in ('CHZ111217') ;



SELECT BarCode,AmountPortion,Quantity
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('18518642112')
    )  and AmountPortion > 0 ORDER BY BIN_SaleRecordID DESC
union all
SELECT BarCode,AmountPortion,Quantity
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('15812044547')
    )  and AmountPortion > 0 ORDER BY BIN_SaleRecordID DESC;

SELECT srd.BarCode,srd.AmountPortion,srd.Quantity,sr.MemberCode
FROM BIN_SaleRecordDetail_all srd left join BIN_SaleRecord_all sr on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
where sr.SaleType IN ('NS','SR') AND sr.SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and sr.MemberCode in ('15812044547');


SELECT BarCode,AmountPortion,Quantity,MemberCode
FROM BIN_SaleRecordDetail_all srd ANY left join (
    SELECT BIN_SaleRecordID,MemberCode FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('15812044547')
    )  sr on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID;


with(
    SELECT BIN_SaleRecordID,MemberCode FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('15812044547')
    ) as temp
SELECT BarCode,AmountPortion,Quantity,temp.MemberCode
FROM BIN_SaleRecordDetail_all where temp.BIN_SaleRecordID = BIN_SaleRecordID;


----step1------
SELECT MemberCode,BIN_SaleRecordID as id FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('18518642112')
order by BIN_SaleRecordID;

----step2------
SELECT BIN_SaleRecordID,
       groupArray(BarCode) as barcodes,groupArray(AmountPortion) as amount ,groupArray(Quantity) as qtys
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('15812044547','18518642112')
    )  and AmountPortion > 0 group by BIN_SaleRecordID ;


SELECT groupArray(BIN_SaleRecordID) as ids ,UnitCode, groupArray(AmountPortion) as amount,groupArray(Quantity) as qty
FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID global in (
    SELECT BIN_SaleRecordID FROM BIN_SaleRecord_all PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-07-30' and MemberCode in ('15101221121')
    )  and AmountPortion > 0 group by UnitCode order by arrayElement(groupArray(BIN_SaleRecordID),1) desc;
--ORDER BY BIN_SaleRecordID DESC;



SELECT BIN_OrganizationID,sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount  from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-07-25' AND '2022-07-31' and Channel in ('PKWechatApplet','Pekonws')
and BIN_OrganizationID in (
'3380',
'4209',
'4588',
'4663',
'5304',
'5578',
'5929',
'6414',
'6492',
'8168',
'8785',
'8869',
'8976',
'8990',
'9465',
'9706',
'9789',
'9792',
'10392',
'10396',
'10663',
'11829',
'11834',
'12021',
'12377',
'12429',
'12518',
'12561',
'12832',
'12842',
'13077',
'13292',
'13505',
'13611',
'13903',
'14531',
'14682',
'14687',
'14958',
'14990',
'15016',
'15026',
'15027',
'15058',
'15063',
'15099',
'15134',
'15207',
'15214',
'15224',
'15288',
'15329',
'15347',
'15371',
'15460',
'15486',
'15487')group by BIN_OrganizationID order by BIN_OrganizationID;


SELECT BIN_OrganizationID,sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount  from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-08-08' AND '2022-08-14'
             --and Channel in ('PKWechatApplet','Pekonws')
and BIN_OrganizationID in (
'803',
'3380',
'4209',
'4588',
'4663',
'5304',
'5578',
'5929',
'6414',
'6492',
'7214',
'8168',
'8785',
'8869',
'8976',
'8990',
'9465',
'9470',
'9647',
'9706',
'9789',
'9792',
'10392',
'10663',
'10850',
'11829',
'11834',
'12021',
'12377',
'12429',
'12518',
'12561',
'12832',
'12842',
'13077',
'13292',
'13505',
'13611',
'13827',
'13833',
'13903',
'14028',
'14431',
'14531',
'14545',
'14611',
'14682',
'14687',
'14958',
'14990',
'15016',
'15026',
'15027',
'15058',
'15059',
'15063',
'15099',
'15113',
'15118',
'15134',
'15207',
'15214',
'15224',
'15278',
'15288',
'15315',
'15329',
'15347',
'15371',
'15460',
'15486',
'15487') group by BIN_OrganizationID order by BIN_OrganizationID;


SELECT BIN_OrganizationID,sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount  from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-08-01' AND '2022-08-07' and Channel in ('PKWechatApplet','Pekonws')
and BIN_OrganizationID in (
'14611') group by BIN_OrganizationID order by BIN_OrganizationID;


SELECT  UnitCode, sum(Quantity) as orderQty
                  FROM BIN_SaleRecordDetail_all
                  WHERE BIN_SaleRecordID IN (
                           SELECT BIN_SaleRecordID from BIN_SaleRecord_all
                           PREWHERE SaleDate BETWEEN '2022-07-14' AND '2022-07-31'
                            )
                    AND UnitCode IN  ('2011046','2011047','2024171','2024009','2024013') and AmountPortion = 0 group by UnitCode;


SELECT BIN_EmployeeID,indexOf(groupArray(BIN_OrganizationID),0),sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,count(1) as orderQty
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-07-25' AND '2022-07-31' and Channel in ('PKWechatApplet','Pekonws')
group by BIN_EmployeeID;


SELECT groupArray(MemberCode),sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,count(1) as orderQty
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-07-25' AND '2022-07-31' and Channel in ('PKWechatApplet','Pekonws')
group by BIN_OrganizationID;


----倩倩报表-----

SELECT EmployeeCode,
       arrayElement(groupArray(BIN_OrganizationID),-1) as orgId,
       sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderQty,
       sumKahan(case when SaleType = 'SR' then (0) else 1 end) as orderNums
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-01-01' AND '2022-08-31' and Channel in ('PKWechatApplet','Pekonws') and EmployeeCode = 'CHZ112662'
group by EmployeeCode;



SELECT EmployeeCode,
       arrayElement(groupArray(BIN_OrganizationID),-1) as orgId,
       sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderQty,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderNums
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-08-01' AND '2022-08-31'  and EmployeeCode = 'ZW6116' and BIN_OrganizationID = 10011
group by EmployeeCode;

--------- xin -----------
SELECT EmployeeCode,
       arrayElement(groupArray(BIN_OrganizationID),-1) as orgId,
       sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderQty,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderNums
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-08-01' AND '2022-08-31' and EmployeeCode = 'ZW6116'
group by EmployeeCode,BIN_OrganizationID;

SELECT EmployeeCode,
       arrayElement(groupArray(BIN_OrganizationID),-1) as orgId,
       sumKahan(case when SaleType = 'SR' then (-1)*Amount else Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderQty,
       sumKahan(case when SaleType = 'SR' then (-1) else 1 end) as orderNums
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-08-01' AND '2022-08-31' and Channel in ('PKWechatApplet','Pekonws') and EmployeeCode = 'ZW6116'
group by EmployeeCode,BIN_OrganizationID;


SELECT EmployeeCode,
        BIN_OrganizationID,Amount,Channel,SaleType,SaleDate
from BIN_SaleRecord_all
PREWHERE SaleType IN ('NS','SR') AND SaleDate BETWEEN '2022-07-30' AND '2022-08-31'
             --and Channel in ('PKWechatApplet','Pekonws')
             and EmployeeCode = 'ZW6116' and BIN_OrganizationID = 10011;



SELECT s.EmployeeCode,
        s.BIN_OrganizationID,s.Amount,s.Channel,s.SaleType,s.SaleDate
from BIN_SaleRecord_all s left join BIN_SaleRecordDetail_all d on s.BIN_SaleRecordID = d.BIN_SaleRecordID
WHERE s.SaleType IN ('NS','SR') AND s.SaleDate BETWEEN '2022-08-01' AND '2022-08-31' and d.BarCode in ('6959436301394');
             --and Channel in ('PKWechatApplet','Pekonws')
             --and EmployeeCode = 'ZW6116' and BIN_OrganizationID = 10011;


SELECT s.EmployeeCode,d.BarCode,
       sumKahan(case when SaleType = 'SR' then (-1)*s.Amount else s.Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1)*d.Quantity else d.Quantity end) AS orderQty
from BIN_SaleRecord_all s left join BIN_SaleRecordDetail_all d on s.BIN_SaleRecordID = d.BIN_SaleRecordID
WHERE s.SaleType IN ('NS','SR') AND s.SaleDate BETWEEN '2022-01-01' AND '2022-09-31' and d.BarCode in ('6959436323877')
group by s.EmployeeCode,d.BarCode;


SELECT s.BIN_OrganizationID,d.BarCode,
       sumKahan(case when SaleType = 'SR' then (-1)*s.Amount else s.Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1)*d.Quantity else d.Quantity end) AS orderQty
from BIN_SaleRecord_all s left join BIN_SaleRecordDetail_all d on s.BIN_SaleRecordID = d.BIN_SaleRecordID
WHERE s.SaleType IN ('NS','SR') AND s.SaleDate BETWEEN '2022-01-01' AND '2022-09-31' and d.BarCode in ('6959436323877')
group by s.BIN_OrganizationID,d.BarCode;


SELECT record.BIN_OrganizationID,
       recorddetail.BarCode,
       sumKahan(case when SaleType = 'SR' then (-1) * record.Amount else record.Amount end) AS amount,
       sumKahan(case when SaleType = 'SR' then (-1) * recorddetail.Quantity else recorddetail.Quantity end) AS orderQty
from BIN_SaleRecord_all record
         inner join BIN_SaleRecordDetail_all recorddetail on record.BIN_SaleRecordID = recorddetail.BIN_SaleRecordID
WHERE record.SaleType IN ('NS', 'SR')
  AND record.SaleDate BETWEEN '2022-01-01' AND '2022-09-31'
  and recorddetail.BarCode in ('6959436323877')
group by record.BIN_OrganizationID, recorddetail.BarCode;


SELECT record.EmployeeCode,
       recorddetail.BarCode,
       record.BIN_OrganizationID,
       sumKahan(case when SaleType = 'SR' then (-1) * record.Amount else record.Amount end)  AS amount,
       sumKahan(case when SaleType = 'SR' then (-1) * recorddetail.Quantity else recorddetail.Quantity end) AS orderQty
from BIN_SaleRecord_all record
         inner join
     (SELECT BIN_SaleRecordID, Quantity, AmountPortion, BarCode
      FROM BIN_SaleRecordDetail_all PREWHERE BarCode in ('6959436323877') ) as recorddetail
     on record.BIN_SaleRecordID = recorddetail.BIN_SaleRecordID
    prewhere record.SaleType IN ('NS', 'SR') AND record.SaleDate BETWEEN '2022-01-01' AND '2022-09-31'
    -- and record.Channel in ('PKWechatApplet', 'Pekonws')
group by record.BIN_OrganizationID,record.EmployeeCode, recorddetail.BarCode;
--ORDER BY BIN_SaleRecordID DESC;


SELECT
       record.EmployeeCode,
       record.BIN_OrganizationID,
       sumKahan(case when SaleType = 'SR' then (-1) * record.Amount else record.Amount end)  AS amount
from BIN_SaleRecord_all record
    prewhere record.SaleType IN ('NS', 'SR') AND record.SaleDate BETWEEN '2022-09-01' AND '2022-09-06'
    -- and BIN_OrganizationID = 15113
                 and EmployeeCode in ('CH030922')
    -- and record.Channel in ('PKWechatApplet', 'Pekonws') -- ZW017138
group by record.BIN_OrganizationID
       ,record.EmployeeCode;

SELECT sumKahan(case when SaleType = 'SR' then (-1) * record.Amount else record.Amount end)  AS amount
from BIN_SaleRecord_all record
    prewhere record.SaleType IN ('NS', 'SR') AND record.SaleDate BETWEEN '2022-09-01' AND '2022-09-06'
    and BIN_OrganizationID = 15113;



SELECT BIN_SaleRecordID,MainCode,InActivity,BarCode,Quantity,AmountPortion,GiftFlag
from BIN_SaleRecordDetail_all
prewhere BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    from BIN_SaleRecordDetail_all
        prewhere MainCode = 'MC2208290000005'
    group by BIN_SaleRecordID
);



SELECT top 1000 BIN_SaleRecordID,MainCode,InActivity,BarCode,Quantity,AmountPortion,GiftFlag
from BIN_SaleRecordDetail_all
prewhere BIN_SaleRecordID in (
    SELECT BIN_SaleRecordID
    from BIN_SaleRecordDetail_all
        prewhere MainCode  is not null
    group by BIN_SaleRecordID order by BIN_SaleRecordID desc
);


SELECT -- BIN_SaleRecordID,MainCode,InActivity,BarCode,Quantity,AmountPortion,GiftFlag
       MainCode,BarCode,sumKahan(Quantity) as qty, sumKahan(AmountPortion) amount
from BIN_SaleRecordDetail_all srd
         inner join
     (SELECT BIN_SaleRecordID
      FROM BIN_SaleRecord_all PREWHERE SaleDate BETWEEN '2022-08-01' AND '2022-09-31' ) as sr
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    prewhere MainCode = 'MC2208290000005'
group by MainCode,BarCode;


SELECT
       arrayElement(groupArray(InActivity),-1) as activityName,
       MainCode,
       BarCode,
       GiftFlag,
       -- type,
       sumKahan(case when sr.SaleType = 'SR' then (-1) * AmountPortion else AmountPortion end)  AS amount,
       sumKahan(case when sr.SaleType = 'SR' then (-1) * Quantity else Quantity end)  AS qty
from BIN_SaleRecordDetail_all srd
         inner join
     (SELECT BIN_SaleRecordID,SaleType
      FROM BIN_SaleRecord_all PREWHERE SaleDate BETWEEN '2022-09-01' AND '2022-09-31' ) as sr
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    prewhere MainCode is not null
group by MainCode,BarCode,GiftFlag order by MainCode;


SELECT
       arrayElement(groupArray(InActivity),-1) as activityName,
       MainCode
from BIN_SaleRecordDetail_all srd
         inner join
     (SELECT BIN_SaleRecordID
      FROM BIN_SaleRecord_all PREWHERE SaleDate BETWEEN '2022-09-01' AND '2022-09-31' ) as sr
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    prewhere MainCode is not null
group by MainCode;



SELECT BIN_SaleRecordID,MainCode,InActivity,BarCode,Quantity,AmountPortion,GiftFlag
from BIN_SaleRecordDetail_all srd
        prewhere MainCode  is not null and BIN_SaleRecordID in
     (SELECT BIN_SaleRecordID
      FROM BIN_SaleRecord_all PREWHERE SaleDate BETWEEN '2022-09-01' AND '2022-09-31' );



SELECT
       MainCode,
       count(MemberCode) as mems,
       sumKahan(case when sr.SaleType = 'SR' then (-1) * sr.Amount else sr.Amount end)  AS amount,
       sumKahan(case when sr.SaleType = 'SR' then (-1) else 1 end)  AS qty
from BIN_SaleRecord_all sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022') ) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    prewhere SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
group by srd.MainCode order by MainCode;


SELECT
       MainCode,
       count(distinct BIN_MemberInfoID) as mems,
       sumKahan(Amount)  AS amount,
       sumKahan(BillCount)  AS qty
from  (SELECT * from BIN_SaleRecord_all record
        prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
            SELECT record.BillCodePre
            from BIN_SaleRecord_all record
            prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
            and record.SaleType = 'SR'
    ) and SaleType = 'NS' ) as sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022') ) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
group by srd.MainCode order by MainCode;



-- select
--        MainCode,
--        count(distinct BIN_MemberInfoID) as new_mems,
--        sumKahan(Amount)  AS new_amount,
--        sumKahan(BillCount)  AS new_qty from
--     (SELECT *from BIN_SaleRecord_all record
--         prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
--             SELECT record.BillCodePre
--             from BIN_SaleRecord_all record
--             prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
--             and record.SaleType = 'SR'
--     ) and SaleType = 'NS' ) as sr
--          inner join
--      (SELECT BIN_SaleRecordID,MainCode,GiftFlag,AmountPortion
--       FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022')) as srd
--      on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
--        inner join
--     (SELECT memberId,firstSaleDate,firstMonthAmt FROM dc_member.dp_memberinfo ) as member
--     on sr.BIN_MemberInfoID = member.memberId
--     where SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and member.firstSaleDate BETWEEN 20220901 and 20220914
-- group by srd.MainCode,GiftFlag order by MainCode;


-----type=1  begin---------
SELECT
       count(distinct BIN_MemberInfoID) as mems, -- 购买人数
       sumKahan(AmountPortion)  AS amount, --销售金额
       count(distinct BIN_SaleRecordID)  AS qty --销售单数
from  (SELECT * from BIN_SaleRecord_all record
        prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
            SELECT record.BillCodePre
            from BIN_SaleRecord_all record
            prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
            and record.SaleType = 'SR'
    ) and SaleType = 'NS' ) as sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode,GiftFlag,AmountPortion
      FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
          SELECT distinct BIN_SaleRecordID
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022'))) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14';


select
       -- count(distinct sr.BIN_SaleRecordID)  AS new_qty, -- ？新会单数
       count(distinct BIN_MemberInfoID) as new_mems, --新会人数
       sumKahan(AmountPortion)  AS new_amount -- 新会金额
from
    (SELECT * from BIN_SaleRecord_all record
        prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
            SELECT record.BillCodePre
            from BIN_SaleRecord_all record
            prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
            and record.SaleType = 'SR'
    ) and SaleType = 'NS' ) as sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode,GiftFlag,AmountPortion
      FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
          SELECT distinct BIN_SaleRecordID
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022'))) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
       inner join
    (SELECT memberId,firstSaleDate,firstMonthAmt FROM dc_member.dp_memberinfo ) as member
    on sr.BIN_MemberInfoID = member.memberId
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and member.firstSaleDate BETWEEN 20220901 and 20220914;
-- group by srd.MainCode,GiftFlag order by MainCode;
-----type=1  end-----------

-----type=2  两部合并开始-----------
WITH (
    SELECT array(toString(count(distinct BIN_MemberInfoID)),
                 toString(round(sumKahan(AmountPortion), 2)),
                 toString(count(distinct BIN_SaleRecordID))) as arrayS
    from (SELECT *
          from BIN_SaleRecord_all record
              prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
              SELECT record.BillCodePre
              from BIN_SaleRecord_all record
                  prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
                  and record.SaleType = 'SR'
          ) and SaleType = 'NS' ) as sr
             inner join
         (SELECT BIN_SaleRecordID, MainCode, GiftFlag, AmountPortion
          FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
              SELECT distinct BIN_SaleRecordID
              FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022'))) as srd
         on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
) as total

select
       -- count(distinct sr.BIN_SaleRecordID)  AS new_qty, -- ？新会单数
       arrayElement(total,1) as mems,
       arrayElement(total,2) as amount,
       arrayElement(total,3) as qty,
       count(distinct BIN_MemberInfoID) as new_mems, --新会人数
       sumKahan(AmountPortion)  AS new_amount -- 新会金额
from
    (SELECT * from BIN_SaleRecord_all record
        prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
            SELECT record.BillCodePre
            from BIN_SaleRecord_all record
            prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
            and record.SaleType = 'SR'
    ) and SaleType = 'NS' ) as sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode,GiftFlag,AmountPortion
      FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
          SELECT distinct BIN_SaleRecordID
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022'))) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
       inner join
    (SELECT memberId,firstSaleDate,firstMonthAmt FROM dc_member.dp_memberinfo ) as member
    on sr.BIN_MemberInfoID = member.memberId
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and member.firstSaleDate BETWEEN 20220901 and 20220914;

-----type=2  两部合并结束-----------


-----type=2  begin---------
SELECT
       count(distinct BIN_MemberInfoID) as mems, -- 购买人数
       sumKahan(AmountPortion)  AS amount, --销售金额
       count(distinct BIN_SaleRecordID)  AS qty --销售单数
from  (SELECT * from BIN_SaleRecord_all record
        prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
            SELECT record.BillCodePre
            from BIN_SaleRecord_all record
            prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
            and record.SaleType = 'SR'
    ) and SaleType = 'NS' ) as sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode,BarCode,AmountPortion
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000004')) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14';

select
       -- count(distinct sr.BIN_SaleRecordID)  AS new_qty, -- ？新会单数
       count(distinct BIN_MemberInfoID) as new_mems, --新会人数
       sumKahan(AmountPortion)  AS new_amount -- 新会金额
from
    (SELECT * from BIN_SaleRecord_all record
        prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
            SELECT record.BillCodePre
            from BIN_SaleRecord_all record
            prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
            and record.SaleType = 'SR'
    ) and SaleType = 'NS' ) as sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode,BarCode,AmountPortion
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000004')) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
       inner join
    (SELECT memberId,firstSaleDate,firstMonthAmt FROM dc_member.dp_memberinfo ) as member
    on sr.BIN_MemberInfoID = member.memberId
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and member.firstSaleDate BETWEEN 20220901 and 20220914;
-----type=2  end-----------



-- SELECT BIN_SaleRecordID,MainCode,BarCode,AmountPortion
--       FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000004');
--
--
-- SELECT BIN_SaleRecordID,MainCode,BarCode,AmountPortion
--       FROM BIN_SaleRecordDetail_all PREWHERE BIN_SaleRecordID in (
--           SELECT distinct BIN_SaleRecordID
--       FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000022'));


    SELECT
           count(distinct BIN_MemberInfoID) as mems,   -- 购买人数
           toDecimal32(sumKahan(AmountPortion),2) AS amount, --销售金额
           round(sumKahan(AmountPortion),2) AS amount2,
           sumKahan(AmountPortion) as amount3,
           count(distinct BIN_SaleRecordID) AS qty,  --销售单数
           array(mems,qty) as arrayT,-- 一样的类型才行
           array(toString(mems),toString(amount2),toString(qty)) as arrayS,-- 一样的类型才行
           tuple(mems,amount,qty) as tuple -- 不同的数据类型也行
    from (SELECT *
          from BIN_SaleRecord_all record
              prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-10' and BillCode not in (
              SELECT record.BillCodePre
              from BIN_SaleRecord_all record
                  prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-10'
                  and record.SaleType = 'SR'
          ) and SaleType = 'NS' ) as sr
             inner join
         (SELECT BIN_SaleRecordID, MainCode, BarCode, AmountPortion
          FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000004')) as srd
         on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-10';

-----type=2  两部合并开始-----------

WITH (
    SELECT array(toString(count(distinct BIN_MemberInfoID)),
                 toString(round(sumKahan(AmountPortion), 2)),
                 toString(count(distinct BIN_SaleRecordID))) as arrayS
    from (SELECT *
          from BIN_SaleRecord_all record
              prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-10' and BillCode not in (
              SELECT record.BillCodePre
              from BIN_SaleRecord_all record
                  prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-10'
                  and record.SaleType = 'SR'
          ) and SaleType = 'NS' ) as sr
             inner join
         (SELECT BIN_SaleRecordID, MainCode, BarCode, AmountPortion
          FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000004')) as srd
         on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-10'
)  as total
select
       arrayElement(total,1) as mems,
       arrayElement(total,2) as amount,
       arrayElement(total,3) as qty,
       count(distinct BIN_MemberInfoID) as new_mems, --新会人数
       round(sumKahan(AmountPortion),2)  AS new_amount -- 新会金额
from
    (SELECT * from BIN_SaleRecord_all record
        prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and BillCode not in (
            SELECT record.BillCodePre
            from BIN_SaleRecord_all record
            prewhere record.SaleDate BETWEEN '2022-09-01' AND '2022-09-14'
            and record.SaleType = 'SR'
    ) and SaleType = 'NS' ) as sr
         inner join
     (SELECT BIN_SaleRecordID,MainCode,BarCode,AmountPortion
      FROM BIN_SaleRecordDetail_all PREWHERE MainCode in ('MC2208290000004')) as srd
     on sr.BIN_SaleRecordID = srd.BIN_SaleRecordID
       inner join
    (SELECT memberId,firstSaleDate,firstMonthAmt FROM dc_member.dp_memberinfo ) as member
    on sr.BIN_MemberInfoID = member.memberId
    where SaleDate BETWEEN '2022-09-01' AND '2022-09-14' and member.firstSaleDate BETWEEN 20220901 and 20220914;

-----type=2  两部合并结束-----------

SELECT round(5/3, 2) AS x;