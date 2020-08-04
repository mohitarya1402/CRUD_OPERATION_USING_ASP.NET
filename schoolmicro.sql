


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create the Department table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[Department]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Department]([DepartmentID] [int] NOT NULL,
[Name] [nvarchar](50) NOT NULL,
[Budget] [money] NOT NULL,
[StartDate] [datetime] NOT NULL,
[Administrator] [int] NULL,
CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED
(
[DepartmentID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

-- Create the Person table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[Person]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Person]([PersonID] [int] IDENTITY(1,1) NOT NULL,
[LastName] [nvarchar](50) NOT NULL,
[FirstName] [nvarchar](50) NOT NULL,
[HireDate] [datetime] NULL,
[EnrollmentDate] [datetime] NULL,
[Discriminator] [nvarchar](50) NOT NULL,
CONSTRAINT [PK_School.Student] PRIMARY KEY CLUSTERED
(
[PersonID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

-- Create the OnsiteCourse table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[OnsiteCourse]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OnsiteCourse]([CourseID] [int] NOT NULL,
[Location] [nvarchar](50) NOT NULL,
[Days] [nvarchar](50) NOT NULL,
[Time] [smalldatetime] NOT NULL,
CONSTRAINT [PK_OnsiteCourse] PRIMARY KEY CLUSTERED
(
[CourseID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

-- Create the OnlineCourse table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[OnlineCourse]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OnlineCourse]([CourseID] [int] NOT NULL,
[URL] [nvarchar](100) NOT NULL,
CONSTRAINT [PK_OnlineCourse] PRIMARY KEY CLUSTERED
(
[CourseID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

--Create the StudentGrade table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[StudentGrade]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[StudentGrade]([EnrollmentID] [int] IDENTITY(1,1) NOT NULL,
[CourseID] [int] NOT NULL,
[StudentID] [int] NOT NULL,
[Grade] [decimal](3, 2) NULL,
CONSTRAINT [PK_StudentGrade] PRIMARY KEY CLUSTERED
(
[EnrollmentID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

-- Create the CourseInstructor table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[CourseInstructor]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CourseInstructor]([CourseID] [int] NOT NULL,
[PersonID] [int] NOT NULL,
CONSTRAINT [PK_CourseInstructor] PRIMARY KEY CLUSTERED
(
[CourseID] ASC,
[PersonID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

-- Create the Course table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[Course]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Course]([CourseID] [int] NOT NULL,
[Title] [nvarchar](100) NOT NULL,
[Credits] [int] NOT NULL,
[DepartmentID] [int] NOT NULL,
CONSTRAINT [PK_School.Course] PRIMARY KEY CLUSTERED
(
[CourseID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

-- Create the OfficeAssignment table.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[OfficeAssignment]')
AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OfficeAssignment]([InstructorID] [int] NOT NULL,
[Location] [nvarchar](50) NOT NULL,
[Timestamp] [timestamp] NOT NULL,
CONSTRAINT [PK_OfficeAssignment] PRIMARY KEY CLUSTERED
(
[InstructorID] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]) ON [PRIMARY]
END
GO

-- Define the relationship between OnsiteCourse and Course.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_OnsiteCourse_Course]')
AND parent_object_id = OBJECT_ID(N'[dbo].[OnsiteCourse]'))
ALTER TABLE [dbo].[OnsiteCourse] WITH CHECK ADD
CONSTRAINT [FK_OnsiteCourse_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[OnsiteCourse] CHECK
CONSTRAINT [FK_OnsiteCourse_Course]
GO

-- Define the relationship between OnlineCourse and Course.
 (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_OnlineCourse_Course]')
AND parent_object_id = OBJECT_ID(N'[dbo].[OnlineCourse]'))
ALTER TABLE [dbo].[OnlineCourse] WITH CHECK ADD
CONSTRAINT [FK_OnlineCourse_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[OnlineCourse] CHECK
CONSTRAINT [FK_OnlineCourse_Course]
GO

-- Define the relationship between StudentGrade and Course.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentGrade_Course]')
AND parent_object_id = OBJECT_ID(N'[dbo].[StudentGrade]'))
ALTER TABLE [dbo].[StudentGrade] WITH CHECK ADD
CONSTRAINT [FK_StudentGrade_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[StudentGrade] CHECK
CONSTRAINT [FK_StudentGrade_Course]
GO

--Define the relationship between StudentGrade and Student.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_StudentGrade_Student]')
AND parent_object_id = OBJECT_ID(N'[dbo].[StudentGrade]'))
ALTER TABLE [dbo].[StudentGrade] WITH CHECK ADD
CONSTRAINT [FK_StudentGrade_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[StudentGrade] CHECK
CONSTRAINT [FK_StudentGrade_Student]
GO

-- Define the relationship between CourseInstructor and Course.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_CourseInstructor_Course]')
AND parent_object_id = OBJECT_ID(N'[dbo].[CourseInstructor]'))
ALTER TABLE [dbo].[CourseInstructor] WITH CHECK ADD
CONSTRAINT [FK_CourseInstructor_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([CourseID])
GO
ALTER TABLE [dbo].[CourseInstructor] CHECK
CONSTRAINT [FK_CourseInstructor_Course]
GO

-- Define the relationship between CourseInstructor and Person.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_CourseInstructor_Person]')
AND parent_object_id = OBJECT_ID(N'[dbo].[CourseInstructor]'))
ALTER TABLE [dbo].[CourseInstructor] WITH CHECK ADD
CONSTRAINT [FK_CourseInstructor_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[CourseInstructor] CHECK
CONSTRAINT [FK_CourseInstructor_Person]
GO

-- Define the relationship between Course and Department.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_Course_Department]')
AND parent_object_id = OBJECT_ID(N'[dbo].[Course]'))
ALTER TABLE [dbo].[Course] WITH CHECK ADD
CONSTRAINT [FK_Course_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [FK_Course_Department]
GO

--Define the relationship between OfficeAssignment and Person.
IF NOT EXISTS (SELECT * FROM sys.foreign_keys
WHERE object_id = OBJECT_ID(N'[dbo].[FK_OfficeAssignment_Person]')
AND parent_object_id = OBJECT_ID(N'[dbo].[OfficeAssignment]'))
ALTER TABLE [dbo].[OfficeAssignment] WITH CHECK ADD
CONSTRAINT [FK_OfficeAssignment_Person] FOREIGN KEY([InstructorID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[OfficeAssignment] CHECK
CONSTRAINT [FK_OfficeAssignment_Person]
GO

-- Create InsertOfficeAssignment stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[InsertOfficeAssignment]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = CREATE PROCEDURE [dbo].[InsertOfficeAssignment]
@InstructorID int,
@Location nvarchar(50)
AS
INSERT INTO dbo.OfficeAssignment (InstructorID, Location)
VALUES (@InstructorID, @Location);
IF @@ROWCOUNT > 0
BEGIN
SELECT [Timestamp] FROM OfficeAssignment
WHERE InstructorID=@InstructorID;
END

END
GO

--Create the UpdateOfficeAssignment stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[UpdateOfficeAssignment]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdateOfficeAssignment]
@InstructorID int,
@Location nvarchar(50),
@OrigTimestamp timestamp
AS
UPDATE OfficeAssignment SET Location=@Location
WHERE InstructorID=@InstructorID AND [Timestamp]=@OrigTimestamp;
IF @@ROWCOUNT > 0
BEGIN
SELECT [Timestamp] FROM OfficeAssignment
WHERE InstructorID=@InstructorID;
END
'
END
GO

-- Create the DeleteOfficeAssignment stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[DeleteOfficeAssignment]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeleteOfficeAssignment]
@InstructorID int
AS
DELETE FROM OfficeAssignment
WHERE InstructorID=@InstructorID;
'
END
GO

-- Create the DeletePerson stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[DeletePerson]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[DeletePerson]
@PersonID int
AS
DELETE FROM Person WHERE PersonID = @PersonID;
'
END
GO

-- Create the UpdatePerson stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePerson]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[UpdatePerson]
@PersonID int,
@LastName nvarchar(50),
@FirstName nvarchar(50),
@HireDate datetime,
@EnrollmentDate datetime,
@Discriminator nvarchar(50)
AS
UPDATE Person SET LastName=@LastName,
FirstName=@FirstName,
HireDate=@HireDate,
EnrollmentDate=@EnrollmentDate,
Discriminator=@Discriminator
WHERE PersonID=@PersonID;
'
END
GO

-- Create the InsertPerson stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[InsertPerson]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[InsertPerson]
@LastName nvarchar(50),
@FirstName nvarchar(50),
@HireDate datetime,
@EnrollmentDate datetime,
@Discriminator nvarchar(50)
AS
INSERT INTO dbo.Person (LastName,
FirstName,
HireDate,
EnrollmentDate,
Discriminator)
VALUES (@LastName,
@FirstName,
@HireDate,
@EnrollmentDate,
@Discriminator);
SELECT SCOPE_IDENTITY() as NewPersonID;
'
END
GO

-- Create GetStudentGrades stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[GetStudentGrades]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetStudentGrades]'
@StudentID int
AS
SELECT EnrollmentID, Grade, CourseID, StudentID FROM dbo.StudentGrade
WHERE StudentID = @StudentID
END
GO

-- Create GetDepartmentName stored procedure.
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'[dbo].[GetDepartmentName]')
AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[GetDepartmentName]
@ID int,
@Name nvarchar(50) OUTPUT
AS
SELECT @Name = Name FROM Department
WHERE DepartmentID = @ID
'
END
GO

select * from person
-- Insert data into the Person table.
USE School
GO
SET IDENTITY_INSERT dbo.Person ON
GO
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (1, 'Abercrombie', 'Kim', '1995-03-11', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (2, 'Barzdukas', 'Gytis', null, '2005-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (3, 'Justice', 'Peggy', null, '2001-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (4, 'Fakhouri', 'Fadi', '2002-08-06', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (5, 'Harui', 'Roger', '1998-07-01', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (6, 'Li', 'Yan', null, '2002-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (7, 'Norman', 'Laura', null, '2003-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (8, 'Olivotto', 'Nino', null, '2005-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (9, 'Tang', 'Wayne', null, '2005-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (10, 'Alonso', 'Meredith', null, '2002-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (11, 'Lopez', 'Sophia', null, '2004-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (12, 'Browning', 'Meredith', null, '2000-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (13, 'Anand', 'Arturo', null, '2003-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (14, 'Walker', 'Alexandra', null, '2000-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (15, 'Powell', 'Carson', null, '2004-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (16, 'Jai', 'Damien', null, '2001-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (17, 'Carlson', 'Robyn', null, '2005-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (18, 'Zheng', 'Roger', '2004-02-12', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (19, 'Bryant', 'Carson', null, '2001-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (20, 'Suarez', 'Robyn', null, '2004-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (21, 'Holt', 'Roger', null, '2004-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (22, 'Alexander', 'Carson', null, '2005-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (23, 'Morgan', 'Isaiah', null, '2001-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (24, 'Martin', 'Randall', null, '2005-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (25, 'Kapoor', 'Candace', '2001-01-15', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (26, 'Rogers', 'Cody', null, '2002-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (27, 'Serrano', 'Stacy', '1999-06-01', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (28, 'White', 'Anthony', null, '2001-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (29, 'Griffin', 'Rachel', null, '2004-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (30, 'Shan', 'Alicia', null, '2003-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (31, 'Stewart', 'Jasmine', '1997-10-12', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (32, 'Xu', 'Kristen', '2001-7-23', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (33, 'Gao', 'Erica', null, '2003-01-30', 'Student');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (34, 'Van Houten', 'Roger', '2000-12-07', null, 'Instructor');
GO
SET IDENTITY_INSERT dbo.Person OFF
GO
select * from person
insert into person values(132,'dxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(133,'gdxg','tuty','2010-10-2',null,'student');
insert into person values(134,'dxg','ytuty','2010-10-12',null,'student');
insert into person values(135,'gdxg','tuty','2010-10-20',null,'student');
insert into person values(136,'xgdxg','ytuty','2010-10-2',null,'student');
insert into person values(137,'xg','tuty','2010-10-2',null,'student');
insert into person values(138,'dg','ytuty','2010-10-12',null,'student');
insert into person values(139,'g','tuty','2010-10-20',null,'student');
insert into person values(140,'dag','ytuty','2010-10-2',null,'student');
insert into person values(141,'gsadxg','tuty','2010-10-2',null,'student');
insert into person values(142,'dasxg','ytuty','2010-10-12',null,'student');
insert into person values(143,'gdasxg','tuty','2010-10-20',null,'student');
insert into person values(144,'xgsadxg','ytuty','2010-10-2',null,'student');
insert into person values(145,'xgas','tuty','2010-10-2',null,'student');
insert into person values(146,'dasg','ytuty','2010-10-12',null,'student');
insert into person values(147,'ghbfas','tuty','2010-10-20',null,'student');
insert into person values(148,'dhfxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(149,'gdhfxg','tuty','2010-10-2',null,'student');
insert into person values(150,'dhfxg','ytuty','2010-10-12',null,'student');
insert into person values(151,'gbdxg','tuty','2010-10-20',null,'student');
insert into person values(152,'xgvxdxg','ytuty','2010-10-2',null,'student');
insert into person values(153,'xvxvxg','tuty','2010-10-2',null,'student');
insert into person values(154,'vvdg','ytuty','2010-10-12',null,'student');
insert into person values(155,'gvv','tuty','2000-10-20',null,'student');
insert into person values(156,'daxvxg','ytuty','2000-10-2',null,'student');
insert into person values(157,'gvxsadxg','tuty','2011-10-2',null,'student');
insert into person values(158,'davxsxg','ytuty','2010-10-12',null,'student');
insert into person values(159,'gdabvcsxg','tuty','2010-10-20',null,'student');
insert into person values(160,'xgsavdxg','ytuty','2010-10-2',null,'student');
insert into person values(161,'xgavs','tuty','2010-10-2',null,'student');
insert into person values(162,'dvasg','ytuty','2010-10-12',null,'student');
insert into person values(163,'gpcas','tuty','2010-10-20',null,'student');
insert into person values(164,'dxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(165,'gdpxg','tuty','2010-10-2',null,'student');
insert into person values(166,'dpxg','ytuty','2010-10-12',null,'student');
insert into person values(167,'gdpxg','tuty','2010-10-20',null,'student');
insert into person values(168,'xgpdxg','ytuty','2010-10-2',null,'student');
insert into person values(169,'xpg','tuty','2010-10-2',null,'student');
insert into person values(170,'dpg','ytuty','2010-10-12',null,'student');
insert into person values(171,'pg','tuty','2010-10-20',null,'student');
insert into person values(172,'dpag','ytuty','2010-10-2',null,'student');
insert into person values(173,'gspadxg','tuty','2010-10-2',null,'student');
insert into person values(174,'daspxg','ytuty','2010-10-12',null,'student');
insert into person values(175,'gdaspxg','tuty','2010-10-20',null,'student');
insert into person values(176,'xgpsadxg','ytuty','2010-10-2',null,'student');
insert into person values(177,'pgas','tuty','2010-10-2',null,'student');
insert into person values(178,'dpasg','ytuty','2010-10-12',null,'student');
insert into person values(179,'puhbfas','tuty','2010-10-20',null,'student');
insert into person values(180,'duhfxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(181,'gudhfxg','tuty','2010-10-2',null,'student');
insert into person values(182,'udhfxg','ytuty','2010-10-12',null,'student');
insert into person values(183,'gybdxg','tuty','2010-10-20',null,'student');
insert into person values(184,'xtgvxdxg','ytuty','2010-10-2',null,'student');
insert into person values(185,'xtvxvxg','tuty','2010-10-2',null,'student');
insert into person values(187,'vrvdg','ytuty','2010-10-12',null,'student');
insert into person values(188,'gvgv','tuty','2000-10-20',null,'student');
insert into person values(189,'dagxvxg','ytxuty','2000-10-2',null,'student');
insert into person values(190,'gvxrgsadxg','tcuty','2011-10-2',null,'student');
insert into person values(191,'dagvxsxg','yctuty','2010-10-12',null,'student');
insert into person values(192,'gdrabvcsxg','tuty','2010-10-20',null,'student');
insert into person values(193,'xgrsavdxg','ytcuty','2010-10-2',null,'student');
insert into person values(194,'xrgavs','tuty','2010-10-2',null,'student');
insert into person values(195,'dvrasg','ytcuty','2010-10-12',null,'student');
insert into person values(196,'gvcas','tucty','2017-10-20',null,'student');
insert into person values(197,'dhdxgdxg','ytuty','2017-10-2',null,'student');
insert into person values(198,'gdxsg','tuty','2012-10-2',null,'student');
insert into person values(199,'dxgaA','ytcuty','2013-10-12',null,'student');
insert into person values(200,'gdmxgS','tuty','2017-10-20',null,'student');
insert into person values(201,'xbgdxAZg','yctuty','2020-10-2',null,'student');
insert into person values(202,'xgAmbS','tAuty','2014-10-2',null,'student');
insert into person values(203,'mbdg','ytuty','2010-10-12',null,'student');
insert into person values(204,'gmb','tuty','2011-10-20',null,'student');
insert into person values(205,'dbvag','ytuty','2019-10-2',null,'student');
insert into person values(206,'gsvbadxg','tuty','2018-10-2',null,'student');
insert into person values(207,'dacsxg','ytuty','2017-10-12',null,'student');
insert into person values(208,'gdcasxg','tuty','2000-10-20',null,'student');
insert into person values(209,'xgcsadxg','ytuty','1990-10-2',null,'student');
insert into person values(210,'xgcas','tuty','2010-10-2',null,'student');
insert into person values(211,'dacsg','ytuty','2010-10-12',null,'student');
insert into person values(212,'gxhbfas','tuty','2010-10-20',null,'student');
insert into person values(213,'dhfxxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(214,'gdxhfxg','tuty','2010-10-2',null,'student');
insert into person values(215,'dhcfxg','ytuty','2010-10-12',null,'student');
insert into person values(216,'gbdzxg','tuty','2010-10-20',null,'student');
insert into person values(217,'xzgvxdxg','ytuty','2010-10-2',null,'student');
insert into person values(218,'zxvxvxg','tuty','2010-10-2',null,'student');
insert into person values(219,'zvvdg','ytuty','2010-10-12',null,'student');
insert into person values(220,'zgvv','tuty','2000-10-20',null,'student');
insert into person values(221,'zdaxvxg','ytuty','2000-10-2',null,'student');
insert into person values(222,'zgvxsadxg','tuty','2011-10-2',null,'student');
insert into person values(223,'zdavxsxg','ytuty','2010-10-12',null,'student');
insert into person values(224,'gdzabvcsxg','tuty','2010-10-20',null,'student');
insert into person values(225,'xgdxg','ytuty','2010-10-2',null,'student');
insert into person values(226,'xvs','tuty','2010-10-2',null,'student');
insert into person values(227,'sg','ytuty','2010-10-12',null,'student');
insert into person values(228,'as','tuty','2010-10-20',null,'student');
insert into person values(229,'g','ytuty','2010-10-2',null,'student');
insert into person values(230,'pxg','tuty','2010-10-2',null,'student');
insert into person values(231,'gp','ytuty','2010-10-12',null,'student');
insert into person values(232,'gdpppxg','tuty','2010-10-20',null,'student');
insert into person values(233,'xglpdxg','ytuty','2010-10-2',null,'student');
insert into person values(234,'xlpg','tuty','2010-10-2',null,'student');
insert into person values(235,'dlpg','ytuty','2010-10-12',null,'student');
insert into person values(236,'pllg','tuty','2010-10-20',null,'student');
insert into person values(237,'dlpag','ytuty','2010-10-2',null,'student');
insert into person values(238,'gspladxg','tuty','2010-10-2',null,'student');
insert into person values(239,'daslpxg','ytuty','2010-10-12',null,'student');
insert into person values(240,'gdlaspxg','tuty','2010-10-20',null,'student');
insert into person values(241,'xlglpsadxg','ytuty','2010-10-2',null,'student');
insert into person values(242,'plgas','tuty','2010-10-2',null,'student');
insert into person values(243,'dplasg','ytuty','2010-10-12',null,'student');
insert into person values(244,'pullhbfas','tuty','2010-10-20',null,'student');
insert into person values(245,'duhlfxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(246,'gudlhfxg','tuty','2010-10-2',null,'student');
insert into person values(247,'udhlfxg','ytuty','2010-10-12',null,'student');
insert into person values(248,'ghybdxg','tuty','2010-10-20',null,'student');
insert into person values(249,'xhtgvxdxg','ytuty','2010-10-2',null,'student');
insert into person values(250,'xhgtvxvxg','tuty','2010-10-2',null,'student');
insert into person values(251,'vrhgvdg','ytuty','2010-10-12',null,'student');
insert into person values(252,'gvhggv','tuty','2000-10-20',null,'student');
insert into person values(253,'daghgxvxg','ytuty','2000-10-2',null,'student');
insert into person values(254,'gvxhgrgsadxg','tuty','2011-10-2',null,'student');
insert into person values(255,'daggvxsxg','ytuty','2010-10-12',null,'student');
insert into person values(256,'gggh','tuty','2010-10-20',null,'student');
insert into person values(257,'dxg','ytuty','2010-10-2',null,'student');
insert into person values(258,'dxgrgavs','tuty','2010-10-2',null,'student');
insert into person values(259,'ddvrgasg','ytuty','2010-10-12',null,'student');
insert into person values(260,'gxdfrvcas','tuty','2010-10-20',null,'student');
insert into person values(261,'dxgjdxg','ytuty','2010-10-2',null,'student');
insert into person values(262,'gdxgj','tuty','2010-10-2',null,'student');
insert into person values(263,'dxgj','ytuty','2010-10-12',null,'student');
insert into person values(264,'gdxgj','tuty','2010-10-20',null,'student');
insert into person values(265,'xgdxjg','ytuty','2010-10-2',null,'student');
insert into person values(266,'xgj','tuty','2010-10-2',null,'student');
insert into person values(267,'dgjj','ytuty','2010-10-12',null,'student');
insert into person values(268,'gjh','tuty','2010-10-20',null,'student');
insert into person values(269,'dahjg','ytuty','2010-10-2',null,'student');
insert into person values(270,'gsajhdxg','tuty','2010-10-2',null,'student');
insert into person values(271,'dasjhxg','ytuty','2010-10-12',null,'student');
insert into person values(272,'gdahjsxg','tuty','2010-10-20',null,'student');
insert into person values(273,'xgsajgdxg','ytuty','2010-10-2',null,'student');
insert into person values(274,'xgasjz','tuty','2010-10-2',null,'student');
insert into person values(275,'daszgj','ytuty','2010-10-12',null,'student');
insert into person values(276,'ghbfjzas','tuty','2010-10-20',null,'student');
insert into person values(277,'dhfzxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(278,'gdhfzxg','tuty','2010-10-2',null,'student');
insert into person values(279,'dhfxzg','ytuty','2010-10-12',null,'student');
insert into person values(280,'gbdxgz','tuty','2010-10-20',null,'student');
insert into person values(281,'xgvxdzzdxg','ytuty','2010-10-2',null,'student');
insert into person values(282,'xvxvxgzd','tuty','2010-10-2',null,'student');
insert into person values(283,'vvdgz','ytuty','2010-10-12',null,'student');
insert into person values(284,'gvvz','tuty','2000-10-20',null,'student');
insert into person values(285,'daxvzxg','ytuty','2000-10-2',null,'student');
insert into person values(286,'gvxsazdddxg','tuty','2011-10-2',null,'student');
insert into person values(287,'davxsxgs','ytuty','2010-10-12',null,'student');
insert into person values(288,'gdabvcsxsfg','tuty','2010-10-20',null,'student');
insert into person values(289,'xgsavdxgf','ytuty','2010-10-2',null,'student');
insert into person values(290,'xgavss','tuty','2010-10-2',null,'student');
insert into person values(291,'dvasgs','ytuty','2010-10-12',null,'student');
insert into person values(292,'gpcasz','tuty','2010-10-20',null,'student');
insert into person values(293,'dxgdxcg','ytuty','2010-10-2',null,'student');
insert into person values(294,'gdpxgvc','tuty','2010-10-2',null,'student');
insert into person values(295,'dpxcg','ytuty','2010-10-12',null,'student');
insert into person values(296,'gdpxvg','tuty','2010-10-20',null,'student');
insert into person values(297,'xgpxcdxg','ytuty','2010-10-2',null,'student');
insert into person values(298,'xpgv','tuty','2010-10-2',null,'student');
insert into person values(299,'dpgvx','ytuty','2010-10-12',null,'student');
insert into person values(300,'pgv','tuty','2010-10-20',null,'student');
insert into person values(301,'dpxaxg','ytuty','2010-10-2',null,'student');
insert into person values(302,'gspvxadxg','tuty','2010-10-2',null,'student');
insert into person values(303,'dasxzpxg','ytuty','2010-10-12',null,'student');
insert into person values(304,'gdasqpxg','tuty','2010-10-20',null,'student');
insert into person values(305,'xgpsadqxg','ytuty','2010-10-2',null,'student');
insert into person values(306,'pgaswq','tuty','2010-10-2',null,'student');
insert into person values(307,'dpasgw','ytuty','2010-10-12',null,'student');
insert into person values(308,'puhbfaqws','tuty','2010-10-20',null,'student');
insert into person values(309,'duhfxgdwqxg','ytuty','2010-10-2',null,'student');
insert into person values(310,'gudhfxqg','tuty','2010-10-2',null,'student');
insert into person values(311,'udhfxqg','ytuty','2010-10-12',null,'student');
insert into person values(312,'gybdxgre','tuty','2010-10-20',null,'student');
insert into person values(313,'xtgvxdxeg','ytuty','2010-10-2',null,'student');
insert into person values(314,'xtvxvxge','tuty','2010-10-2',null,'student');
insert into person values(315,'vrvdg','ytuty','2010-10-12',null,'student');
insert into person values(316,'gwvgv','tuty','2000-10-20',null,'student');
insert into person values(317,'dawgxvxg','ytxuty','2000-10-2',null,'student');
insert into person values(318,'gvxwrgsadxg','tcuty','2011-10-2',null,'student');
insert into person values(319,'dagvsxsxg','yctuty','2010-10-12',null,'student');
insert into person values(320,'gdrabvcsxg','tuty','2010-10-20',null,'student');
insert into person values(321,'xgrsasvdxg','ytcuty','2010-10-2',null,'student');
insert into person values(322,'xrgavsa','tuty','2010-10-2',null,'student');
insert into person values(323,'dvarasg','ytcuty','2010-10-12',null,'student');
insert into person values(324,'gvacas','tucty','2017-10-20',null,'student');
insert into person values(325,'dhadxgdxg','ytuty','2017-10-2',null,'student');
insert into person values(326,'gdaaxsg','tuty','2012-10-2',null,'student');
insert into person values(327,'dxagaA','ytcuty','2013-10-12',null,'student');
insert into person values(328,'gdmssaxgS','tuty','2017-10-20',null,'student');
insert into person values(329,'xbgdsaxAZg','yctuty','2020-10-2',null,'student');
insert into person values(330,'xgAmsbS','tAuty','2014-10-2',null,'student');
insert into person values(331,'mbdg','ytuty','2010-10-12',null,'student');
insert into person values(332,'gmaassb','tuty','2011-10-20',null,'student');
insert into person values(333,'dbvasag','ytuty','2019-10-2',null,'student');
insert into person values(334,'gsvsbadxg','tuty','2018-10-2',null,'student');
insert into person values(335,'dacsaxg','ytuty','2017-10-12',null,'student');
insert into person values(336,'gdcaassxg','tuty','2000-10-20',null,'student');
insert into person values(337,'xgcsaasdxg','ytuty','1990-10-2',null,'student');
insert into person values(338,'xgcaas','tuty','2010-10-2',null,'student');
insert into person values(339,'dacsasg','ytuty','2010-10-12',null,'student');
insert into person values(340,'gxhbsafas','tuty','2010-10-20',null,'student');
insert into person values(341,'dhfxxsagdxg','ytuty','2010-10-2',null,'student');
insert into person values(342,'gdxhfxasg','tuty','2010-10-2',null,'student');
insert into person values(343,'dhcfxga','ytuty','2010-10-12',null,'student');
insert into person values(344,'gbdzxsag','tuty','2010-10-20',null,'student');
insert into person values(345,'xzgvxsdxg','ytuty','2010-10-2',null,'student');
insert into person values(346,'zxvxvaaxg','tuty','2010-10-2',null,'student');
insert into person values(347,'zvvdgpo','ytuty','2010-10-12',null,'student');
insert into person values(348,'zopgvv','tuty','2000-10-20',null,'student');
insert into person values(349,'zdpoaxvxg','ytuty','2000-10-2',null,'student');
insert into person values(350,'zgvpoxsadxg','tuty','2011-10-2',null,'student');
insert into person values(351,'zdavopxsxg','ytuty','2010-10-12',null,'student');
insert into person values(352,'gdzapoobvcsxg','tuty','2010-10-20',null,'student');
insert into person values(353,'xgodxg','ytuty','2010-10-2',null,'student');
insert into person values(354,'xvops','tuty','2010-10-2',null,'student');
insert into person values(355,'sopog','ytuty','2010-10-12',null,'student');
insert into person values(356,'asop','tuty','2010-10-20',null,'student');
insert into person values(357,'gop','ytuty','2010-10-2',null,'student');
insert into person values(358,'pxopg','tuty','2010-10-2',null,'student');
insert into person values(359,'gpop','ytuty','2010-10-12',null,'student');
insert into person values(360,'gdoppppxg','tuty','2010-10-20',null,'student');
insert into person values(361,'xglpopdxg','ytuty','2010-10-2',null,'student');
insert into person values(362,'xlppog','tuty','2010-10-2',null,'student');
insert into person values(363,'dlpopg','ytuty','2010-10-12',null,'student');
insert into person values(364,'pllopg','tuty','2010-10-20',null,'student');
insert into person values(365,'dlpaopg','ytuty','2010-10-2',null,'student');
insert into person values(366,'gsplapodxg','tuopty','2010-10-2',null,'student');
insert into person values(367,'daslpopxg','ytuty','2010-10-12',null,'student');
insert into person values(368,'gdlaspopxg','tuty','2010-10-20',null,'student');
insert into person values(369,'xlglpsopadxg','ytuty','2010-10-2',null,'student');
insert into person values(370,'plgapos','tuty','2010-10-2',null,'student');
insert into person values(371,'dplaopsg','ytuty','2010-10-12',null,'student');
insert into person values(372,'pullophbfas','tuty','2010-10-20',null,'student');
insert into person values(373,'duhlpofxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(374,'gudlhfopxtg','tuty','2010-10-2',null,'student');
insert into person values(375,'udhtlfxog','ytuty','2010-10-12',null,'student');
insert into person values(376,'ghytbdxg','tuty','2010-10-20',null,'student');
insert into person values(377,'xhttgvxdxg','ytuty','2010-10-2',null,'student');
insert into person values(378,'xhgtttttvxvxg','tuty','2010-10-2',null,'student');
insert into person values(379,'vrhgttvdg','ytuty','2010-10-12',null,'student');
insert into person values(380,'gvhggv','tuty','2000-10-20',null,'student');
insert into person values(381,'daghgtxvxg','ytuty','2000-10-2',null,'student');
insert into person values(382,'gvxhgrtgsadxg','tuty','2011-10-2',null,'student');
insert into person values(383,'daggvtxsxg','ytuty','2010-10-12',null,'student');
insert into person values(384,'gggth','tuty','2010-10-20',null,'student');
insert into person values(385,'xgtgrsavdxg','ytuty','2010-10-2',null,'student');
insert into person values(386,'xgtrgavs','tuty','2010-10-2',null,'student');
insert into person values(387,'dvtrgasg','ytuty','2010-10-12',null,'student');
insert into person values(388,'gxtfrvcas','tuty','2010-10-20',null,'student');
insert into person values(389,'deepakdxg','ytuty','2010-10-2',null,'student');
insert into person values(390,'gkkxg','tuty','2010-10-2',null,'student');
insert into person values(391,'dxgk','ytuty','2010-10-12',null,'student');
insert into person values(392,'gdkxg','tuty','2010-10-20',null,'student');
insert into person values(393,'xgkdxg','ytuty','2010-10-2',null,'student');
insert into person values(394,'xgkk','tuty','2010-10-2',null,'student');
insert into person values(395,'dgk','ytuty','2010-10-12',null,'student');
insert into person values(396,'gkk','tuty','2010-10-20',null,'student');
insert into person values(397,'dkkag','ytuty','2010-10-2',null,'student');
insert into person values(398,'gskkadxg','tuty','2010-10-2',null,'student');
insert into person values(399,'daksxg','ytuty','2010-10-12',null,'student');
insert into person values(400,'gdkasxg','tuty','2010-10-20',null,'student');
insert into person values(401,'xgksadxg','ytuty','2010-10-2',null,'student');
insert into person values(402,'xkgas','tuty','2010-10-2',null,'student');
insert into person values(403,'dkasg','ytuty','2010-10-12',null,'student');
insert into person values(404,'gkhbfas','tuty','2010-10-20',null,'student');
insert into person values(405,'dkhfxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(406,'gkkdhfxg','tuty','2010-10-2',null,'student');
insert into person values(407,'dhkkfxg','ytuty','2010-10-12',null,'student');
insert into person values(408,'gbdkkxg','tuty','2010-10-20',null,'student');
insert into person values(409,'gcggghcg','ytuty','2010-10-2',null,'student');
insert into person values(410,'xvxkkvxg','tuty','2010-10-2',null,'student');
insert into person values(411,'vvdgk','ytuty','2010-10-12',null,'student');
insert into person values(412,'gvkv','tuty','2000-10-20',null,'student');
insert into person values(413,'daxkvxg','ytuty','2000-10-2',null,'student');
insert into person values(414,'gvkxsadxg','tuty','2011-10-2',null,'student');
insert into person values(415,'dkkavxsxg','ytuty','2010-10-12',null,'student');
insert into person values(416,'gdakkbvcsxg','tuty','2010-10-20',null,'student');
insert into person values(417,'xgsakvdxg','ytuty','2010-10-2',null,'student');
insert into person values(418,'xgavks','tuty','2010-10-2',null,'student');
insert into person values(419,'dvaksg','ytuty','2010-10-12',null,'student');
insert into person values(420,'gpckas','tuty','2010-10-20',null,'student');
insert into person values(421,'dxgldxg','ytuty','2010-10-2',null,'student');
insert into person values(422,'gdpxg','tuty','2010-10-2',null,'student');
insert into person values(423,'dpxgkl','ytuty','2010-10-12',null,'student');
insert into person values(424,'gdpxlkg','tuty','2010-10-20',null,'student');
insert into person values(425,'xgpdlkxg','ytuty','2010-10-2',null,'student');
insert into person values(426,'xlkpg','tuty','2010-10-2',null,'student');
insert into person values(427,'dpklg','ytuty','2010-10-12',null,'student');
insert into person values(428,'plg','tuty','2010-10-20',null,'student');
insert into person values(429,'dklpag','ytuty','2010-10-2',null,'student');
insert into person values(430,'gslkpadxg','tuty','2010-10-2',null,'student');
insert into person values(431,'dalkspxg','ytuty','2010-10-12',null,'student');
insert into person values(432,'gdalkspxg','tuty','2010-10-20',null,'student');
insert into person values(433,'xgpslkadxg','ytuty','2010-10-2',null,'student');
insert into person values(434,'pgkas','tuty','2010-10-2',null,'student');
insert into person values(435,'dklpasg','ytuty','2010-10-12',null,'student');
insert into person values(436,'pulkhbfas','tuty','2010-10-20',null,'student');
insert into person values(437,'duhlkfxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(438,'gudlhfxg','tuty','2010-10-2',null,'student');
insert into person values(439,'udhkfxg','ytuty','2010-10-12',null,'student');
insert into person values(440,'gybldxg','tuty','2010-10-20',null,'student');
insert into person values(441,'xtgvlxdxg','ytuty','2010-10-2',null,'student');
insert into person values(442,'xtvxkvxg','tuty','2010-10-2',null,'student');
insert into person values(443,'vrvldg','ytuty','2010-10-12',null,'student');
insert into person values(444,'gvlkgv','tuty','2000-10-20',null,'student');
insert into person values(445,'dagklxvxg','ytxuty','2000-10-2',null,'student');
insert into person values(446,'gvxrlgsadxg','tcuty','2011-10-2',null,'student');
insert into person values(447,'dagvlxsxg','yctuty','2010-10-12',null,'student');
insert into person values(448,'gdralbvcsxg','tuty','2010-10-20',null,'student');
insert into person values(449,'xgrsajklvdxg','ytcuty','2010-10-2',null,'student');
insert into person values(450,'xrgkjavs','tuty','2010-10-2',null,'student');
insert into person values(451,'dvkrasg','ytcuty','2010-10-12',null,'student');
insert into person values(452,'gkjvcas','tucty','2017-10-20',null,'student');
insert into person values(453,'dkhdxgdxg','ytuty','2017-10-2',null,'student');
insert into person values(454,'gdkjxsg','tuty','2012-10-2',null,'student');
insert into person values(455,'dxkgaA','ytcuty','2013-10-12',null,'student');
insert into person values(456,'gdjkmxgS','tuty','2017-10-20',null,'student');
insert into person values(457,'xbkgdxAZg','yctuty','2020-10-2',null,'student');
insert into person values(458,'xgkjAmbS','tAuty','2014-10-2',null,'student');
insert into person values(459,'mbdkkg','ytuty','2010-10-12',null,'student');
insert into person values(460,'gmkb','tuty','2011-10-20',null,'student');
insert into person values(461,'dbkvag','ytuty','2019-10-2',null,'student');
insert into person values(462,'gskjvbadxg','tuty','2018-10-2',null,'student');
insert into person values(463,'dacksxg','ytuty','2017-10-12',null,'student');
insert into person values(464,'gdckjasxg','tuty','2000-10-20',null,'student');
insert into person values(465,'xgcskjkadxg','ytuty','1990-10-2',null,'student');
insert into person values(466,'xgckjas','tuty','2010-10-2',null,'student');
insert into person values(467,'dajkcsg','ytuty','2010-10-12',null,'student');
insert into person values(468,'gxkhbfas','tuty','2010-10-20',null,'student');
insert into person values(469,'dhkjfxxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(470,'gdxkjhfxg','tuty','2010-10-2',null,'student');
insert into person values(471,'dhcfkxg','ytuty','2010-10-12',null,'student');
insert into person values(472,'gbdzkxg','tuty','2010-10-20',null,'student');
insert into person values(473,'xzgvkxdxg','ytuty','2010-10-2',null,'student');
insert into person values(474,'zxvxijvxg','tuty','2010-10-2',null,'student');
insert into person values(475,'zvvdiog','ytuty','2010-10-12',null,'student');
insert into person values(476,'zgvov','tuty','2000-10-20',null,'student');
insert into person values(477,'zdaioxvxg','ytuty','2000-10-2',null,'student');
insert into person values(478,'zgvxoisadxg','tuty','2011-10-2',null,'student');
insert into person values(479,'zdavxoisxg','ytuty','2010-10-12',null,'student');
insert into person values(480,'gdzabvoicsxg','tuty','2010-10-20',null,'student');
insert into person values(481,'xgdioxg','ytuty','2010-10-2',null,'student');
insert into person values(482,'xvios','tuty','2010-10-2',null,'student');
insert into person values(483,'soig','ytuty','2010-10-12',null,'student');
insert into person values(484,'aois','tuty','2010-10-20',null,'student');
insert into person values(485,'goii','ytuty','2010-10-2',null,'student');
insert into person values(486,'poixg','tuty','2010-10-2',null,'student');
insert into person values(487,'giop','ytuty','2010-10-12',null,'student');
insert into person values(488,'gdoipppxg','tuty','2010-10-20',null,'student');
insert into person values(489,'xgloipdxg','ytuty','2010-10-2',null,'student');
insert into person values(490,'xlfhg','tuty','2010-10-2',null,'student');
insert into person values(491,'dlpgfh','ytuty','2010-10-12',null,'student');
insert into person values(492,'pllgfh','tuty','2010-10-20',null,'student');
insert into person values(493,'dlpahfg','ytuty','2010-10-2',null,'student');
insert into person values(494,'gsplhfadxg','tuty','2010-10-2',null,'student');
insert into person values(495,'daslhfpxg','ytuty','2010-10-12',null,'student');
insert into person values(496,'gdlahfspxg','tuty','2010-10-20',null,'student');
insert into person values(497,'xlglhfpsadxg','ytuty','2010-10-2',null,'student');
insert into person values(498,'plghfas','tuty','2010-10-2',null,'student');
insert into person values(499,'dplfhasg','ytuty','2010-10-12',null,'student');
insert into person values(500,'pullhffhhbfas','tuty','2010-10-20',null,'student');
insert into person values(501,'duhlfxghfdxg','ytuty','2010-10-2',null,'student');
insert into person values(502,'gudlhfhfxg','tuty','2010-10-2',null,'student');
insert into person values(503,'udhlffhxg','ytuty','2010-10-12',null,'student');
insert into person values(504,'ghybhfdxg','tuty','2010-10-20',null,'student');
insert into person values(505,'hvhvhv','ytuty','2010-10-2',null,'student');
insert into person values(506,'xhgfhtvxvxg','tuty','2010-10-2',null,'student');
insert into person values(507,'vrhgfhvdg','ytuty','2010-10-12',null,'student');
insert into person values(508,'gvhggfhv','tuty','2000-10-20',null,'student');
insert into person values(509,'daghgfhxvxg','ytuty','2000-10-2',null,'student');
insert into person values(510,'fgdxg','tuty','2011-10-2',null,'student');
insert into person values(520,'dvsxg','ytuty','2010-10-12',null,'student');
insert into person values(521,'pgfphf','tuty','2010-10-20',null,'student');
insert into person values(522,'dxgfhf','ytuty','2010-10-2',null,'student');
insert into person values(523,'dhfgavs','tuty','2010-10-2',null,'student');
insert into person values(524,'ddvrghfasg','ytuty','2010-10-12',null,'student');
insert into person values(525,'gxdfrfhvcas','tuty','2010-10-20',null,'student');
insert into person values(526,'dxgjdfhxg','ytuty','2010-10-2',null,'student');
insert into person values(527,'gdxgfhj','tuty','2010-10-2',null,'student');
insert into person values(528,'dxgjfh','ytuty','2010-10-12',null,'student');
insert into person values(529,'gdxghfj','tuty','2010-10-20',null,'student');
insert into person values(530,'xgdxjhfg','ytuty','2010-10-2',null,'student');
insert into person values(531,'xgjhf','thfuty','2010-10-2',null,'student');
insert into person values(532,'dgjjfh','ytuty','2010-10-12',null,'student');
insert into person values(533,'gjhfh','thffhuty','2010-10-20',null,'student');
insert into person values(534,'dahfhjg','ytfhuty','2010-10-2',null,'student');
insert into person values(535,'gsajhdhfxg','tufhty','2010-10-2',null,'student');
insert into person values(536,'dasjhxg','ytfhuty','2010-10-12',null,'student');
insert into person values(537,'gdahjsxg','tuty','2010-10-20',null,'student');
insert into person values(538,'xgsajgdxg','ythfuty','2010-10-2',null,'student');
insert into person values(539,'xgasjz','tutfhy','2010-10-2',null,'student');
insert into person values(540,'daszgj','ytfhuty','2010-10-12',null,'student');
insert into person values(541,'ghbfjzas','hftuty','2010-10-20',null,'student');
insert into person values(542,'dhfzxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(543,'gdhfzxg','tufhty','2010-10-2',null,'student');
insert into person values(544,'dhfxzg','ytuhfty','2010-10-12',null,'student');
insert into person values(545,'gbdxgz','tuthfy','2010-10-20',null,'student');
insert into person values(546,'xgvxdzzdxg','yhftuty','2010-10-2',null,'student');
insert into person values(547,'xvxvxgzd','tuthfy','2010-10-2',null,'student');
insert into person values(548,'vvdgz','ytutfhy','2010-10-12',null,'student');
insert into person values(549,'gvvz','tutfhy','2000-10-20',null,'student');
insert into person values(550,'daxvzxg','yhftuty','2000-10-2',null,'student');
insert into person values(551,'gvxsazdddxgfh','tuty','2011-10-2',null,'student');
insert into person values(552,'davxsxgs','ytuhfty','2010-10-12',null,'student');
insert into person values(553,'gdabvcsxsfg','tfhuty','2010-10-20',null,'student');
insert into person values(554,'xgsavdxgf','ytufhty','2010-10-2',null,'student');
insert into person values(555,'xgavss','tudgty','2010-10-2',null,'student');
insert into person values(556,'dvasgs','ytudgty','2010-10-12',null,'student');
insert into person values(557,'gpcasz','tutdgy','2010-10-20',null,'student');
insert into person values(558,'dxgdxcg','ytugdty','2010-10-2',null,'student');
insert into person values(559,'gdpxgvc','tuty','2010-10-2',null,'student');
insert into person values(560,'dpxfcg','ytutyf','2010-10-12',null,'student');
insert into person values(561,'gdpgxvg','tuty','2010-10-20',null,'student');
insert into person values(562,'xgpxvcdxg','ytuty','2010-10-2',null,'student');
insert into person values(563,'xpgcgv','tuty','2010-10-2',null,'student');
insert into person values(564,'dpgcvx','ytuty','2010-10-12',null,'student');
insert into person values(565,'pbcbgv','tuty','2010-10-20',null,'student');
insert into person values(566,'dpcbxaxg','ytuty','2010-10-2',null,'student');
insert into person values(567,'gspvxadxg','tuty','2010-10-2',null,'student');
insert into person values(568,'dacbsxzpxg','ytuty','2010-10-12',null,'student');
insert into person values(569,'gdabcsqpxg','tuty','2010-10-20',null,'student');
insert into person values(570,'xgpsbccadqxg','ytuty','2010-10-2',null,'student');
insert into person values(571,'pgaswbcq','tuty','2010-10-2',null,'student');
insert into person values(572,'dpasgw','ytuty','2010-10-12',null,'student');
insert into person values(573,'puhbbcfaqws','tuty','2010-10-20',null,'student');
insert into person values(574,'qxg','ytuty','2010-10-2',null,'student');
insert into person values(575,'gudhfxqg','tuty','2010-10-2',null,'student');
insert into person values(576,'qudhfxqg','ytuty','2010-10-12',null,'student');
insert into person values(577,'gybdxgre','tuty','2010-10-20',null,'student');
insert into person values(578,'xaqtgvxdxeg','ytuty','2010-10-2',null,'student');
insert into person values(579,'xtvxavxge','tuty','2010-10-2',null,'student');
insert into person values(580,'vrvqdg','ytuty','2010-10-12',null,'student');
insert into person values(581,'gwvgqv','tuty','2000-10-20',null,'student');
insert into person values(582,'dawgqxvxg','ytxuty','2000-10-2',null,'student');
insert into person values(583,'gvxwaqrgsadxg','tcuty','2011-10-2',null,'student');
insert into person values(584,'dagvsaqxsxg','yctuty','2010-10-12',null,'student');
insert into person values(585,'gdrabvaqcsxg','tuty','2010-10-20',null,'student');
insert into person values(586,'xgrsasaqvdxg','ytcuty','2010-10-2',null,'student');
insert into person values(587,'xrgavsaaq','tuty','2010-10-2',null,'student');
insert into person values(588,'dvaraqsg','ytcuty','2010-10-12',null,'student');
insert into person values(589,'gvacaqas','tucty','2017-10-20',null,'student');
insert into person values(590,'dhadxgqadxg','ytuty','2017-10-2',null,'student');
insert into person values(591,'gdaaxsqag','tuty','2012-10-2',null,'student');
insert into person values(592,'dxagaqA','ytcuty','2013-10-12',null,'student');
insert into person values(593,'gdmssaqaxgS','tuty','2017-10-20',null,'student');
insert into person values(594,'xbgdsaqaxAZg','yctuty','2020-10-2',null,'student');
insert into person values(595,'xgAmsbS','tAuty','2014-10-2',null,'student');
insert into person values(596,'mbdqag','ytuty','2010-10-12',null,'student');
insert into person values(597,'gmaaaqssb','tuty','2011-10-20',null,'student');
insert into person values(598,'dbvasqaqaag','ytuty','2019-10-2',null,'student');
insert into person values(599,'gsvsbadqaxg','tuty','2018-10-2',null,'student');
insert into person values(600,'dacsaxaqg','ytuty','2017-10-12',null,'student');
insert into person values(601,'gdcaasqasxg','tuty','2000-10-20',null,'student');
insert into person values(602,'xgcsaaaqsdxg','ytuty','1990-10-2',null,'student');
insert into person values(603,'xgcaaqas','tuty','2010-10-2',null,'student');
insert into person values(604,'dacsasag','ytuty','2010-10-12',null,'student');
insert into person values(605,'gxhbsaqfas','tuty','2010-10-20',null,'student');
insert into person values(606,'dhfxxsaagdxg','ytuty','2010-10-2',null,'student');
insert into person values(607,'gdxhfxqasg','tuty','2010-10-2',null,'student');
insert into person values(608,'dhcfxgaa','ytuty','2010-10-12',null,'student');
insert into person values(609,'gbdzxsaag','tuty','2010-10-20',null,'student');
insert into person values(610,'xzgvxsadxg','ytuty','2010-10-2',null,'student');
insert into person values(611,'zxvxvaqaxg','tuty','2010-10-2',null,'student');
insert into person values(612,'zvvdgpoq','ytuty','2010-10-12',null,'student');
insert into person values(613,'zopgvvaq','tuty','2000-10-20',null,'student');
insert into person values(614,'zdpoaxvaqxg','ytuty','2000-10-2',null,'student');
insert into person values(615,'adxg','tuty','2011-10-2',null,'student');
insert into person values(616,'zdavopxsxg','ytuty','2010-10-12',null,'student');
insert into person values(617,'qgdzapoobvcsxg','tuty','2010-10-20',null,'student');
insert into person values(618,'xqgodxg','ytuty','2010-10-2',null,'student');
insert into person values(619,'xvaops','tuty','2010-10-2',null,'student');
insert into person values(620,'sopoaqg','ytuty','2010-10-12',null,'student');
insert into person values(621,'asopq','tuty','2010-10-20',null,'student');
insert into person values(622,'gopa','ytuty','2010-10-2',null,'student');
insert into person values(623,'pxoaqpqg','tuty','2010-10-2',null,'student');
insert into person values(624,'gpoqap','ytuty','2010-10-12',null,'student');
insert into person values(625,'gdoaqppppxg','tuty','2010-10-20',null,'student');
insert into person values(626,'xglpopdxg','ytuty','2010-10-2',null,'student');
insert into person values(627,'xlpaqpog','tuty','2010-10-2',null,'student');
insert into person values(628,'dlpqopg','ytuty','2010-10-12',null,'student');
insert into person values(629,'pllaqopg','tuty','2010-10-20',null,'student');
insert into person values(630,'dlpaaopg','ytuty','2010-10-2',null,'student');
insert into person values(631,'gspalqapodxg','tuopty','2010-10-2',null,'student');
insert into person values(632,'daqslpopxg','ytuty','2010-10-12',null,'student');
insert into person values(633,'gdlqaaaspopxg','tuty','2010-10-20',null,'student');
insert into person values(634,'xlglaqpsopadxg','ytuty','2010-10-2',null,'student');
insert into person values(635,'plgapaqos','tuty','2010-10-2',null,'student');
insert into person values(636,'dplaoapsg','ytuty','2010-10-12',null,'student');
insert into person values(637,'pulloqphbfas','tuty','2010-10-20',null,'student');
insert into person values(638,'duhlapofxgdxg','ytuty','2010-10-2',null,'student');
insert into person values(639,'gudlqhfopxtg','tuty','2010-10-2',null,'student');
insert into person values(640,'udhtalfxog','ytuty','2010-10-12',null,'student');
insert into person values(641,'ghytaqbdxg','tuty','2010-10-20',null,'student');
insert into person values(642,'xhttgaqvxdxg','ytuty','2010-10-2',null,'student');
insert into person values(643,'xhgttaqtttvxvxg','tuty','2010-10-2',null,'student');
insert into person values(644,'vrhgttaqvdg','ytuty','2010-10-12',null,'student');
insert into person values(645,'gvhgqgv','tuty','2000-10-20',null,'student');
insert into person values(646,'daghqagtxvxg','ytuty','2000-10-2',null,'student');
insert into person values(647,'gvxhghjqrtgsadxg','tuty','2011-10-2',null,'student');
insert into person values(648,'daggvtjxsxg','ytuty','2010-10-12',null,'student');
insert into person values(649,'ggghjth','tuty','2010-10-20',null,'student');
insert into person values(650,'xgtgjrsavdxg','ytuty','2010-10-2',null,'student');
insert into person values(651,'xgtrhjgavs','tuty','2010-10-2',null,'student');
insert into person values(652,'dvtrgjasg','ytuty','2010-10-12',null,'student');
insert into person values(653,'gxtfrhjvcas','tuty','2010-10-20',null,'student');
-- Insert data into the Department table.
-- Insert data into the Department table.
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (1, 'Engineering', 350000.00, '2007-09-01', 2);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (2, 'English', 120000.00, '2007-09-01', 6);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (4, 'Economics', 200000.00, '2007-09-01', 4);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (7, 'Mathematics', 250000.00, '2007-09-01', 3);
GO



-- Insert data into the Course table.
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (1050, 'Chemistry', 4, 1);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (1061, 'Physics', 4, 1);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (1045, 'Calculus', 4, 7);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (2030, 'Poetry', 2, 2);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (2021, 'Composition', 3, 2);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (2042, 'Literature', 4, 2);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (4022, 'Microeconomics', 3, 4);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (4041, 'Macroeconomics', 3, 4);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (4061, 'Quantitative', 2, 4);
INSERT INTO dbo.Course (CourseID, Title, Credits, DepartmentID)
VALUES (3141, 'Trigonometry', 4, 7);
GO

-- Insert data into the OnlineCourse table.
INSERT INTO dbo.OnlineCourse (CourseID, URL)
VALUES (2030, 'http://www.fineartschool.net/Poetry');
INSERT INTO dbo.OnlineCourse (CourseID, URL)
VALUES (2021, 'http://www.fineartschool.net/Composition');
INSERT INTO dbo.OnlineCourse (CourseID, URL)
VALUES (4041, 'http://www.fineartschool.net/Macroeconomics');
INSERT INTO dbo.OnlineCourse (CourseID, URL)
VALUES (3141, 'http://www.fineartschool.net/Trigonometry');

--Insert data into OnsiteCourse table.
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (1050, '123 Smith', 'MTWH', '11:30');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (1061, '234 Smith', 'TWHF', '13:15');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (1045, '121 Smith','MWHF', '15:30');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (4061, '22 Williams', 'TH', '11:15');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (2042, '225 Adams', 'MTWH', '11:00');
INSERT INTO dbo.OnsiteCourse (CourseID, Location, Days, [Time])
VALUES (4022, '23 Williams', 'MWF', '9:00');

-- Insert data into the CourseInstructor table.
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (1050, 1);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (1061, 31);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (1045, 5);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (2030, 4);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (2021, 27);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (2042, 25);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (4022, 18);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (4041, 32);
INSERT INTO dbo.CourseInstructor(CourseID, PersonID)
VALUES (4061, 34);
GO

--Insert data into the OfficeAssignment table.
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (1, '17 Smith');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (4, '29 Adams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (5, '37 Williams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (18, '143 Smith');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (25, '57 Adams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (27, '271 Williams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (31, '131 Smith');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (32, '203 Williams');
INSERT INTO dbo.OfficeAssignment(InstructorID, Location)
VALUES (34, '213 Smith');

-- Insert data into the StudentGrade table.
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 2, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2030, 2, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 3, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2030, 3, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 6, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2042, 6, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 7, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2042, 7, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2021, 8, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (2042, 8, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 9, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 10, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 11, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 12, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 12, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 14, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 13, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 13, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 14, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 15, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 16, 2);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 17, null);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 19, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 20, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 21, 2);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 22, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4041, 22, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4061, 22, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (4022, 23, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1045, 23, 1.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 24, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 25, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1050, 26, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 26, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 27, 3);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1045, 28, 2.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1050, 28, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 29, 4);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1050, 30, 3.5);
INSERT INTO dbo.StudentGrade (CourseID, StudentID, Grade)
VALUES (1061, 30, 4);
GO

select * from dbo.Course
select * from  dbo.StudentGrade
select * from dbo.OfficeAssignment
select * from dbo.CourseInstructor
select * from dbo.OnsiteCourse
select * from dbo.OnlineCourse
select * from dbo.Course
select * from dbo.Department
select * from dbo.Person
select * from Department













