/*
DROP TABLE dbo.portfolio_holdings
go

DROP TABLE dbo.portfolio_master
go
*/
CREATE TABLE dbo.portfolio_master
	(portfolio_id int IDENTITY(1,1) PRIMARY KEY,
	portfolio_name		VARCHAR(100) NOT NULL)

	go

--lets create 10 portfolios 
	DECLARE @loopCounter int = 1, @tgt_stock int, @tgt_bond int
	SET IDENTITY_INSERT dbo.portfolio_master ON

	WHILE(@loopCounter < 11)
	begin
		SELECT @tgt_stock = FLOOR(RAND()*(80- 1) + 1)
		SELECT @tgt_bond = (100- @tgt_stock)
		INSERT INTO dbo.portfolio_master 
			(portfolio_id, portfolio_name, target_weight_stock, target_weight_bonds) 
		VALUES 
			(@loopCounter , 'Portfolio ' + cast(@loopCounter as varchar(10)) , @tgt_stock, @tgt_bond) 
		SET @loopCounter=@loopCounter+1
	end 
go


CREATE TABLE dbo.portfolio_holdings
	(	id int IDENTITY(1,1) ,
		portfolio_id	INT NOT NULL,
		value_dt		DATETIME,
		sec_id			INT NOT NULL,
		shares			INT
	)
go
USE [db_security]
GO

ALTER TABLE [dbo].[portfolio_holdings]  WITH CHECK ADD  CONSTRAINT [FK_portfolio_holdings_portfolio_master] FOREIGN KEY([portfolio_id])
REFERENCES [dbo].[portfolio_master] ([portfolio_id])
GO

ALTER TABLE [dbo].[portfolio_holdings] CHECK CONSTRAINT [FK_portfolio_holdings_portfolio_master]
GO
USE [db_security]
GO

ALTER TABLE [dbo].[portfolio_holdings]  WITH CHECK ADD  CONSTRAINT [FK_portfolio_holdings_sec_master] FOREIGN KEY([sec_id])
REFERENCES [dbo].[sec_master] ([sec_id])
GO

ALTER TABLE [dbo].[portfolio_holdings] CHECK CONSTRAINT [FK_portfolio_holdings_sec_master]
GO


