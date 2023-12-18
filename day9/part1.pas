{$mode objfpc}{$H+}
uses Sysutils, Classes; 

var
  myFile : TextFile;
  List:TStringList;
  s:string;
  cpt:Integer;
  entree: array of int64;
  resultat,total:int64;


function traiteligne(tab :array of int64):int64;
var longueur,cpt,ind:Word;
    resultat,a,b:int64;
    tabresult:array of int64;
    trigger:Boolean;

begin
  cpt:=0;
  ind:=0;
  longueur:=Length(tab) DIV 2;
  SetLength(tabresult,0);
  repeat
    a:=tab[cpt];
    b:=tab[cpt+1];
    resultat:=b-a;
    SetLength(tabresult,length(tabresult)+1);
    tabresult[ind]:=resultat;
    inc(ind);
    cpt:=cpt+1;
  until (cpt>=Length(tab)-1);
  for cpt:=0 to length(tabresult)-1 do write(inttostr(tabresult[cpt])+' ');
  writeln();
  trigger:=false;
  for cpt:=0 to Length(tabresult)-1 do 
      if tabresult[cpt]<>0 then trigger:=true;
  if trigger=false then
  begin
    traiteligne:=0;
  end
  else
  begin
    traiteligne:=tabresult[Length(tabresult)-1]+traiteligne(tabresult);
  end;
end;


procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
   Strings.StrictDelimiter := true;
end;


begin
  SetLength(entree,0);
  List := TStringList.Create;
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  resultat:=0;
  total:=0;
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    Split(' ', s, List);
    SetLength(entree,List.Count);
    for cpt:=0 to List.Count-1 do entree[cpt]:=StrToInt64(List[cpt]);
    resultat:=traiteligne(entree)+entree[cpt];
    total:=total+resultat;
    writeln(s + ' ** '+IntToStr(resultat)+' ** ');
  end;  
  CloseFile(myFile);
  writeln('Total : '+IntToStr(total));
end.