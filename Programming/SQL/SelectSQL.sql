/**
 Navicat Premium Data Transfer
*/
/**
zhuntiku 
  Question

*/
select top 400 [ID] from Question WHERE SubjectID ='01C49869-64FE-4719-8E09-1F0871435299' and Status = 1 ORDER BY CreateTime DESC;

use zhuntiku;
(SELECT Count(*)as totalNumber FROM Question WHERE 
Status = 1 
and QuestionType = 1 
and SubjectID ='01C49869-64FE-4719-8E09-1F0871435299' )
UNION ALL
(SELECT Count(*)as totalNumber FROM Question WHERE 
Status = 1 
and QuestionType = 2
and SubjectID ='01C49869-64FE-4719-8E09-1F0871435299' )
UNION All
(SELECT Count(*)as totalNumber FROM Question WHERE 
Status = 1 
and QuestionType = 3
and SubjectID ='01C49869-64FE-4719-8E09-1F0871435299' )
order BY totalNumber;
/** 每日一练 科目下的总题目 */
SELECT Count(*)as totalNumber FROM Question WHERE 
Status = 1 
and QuestionType <> 4
and SubjectID ='01C49869-64FE-4719-8E09-1F0871435299'

/** 每日一练 随机取10道题 */
SELECT top 10 r.ID from(
	select 
	ID,ROW_NUMBER() OVER(ORDER BY CreateTime DESC) as intervalNumber from Question 
	WHERE Status = 1 and QuestionType = 1 and SubjectID ='01C49869-64FE-4719-8E09-1F0871435299' ) as r 
where r.intervalNumber > 500;


SELECT SUM(CASE WHEN WrongRate BETWEEN 0.81 and 1.00 
					THEN 1
					ELSE 0
				END
				) as extremelyHigh,
			SUM(CASE WHEN WrongRate BETWEEN 0.61 and 0.80 
				THEN 1
				ELSE 0
			END
			) as veryHigh,
			SUM(CASE WHEN WrongRate BETWEEN 0.40 and 0.60 
				THEN 1
				ELSE 0
			END
			) as higher
FROM [dbo].[Question] where 
  status = 1 
  and QuestionType <= 4
  and TestCount > 15  
  --and q.DealCorrecState = 0 
  and( DealCorrecState=0 or DealCorrecState=2 or CorrectCount<15 )
  and SubjectID = '6FC5A6F4-4C1F-48D8-934C-622489DED295';   
--  and PaperHistoryID is null;


use zhuntiku;
SELECT * from EverydayTest WHERE [DAY] = 20181226;

/** 高频考点  1：极高 2：特高  3：较高 */
SELECT  * FROM [dbo].[Question] where 
	DifficultTestPointRate =3
	and status = 1 
	and SubjectID = '6FC5A6F4-4C1F-48D8-934C-622489DED295' ORDER BY DifficultTestPointRate desc
;

/** 高频考点 - 用户已经做 */
SELECT  q.DifficultTestPointRate,count(q.DifficultTestPointRate) as hasDone
FROM [QuestionHistory_D5D86F55-3483-4281-850C-214C5E5B9C22] h LEFT JOIN Question q ON q.id = h.QuestionID where 
  h.Username = 'ceshi'
  and h.SubjectID = '6FC5A6F4-4C1F-48D8-934C-622489DED295' and q.DifficultTestPointRate in (1,2,3)   
	GROUP  BY q.DifficultTestPointRate;

SELECT top 50 * FROM [dbo].[Question] where 
 id in( '9e294781-1dbe-42be-95ac-daad17b6bece' ,
				'bc029651-65df-423d-8405-bad83314a3f6' ,
				'70943405-6345-4aa3-a912-6721c044000e'
				);

/** 高频易错 - 筛选题的过程 */
SELECT 
  SUM(CASE WHEN q.WrongRate BETWEEN 0.81 and 1.00 THEN 1 ELSE 0 END ) as extremelyHigh,
  SUM(CASE WHEN q.WrongRate BETWEEN 0.61 and 0.80 THEN 1 ELSE 0 END ) as veryHigh,
  SUM(CASE WHEN q.WrongRate BETWEEN 0.40 and 0.60 THEN 1 ELSE 0 END ) as higher
