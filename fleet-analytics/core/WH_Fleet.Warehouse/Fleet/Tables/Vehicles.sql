CREATE TABLE [Fleet].[Vehicles] (

	[VehicleID] int NOT NULL, 
	[Plate] varchar(50) NULL, 
	[Brand] varchar(20) NULL, 
	[TruckType] varchar(70) NULL, 
	[TrailerType] varchar(50) NULL, 
	[Year] int NULL
);


GO
ALTER TABLE [Fleet].[Vehicles] ADD CONSTRAINT PK_Vehicles primary key NONCLUSTERED ([VehicleID]);