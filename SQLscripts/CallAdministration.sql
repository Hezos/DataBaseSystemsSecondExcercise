create sequence HASEQ;
CREATE OR REPLACE TRIGGER trCall AFTER INSERT OR DELETE OR UPDATE ON Hivasok
DECLARE
szoveg CHAR(100);
MID int;
AID int;
BEGIN
IF INSERTING THEN
szoveg := 'New call registered' || USER || TO_CHAR(sysdate,'YYYY.MM.DD');
END IF;
IF DELETING THEN
szoveg := 'Call deleted' || USER || TO_CHAR(sysdate,'YYYY.MM.DD');
END IF;
IF UPDATING THEN
szoveg := 'Call was modified' || USER || TO_CHAR(sysdate,'YYYY.MM.DD');
END IF;

    select MAX(Id) INTO MID from Naplo;
    select HASEQ.NEXTVAL into AID from DUAL;
    while AID <= MID loop
        select HASEQ.NEXTVAL into AID from DUAL;
    end loop;

INSERT INTO Naplo VALUES (AID, szoveg);
END;
