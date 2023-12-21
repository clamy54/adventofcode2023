{$mode objfpc}{$H+}
uses Sysutils, Classes; 

type point=record
        x,y:word;
     end;

var myFile : TextFile;
    map,mapfinal:array of string;
    s:string;
    cpt,curseur,dummy,distance:word;
    galaxies:array of point;
    total:longint;

function iscolumnempty(numcol: word):boolean;
var trigger:boolean;
    cpt:word;
begin
  trigger:=true;
  for cpt:=0 to length(map)-1 do if map[cpt][numcol]='#' then trigger:=false;
  iscolumnempty:=trigger;
end;

begin
  SetLength(map,0);
  SetLength(galaxies,0);
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    if pos('#',s)=0 then 
    begin
      //expansion horizontale
      SetLength(map,length(map)+2);
      map[length(map)-2]:=s;
      map[length(map)-1]:=s;
    end
    else
    begin
      SetLength(map,length(map)+1);
      map[length(map)-1]:=s;
    end;  
  end;
  SetLength(mapfinal,Length(map));
  for dummy:=0 to length(map)-1 do
  begin
    s:='';
    //expansion verticale
    for cpt:=1 to Length(map[dummy]) do if iscolumnempty(cpt)=True then s:=s+'..' else s:=s+map[dummy][cpt];
    mapfinal[dummy]:=s;
  end;
  cpt:=0;
  for dummy:=0 to length(mapfinal)-1 do
  begin
    for curseur:=1 to length(mapfinal[dummy]) do
    begin
      if mapfinal[dummy][curseur]='#' then
      begin
        SetLength(galaxies,length(galaxies)+1);
        galaxies[cpt].x:=curseur;
        galaxies[cpt].y:=dummy;
        inc(cpt);
      end;      
    end;
   end;
  for dummy:=0 to length(mapfinal)-1 do writeln(mapfinal[dummy]);
  //for dummy:=0 to length(galaxies)-1 do WriteLn('Galaxie #'+IntToStr(dummy+1)+' : x='+IntToStr(galaxies[dummy].x)+' y ='+IntToStr(galaxies[dummy].y));
  total:=0;
  for cpt:=0 to Length(galaxies)-1 do 
  begin
    for curseur:=cpt+1 to Length(galaxies)-1 do 
    begin  
      distance:=Abs(galaxies[curseur].x-galaxies[cpt].x)+Abs(galaxies[curseur].y-galaxies[cpt].y);
      total:=total+distance;
    end;
  end;
  writeln('Total : '+IntToStr(total));
end.