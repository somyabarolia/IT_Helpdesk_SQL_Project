-- Users table (no DEFAULT on User_ID)
CREATE TABLE Users (
    User_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Role VARCHAR2(50) CHECK (Role IN ('Customer', 'L2 Engineer', 'L3 Engineer')) NOT NULL
);

-- Trigger for auto-incrementing User_ID
CREATE OR REPLACE TRIGGER trg_users_id
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    :NEW.User_ID := seq_users.NEXTVAL;
END;

-- Tickets table (no DEFAULT on Ticket_ID)
CREATE TABLE Tickets (
    Ticket_ID NUMBER PRIMARY KEY,
    Type VARCHAR2(50) CONSTRAINT chk_type CHECK (Type IN ('Incident', 'Service Request')) NOT NULL,
    Title VARCHAR2(200) NOT NULL,
    Description CLOB,
    Priority VARCHAR2(20) DEFAULT 'Medium' CONSTRAINT chk_priority CHECK (Priority IN ('Low', 'Medium', 'High')),
    Status VARCHAR2(50) DEFAULT 'Open' CONSTRAINT chk_status CHECK (Status IN ('Open', 'Assigned', 'In Progress', 'Resolved', 'Closed')),
    Created_Date DATE DEFAULT SYSDATE,
    Resolved_Date DATE,
    Assigned_To NUMBER REFERENCES Users(User_ID),
    Created_By NUMBER REFERENCES Users(User_ID) NOT NULL,
    Category VARCHAR2(100)
);

SELECT table_name FROM user_tables WHERE table_name = 'USERS';

-- Trigger for auto-incrementing Ticket_ID
CREATE OR REPLACE TRIGGER trg_tickets_id
BEFORE INSERT ON Tickets
FOR EACH ROW
BEGIN
    :NEW.Ticket_ID := seq_tickets.NEXTVAL;
END;

-- SLAs table (no DEFAULT on SLA_ID)
CREATE TABLE SLAs (
    SLA_ID NUMBER PRIMARY KEY,
    Ticket_ID NUMBER REFERENCES Tickets(Ticket_ID) ON DELETE CASCADE,
    SLA_Type VARCHAR2(100) NOT NULL,
    Target_Hours NUMBER NOT NULL,
    Breach_Status VARCHAR2(3) DEFAULT 'No' CHECK (Breach_Status IN ('Yes', 'No'))
);

-- Trigger for auto-incrementing SLA_ID
CREATE OR REPLACE TRIGGER trg_slas_id
BEFORE INSERT ON SLAs
FOR EACH ROW
BEGIN
    :NEW.SLA_ID := seq_slas.NEXTVAL;
END;

-- Worklogs table (no DEFAULT on Worklog_ID)
CREATE TABLE Worklogs (
    Worklog_ID NUMBER PRIMARY KEY,
    Ticket_ID NUMBER REFERENCES Tickets(Ticket_ID) ON DELETE CASCADE,
    User_ID NUMBER REFERENCES Users(User_ID),
    Log_Date DATE DEFAULT SYSDATE,
    Hours_Worked NUMBER(4,2) NOT NULL,
    Description CLOB
);

-- Trigger for auto-incrementing Worklog_ID
CREATE OR REPLACE TRIGGER trg_worklogs_id
BEFORE INSERT ON Worklogs
FOR EACH ROW
BEGIN
    :NEW.Worklog_ID := seq_worklogs.NEXTVAL;
END;

-- Ticket_History table (no DEFAULT on History_ID)
CREATE TABLE Ticket_History (
    History_ID NUMBER PRIMARY KEY,
    Ticket_ID NUMBER REFERENCES Tickets(Ticket_ID) ON DELETE CASCADE,
    Old_Status VARCHAR2(50),
    New_Status VARCHAR2(50) NOT NULL,
    Changed_By NUMBER REFERENCES Users(User_ID),
    Change_Date DATE DEFAULT SYSDATE
);

-- Trigger for auto-incrementing History_ID
CREATE OR REPLACE TRIGGER trg_ticket_history_id
BEFORE INSERT ON Ticket_History
FOR EACH ROW
BEGIN
    :NEW.History_ID := seq_ticket_history.NEXTVAL;
END;
