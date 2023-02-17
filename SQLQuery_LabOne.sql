/*DROP DATABASE IF EXISTS BrandonCarpenter
Go

CREATE DATABASE BrandonCarpenter
GO
*/


use BrandonCarpenter
GO

DROP TABLE IF EXISTS  TripLeg
GO

DROP TABLE IF EXISTS TransitLines
GO
DROP TABLE IF EXISTS  TripLeg
GO

DROP TABLE IF EXISTS  Stations
GO

DROP TABLE IF EXISTS  TripPlans
GO




CREATE TABLE TransitLines(
    TransitLine VARCHAR(50)
    CONSTRAINT PK_TransitLine PRIMARY KEY,
    IntervalMins INT NOT NULL
    CONSTRAINT CHK_IntervalMins check(IntervalMins > 0)
);

CREATE TABLE TripPlans (
    TripPlanID INT IDENTITY(1,1)
    CONSTRAINT PK_TripPlanID PRIMARY KEY,
    PlanGenerated DATETIME NOT NULL
    CONSTRAINT DF_PlanGenerated DEFAULT GETDATE(),

);
CREATE TABLE Stations(
    Station VARCHAR(50)
    CONSTRAINT PK_Station PRIMARY KEY,
    StreetAddress VARCHAR(30)
    CONSTRAINT NN_StreetAddress NOT NULL,
    City VARCHAR(30) NOT NULL
    CONSTRAINT DF_City DEFAULT 'Edmonton',
    Province VARCHAR(2) NOT NULL
    CONSTRAINT DF_Province DEFAULT 'AB',
    PostalCode CHAR(7) NOT NULL
    CONSTRAINT CHK_PostalCode check(PostalCode like '[A-Z][0-9][A-Z] [0-9][A-Z][0-9]'),
);
CREATE TABLE TripLeg (
    TripPlanID INT NOT NULL
    CONSTRAINT FK_TripPlanID REFERENCES TripPlans(TripPlanID),
    TransitLine VARCHAR(50) NOT NULL
    CONSTRAINT FK_TransitLine REFERENCES TransitLines(TransitLine),
    StartStation VARCHAR(50) NOT NULL
    CONSTRAINT FK_StartStation REFERENCES Stations(Station),
    FinishStation VARCHAR(50) NOT NULL
    CONSTRAINT FK_FinishStation REFERENCES Stations(Station),
    StartDeparture DATETIME NOT NULL,
    FinishArrival DATETIME NOT NULL,
    Duration as DATEDIFF(minute, StartDeparture, FinishArrival),
    PRIMARY KEY(TripPlanID, TransitLine)
);