FROM [dbo].[Question] q where 
	-- IsDifficult = 1 and
	 status = 1 
--	and WrongRate BETWEEN 0.61 and 0.80
	and QuestionType <= 4
	and TestCount > 15
  and ( DealCorrecState=0 or DealCorrecState=2 or CorrectCount<15 )
	and SubjectID = '6FC5A6F4-4C1F-48D8-934C-622489DED295' 
	and ExamID ='D5D86F55-3483-4281-850C-214C5E5B9C22'
--	GROUP BY WrongRate
--	ORDER BY WrongRate desc
;
/**高频易错  - 用户已答试题*/
SELECT  
  SUM(CASE WHEN q.WrongRate BETWEEN 0.81 and 1.00 THEN 1 ELSE 0 END ) as extremelyHigh,
  SUM(CASE WHEN q.WrongRate BETWEEN 0.61 and 0.80 THEN 1 ELSE 0 END ) as veryHigh,
  SUM(CASE WHEN q.WrongRate BETWEEN 0.40 and 0.60 THEN 1 ELSE 0 END ) as higher
FROM [QuestionHistory_D5D86F55-3483-4281-850C-214C5E5B9C22] h LEFT JOIN Question q ON q.id = h.QuestionID where 
  h.Username = 'ceshi'
  and q.status = 1 
  and q.QuestionType <= 4
  and q.TestCount > 15  
  and( q.DealCorrecState=0 or q.DealCorrecState=2 or q.CorrectCount<15 )
  and h.SubjectID = '6FC5A6F4-4C1F-48D8-934C-622489DED295'   
  and PaperHistoryID is null

/** 高频易错--用户未回试题*/
use zhuntiku;
select top 30 randomResult.ID from( 
select undoResult.ID,ROW_NUMBER() over(order by undoResult.id) as rowNum from ( 
	SELECT ID FROM [dbo].[Question] q where 
	status = 1 
	-- and q.WrongRate BETWEEN 0.61 and 0.8 
	and q.DifficultTestPointRate = 3
	and q.TestCount > 15 
	and ( DealCorrecState=0 or DealCorrecState=2 or CorrectCount < 15 ) 
	and q.SubjectID = '6FC5A6F4-4C1F-48D8-934C-622489DED295' 
	and q.ExamID = 'D5D86F55-3483-4281-850C-214C5E5B9C22' 
	EXCEPT SELECT questionId FROM [QuestionHistory_D5D86F55-3483-4281-850C-214C5E5B9C22] h WHERE 
	h.SubjectID = '6FC5A6F4-4C1F-48D8-934C-622489DED295' 
	and h.ExamID = 'D5D86F55-3483-4281-850C-214C5E5B9C22' 
	and h.Username = 'ceshi' 
) undoResult ) randomResult where randomResult.rowNum > 100; 


/** 高频易错-用户未回试题*/
SELECT  DifficultTestPointRate as testLevel , count(*) as totalNum FROM [dbo].[Question] WHERE  
	status = 1 and SubjectID = '8AC7EBC4-1595-4AE1-87D7-C0F4C80D82DA'
	and  (IsDifficultTestPoint = 1 
				OR DifficultTestPointRate in(1,2,3)
				)
	GROUP BY DifficultTestPointRate;


/**
zhuntiku 
  EverydayTest

*/
use zhuntiku;
/** 默认取10天的题 */
SELECT top(10) * FROM [dbo].[EverydayTest] where ExamID ='BF7B6BD1-B56D-4705-9797-00B23837A81C' and SubjectID = '3843F942-9E3E-46E4-A8A6-366EF008C3A6' ORDER BY [Day] desc ;
DELETE FROM EverydayTest  where ExamID ='BF7B6BD1-B56D-4705-9797-00B23837A81C' and SubjectID = '3843F942-9E3E-46E4-A8A6-366EF008C3A6' and DAY = 20181226;
SELECT top 10 * FROM 	EverydayTest
	WHERE examId='d5d86f55-3483-4281-850c-214c5e5b9c22' AND
  subjectId='6fc5a6f4-4c1f-48d8-934c-622489ded295' 
	and day <= 20181231
	ORDER BY [Day] desc ;


/** OrderProducts */

USE wangxiao2_products;
SELECT * FROM [dbo].[Order_Products] WHERE OrderNumber IN ('201907161418055319211','201907201127334338363') 
AND Type = '0';


