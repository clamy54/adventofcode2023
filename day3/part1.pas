{$mode objfpc}{$H+}
uses Sysutils;

var
  myFile : TextFile;
  valeur:Word;
  s,numero:string;
  tab:array[1..140] of string;

  t,dummy:integer;

  trigstart,trigsymb:Boolean;
  total:LongInt;

function isasymbol(c: char): Boolean;
begin
if ((c<>'.') and ((ord(c)<48) or (Ord(c)>57))) then isasymbol:=true else isasymbol:=false;
end;


function isanumber(c: char): Boolean;
begin
if ((ord(c)>47) and (Ord(c)<58)) then isanumber:=true else isanumber:=false;
end;

function ispartnumber(ligne,position:Integer): Boolean;
var symbole:boolean;

begin
 symbole:=false;

 if position>1 then
 begin
   if isasymbol(tab[ligne][position-1]) then symbole:=true;
   if ligne>1 then if isasymbol(tab[ligne-1][position-1]) then symbole:=true;
   if ligne<140 then if isasymbol(tab[ligne+1][position-1]) then symbole:=true;
 end;

 if ligne>1 then if isasymbol(tab[ligne-1][position]) then symbole:=true;
 if ligne<140 then if isasymbol(tab[ligne+1][position]) then symbole:=true;

 if position<length(tab[ligne]) then
 begin
   if isasymbol(tab[ligne][position+1]) then symbole:=true;
   if ligne>1 then if isasymbol(tab[ligne-1][position+1]) then symbole:=true;
   if ligne<140 then if isasymbol(tab[ligne+1][position+1]) then symbole:=true;
 end;

 ispartnumber:=symbole
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
  t:=1;
  
  for t:=1 to 140 do
  begin
  trigstart:=false;
  trigsymb:=false;
  numero:='';
  for dummy:=1 to Length(tab[t]) do
  begin
    if isanumber(tab[t][dummy]) then
    begin
      if ispartnumber(t,dummy) then trigsymb:=true;
      if trigstart=true then 
      begin
        numero:=numero+tab[t][dummy];
      end
      else
      begin
        trigstart:=true;
        numero:=tab[t][dummy];
      end;
    end
    else
    begin
      if trigstart=true then
      begin
        trigstart:=false;
        if trigsymb then total:=total+StrToInt(numero);
        numero:='';       
        trigsymb:=false; 
      end;
    end;
  end;
  if trigstart=true then
  begin
   if trigsymb then total:=total+StrToInt(numero);
  end;  
  end;
  Writeln('Total : '+IntToStr(total));

end.
