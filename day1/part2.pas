{$mode objfpc}{$H+}
uses Sysutils;

const
  nombres: array [1..9] of string = ('one','two','three','four','five','six','seven','eight','nine');

var
  myFile : TextFile;
  valeur:LongInt;
  s:string;

function RPos(const aSubStr, aString : String; const aStartPos: Integer): Integer; overload;
var
  i: Integer;
  pStr: PChar;
  pSub: PChar;
begin
  pSub := Pointer(aSubStr);

  for i := aStartPos downto 1 do
  begin
    pStr := @(aString[i]);
    if (pStr^ = pSub^) then
    begin
      if CompareMem(pSub, pStr, Length(aSubStr)) then
      begin
        result := i;
        EXIT;
      end;
    end;
  end;

  result := 0;
end;


function RPos(const aSubStr, aString : String): Integer; overload;
begin
  result := RPos(aSubStr, aString, Length(aString) - Length(aSubStr) + 1);
end;


function comptage(s: string): integer;
var position,iValue, iCode,first, last,cpt,firstoccur, lastoccur :integer;

begin
 first:=0;
 last:=0;
 firstoccur:=0;
 lastoccur:=0;
  write(s+' - ');

  for cpt:=1 to 9 do
  begin
    position:=Pos(nombres[cpt],s);
    if position>0 then
    begin
      if firstoccur=0 then
      begin
        firstoccur:=cpt;
      end
      else
      begin
        if position<Pos(nombres[firstoccur],s) then firstoccur:=cpt;
      end;
    end;
  end;


  for cpt:=1 to 9 do
  begin
    position:=RPos(nombres[cpt],s);
    if position>0 then
    begin
      if lastoccur=0 then
      begin
        lastoccur:=cpt;
      end
      else
      begin
        if position>RPos(nombres[lastoccur],s) then lastoccur:=cpt;
      end;  
    end;
  end;

  if firstoccur>0 then  s:=StringReplace(s,nombres[firstoccur],IntToStr(firstoccur),[]);
  if lastoccur>0 then  s:=StringReplace(s,nombres[lastoccur],IntToStr(lastoccur),[rfReplaceAll]);  
  write(s+' - ');
  for cpt:=1 to length (s) do
  begin
   val(s[cpt], iValue, iCode);
   if iCode = 0 then
   begin
    if first=0 then first:=iValue;
    last:=iValue;
   end;
  end;
  comptage:=first*10+last;
  writeln(IntToStr(comptage));
end;



begin

  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  valeur:=0;
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    valeur:=valeur+comptage(s);
  end;
  CloseFile(myFile);
  Writeln('Resultat : '+IntToStr(valeur));
end.



