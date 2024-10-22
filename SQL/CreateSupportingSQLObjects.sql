CREATE OR ALTER FUNCTION [dbo].[GetParentSecType](@sec_id int)
RETURNS int
AS
BEGIN
	declare @result int, @sec_type_id int 
	SELECT @sec_type_id = sec_type_id FROM dbo.sec_master WHERE sec_id = @sec_id	
	
	;WITH cte
     AS (SELECT 
                sec_type_id,
				parent_sec_type_id 
         FROM   dbo.sec_type 
         WHERE  sec_type_id = @sec_type_id 
         UNION ALL 
         SELECT parent.sec_type_id, 
                parent.parent_sec_type_id
         FROM   dbo.sec_type parent 
                INNER JOIN cte 
                        ON parent.parent_sec_type_id= cte.sec_type_id) 

	SELECT @result = parent_sec_type_id FROM dbo.sec_type WHERE parent_sec_type_id in (1,9)
	
	RETURN @result

END
GO


CREATE FUNCTION dbo.GetTMV	(@portfolio_id int,	@value_dt datetime)
RETURNS FLOAT
AS
BEGIN
	declare @result float 
	
	SELECT @result = sum(p.shares * p2.price) 
	FROM
		dbo.portfolio_holdings p
	INNER JOIN 
		dbo.price p2 on p.sec_id = p2.sec_id and p.value_dt=p2.value_dt
	WHERE
		p2.value_dt  =@value_dt 
	
	return @result


END
go


USE [db_security]
GO

/****** Object:  UserDefinedFunction [dbo].[GetTMV]    Script Date: 10/20/2024 7:06:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION [dbo].[GetTotalShares]	(@portfolio_id int,	@value_dt datetime)
RETURNS FLOAT
AS
BEGIN
	declare @result float 
	
	SELECT @result = sum(p.shares)
	FROM
		dbo.portfolio_holdings p
	WHERE
		p.value_dt  =@value_dt 
	
	return @result


END
GO


USE [db_security]
GO
/****** Object:  StoredProcedure [dbo].[GetPortfolio]    Script Date: 10/22/2024 6:36:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[GetPortfolio]
	@portfolio_id int 
as
begin

	DECLARE @value_dt datetime = '10/22/2024'

	;with cte as 
		(SELECT 
			pm.[portfolio_id]
			  ,[portfolio_name]
			  ,[target_weight_stock]
			  ,[target_weight_bonds]
			  ,isnull(Stocks.MktVal,0.000)  [mktVal_Stocks]
			  ,isnull(bonds.MktVal,0.000)	[mktVal_Bonds]
			 ,[dbo].[GetTMV](@portfolio_id,@value_dt) TotalMktVal
		  FROM 
			[dbo].[portfolio_master] pm
		  OUTER APPLY
			(
			SELECT 
				SUM(shares * price) as MktVal
			FROM 
				dbo.portfolio_holdings h
			INNER JOIN	
				dbo.price p on h.sec_id = p.sec_id AND p.value_dt=h.value_dt
			INNER JOIN	
				dbo.sec_master sm  on h.sec_id = sm.sec_id
			INNER JOIN
				dbo.sec_type st on sm.sec_type_id=st.sec_type_id
			WHERE
				h.value_dt = @value_dt AND
				h.portfolio_id = @portfolio_id AND
				st.master_sec_type = 'STOCK') Stocks

			OUTER APPLY
			(
			SELECT 
				SUM(shares * price) as MktVal
			FROM 
				dbo.portfolio_holdings h
			INNER JOIN	
				dbo.price p on h.sec_id = p.sec_id AND p.value_dt=h.value_dt
			INNER JOIN	
				dbo.sec_master sm  on h.sec_id = sm.sec_id
			INNER JOIN
				dbo.sec_type st on sm.sec_type_id=st.sec_type_id
			WHERE
				h.value_dt = @value_dt AND
				h.portfolio_id = @portfolio_id AND
				st.master_sec_type = 'BOND')  Bonds

			WHERE pm.portfolio_id = @portfolio_id
		 )

		 SELECT 
			portfolio_id, 
			portfolio_name, 
			target_weight_stock, 
			target_weight_bonds, 
			mktVal_Stocks, 
			mktVal_Stocks, 
			TotalMktVal, 
			100 * mktVal_Stocks/TotalMktVal [ActualWeightStocks],
			100 * mktVal_Bonds/TotalMktVal  [ActualWeightBonds]
		 FROM 
			cte
end
go














CREATE OR ALTER   VIEW [dbo].[vw_PortfolioHoldings]

as

SELECT 
				h.portfolio_id, 
				pm.portfolio_name,
				h.value_dt, 
				h.sec_id, 
				sm.sec_name, 
				h.shares, 
				p.price, 
				st2.sec_type_name,
				dbo.GetTMV(h.portfolio_id, h.value_dt) TMV, 
				dbo.GetTotalShares(h.portfolio_id, h.value_dt) TotalShares, 
				(h.shares * p.price) [position_value],
				h.target_weight,
				100 * (h.shares * p.price)/dbo.GetTMV(h.portfolio_id, h.value_dt) [actual_weight]
			FROM 
				[db_security].[dbo].[portfolio_holdings] h
			INNER JOIN
				dbo.portfolio_master pm on h.portfolio_id = pm.portfolio_id 
			INNER JOIN	
				dbo.price p on h.sec_id = p.sec_id and p.value_dt=h.value_dt
			INNER JOIN
				dbo.sec_master sm on h.sec_id = sm.sec_id
			INNER JOIN
				dbo.sec_type st on sm.sec_type_id=st.sec_type_id
			INNER JOIN
				dbo.sec_type st2 on st.parent_sec_type_id=st2.sec_type_id 

GO




