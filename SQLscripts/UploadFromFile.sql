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