SELECT * FROM [dbo].[Order_Products] WHERE OrderNumber ='201907201127334338363';
SELECT
	* 
FROM
	[dbo].[Order_Products] 
WHERE
	OrderNumber = '201907181601143726735' 
-- 	AND productId IN ( 'AFE5518A-40E6-43FF-8013-5712CC2BC2C1' ) 
	AND Type = 0;


SELECT 
	*
	FROM(
		SELECT 
	 count( OrderNumber) AS times,
		OrderNumber
		-- ,ProductId 
	FROM
		[dbo].[Order_Products]
	WHERE
		username = 'ceshi' 
		AND Type = 0 
	GROUP BY
		OrderNumber) op
	WHERE op.times = 2 ;
	
SELECT OrderNumber FROM [dbo].[Order_Products] WHERE ProductId IN ('50369063-7554-4864-8383-605BDFBD81F7','9429DF3B-231A-4FEA-802E-2BA652A40A78') 
AND Type = '0' AND username = 'ceshi' GROUP BY OrderNumber; 

SELECT 
	*
	FROM(
SELECT count( OrderNumber) AS times,OrderNumber FROM [dbo].[Order_Products] WHERE 
OrderNumber IN (
'201705171350256241418',
'201711031100490395155',
'201711031133543384530',
'201711031134377031727',
'201711031139281985335',
'201711031346119188720',
'201711031347404019087',
'201711031349372846584',
'201711031401088809293',
'201711031438494876810',
'201711031440070325390',
'201711031441558158880',
'201711031442218587774',
'201711031442585636437',
'201711131406035197171') 
AND Type = '0' AND username = 'ceshi' GROUP BY OrderNumber
) opp
WHERE opp.times = 2;


SELECT
	OrderNumber 
FROM
	(
SELECT COUNT
	( OrderNumber ) AS times,
	OrderNumber 
FROM
	[dbo].[Order_Products] 
WHERE
	ProductId IN ( '50369063-7554-4864-8383-605BDFBD81F7', '9429DF3B-231A-4FEA-802E-2BA652A40A78' ) 
	AND Type = '0' 
	AND username = 'ceshi' 
GROUP BY
	OrderNumber 
	) opp 
WHERE
	opp.times = 2 
EXCEPT
SELECT
	OrderNumber 
FROM
	[dbo].[Order] 
WHERE
	username = 'ceshi' 
	AND PayStatus = '0';
	

SELECT * FROM 
	[dbo].[Order_Products] 
	WHERE OrderNumber IN (
	(
	SELECT
		OrderNumber 
	FROM
		(
	SELECT COUNT
		( OrderNumber ) AS times,
		COUNT(*) AS itmes,
		OrderNumber 
	FROM
		[dbo].[Order_Products] 
	WHERE
		ProductId IN ( '50369063-7554-4864-8383-605BDFBD81F7' ) 
		AND Type = '0' 
		AND username = 'ceshi' 
	GROUP BY
		OrderNumber 
		) opp 
	WHERE
		opp.times = 1
	)
)





SELECT DISTINCT
	( OrderNumber ) 
FROM
	[wangxiao2_products].[dbo].[Order_Products] 
WHERE
	OrderNumber IN (
SELECT
	OrderNumber 
FROM
	( SELECT OrderNumber, COUNT ( * ) timecount FROM [wangxiao2_products].[dbo].[Order_Products] WHERE username = 'ceshi' AND [Type] = 0 GROUP BY OrderNumber ) a 
WHERE
	a.timecount= 2
	) 
	AND ProductId IN ( '50369063-7554-4864-8383-605BDFBD81F7', '9429DF3B-231A-4FEA-802E-2BA652A40A78') 
	AND [Type] = 0 
	AND CreateTime  
	AND OrderNumber IN (
SELECT
	OrderNumber 
FROM
	[wangxiao2_products].[dbo].[Order] 
WHERE
	username = 'ceshi' 
	AND PayStatus = 0)



SELECT OrderNumber FROM [dbo].[Order_Products] WHERE username = 'ceshi' AND productId IN ('AF9EFA58-1BD6-4B07-9AC1-43E0F8837E6D')  GROUP BY OrderNumber;
	
	
	
	
