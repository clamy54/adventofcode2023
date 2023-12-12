{$mode objfpc}{$H+}
uses Sysutils, Classes; 


type tirage=record
        red,green,blue : Integer;
      end;

const maxred=12;
      maxgreen=13;
      maxblue=14;

var
  myFile : TextFile;
  s,outstr:string;
  dummy,dummysc:Word;
  trig:Boolean;
  total:longint;


procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;


function getnumbers(s: string): tirage;
var red,green,blue,dummy:Integer;
    elements: TStringList;
    elm:string;
begin
  elements := TStringList.Create;
  red:=0;
  green:=0;
  blue:=0;
  Split(',', s, elements);
  for dummy:= 0 to elements.Count-1 do
  begin
    elm:=elements[dummy];
    WriteLn(elm);
    if Pos('red',elm)>0 then
    begin
      elm:=StringReplace(elm,'red','',[rfReplaceAll]);
      red:=red+StrToInt(elm);
    end;
    if Pos('green',elm)>0 then
    begin
      elm:=StringReplace(elm,'green','',[rfReplaceAll]);
      green:=green+StrToInt(elm);
    end;
    if Pos('blue',elm)>0 then
    begin
      elm:=StringReplace(elm,'blue','',[rfReplaceAll]);
      blue:=blue+StrToInt(elm);
    end;
  end;
  elements.Free;
  getnumbers.red:=red;
  getnumbers.green:=green;
  getnumbers.blue:=blue;
end;

function teste(s: string): Boolean;
var List: TStringList;
    isvalid:Boolean;
    dummy:Integer;
    resultat: tirage;
  
begin
  s:=StringReplace(s,' ','',[rfReplaceAll]);
  writeln('Phrase a tester : '+s);
  List := TStringList.Create;
  Split(';', s, List);
  isvalid:=true;
  for dummy:= 0 to List.Count-1 do
  begin
    writeln('element '+inttostr(dummy)+': '+List[dummy]);
    resultat:=getnumbers(List[dummy]);
    if (resultat.red>maxred) or (resultat.green>maxgreen) or (resultat.blue>maxblue) then isvalid:=false; 
  end;
  teste:=isvalid;
  List.Free;
end;



begin
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  dummysc:=0;
  total:=0;
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    inc(dummysc);
    trig:=false;
    outstr:='';
    for dummy:=1 to Length(s) do
    begin
      if s[dummy]=':' then
      begin
        trig:=true;
      end
      else
      begin
        if trig=true then outstr:=outstr+s[dummy];
      end
    end;
    if teste(outstr)=true then total:=total+dummysc;
  end;
  CloseFile(myFile);
  writeln('total : '+IntToStr(total));
end.

