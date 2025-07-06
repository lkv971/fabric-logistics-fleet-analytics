CREATE PROCEDURE Fleet.upsert_proc
AS
BEGIN

    UPDATE FC
    SET FC.City = FSC.City,
    FC.State = FSC.State,
    FC.Latitude = FSC.Latitude,
    FC.Longitude = FSC.Longitude
    FROM Fleet.Customers AS FC
    INNER JOIN Fleet.Staging_Customers AS FSC
    ON FC.CustomerID = FSC.CustomerID
    WHERE FC.City <> FSC.City
    OR FC.State <> FSC.State
    OR FC.Latitude <> FSC.Latitude
    OR FC.Longitude <> FSC.Longitude;

    INSERT INTO Fleet.Customers(CustomerID, City, State, Latitude, Longitude)
    SELECT FSC.CustomerID, FSC.City, FSC.State, FSC.Latitude, FSC.Longitude
    FROM Fleet.Staging_Customers AS FSC
    WHERE NOT EXISTS (
    SELECT 1 FROM Fleet.Customers AS FC 
    WHERE FC.CustomerID = FSC.CustomerID
    );
    
    UPDATE FD
    SET FD.Driver = FSD.Driver
    FROM Fleet.Drivers AS FD
    INNER JOIN Fleet.Staging_Drivers AS FSD
    ON FD.DriverID = FSD.DriverID
    WHERE FD.Driver <> FSD.Driver;

    INSERT INTO Fleet.Drivers (DriverID, Driver)
    SELECT FSD.DriverID, FSD.Driver
    FROM Fleet.Staging_Drivers AS FSD
    WHERE NOT EXISTS (
    SELECT 1 FROM Fleet.Drivers AS FD 
    WHERE FD.DriverID = FSD.DriverID
    );

    UPDATE FV
    SET FV.Plate = FSV.Plate,
    FV.Brand = FSV.Brand,
    FV.TruckType = FSV.TruckType,
    FV.TrailerType = FSV.TrailerType,
    FV.Year = FSV.Year
    FROM Fleet.Vehicles AS FV
    INNER JOIN Fleet.Staging_Vehicles AS FSV
    ON FV.VehicleID = FSV.VehicleID
    WHERE FV.Brand <> FSV.Brand
    OR FV.TruckType <> FSV.TruckType
    OR FV.TrailerType <> FSV.TrailerType
    OR FV.Year <> FSV.Year;

    INSERT INTO Fleet.Vehicles (VehicleID, Plate, Brand, TruckType, TrailerType, Year)
    SELECT FSV.VehicleID, FSV.Plate, FSV.Brand, FSV.TruckType, FSV.TrailerType, FSV.Year
    FROM Fleet.Staging_Vehicles AS FSV
    WHERE NOT EXISTS (
    SELECT 1 FROM Fleet.Vehicles AS FV
    WHERE FV.VehicleID = FSV.VehicleID
    );

    INSERT INTO Fleet.Costs (Date, VehicleID, DriverID, KMTraveled, Liters, Fuel, Maintenance, FixedCost)
    SELECT FSCO.Date, FSCO.VehicleID, FSCO.DriverID, FSCO.KMTraveled, FSCO.Liters, FSCO.Fuel, FSCO.Maintenance, FSCO.FixedCost
    FROM Fleet.Staging_Costs AS FSCO
    WHERE NOT EXISTS (
    SELECT 1 FROM Fleet.Costs AS FCO
    WHERE FCO.Date = FSCO.Date
    AND FCO.VehicleID = FSCO.VehicleID
    AND FCO.DriverID = FSCO.DriverID
    );

    INSERT INTO Fleet.Freights (Date, CustomerID, VehicleID, InvoiceNumber, FreightID, City, NetRevenue, Weight, GoodsValue)
    SELECT FSF.Date, FSF.CustomerID, FSF.VehicleID, FSF.InvoiceNumber, FSF.FreightID, FSF.City, FSF.NetRevenue, FSF.Weight, FSF.GoodsValue
    FROM Fleet.Staging_Freights AS FSF
    WHERE NOT EXISTS (
    SELECT 1 FROM Fleet.Freights AS FF
    WHERE FF.Date = FSF.Date
    AND FF.CustomerID = FSF.CustomerID
    AND FF.VehicleID = FSF.VehicleID
    AND FF.InvoiceNumber = FSF.InvoiceNumber 
    AND FF.FreightID = FSF.FreightID
    );

    INSERT INTO Fleet.Dates (Date, Year, Quarter, MonthNumber, MonthName, Day, DayName, DayOfWeek)
    SELECT FSDA.Date, FSDA.Year, FSDA.Quarter, FSDA.MonthNumber, FSDA.MonthName, FSDA.Day, FSDA.DayName, FSDA.DayOfWeek
    FROM Fleet.Staging_Dates AS FSDA
    WHERE NOT EXISTS (
    SELECT 1 FROM Fleet.Dates AS FDA
    WHERE FDA.Date = FSDA.Date
    );

END;