-- Auto Generated (Do not modify) 4E60054898517BF9350B6500D4AC0F9B57F6FD484B14CAA57F4E180AD43C473C
CREATE VIEW Fleet.Staging_Freights 
AS SELECT DISTINCT
Date,
CustomerID,
VehicleID,
InvoiceNumber,
FreightID,
City,
NetRevenue,
Weight,
GoodsValue
FROM LH_Fleet.dbo.Freights;