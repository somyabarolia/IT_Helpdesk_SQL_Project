-- View: Active tickets with assignee details
CREATE OR REPLACE VIEW Active_Tickets AS
SELECT t.Ticket_ID, t.Title, t.Status, t.Priority, u.Name AS Assignee
FROM Tickets t
LEFT JOIN Users u ON t.Assigned_To = u.User_ID
WHERE t.Status IN ('Open', 'Assigned', 'In Progress');

-- View: SLA summary with aggregations
CREATE OR REPLACE VIEW SLA_Summary AS
SELECT Ticket_ID, COUNT(*) AS Total_SLAs, SUM(CASE WHEN Breach_Status = 'Yes' THEN 1 ELSE 0 END) AS Breached_SLAs
FROM SLAs
GROUP BY Ticket_ID;
