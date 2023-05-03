CREATE DATABASE P328Events

USE P328Events

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20)
)

CREATE TABLE Events
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100),
	[Desc] NVARCHAR(500),
	Image NVARCHAR(100),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	StartDate DATETIME2,
	EndDate DATETIME2
)

CREATE TABLE Speakers
(
	Id INT PRIMARY KEY IDENTITY,
	FullName NVARCHAR(35),
	Position NVARCHAR(20)
)

CREATE TABLE EventSpeakers
(
	EventId INT NOT NULL REFERENCES Events(Id),
	SpeakerId INT NOT NULL REFERENCES Speakers(Id),
	StartTime TIME,
	EndTime TIME,
	PRIMARY KEY (EventId,SpeakerId)
)

INSERT INTO Categories
VALUES
('Programming'),
('AI'),
('DataScience'),
('Design')

INSERT INTO Speakers
VALUES
('Abbas Abbasov','CEO'),
('Nermin Abbasova','Developer'),
('Tofiq Qulamov','Designer'),
('Fikret Omerov','CTO'),
('Xeyale Bagirova','Blogger')

INSERT INTO Events(Name,CategoryId,StartDate,EndDate)
VALUES
('Event 1',1,'2022-10-24 14:00','2022-10-24 20:30'),
('Event 2',2,'2023-05-30 08:00','2022-05-30 14:30'),
('Event 3',3,'2023-08-20 10:00','2023-08-20 11:30'),
('Event 4',3,'2023-08-20 10:00','2023-08-20 11:30'),
('Event 5',2,'2023-08-20 10:00','2023-08-20 11:30'),
('Event 6',1,'2023-08-20 10:00','2023-08-20 11:30'),
('Event 7',4,'2023-09-20 10:00','2023-09-20 10:30'),
('Event 8',4,'2023-10-20 12:00','2023-10-21 08:30'),
('Event 9',2,'2023-08-20 10:00','2023-08-21 11:30'),
('Event 10',1,'2023-08-20 10:00','2023-08-21 11:30')

INSERT INTO EventSpeakers(SpeakerId,EventId,StartTime,EndTime)
VALUES
(1,1,'14:00','15:30'),
(1,2,'10:30','14:00'),
(2,2,'13:30','20:00'),
(3,1,'09:30','12:00'),
(3,4,'09:30','12:00'),
(4,5,'09:30','13:00'),
(1,6,'12:30','14:00'),
(2,5,'09:30','12:00'),
(3,7,'10:30','12:00'),
(4,7,'11:30','13:00')


SELECT Events.*,Categories.Name,(SELECT COUNT(EventId) FROM EventSpeakers WHERE EventSpeakers.EventId=Events.Id) AS SpeakerCount  FROM Events
JOIN Categories ON Events.CategoryId=Categories.Id

SELECT Events.*,Categories.Name,(SELECT COUNT(EventId) FROM EventSpeakers WHERE EventSpeakers.EventId=Events.Id) AS SpeakerCounts,(SELECT DATEDIFF(minute,EventSpeakers.StartTime,EventSpeakers.EndTime)) AS DateDifference FROM Events
JOIN Categories ON Categories.Id=Events.CategoryId
   JOIN EventSpeakers ON EventSpeakers.EventId=Events.Id

CREATE PROCEDURE USP_FindEvent
@Day TINYINT,@Month TINYINT,@Year INT
AS
SELECT * FROM Events
WHERE @Day=DAY(Events.StartDate) AND @Month=MONTH(Events.StartDate) AND @Year=YEAR(Events.StartDate)


EXEC USP_FindEvent 24,10,2022

CREATE VIEW VW_SpeakersEvents
AS
SELECT Speakers.*,(SELECT COUNT(SpeakerId) FROM EventSpeakers WHERE EventSpeakers.SpeakerId=Speakers.Id) AS JoinedEvents FROM Speakers

SELECT * FROM VW_SpeakersEvents

SELECT CategoryId FROM Events
GROUP BY CategoryId
HAVING COUNT(Id)>2

CREATE VIEW VW_BeforeYearEvent
AS
SELECT * FROM Events
WHERE CONVERT(DATE,Events.StartDate)>CONVERT(DATE,DATEADD(YEAR,-1,GETDATE())) AND CONVERT(DATE,GETDATE())>Events.StartDate

SELECT * FROM VW_BeforeYearEvent


CREATE PROCEDURE USP_ReturnAVGMinEvent
@CategoryId INT
AS
RETURN (SELECT CategoryId,SUM(DATEDIFF(minute,Events.StartDate,Events.EndDate)) FROM Events
        GROUP BY CategoryId
		HAVING CategoryId=@CategoryId)

EXEC USP_ReturnAVGMinEvent 1


SELECT CategoryId,SUM(DATEDIFF(minute,Events.StartDate,Events.EndDate)) FROM Events
        GROUP BY CategoryId
		HAVING CategoryId=1

SELECT * FROM Events

SELECT DATEDIFF(minute,Events.StartDate,Events.EndDate) FROM Events