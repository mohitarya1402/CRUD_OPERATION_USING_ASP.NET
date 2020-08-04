 


/*&&&&&&&&&&&&&&&&&&&&&&&&&&&& --database name is schoolmicrosoft -------&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/ 
 --department table 1
create table department(
departmentid int NOT NULL PRIMARY KEY ,
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
/*CREATE PROCEDURE  InsertOfficeAssignment
@InstructorID int,
@Location nvarchar(50)
AS
INSERT INTO dbo.OfficeAssignment (InstructorID, Location)
VALUES (@InstructorID, @Location);
IF @@ROWCOUNT > 0
BEGIN
SELECT [Timestamp] FROM OfficeAssignment
WHERE InstructorID=@InstructorID;
END*/
IF NOT EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N[dbo].[InsertOfficeAssignment])
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


INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (1, 'Abercrombie', 'Kim', '1995-03-11', null, 'Instructor');
INSERT INTO dbo.Person (PersonID, LastName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (2, 'Barzdukas', 'Gytis', null, '2005-09-01', 'Student');
INSERT INTO dbo.Person (PersonID, firName, FirstName, HireDate, EnrollmentDate, Discriminator)
VALUES (3, 'Justice', 'Peggy', null, '2001-09-01', 'Student');

insert into person values(4,'mahobia','daksha','2020-12-5',null,'student');
insert into person values(5,'saanvi','mahobia','2020-12-6',null,'student');
insert into person values(6,'mahobia','daksha','2020-12-5',null,'student');
insert into person values(7,'saanvi','mahobia','2020-12-6',null,'student');
insert into person values(8,'minu','mahobia','2020-12-8',null,'student');
insert into person values(9,'mantu','mahobia','2020-12-9',null,'student');
insert into person values(10,'mahobia','ravi','2020-12-10',null,'student');
insert into person values(11,'saanvi','mahobia','2020-12-16',null,'student');
insert into person values(12,'prem','daksha','2020-12-15',null,'student');
insert into person values(13,'raju','mahobia','2020-12-16',null,'student');
insert into person values(14,'john ','daksha','2020-12-05',null,'student');
insert into person values(15,'willam','mahobia','2020-12-06',null,'student');
insert into person values(16,'kiran','mahobia','2020-12-08',null,'student');
insert into person values(17,'mantu','mahobia','2020-12-09',null,'student');
insert into person values(18,'bathri','ravi','2020-12-11',null,'student');
insert into person values(19,'shubham','mahobia','2020-12-1',null,'student');
insert into person values(20,'lord','daksha','2020-12-15',null,'student');
insert into person values(21,'dilip','mahobia','2020-12-09',null,'student');
insert into person values(22,'nike','daksha','2020-12-05',null,'student');
insert into person values(23,'mike ','robertson','2020-12-11',null,'student');
insert into person values(24,'robert','will','2020-12-8',null,'student');
insert into person values(25,'bruce','kavin','2020-12-14',null,'student');
insert into person values(26,'draco','harry','2020-12-11',null,'student');
insert into person values(27,'billy','jr','2020-12-26',null,'student');
insert into person values(28,'smith','johnson','2020-12-05',null,'student');
insert into person values(29,'sachin','rao','2020-12-26',null,'student');
insert into person values(30,'rao','hament','2020-12-14',null,'student');
insert into person values(31,'aaditya','mahobia','2020-12-26',null,'student');
insert into person values(32,'krishna','rao','2020-12-26',null,'student');
insert into person values(33,'kavin','willam','2020-12-10',null,'student');
insert into person values(34,'brush',' norm ','2020-12-21',null,'student');
insert into person values(35,'smack','smith','2020-12-20',null,'student');
insert into person values(36,'george','admson','2020-12-25',null,'student');
insert into person values(37,'alcock','leslie','2020-12-01',null,'student');
insert into person values(38,'mick','admson','2020-12-17',null,'student');
insert into person values(39,'russell','rao','2020-12-26',null,'student');
insert into person values(40,'thomas','muller','2020-11-19',null,'student');
insert into person values(41,'marcelo','barker','2020-10-24',null,'student');
insert into person values(42,'marcelo','romeno','2020-1-11',null,'student');
insert into person values(43,'adam','willson','2020-10-05',null,'student');
insert into person values(44,'king ','robin','2020-02-18',null,'student');
insert into person values(45,'romno','jr','2020-12-16',null,'student');
insert into person values(46,'billy ','jr','2020-09-05',null,'student');
insert into person values(47,'willam','wallt','2020-02-06',null,'student');
insert into person values(48,'david','son','2020-03-11',null,'student');
insert into person values(49,'jack','robertson','2020-15-28',null,'student');
insert into person values(50,'philip','barker','2020-12-21',null,'student');
insert into person values(51,'edward','wales','2020-12-18',null,'student');
insert into person values(52,'lord','willam','2020-12-25',null,'student');
insert into person values(53,'watson','barko','2020-06-05',null,'student');
insert into person values(54,'bin','willson','2020-02-20',null,'student');
insert into person values(55,'adam ','robertson','2020-02-11',null,'student');
insert into person values(56,'robert','will','2020-12-18',null,'student');
insert into person values(57,'katty','willam','2020-12-24',null,'student');
insert into person values(58,'backam','rao','2020-12-31',null,'student');
insert into person values(59,'robin','jr','2020-12-26',null,'student');
insert into person values(60,'kimm','johnson','2020-12-25',null,'student');
insert into person values(61,'harshit','ram','2020-12-28',null,'student');
insert into person values(62,'avishank','rathod','2020-12-04',null,'student');
insert into person values(63,'deepak','nepali','2020-12-26',null,'student');
insert into person values(64,'amar ','singh','2020-10-06',null,'student');
insert into person values(65,'harmeet','rao','2020-11-11',null,'student');
insert into person values(66,'aman',' makin ','2020-10-30',null,'student');
insert into person values(67,'amelia','rose ','2020-12-03',null,'student');
insert into person values(68,'oliva','rossam','2020-12-31',null,'student');
insert into person values(69,'eva','philp','2020-12-26',null,'student');
insert into person values(70,'jessica','nore ','2020-02-5',null,'student');
insert into person values(71,'shlena','rombo','2020-01-16',null,'student');
insert into person values(72,'sofia','hussun','2020-12-31',null,'student');
insert into person values(73,'baba','hussun','2020-12-19',null,'student');
insert into person values(74,'molly','rao','2020-12-03',null,'student');
insert into person values(75,'alice','jhon','2020-12-26',null,'student');
insert into person values(76,'max','robinson','2020-08-03',null,'student');
insert into person values(77,'dale','smith ','2020-10-26',null,'student');
insert into person values(78,'osama  ','hussan ','2020-12-15',null,'student');
insert into person values(79,'jhonthan','marcos','2020-11-06',null,'student');
insert into person values(80,'mortal','raman','2020-12-05',null,'student');
insert into person values(81,'amit','shing','2020-12-31',null,'student');
insert into person values(82,'srinvas','rao','2020-12-01',null,'student');
insert into person values(83,'monu','mahobia','2020-12-01',null,'student');
insert into person values(84,'maron','five','2020-12-10',null,'student');
insert into person values(85,'chintu','raman ','2020-12-08',null,'student');
insert into person values(86,'richard','willamson','2020-06-12',null,'student');
insert into person values(87,'rahul','kummar','2020-12-15',null,'student');
insert into person values(88,'sandeep','bhalavi','2020-12-18',null,'student');
insert into person values(89,'shrikant','dehariya','2020-11-28',null,'student');
insert into person values(90,'Maria','willson','2020-12-11',null,'student');
insert into person values(91,'victoria','rossam','2020-12-26',null,'student');
insert into person values(92,'gauraV','sing','2020-12-07',null,'student');
insert into person values(93,'justin','brack','2020-12-26',null,'student');
insert into person values(94,'ronaldo','madrid','2020-07-07',null,'student');
insert into person values(95,'sara','kim','2020-08-06',null,'student');
insert into person values(96,'sk','rao','2020-12-06',null,'student');
insert into person values(97,'tilly ','willam','2020-12-10',null,'student');
insert into person values(98,'sammy',' norm ','2020-12-21',null,'student');
insert into person values(99,'aaja','reddy','2020-12-20',null,'student');
insert into person values(100,'sai ','reddy','2020-12-25',null,'student');
insert into person values(101,'alster','smith','2020-12-01',null,'student');
insert into person values(102,'donald','young ','2020-12-17',null,'student');
insert into person values(103,'dean ','ambrose ','2020-12-26',null,'student');
insert into person values(104,'romin','muller','2020-11-19',null,'student');
insert into person values(105,'seth','rollins','2020-10-24',null,'student');
insert into person values(106,'diago','romeno','2020-1-11',null,'student');
insert into person values(107,'kane','willson','2020-10-05',null,'student');
insert into person values(108,'lilly ','james','2020-02-18',null,'student');
insert into person values(109,'roonye','smith','2020-12-16',null,'student'); 
insert into person values(110,'david ','backam','2020-09-05',null,'student');
insert into person values(111,'ricky','wallter','2020-02-06',null,'student');
insert into person values(112,'andreo','will','2020-03-11',null,'student');
insert into person values(113,'shree','raman','2020-15-28',null,'student');
insert into person values(114,'mayank','barker','2020-12-21',null,'student');
insert into person values(115,'crish','wales','2020-12-18',null,'student');
insert into person values(116,'daran','william','2020-12-25',null,'student');
insert into person values(117,'shane','watson','2020-06-05',null,'student');
insert into person values(118,'ravi','willson','2020-02-20',null,'student');
insert into person values(119,'john ','robertson','2020-02-11',null,'student');
insert into person values(120,'robert','petenson','2020-12-18',null,'student');
insert into person values(121,'archer','willam','2020-12-24',null,'student');
insert into person values(122,'sangeta','rao','2020-12-31',null,'student');
insert into person values(123,'william','jr','2020-12-26',null,'student');
insert into person values(124,'david','johnson','2020-12-25',null,'student');
insert into person values(125,'dilip','ram','2020-12-28',null,'student');
insert into person values(126,'ashok','rathod','2020-12-04',null,'student');
insert into person values(127,'kamal','singh','2020-12-26',null,'student');
insert into person values(128,'harmeet ','singh','2020-10-06',null,'student');
insert into person values(129,'pratap','rao','2020-11-11',null,'student');
insert into person values(130,'denesh',' yadav ','2020-10-30',null,'student');
insert into person values(131,'arman','khan','2020-12-10',null,'student');


select * from person

-- Insert data into the Department table.
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (1, 'Engineering', 350000.00, '2007-09-01', 2);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (2, 'English', 120000.00, '2007-09-01', 6);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (4, 'Economics', 200000.00, '2007-09-01', 4);
INSERT INTO dbo.Department (DepartmentID, [Name], Budget, StartDate, Administrator)
VALUES (7, 'Mathematics', 250000.00, '2007-09-01', 3);




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




select * from  dbo.Course
select * from  dbo.StudentGrade
select * from dbo.OfficeAssignment
select * from dbo.CourseInstructor
select * from dbo.OnsiteCourse
select * from dbo.OnlineCourse
select * from dbo.Course
select * from dbo.Department
select * from dbo.Person
select * from Department

