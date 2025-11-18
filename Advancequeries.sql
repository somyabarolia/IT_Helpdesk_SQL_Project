-- CTE: SLA breaches by category (using aggregation and CTE)
WITH Breach_CTE AS (
    SELECT t.Category, COUNT(s.SLA_ID) AS Breach_Count
    FROM Tickets t
    JOIN SLAs s ON t.Ticket_ID = s.Ticket_ID
    WHERE s.Breach_Status = 'Yes'
    GROUP BY t.Category
)
SELECT Category, Breach_Count, ROUND(Breach_Count / (SELECT SUM(Breach_Count) FROM Breach_CTE) * 100, 2) AS Breach_Percentage
FROM Breach_CTE;

-- Window function: Daily ticket trends (rolling sum of tickets created)
SELECT Created_Date, COUNT(*) AS Daily_Count,
       SUM(COUNT(*)) OVER (ORDER BY Created_Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Count
FROM Tickets
GROUP BY Created_Date
ORDER BY Created_Date;

-- Aggregation: Average resolution time by priority
SELECT Priority, AVG((Resolved_Date - Created_Date) * 24) AS Avg_Resolution_Hours
FROM Tickets
WHERE Resolved_Date IS NOT NULL
GROUP BY Priority;
