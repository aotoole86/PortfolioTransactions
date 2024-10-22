/*
ALTER TABLE dbo.price DROP CONSTRAINT [FK_price_sec_master]
go
ALTER TABLE dbo.sec_master DROP CONSTRAINT [FK_sec_master_sec_type]
go

DROP TABLE dbo.price
go
DROP TABLE dbo.sec_type
go
DROP TABLE dbo.sec_master
go
*/
CREATE TABLE dbo.sec_type
	(sec_type_id INT IDENTITY(1,1) PRIMARY KEY,
	parent_sec_type_id INT NULL, 
	sec_type_name	VARCHAR(100),
	master_sec_type	VARCHAR(100) 
	)
	USE [db_security]
GO


CREATE TABLE dbo.sec_master
	(sec_id int IDENTITY(1,1) PRIMARY KEY,
	sec_type_id int NOT NULL,
	sec_name VARCHAR(100),
	mkt_cap	float
	)

go
ALTER TABLE [dbo].[sec_master]  WITH CHECK ADD  CONSTRAINT [FK_sec_master_sec_type] FOREIGN KEY([sec_type_id])
REFERENCES [dbo].[sec_type] ([sec_type_id])
GO



ALTER TABLE [dbo].[sec_master] CHECK CONSTRAINT [FK_sec_master_sec_type]
GO

CREATE TABLE dbo.price
	(
	id int IDENTITY,
	sec_id int NOT NULL,
	value_dt	DATETIME NOT NULL,
	price float
	)
go

ALTER TABLE [dbo].[price]  WITH CHECK ADD  CONSTRAINT [FK_price_sec_master] FOREIGN KEY([sec_id])
REFERENCES [dbo].[sec_master] ([sec_id])
GO

ALTER TABLE [dbo].[price] CHECK CONSTRAINT [FK_price_sec_master]
GO


