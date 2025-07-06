CREATE TABLE [Fleet].[Drivers] (

	[DriverID] int NOT NULL, 
	[Driver] varchar(200) NULL
);


GO
ALTER TABLE [Fleet].[Drivers] ADD CONSTRAINT PK_Drivers primary key NONCLUSTERED ([DriverID]);