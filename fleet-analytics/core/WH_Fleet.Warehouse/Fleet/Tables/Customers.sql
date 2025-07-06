CREATE TABLE [Fleet].[Customers] (

	[CustomerID] int NOT NULL, 
	[City] varchar(200) NULL, 
	[State] varchar(10) NULL, 
	[Latitude] float NULL, 
	[Longitude] float NULL
);


GO
ALTER TABLE [Fleet].[Customers] ADD CONSTRAINT PK_Customers primary key NONCLUSTERED ([CustomerID]);