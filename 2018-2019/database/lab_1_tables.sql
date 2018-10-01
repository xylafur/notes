/*
    PLEASE NOTE: THE "DROP TABLE CASCADE CONSTRAINTS" LINES HAVE BEEN REMOVED.
    BEFORE RUNNING THIS CODE, PLEASE DROP ALL RELEVANT TABLES.
*/

CREATE TABLE Tutor(
    TutorKey INTEGER PRIMARY KEY,
    TutorLastName CHAR(20),
    TutorFirstName CHAR(20),
    TutorPhone INTEGER,
    TutorEmail CHAR(30),
    TutorHireDate DATE,
    TutorStatus CHAR(10)
);

INSERT INTO Tutor VALUES(
    980010000, 'Roberts', 'Martha', 2065551467, 'mroberts@yahoo.com', DATE '2010-01-06', 'Active');
INSERT INTO Tutor VALUES(
    980010001, 'Brown', 'Susan', 2065553528, 'Sb4@hotmail.com', DATE '2009-02-01', 'Active');
INSERT INTO Tutor VALUES(
    980010002, 'Foster', 'Daniel', 2065553490, 'Foster32@aol.com', DATE '2009-02-12', 'Active');
INSERT INTO Tutor VALUES(
    980010003, 'Anderson', 'Nathan', 2065556320, NULL, DATE '2009-03-02', 'Inactive');
INSERT INTO Tutor VALUES(
    980010004, 'Lewis', 'Ginger', 2065552985, 'ginger@hotmail.com', DATE '2009-03-15', 'Active');

CREATE TABLE Course(
    CourseKey CHAR(6) PRIMARY KEY,
    CourseName CHAR(40),
    CourseDescription CHAR(200)
);

INSERT INTO Course VALUES(
    'ITC110', 'Beginning Programming', 'Programming using C#');
INSERT INTO Course VALUES(
    'ITC220', 'Introduction to Database', 'Overview of database design and topics');
INSERT INTO Course VALUES(
    'ITC255', 'System Analysis', 'Systems analysis and design');
INSERT INTO Course VALUES(
    'MAT107', 'Applied Math', 'Applied math for computers');
INSERT INTO Course VALUES(
    'ENG211', 'Technical Writing', 'Technical writing for Information technology');
INSERT INTO Course VALUES(
    'WEB110', 'Beginning Web Page Design', 'Basic xhtml');
INSERT INTO Course VALUES(
    'ITC226', 'Database Administration', 'SQL Server administration');

CREATE TABLE Ethnicity(
    EthnicityKey CHAR(20) PRIMARY KEY,
    EthnicityDescription CHAR(100)
);

INSERT INTO Ethnicity VALUES('Caucasian', 'White, European origin');
INSERT INTO Ethnicity VALUES('Asian', 'Chinese, Japanese, Korean, Southeast Asian');
INSERT INTO Ethnicity VALUES('AfrAmer', 'African American or of African origin');
INSERT INTO Ethnicity VALUES('Hispanic', 'Mexican, Central or South American, Caribbean');
INSERT INTO Ethnicity VALUES('Pacific', 'Pacific Islander');
INSERT INTO Ethnicity VALUES('Mideast', 'Arabic or Persian');
INSERT INTO Ethnicity VALUES('Other', 'Other or not disclosed');

CREATE TABLE TutorCourse(
    TutorKey INTEGER,
    FOREIGN KEY (TutorKey) REFERENCES Tutor,
    CourseKey CHAR(6),
    FOREIGN KEY (CourseKey) REFERENCES Course,
    PRIMARY KEY(TutorKey, CourseKey)
);

INSERT INTO TutorCourse VALUES(980010002, 'ITC255');
INSERT INTO TutorCourse VALUES(980010002, 'ENG211');
INSERT INTO TutorCourse VALUES(980010004, 'MAT107');
INSERT INTO TutorCourse VALUES(980010000, 'WEB110');
INSERT INTO TutorCourse VALUES(980010001, 'ITC220');
INSERT INTO TutorCourse VALUES(980010001, 'WEB110');
INSERT INTO TutorCourse VALUES(980010003, 'ITC110');

CREATE TABLE Student(
    StudentKey INTEGER PRIMARY KEY,
    StudentLastName CHAR(20),
    StudentFirstName CHAR(20),
    StudentEmail CHAR(50),
    StudentPhone INTEGER,
    StudentGender CHAR,
    StudentAge INTEGER,
    StudentCitizen CHAR(5),
    StudentWorkerRetraining CHAR(5),
    EthnicityKey CHAR(20)
);

