create or replace package Szolgalat is
    procedure FeltoltHivas;
    FUNCTION GetCountOfCalls( kdate DATE) RETURN NUMBER;
    TRIGGER trCall;
    procedure GetCallByName(name varchar2) as SYS_REFCURSOR;
    PROCEDURE GetCallByName(name VARCHAR2) AS SYS_REFCURSOR;
    PROCEDURE GetCallByDate(datum DATE) AS SYS_REFCURSOR;
    TRIGGER KivonulasAdmin;
    procedure UploadFromFile(filename varchar2)
    
end;

create or replace package body Szolgalat is
create sequence HSEQ;
create or replace procedure FeltoltHivas(Id int, nev varchar2, beteg varchar2, datum date) is
MID int;
AID int;
begin
    select MAX(Id) INTO MID from Hivasok;
    select HSEQ.NEXTVAL into AID from DUAL;
    while AID <= MID loop
        select HSEQ.NEXTVAL into AID from DUAL;
    end loop;
    insert into Hivasok values(AID, nev, beteg, datum);
commit;
end;

CREATE OR REPLACE PROCEDURE GetCallByName(name VARCHAR2) AS SYS_REFCURSOR
  kurzor SYS_REFCURSOR;
BEGIN
  OPEN kurzor FOR  SELECT * FROM Hivasok WHERE Hivasok.Szemely = name;
  RETURN v_cursor;
END;

DECLARE
  KeresesEredmenyek SYS_REFCURSOR;
BEGIN
  KeresesEredmenyek := GetCallByName('ertek');
END;

CREATE OR REPLACE PROCEDURE GetCallByPatient(pname VARCHAR2) AS SYS_REFCURSOR
  kurzor SYS_REFCURSOR;
BEGIN
  OPEN kurzor FOR  SELECT * FROM Hivasok WHERE Hivasok.Beteg = pname;
  RETURN v_cursor;
END;

DECLARE
  KeresesEredmenyek SYS_REFCURSOR;
BEGIN
  KeresesEredmenyek := GetCallByName('ertek');
END;

CREATE OR REPLACE PROCEDURE GetCallByDate(datum DATE) AS SYS_REFCURSOR
  kurzor SYS_REFCURSOR;
BEGIN
  OPEN kurzor FOR  SELECT * FROM Hivasok WHERE Hivasok.datum = datum;
  RETURN v_cursor;
END;

--ezeket nem itt kell meghívni, majd a Java kódban packagenaem.procedurename(para)
DECLARE
  KeresesEredmenyek SYS_REFCURSOR;
BEGIN
  KeresesEredmenyek := GetCallByDate('YYYY-MM-DD');
END;

CREATE OR REPLACE FUNCTION GetCountOfCalls( kdate DATE) RETURN NUMBER
IS
  rekordok NUMBER;
BEGIN
  SELECT COUNT(*) INTO rekordok FROM Hivasok WHERE Hivasok.datum = kdate;
  RETURN v_count;
END;

SELECT GetCountOfCalls(TO_DATE('datum', 'YYYY-MM-DD')) AS rekordok FROM dual;

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

grant read on directory Beadando2 to public;
create or replace procedure UploadFromFile(filename varchar2) as
  F1 UTL_FILE.FILE_TYPE;
  SOR varchar2(200);
  
    str VARCHAR2(100) := 'Apple,Banana,Cherry,Durian'; 
  valaszto CHAR := ','; 
  arr DBMS_SQL.VARCHAR2_TABLE;  
  i INTEGER := 1;
  
begin
  F1 := UTL_FILE.FOPEN('Beadando2',filename,'R');
  begin
    loop
       UTL_FILE.GET_LINE(F1,sor,100);
        WHILE (INSTR(sor,delim) > 0) LOOP
    arr(i) := SUBSTR(sor,1,INSTR(sor,valaszto)-1);
    sor := SUBSTR(sor,INSTR(sor, valaszto)+1);
    i := i + 1;
  END LOOP;
  arr(i) := sor;  
  if filename = "HivasAdatok.txt" then
    FOR j IN 1..i LOOP
            insert into Hivasok values(arr(0), arr(1), arr(2), arr(3));
            commit;
         END LOOP;
  end if;
  
  if filename = "KivonulasAdatok.txt" then
    FOR j IN 1..i LOOP
            insert into Hivasok values(arr(0), arr(1), arr(2));
            commit;
         END LOOP;
  end if;
        
    end loop;
   exception
      when others then 
         null;
  end;
  UTL_FILE.FCLOSE(F1);
end;

set serveroutput on

begin
  UploadFromFile;
end;

end Szolgalat;