

--lets generate sample holdings for each account for one day, each account has 100 holdings
declare @portfolios table (portfolio_id int, processed int)
INSERT INTO @portfolios
	(portfolio_id, processed)
SELECT
	portfolio_id, 0
FROM	
	dbo.portfolio_master 

DECLARE @loopCounter int = 0, @portfolio_id int, @sec_id int, @shares int

WHILE ((SELECT COUNT(*) FROM @portfolios WHERE processed = 0) <>  0)
BEGIN
	SELECT TOP 1 @portfolio_id = portfolio_id, @loopCounter = 0 FROM @portfolios WHERE processed = 0 
	SELECT 'processing ... ' + cast(@portfolio_id as varchar(100)) 

	--we now want 100 randomly generated sec_ids with random shares between 100-200
	while(@loopCounter < 100)
	begin
		declare @P TABLE(sec_id int)
		SELECT @sec_id = FLOOR(RAND()*(1000- 1) + 1)

		while (@sec_id NOT IN (SELECT sec_id FROM dbo.portfolio_holdings WHERE portfolio_id = @portfolio_id and sec_id = @sec_id))
		begin
			SELECT @shares = FLOOR(RAND()*(200- 50) + 50)
			INSERT INTO dbo.portfolio_holdings
				(portfolio_id, value_dt, sec_id, shares)
			VALUES 
				(@portfolio_id, cast(getdate() as date), @sec_id, @shares)
		end
		
		SET @loopCounter = @loopCounter + 1
	end
	
	UPDATE @portfolios SET processed = 1 WHERE portfolio_id = @portfolio_id	
	SET @loopCounter = 0
END



USE [db_security]
GO




	SET IDENTITY_INSERT dbo.sec_type ON

	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (1, null, 'STOCK', 'STOCK')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (2, 1, 'COMMON STOCK', 'STOCK')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (3, 1, 'PREFERRED STOCK', 'STOCK')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (4, 3, 'Cumulative', 'STOCK')	 
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (5, 3, 'Non-Cumulative', 'STOCK')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (6, 3, 'Participating', 'STOCK')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (7, 3, 'Convertible', 'STOCK')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (8, 4, 'Class F', 'STOCK')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (9, null, 'BOND', 'BOND')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (10, 9, 'CORPORATE BOND','BOND')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (11, 9, 'MUNICIPAL BOND','BOND')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (12, 9, 'T-BILLS','BOND')
	INSERT INTO dbo.sec_type (sec_type_id, parent_sec_type_id, sec_type_name, master_sec_type) VALUES (13, 9, 'Agency Bonds','BOND')

	SET IDENTITY_INSERT dbo.sec_type ON

	DECLARE @loopCounter int = 0, @sec_type int, @sec_name varchar(100), @mkt_cap FLOAT, @price FLOAT, @sec_id INT
	WHILE(@loopCounter < 1000)
	begin
		
		SELECT @sec_type  = FLOOR(RAND()*(14- 1) + 1)
		SELECT @sec_name = 'SECURITY : ' + CAST (@sec_type  as varchar(2))
		SELECT @mkt_cap = RAND() * 10000.0
		SELECT @price = RAND() * 100.0

		
		SET @loopCounter=@loopCounter+1

		INSERT INTO [dbo].[sec_master]
			(sec_name, sec_type_id, mkt_cap)
		VALUES 
			(@sec_name, @sec_type, @mkt_cap)
		SELECT @sec_id  =SCOPE_IDENTITY()

		INSERT INTO dbo.price
			(sec_id , price, value_dt)
		VALUES
			(@sec_id, @price, CAST(GETDATE() as date))
				
	end
go

