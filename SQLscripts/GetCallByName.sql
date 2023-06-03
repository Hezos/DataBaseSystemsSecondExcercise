CREATE OR REPLACE PROCEDURE GetCallByName(name VARCHAR2) AS SYS_REFCURSOR
  kurzor SYS_REFCURSOR;
BEGIN
  OPEN kurzor FOR  SELECT * FROM Hivasok WHERE Hivasok.Szemely = name;
  RETURN kurzor;
END;

DECLARE
  KeresesEredmenyek SYS_REFCURSOR;
BEGIN
  KeresesEredmenyek := GetCallByName('ertek');
END;