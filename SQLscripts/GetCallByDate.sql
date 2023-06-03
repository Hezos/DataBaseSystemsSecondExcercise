CREATE OR REPLACE PROCEDURE GetCallByDate(datum DATE) AS SYS_REFCURSOR
  kurzor SYS_REFCURSOR;
BEGIN
  OPEN kurzor FOR  SELECT * FROM Hivasok WHERE Hivasok.datum = datum;
  RETURN v_cursor;
END;

--ezeket nem itt kell megh�vni, majd a Java k�dban packagenaem.procedurename(para)
DECLARE
  KeresesEredmenyek SYS_REFCURSOR;
BEGIN
  KeresesEredmenyek := GetCallByDate('YYYY-MM-DD');
END;