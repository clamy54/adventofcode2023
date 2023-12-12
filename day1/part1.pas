{$mode objfpc}{$H+}
uses Sysutils;

var
  myFile : TextFile;
  valeur:Word;
  s:string;


function comptage(s: string): integer;
var iValue, iCode,first, last,cpt :integer;

begin
 first:=0;
 last:=0;
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



