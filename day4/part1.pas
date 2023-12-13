{$mode objfpc}{$H+}
uses Sysutils, Classes; 

Const    numwinning=10;
         nummynumbers=25;

var
  myFile : TextFile;
  winningnumbers: array[1..numwinning] of Integer;
  mynumbers: array[1..nummynumbers] of Integer;
  tiragenumber,total: LongInt;
  s: string;


function isanumber(c: char): Boolean;
begin
    if ((ord(c)>47) and (Ord(c)<58)) then isanumber:=true else isanumber:=false;
end;

procedure parsewinningnumbers(s: string);
var dummy,cpt: Integer;
    numberstr: string;
    trigger:Boolean;

begin
    numberstr:='';
    trigger:=false;
    cpt:=1;
    for dummy:=1 to numwinning do winningnumbers[dummy]:=0;
    for dummy:=pos(':',s) to pos('|',s) do 
    begin
      if isanumber(s[dummy]) then
      begin
        if trigger=true then
        begin
            numberstr:=numberstr+s[dummy];
        end
        else
        begin
            numberstr:=s[dummy];
            trigger:=true;
        end;
      end
      else
      begin
        if trigger=true then
        begin
            trigger:=false;
            winningnumbers[cpt]:=StrToInt(numberstr);
            inc(cpt);
            numberstr:='';
        end;
      end;
    end;
    if trigger=true then
    begin
        trigger:=false;
        winningnumbers[cpt]:=StrToInt(numberstr);
        inc(cpt);
        numberstr:='';
    end;
    write('Numeros gagants : ');
    for dummy:=1 to numwinning do Write(IntToStr(winningnumbers[dummy])+' ');
    Writeln('');
end;

procedure parsemynumbers(s: string);
var dummy,cpt: Integer;
    numberstr: string;
    trigger:Boolean;

begin
    numberstr:='';
    trigger:=false;
    cpt:=1;
    for dummy:=1 to nummynumbers do mynumbers[dummy]:=0;
    for dummy:=(pos('|',s)+1) to length(s) do 
    begin
      if isanumber(s[dummy]) then
      begin
        if trigger=true then
        begin
            numberstr:=numberstr+s[dummy];
        end
        else
        begin
            numberstr:=s[dummy];
            trigger:=true;
        end;
      end
      else
      begin
        if trigger=true then
        begin
            trigger:=false;
            mynumbers[cpt]:=StrToInt(numberstr);
            inc(cpt);
            numberstr:='';
        end;
      end;
    end;
    if trigger=true then
    begin
        trigger:=false;
        mynumbers[cpt]:=StrToInt(numberstr);
        inc(cpt);
        numberstr:='';
    end;
    Write('Mes numeros  : ');
    for dummy:=1 to nummynumbers do Write(IntToStr(mynumbers[dummy])+' ');
    Writeln('');
end;

function matchscore:longint;
var dummy,cpt:integer;
    present:boolean;
    score: integer;
begin
    score:=0;
    for dummy:=1 to nummynumbers do
    begin
        present:=false;
        for cpt:=1 to numwinning do
            if mynumbers[dummy]=winningnumbers[cpt] then present:=true; 
        if present=true then inc(score);
    end;
    Writeln('nombre de correspondances : '+IntToStr(score));
    if score=0 then
        matchscore:=0
    else
        matchscore:=round(exp((score-1)*ln(2))); // 2^(score-1)
end;

begin
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  total:=0;
  tiragenumber:=1;
  while not Eof(myFile) do
  begin
    Writeln('Tirage #'+IntToStr(tiragenumber));
    ReadLn(myFile, s);
    parsewinningnumbers(s);
    parsemynumbers(s);
    Writeln('MatchScore : '+IntToStr(matchscore));
    total:=total+matchscore;
    inc(tiragenumber);
  end;
  CloseFile(myFile);
  Writeln('Total : '+IntToStr(total));
end.