INSERT INTO Student VALUES(
    990001000, 'Peterson', 'Laura', NULL, 2065559318, 'F', 23, 'True', 'False', 'Caucasian');
INSERT INTO Student VALUES(
    990001002, 'Carter', 'Shannon', 'Shannon@Carter.Org', 2065554301, 'F', 32, 'True', 'True', 'AfrAmer');
INSERT INTO Student VALUES(
    990001003, 'Martinez', 'Sandy', 'sandym@gmail.com', 2065551158, 'F', 18, 'True', 'False', 'Hispanic');
INSERT INTO Student VALUES(
    990001004, 'Nguyen', 'Lu', 'lstar@yahoo.com', 2065552938, 'M', 19, 'False', 'False', 'Asian');
INSERT INTO Student VALUES(
    990001005, 'Zukof', 'Mark', NULL, 2065551158, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Student VALUES(
    990001006, 'Taylor', 'Patty', 'P147@marketplace.com', 2065551158, 'F', 42, 'True', 'True', 'Caucasian');
INSERT INTO Student VALUES(
    990001007, 'Thomas', 'Lawrence', NULL, 2065551158, 'M', 24, 'True', 'False', 'Caucasian');
INSERT INTO Student VALUES(
    980001008, 'Bradbury', 'Ron', 'rbradbury@mars.org', 2065551158, 'M', 53, 'True', 'True', 'Caucasian');
INSERT INTO Student VALUES(
    980001009, 'Carlos', 'Juan', 'Carlos23@', 2065551158, 'M', 25, 'False', 'False', 'Hispanic');
INSERT INTO Student VALUES(
    009001010, 'Min', 'Ly', 'sandym@gmail.com', 2065551158, 'F', 20, 'False', 'False', 'Asian');

CREATE TABLE StudentCourse(
    StudentKey INTEGER,
    CourseKey CHAR(6),
    StudentCourseQuarter CHAR(10),
    FOREIGN KEY (StudentKey) REFERENCES Student,
    FOREIGN KEY (CourseKey) REFERENCES Course,
    PRIMARY KEY(StudentKey, CourseKey, StudentCourseQuarter)
);

INSERT INTO StudentCourse VALUES(990001000, 'ITC220', 'Fall09');
INSERT INTO StudentCourse VALUES(990001000, 'ITC110', 'Fall09');
INSERT INTO StudentCourse VALUES(990001000, 'WEB110', 'Fall09');
INSERT INTO StudentCourse VALUES(990001002, 'ITC220', 'Fall09');
INSERT INTO StudentCourse VALUES(990001002, 'ITC110', 'Fall09');
INSERT INTO StudentCourse VALUES(990001004, 'MAT107', 'Fall09');
INSERT INTO StudentCourse VALUES(990001004, 'WEB110', 'Fall09');
INSERT INTO StudentCourse VALUES(990001007, 'ITC110', 'Fall09');
INSERT INTO StudentCourse VALUES(980001009, 'ITC110', 'Fall09');
INSERT INTO StudentCourse VALUES(980001009, 'ITC220', 'Fall09');
INSERT INTO StudentCourse VALUES(980001009, 'MAT107', 'Fall09');
INSERT INTO StudentCourse VALUES(990001002, 'ENG211', 'Winter10');
INSERT INTO StudentCourse VALUES(990001002, 'ITC255', 'Winter10');
INSERT INTO StudentCourse VALUES(990001003, 'ENG211', 'Winter10');
INSERT INTO StudentCourse VALUES(990001003, 'ITC255', 'Winter10');
INSERT INTO StudentCourse VALUES(990001005, 'MAT107', 'Winter10');
INSERT INTO StudentCourse VALUES(009001010, 'MAT107', 'Winter10');
INSERT INTO StudentCourse VALUES(009001010, 'ITC255', 'Winter10');
INSERT INTO StudentCourse VALUES(009001010, 'ENG211', 'Winter10');
INSERT INTO StudentCourse VALUES(990001000, 'ITC255', 'Winter10');
INSERT INTO StudentCourse VALUES(990001000, 'MAT107', 'Winter10');

CREATE TABLE Sessions(
    SessionDateTimeKey TIMESTAMP,
    TutorKey INTEGER,
    CourseKey CHAR(6),
    StudentKey INTEGER,
    SessionStatus CHAR(3),
    SessionMaterialCovered CHAR(200),
    PRIMARY KEY(SessionDateTimeKey, TutorKey),
    FOREIGN KEY (TutorKey) REFERENCES Tutor,
    FOREIGN KEY (CourseKey) REFERENCES Course,
    FOREIGN KEY (StudentKey) REFERENCES Student
);

INSERT INTO Sessions VALUES(TIMESTAMP '2009-10-20 14:00:00', 980010001, 'WEB110', 990001000, 'C', 'CSS');
INSERT INTO Sessions VALUES(TIMESTAMP '2009-10-20 13:00:00', 980010003, 'ITC110', 990001000, 'C', 'For next loop');
INSERT INTO Sessions VALUES(TIMESTAMP '2009-10-20 10:30:00', 980010001, 'ITC220', 990001002, 'C', 'Relations');
INSERT INTO Sessions VALUES(TIMESTAMP '2009-11-20 10:00:00', 980010001, 'ITC220', NULL, 'NS', NULL);
INSERT INTO Sessions VALUES(TIMESTAMP '2009-11-05 13:00:00', 980010004, 'MAT107', 990001004, 'C', 'Binary Numbers');
INSERT INTO Sessions VALUES(TIMESTAMP '2009-11-10 14:00:00', 980010001, 'WEB110', 990001000, 'C', 'Web Forms');
INSERT INTO Sessions VALUES(TIMESTAMP '2009-11-10 09:30:00', 980010002, 'ITC255', 990001000, 'C', 'Use Cases');
INSERT INTO Sessions VALUES(TIMESTAMP '2010-01-15 11:00:00', 980010002, 'ENG211', 990001003, 'C', 'Document structure');
INSERT INTO Sessions VALUES(TIMESTAMP '2010-01-20 14:00:00', 980010004, 'MAT107', 990001005, 'NS', NULL);
/* PLEASE FIX ME
INSERT INTO Sessions VALUES(TIMESTAMP '20120-01-22 10:30:00', 980010002, 'ITC255', 990001000, 'C', 'Feasibility');
PLEASE FIX ME*/
INSERT INTO Sessions VALUES(TIMESTAMP '2010-02-05 13:30:00', 980010004, 'MAT107', NULL, NULL, NULL);
INSERT INTO Sessions VALUES(TIMESTAMP '2010-02-10 14:00:00', 980010004, 'MAT107', NULL, NULL, NULL);
INSERT INTO Sessions VALUES(TIMESTAMP '2010-02-13 10:00:00', 980010002, 'ITC255', NULL, NULL, NULL);
INSERT INTO Sessions VALUES(TIMESTAMP '2010-02-14 11:00:00', 980010002, 'ENG211', NULL, NULL, NULL);

CREATE TABLE Request(
    RequestKey INTEGER PRIMARY KEY,
    RequestDate DATE,
    CourseKey CHAR(6),
    RequestStatus CHAR(20),
    StudentKey INTEGER,
    FOREIGN KEY (CourseKey) REFERENCES Course,
    FOREIGN KEY (StudentKey) REFERENCES Student
);

INSERT INTO Request VALUES(1001, DATE '2010-01-05', 'ITC226', 'Active', 009001010);

CREATE TABLE RequestNote(
    RequestNoteKey TIMESTAMP,
    RequestID INTEGER,
    RequestNoteText CHAR(200),
    PRIMARY KEY(RequestNoteKey, RequestID),
    FOREIGN KEY (RequestID) REFERENCES Request
);

INSERT INTO RequestNote VALUES(TIMESTAMP '2010-01-06 14:00:00', 1001,
    'Only offered once a year and not a lot of requests for this class');
INSERT INTO RequestNote VALUES(TIMESTAMP '2010-01-10 10:00:00', 1001,
    'No students available, because a capstone class would have to get someone off campus');

/*
CREATE TRIGGER SessionHours
INSTEAD OF INSERT ON Sessions
*/

DECLARE PROCEDURE usp_StudentLogin(StudentKey IN INTEGER,
                                   output_var OUT CHAR (20)) AS
    c INTEGER;
    BEGIN
        SELECT COUNT(s.StudentKey) INTO c 
        FROM Student s 
        WHERE s.StudentKey=StudentKey;
        IF (c > 0)
        THEN
            SELECT UNIQUE s.StudentLastName INTO output_var 
            FROM Student s 
            WHERE s.StudentKey=StudentKey;
        END IF;
    END usp_StudentLogin;


SET SERVEROUTPUT ON

declare
    studKey INTEGER := 990001000;
    retVal CHAR (20) := '';
begin
    uspStudentLogin(studKey, retVal);
    dbms_output.put_line(retVal);
end;

