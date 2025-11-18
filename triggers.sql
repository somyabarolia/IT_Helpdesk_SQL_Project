-- Trigger: Auto-assign high-priority incidents to L3 engineers
CREATE OR REPLACE TRIGGER auto_assign_high_priority
AFTER INSERT ON Tickets
FOR EACH ROW
WHEN (NEW.Type = 'Incident' AND NEW.Priority = 'High')
BEGIN
    UPDATE Tickets SET Assigned_To = (SELECT User_ID FROM Users WHERE Role = 'L3 Engineer' AND ROWNUM = 1)
    WHERE Ticket_ID = :NEW.Ticket_ID;
END;

-- Trigger: Log status changes in Ticket_History
CREATE OR REPLACE TRIGGER log_status_change
AFTER UPDATE OF Status ON Tickets
FOR EACH ROW
WHEN (OLD.Status != NEW.Status)
BEGIN
    INSERT INTO Ticket_History (Ticket_ID, Old_Status, New_Status, Changed_By)
    VALUES (:NEW.Ticket_ID, :OLD.Status, :NEW.Status, :NEW.Assigned_To);
END;

-- Trigger: Check SLA breaches on ticket resolution
CREATE OR REPLACE TRIGGER check_sla_breach
AFTER UPDATE OF Resolved_Date ON Tickets
FOR EACH ROW
WHEN (NEW.Resolved_Date IS NOT NULL)
DECLARE
    hours_taken NUMBER;
BEGIN
    FOR sla_rec IN (SELECT SLA_ID, Target_Hours FROM SLAs WHERE Ticket_ID = :NEW.Ticket_ID) LOOP
        hours_taken := (:NEW.Resolved_Date - :NEW.Created_Date) * 24;
        IF hours_taken > sla_rec.Target_Hours THEN
            UPDATE SLAs SET Breach_Status = 'Yes' WHERE SLA_ID = sla_rec.SLA_ID;
        END IF;
    END LOOP;
END;
