--create database MvcCRUD
create table department(
departmentid int NOT NULL PRIMARY KEY IDENTITY(1,1),
NAME nvarchar(25),
budget nvarchar(25),
startdate datetime not null,
administrator int 
)

 -- Create the Person table.2

 create table person(
 personid  int NOT NULL PRIMARY KEY,
 firstname nvarchar(25),
 lastname nvarchar(25),
 HireDate datetime NULL,
EnrollmentDate datetime NULL,
Discriminator nvarchar(50) NOT NULL
)

-- Create the OnsiteCourse table.3

CREATE TABLE OnsiteCourse
(
CourseID int NOT NULL PRIMARY KEY,
Location nvarchar(50) NOT NULL,
Days nvarchar(50) NOT NULL,
Time smalldatetime NOT NULL,
)


-- Create the OnlineCourse table.4
 
 CREATE TABLE OnlineCourse
 (
 CourseID int NOT NULL PRIMARY KEY,
URL nvarchar(100) NOT NULL,
)


--Create the StudentGrade table.5


CREATE TABLE StudentGrade(
EnrollmentID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
CourseID int NOT NULL,
StudentID int NOT NULL,
Grade decimal(3, 2) NULL
)

-- Create the CourseInstructor table.6

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



-- Create the Course table.7

CREATE TABLE Course
(
CourseID int NOT NULL   PRIMARY KEY ,
title varchar(100) NOT NULL,
Credits int NOT NULL,
DepartmentID int NOT NULL
)


-- Create the OfficeAssignment table.8

CREATE TABLE OfficeAssignment(
InstructorID int NOT NULL  PRIMARY KEY ,
Location nvarchar(50) NOT NULL  ,
Timestamp timestamp NOT NULL
)


-- Define the relationship between OnsiteCourse and Course.
ALTER TABLE OnsiteCourse
ADD FOREIGN KEY (CourseID) REFERENCES Course(CourseID);




-- Define the relationship between OnlineCourse and Course.
ALTER TABLE OnlineCourse
ADD FOREIGN KEY (CourseID) REFERENCES Course(CourseID);



-- Define the relationship between StudentGrade and Course.

ALTER TABLE StudentGrade
ADD FOREIGN KEY (CourseID) REFERENCES Course(CourseID);

--Define the relationship between StudentGrade and Student.

ALTER TABLE StudentGrade
ADD FOREIGN KEY (StudentID) REFERENCES Person(PersonID);

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


ALTER TABLE CourseInstructor
ADD FOREIGN KEY (PersonID) REFERENCES Person(PersonID);



-- Define the relationship between Course and Department.

ALTER TABLE Course
ADD FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID);



-- Create InsertOfficeAssignment stored procedure.
Create Procedure  InsertOfficeAssignment
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



--Create the UpdateOfficeAssignment stored procedure.

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




-- Create the DeleteOfficeAssignment stored procedure.


CREATE PROCEDURE [dbo].[DeleteOfficeAssignment]
@InstructorID int
AS
DELETE FROM OfficeAssignment
WHERE InstructorID=@InstructorID;


-- Create the DeletePerson stored procedure.
 
 CREATE PROCEDURE  DeletePerson
@PersonID int
AS
DELETE FROM Person WHERE PersonID = @PersonID;
 

 
-- Create the UpdatePerson stored procedure.

CREATE PROCEDURE UpdatePerson
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




-- Create the InsertPerson stored procedure.


CREATE PROCEDURE InsertPerson
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




-- Create GetStudentGrades stored procedure.

CREATE PROCEDURE GetStudentGrades
@StudentID int
AS
SELECT EnrollmentID, Grade, CourseID, StudentID FROM dbo.StudentGrade
WHERE StudentID = @StudentID





-- Create GetDepartmentName stored procedure.

CREATE PROCEDURE GetDepartmentName
@ID int,
@Name nvarchar(50) OUTPUT
AS
SELECT @Name = Name FROM Department
WHERE DepartmentID = @ID


-- Insert data into the Person table.

/*insert into person values('mahobia','daksha','2020-12-5',null,'student');
insert into person values('saanvi','mahobia','2020-12-6',null,'student');
insert into person values('mahobia','daksha','2020-12-5',null,'student');
insert into person values('saanvi','mahobia','2020-12-6',null,'student');
insert into person values('minu','mahobia','2020-12-8',null,'student');
insert into person values('mantu','mahobia','2020-12-9',null,'student');
insert into person values('mahobia','ravi','2020-12-10',null,'student');
insert into person values('saanvi','mahobia','2020-12-16',null,'student');
insert into person values('prem','daksha','2020-12-15',null,'student');*/











