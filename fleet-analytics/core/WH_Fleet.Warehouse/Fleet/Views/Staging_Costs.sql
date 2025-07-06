-- Auto Generated (Do not modify) E3349F531FD60414941082866E2C129A1ABDD37954EA4A26951D6CFA168070E6
CREATE VIEW Fleet.Staging_Costs
AS SELECT DISTINCT
Date,
VehicleID,
DriverID,
KMTraveled,
Liters,
Fuel,
Maintenance,
FixedCost
FROM LH_Fleet.dbo.Costs;