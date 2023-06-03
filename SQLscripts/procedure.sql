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

begin
FeltoltHivas();
end;