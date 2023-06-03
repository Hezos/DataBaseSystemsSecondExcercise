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