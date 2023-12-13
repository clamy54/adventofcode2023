{$mode objfpc}{$H+}
uses Sysutils;

type gear=record
        firstvalue,secondvalue : Integer;
        error:boolean;
      end;
var
  myFile : TextFile;
  valeur:Word;
  s:string;
  tab:array[1..140] of string;

  t,dummy:integer;
  total:LongInt;

function isasymbol(c: char): Boolean;
begin
if ((ord(c)<48) or (Ord(c)>57)) then isasymbol:=true else isasymbol:=false;
end;

function isagear(c: char): Boolean;
begin
if c='*' then isagear:=true else isagear:=false;
end;

function isanumber(c: char): Boolean;
begin
if ((ord(c)>47) and (Ord(c)<58)) then isanumber:=true else isanumber:=false;
end;

function getnumbernearposition(ligne,position :integer):integer;
var valnumber,dummy: integer;
    trigger, triggeristhegood: boolean;
    number:string;

begin
  number:='';
  valnumber:=0;
  trigger:=false;
  triggeristhegood:=false;
  for dummy:=1 to Length(tab[ligne]) do
  begin
    if isanumber(tab[ligne][dummy]) then
    begin
      if trigger=true then
      begin
        number:=number+tab[ligne][dummy];
      end
      else
      begin
        trigger:=true;
        number:=tab[ligne][dummy];
      end;
      if dummy=position then triggeristhegood:=true;
    end
    else
    begin
      if trigger=true then
      begin
        trigger:=false;
        if triggeristhegood=true then
        begin
          valnumber:=StrToInt(number);
          triggeristhegood:=false;
        end;
        number:='';
      end;
    end;
  end;
  if trigger=true then
  begin
    trigger:=false;
    if triggeristhegood=true then
      begin
        valnumber:=StrToInt(number);
        triggeristhegood:=false;
    end;
    number:='';
  end;
  getnumbernearposition:=valnumber;
end;



function getgearvalue(ligne,position:Integer): integer;
var engrenage: gear;
    score: integer;

procedure stockevaleur(valeur: integer);
begin
  // Writeln('stockage : '+IntToStr(valeur));
  if engrenage.firstvalue=0 then
  begin
    engrenage.firstvalue:=valeur;
  end
  else
  begin
    if engrenage.error=false then
    begin
      if engrenage.secondvalue=0 then
      begin
        engrenage.secondvalue:=valeur;
      end
      else
      begin
        engrenage.secondvalue:=0;
        engrenage.error:=true;
        Writeln('Erreur at line '+IntToStr(ligne)+' Position : '+IntToStr(position));
      end;
    end;
  end;
end;

begin
 engrenage.firstvalue:=0;
 engrenage.secondvalue:=0;
 engrenage.error:=false;
 if position>1 then
   if isanumber(tab[ligne][position-1]) then stockevaleur(getnumbernearposition(ligne,position-1));

 if position<length(tab[ligne]) then
   if isanumber(tab[ligne][position+1]) then stockevaleur(getnumbernearposition(ligne,position+1));

if ligne>1 then
begin
  if isanumber(tab[ligne-1][position]) then 
  begin
    stockevaleur(getnumbernearposition(ligne-1,position));
  end
  else
  begin
    if position>1 then
      if isanumber(tab[ligne-1][position-1]) then stockevaleur(getnumbernearposition(ligne-1,position-1));
    if position<length(tab[ligne]) then
      if isanumber(tab[ligne-1][position+1]) then stockevaleur(getnumbernearposition(ligne-1,position+1));
  end;
end;

if ligne<140 then
begin
  if isanumber(tab[ligne+1][position]) then 
  begin
    stockevaleur(getnumbernearposition(ligne+1,position));
  end
  else
  begin
    if position>1 then
      if isanumber(tab[ligne+1][position-1]) then stockevaleur(getnumbernearposition(ligne+1,position-1));
    if position<length(tab[ligne]) then
      if isanumber(tab[ligne+1][position+1]) then stockevaleur(getnumbernearposition(ligne+1,position+1));
  end;
end;

Writeln(IntToStr(engrenage.firstvalue)+' - '+ IntToStr(engrenage.secondvalue));
getgearvalue:=engrenage.firstvalue*engrenage.secondvalue

end;


begin
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  valeur:=0;
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    inc(valeur);
    tab[valeur]:=s;
  end;
  CloseFile(myFile);
  total:=0;
  for t:=1 to 140 do
  begin
  for dummy:=1 to Length(tab[t]) do
  begin
    if isagear(tab[t][dummy]) then total:=total+getgearvalue(t,dummy);
  end;
  end;
  

  Writeln('Total : '+IntToStr(total));

end.
