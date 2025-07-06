-- Auto Generated (Do not modify) 0484356F01F705189A9470D0655FC8A93D494358F8C2ADAEB4BE468C628190B5
CREATE VIEW Fleet.Staging_Dates
AS SELECT DISTINCT 
Date,
Year,
Quarter,
MonthNumber,
MonthName,
Day,
DayName,
DayOfWeek
FROM LH_Fleet.dbo.Dates;