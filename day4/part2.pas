{$mode objfpc}{$H+}
uses Sysutils, Classes; 

Const    numwinning=10;
         nummynumbers=25;
         maxlines=213;

var
  myFile : TextFile;
  dummy,cpt,tiragenumber,total: LongInt;
  tab: array[1..maxlines] of string;
  s: string;


function isanumber(c: char): Boolean;
begin
    if ((ord(c)>47) and (Ord(c)<58)) then isanumber:=true else isanumber:=false;
end;

procedure parseticket(numero: longint);
var winningnumbers: array[1..numwinning] of Integer;
    mynumbers: array[1..nummynumbers] of Integer;
    dummy,cpt,matches,startwin,endwin:integer;
    s:string;

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
  end;

begin
    matches:=0;
    for dummy:=1 to numwinning do winningnumbers[dummy]:=0;
    for dummy:=1 to nummynumbers do mynumbers[dummy]:=0;
    s:=tab[numero];
    parsewinningnumbers(s);
    parsemynumbers(s);
    inc(total);
    for dummy:=1 to nummynumbers do
    begin
        for cpt:=1 to numwinning do
            if mynumbers[dummy]=winningnumbers[cpt] then inc(matches); 
    end;
    if matches>0 then
    begin
      startwin:=0;
      endwin:=0;
      if numero+1 <= maxlines then startwin:=numero+1 else endwin:=maxlines;
      if numero+(matches)<= maxlines then endwin:=numero+(matches) else endwin:=maxlines;
        for dummy:=startwin to endwin do parseticket(dummy);
    end;
end;

begin
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  total:=0;
  cpt:=1;
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    tab[cpt]:=s;
    inc(cpt);
  end;
  dec(cpt);
  CloseFile(myFile);
  for dummy:=1 to cpt do
  begin
    parseticket(dummy);
  end;
  Writeln('Total : '+IntToStr(total));
end.
