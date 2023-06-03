CREATE OR REPLACE FUNCTION GetCountOfCalls( kdate DATE) RETURN NUMBER
IS
  rekordok NUMBER;
BEGIN
  SELECT COUNT(*) INTO rekordok FROM Hivasok WHERE Hivasok.datum = kdate;
  RETURN v_count;
END;

SELECT GetCountOfCalls(TO_DATE('datum', 'YYYY-MM-DD')) AS rekordok FROM dual;