--Visual Inspection
--CONDITIONAL DROPS in correct order
--DROP/CREATE DB commented out
--USE STATEMENT
--TransitLines
ROLLBACK
BEGIN TRANSACTION
print 'Transit Lines: Expect 4 Fails'
insert into TransitLines (TransitLine)
values ('X')
insert into TransitLines (IntervalMins)
values (15)
insert into TransitLines(TransitLine, IntervalMins)
values ('cuezwqcwnrxtasdnzflwioesoyfupxcbovztcdsmodeupkhvqap', 15)
insert into TransitLines(TransitLine, IntervalMins)
values ('VALLEY', -5)
print 'Transit Lines: Expect 3 Success'
insert into TransitLines(TransitLine, IntervalMins)
values ('CAPITAL', 5)
insert into TransitLines(TransitLine, IntervalMins)
values ('METRO', 15)
insert into TransitLines(TransitLine, IntervalMins)
values ('WEST EDMONTON MALL - SHERWOOD PARK EXPRESS SERVICE', 30)
--***** STATIONS ********************
print 'Stations: Expect 7 Fails'
insert into Stations (Station)
values ('LAKE MINNEWAKA')
insert into Stations (StreetAddress)
values ('8770 170 ST NW')
insert into Stations (PostalCode)
values ('T5T 4J2')
insert into Stations (StreetAddress, PostalCode)
values ('8770 170 ST NW', 'T5T 4J2')
insert into Stations (Station, StreetAddress, PostalCode)
values ('WEST EDMONTON MALL / WEST JASPER PLACE TRANSIT CENTRE', '8770 170 ST NW', 'T5T
4J2')
insert into Stations (Station, StreetAddress, PostalCode)
values ('WEST EDMONTON MALL / WEST JASPER PLACE TRANSIT CTR', '#1000 8770 170 STREET
NORTHWEST', 'T5T 4J2')
insert into Stations (Station, StreetAddress, PostalCode)
values ('WEST EDMONTON MALL / WEST JASPER PLACE TRANSIT CTR', '8770 170 STREET
NORTHWEST', 'T5T4J2')
--********************
print 'Stations: Expect 6 Success'
insert into Stations (Station, StreetAddress, PostalCode)
values ('WEST EDMONTON MALL / WEST JASPER PLACE TRANSIT CTR', '8770 170 STREET
NORTHWEST', 'T5T 4J2')
insert into Stations (Station, StreetAddress, PostalCode)
values ('NAIT STATION', '10600 PRINCESS ELIZABETH AVE', 'T5J 2R4')
insert into Stations (Station, StreetAddress, PostalCode)
values ('CHURCHILL STATION', 'CHURCHILL SQUARE NW', 'T5J 1X2')
insert into Stations (Station, StreetAddress, PostalCode)
values ('SOUTHGATE STATION', '4804 111 ST NW', 'T6K 3E4')
insert into Stations (Station, StreetAddress, PostalCode)
values ('BELVEDERE STATION', '12876 FORT RD NW', 'T5C 2R6')
insert into Stations (Station, StreetAddress, City, Province, PostalCode)
values ('VANCOUVER INTERNATIONAL AIRPORT - YVR DEPARTURES', '101 W. AIRPORT BLVD','RICHMOND', 'BC', 'V6B 2R3')
--**** TripPlans ****
print 'TripPlans: Expect 1 Fail'
insert into TripPlans (TripPlanId, PlanGenerated)
values(101, GetDate())
--********
print 'TripPlans: Expect 2 Success'
insert into TripPlans(PlanGenerated)
values (GetDate())
declare @TripPlan1 int = @@identity
insert into TripPlans(PlanGenerated)
values (GetDate())
declare @TripPlan2 int = @@identity
--********* TRIPLEG **************
print 'TRIPLEG: Expect 7 Fails'
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation, FinishArrival)
values (10100, 'CAPITAL', 'BELVEDERE STATION', GETDATE(), 'SOUTHGATE STATION',DATEADD(MINUTE,24,GETDATE()))
insert into TripLeg (TransitLine, StartStation, StartDeparture, FinishStation,
FinishArrival)
values ('CAPITAL', 'BELVEDERE STATION', GETDATE(), 'SOUTHGATE STATION',DATEADD(MINUTE,24,GETDATE()))
insert into TripLeg (TripPlanId, StartStation, StartDeparture, FinishStation,
FinishArrival)
values (@TripPlan1, 'CAPITAL', GETDATE(), 'SOUTHGATE STATION',DATEADD(MINUTE,24,GETDATE()))
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation, FinishArrival)
values (@TripPlan1, 'YYC', 'BELVEDERE STATION', GETDATE(), 'SOUTHGATE STATION',DATEADD(MINUTE,24,GETDATE()))
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation)
values (@TripPlan1, 'CAPITAL', 'BELVEDERE STATION', GETDATE(), 'SOUTHGATE STATION')
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation, FinishArrival)
values (@TripPlan1, 'CAPITAL', 'SHAWNESSY STATION', GETDATE(), 'SOUTHGATE STATION',DATEADD(MINUTE,24,GETDATE()))
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation, FinishArrival)
values (10100, 'CAPITAL', 'BELVEDERE STATION', GETDATE(), 'BRENTWOOD STATION',DATEADD(MINUTE,24,GETDATE()))
--*********
PRINT 'TripLeg: Expect 3 Success'
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation, FinishArrival)
values (@TripPlan1, 'CAPITAL', 'BELVEDERE STATION', GETDATE(), 'CHURCHILL STATION',DATEADD(MINUTE,15,GETDATE()))
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation, FinishArrival)
values (@TripPlan1, 'METRO', 'CHURCHILL STATION', DATEADD(MINUTE,20,GETDATE()), 'NAIT STATION',DATEADD(MINUTE,35,GETDATE()))
insert into TripLeg (TripPlanId, TransitLine, StartStation, StartDeparture,
FinishStation, FinishArrival)
values (@TripPlan2, 'CAPITAL', 'SOUTHGATE STATION', GETDATE(), 'VANCOUVER INTERNATIONAL AIRPORT - YVR DEPARTURES',DATEADD(DAY,1,GETDATE()))
--**** confirmation ***
select tp.TripPlanId, tp.PlanGenerated, f.Station 'From', leg.StartDeparture 'Departs',
t.Station 'To', t.City, t.Province, leg.FinishArrival 'Arrives', leg.Duration,
tl.TransitLine, tl.IntervalMins
from TripLeg leg
join stations f
on leg.startstation = f.Station
join stations t
on leg.FinishStation = t.Station
join TripPlans tp
on tp.TripPlanId = leg.TripPlanId
join TransitLines tl
on tl.TransitLine = leg.TransitLine
ROLLBACK
--Review Created Keys
select 'Check Keys: Expect 9 Rows; 5 PK, 4 FK'
SELECT
left(KU.table_name,30) as TABLENAME
,left(column_name,30) as 'Constraint Name', left(tc.constraint_type,30) as
'Constraint Type'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
ON TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
--AND KU.table_name='Riders'
WHERE ku.table_name != 'sysdiagrams'
ORDER BY
KU.TABLE_NAME
,KU.ORDINAL_POSITION
