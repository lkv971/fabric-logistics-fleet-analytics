-- Auto Generated (Do not modify) BA2A7A811FCC3BA7C674D1FF55DCB75CE6A54E87FFF5756C1B61CAAE385EB77A
CREATE VIEW Fleet.Staging_Customers
AS SELECT DISTINCT
CustomerID,
City,
State,
Latitude,
Longitude
FROM LH_Fleet.dbo.Customers;