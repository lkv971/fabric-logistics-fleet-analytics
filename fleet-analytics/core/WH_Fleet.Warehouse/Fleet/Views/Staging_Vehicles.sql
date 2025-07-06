-- Auto Generated (Do not modify) 8E7358D95C60432566E88FABBA1010220E0D086B03AB9CA6F7DAF9748AB5EA7A
CREATE VIEW Fleet.Staging_Vehicles 
AS SELECT DISTINCT 
VehicleID,
Plate,
Brand,
TruckType,
TrailerType,
Year
FROM LH_Fleet.dbo.Vehicles;