
--populate dbo.price from sec_master

declare @price float, @sec_id int
declare @s table (sec_id int, processed int default(0))

INSERT INTO @s SELECT DISTINCT sec_id, 0 FROM dbo.sec_master

WHILE ((SELECT count(*) FROM @s WHERE processed = 0) <> 0)
begin
	SELECT @sec_id = sec_id FROM @s WHERE processed = 0 ORDER BY sec_id
	SELECT @price = RAND() * 100.0

	INSERT INTO dbo.price
		(sec_id , price, value_dt)
	VALUES
		(@sec_id, @price, CAST(GETDATE() as date))
	
	
	UPDATE @s SET processed = 1 WHERE sec_id = @sec_id


end






TRUNCATE TABLE dbo.portfolio_holdings

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

	--we now want 10 randomly generated sec_ids with random shares between 100-200
	while(@loopCounter < 10)
	begin
		declare @P TABLE(sec_id int)
		SELECT @sec_id = FLOOR(RAND()*(1000- 1) + 1)

		while (@sec_id NOT IN (SELECT sec_id FROM dbo.portfolio_holdings WHERE portfolio_id = @portfolio_id and sec_id = @sec_id))
		begin
			SELECT @shares = FLOOR(RAND()*(200- 50) + 50)
			SELECT @portfolio_id [@portfolio_id], cast(getdate() as date), @sec_id [@sec_id], @shares [@shares]

			INSERT INTO dbo.portfolio_holdings (portfolio_id, value_dt, sec_id, shares)
			VALUES (@portfolio_id, cast(getdate() as date), @sec_id, @shares)

			
		end
		
		SET @loopCounter = @loopCounter + 1
	end
	
	UPDATE @portfolios SET processed = 1 WHERE portfolio_id = @portfolio_id
	
	SET @loopCounter = 0
END	
