
-- Insert sample users
INSERT INTO Users (Name, Email, Role) VALUES ('Alice Customer', 'alice@example.com', 'Customer');
INSERT INTO Users (Name, Email, Role) VALUES ('Bob L2', 'bob@example.com', 'L2 Engineer');
INSERT INTO Users (Name, Email, Role) VALUES ('Charlie L3', 'charlie@example.com', 'L3 Engineer');

-- Insert sample tickets
INSERT INTO Tickets (Type, Title, Description, Priority, Created_By, Category) 
VALUES ('Incident', 'Server Down', 'Main server is unresponsive.', 'High', 1, 'Hardware');
INSERT INTO Tickets (Type, Title, Description, Priority, Created_By, Category) 
VALUES ('Service Request', 'New Software Install', 'Request to install Adobe Suite.', 'Medium', 1, 'Software');

-- Insert SLAs
INSERT INTO SLAs (Ticket_ID, SLA_Type, Target_Hours) VALUES (1, 'Response Time', 2);
INSERT INTO SLAs (Ticket_ID, SLA_Type, Target_Hours) VALUES (1, 'Resolution Time', 24);

-- Insert worklogs
INSERT INTO Worklogs (Ticket_ID, User_ID, Hours_Worked, Description) 
VALUES (1, 2, 3.5, 'Diagnosed hardware issue.');

