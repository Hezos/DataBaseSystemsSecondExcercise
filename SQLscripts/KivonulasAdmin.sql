CREATE SEQUENCE KASEQ;
CREATE OR REPLACE TRIGGER KivonulasAdmin AFTER INSERT ON dolgozo
DECLARE
szoveg CHAR(100);
MID int;
AID int;
BEGIN
IF INSERTING THEN
szoveg := 'New operation registered' || USER || TO_CHAR(sysdate,'YYYY.MM.DD');
END IF;


    select MAX(Id) INTO MID from Naplo;
    select HASEQ.NEXTVAL into AID from DUAL;
    while AID <= MID loop
        select HASEQ.NEXTVAL into AID from DUAL;
    end loop;

INSERT INTO Naplo VALUES (AID, szoveg);
END;