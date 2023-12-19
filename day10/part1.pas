{$mode objfpc}
{$codePage CP850}
uses Sysutils, Classes, graph,wincrt; 

type mapelement=record 
                  west,east,north,south:Boolean;
                  element:char;
                  visited:byte;
                end;

    explorateur=record  
                  score,x,y:word;
                  active:Boolean;
                end;

var
  myFile : TextFile;
  map: array of array of mapelement;
  animal: array[1..4] of explorateur;
  s:string;
  dummy:byte;
  nextx,nexty,maxlines,maxcol,nbligne,startx,starty:word;
  trigger:Boolean;
  cpt:byte;
  gd,gm,px,py : smallint; 
  PathToDriver : string; 

procedure drawelement(x,y: smallint;visited:Byte;element:char);
begin

  Case visited of  
   0  : SetColor(DarkGray);  
   1  : SetColor(Red); 
   2  : SetColor(Green); 
   3  : SetColor(Blue); 
   4  : SetColor(Yellow); 
   5  : SetColor(White); 
  else 
   SetColor(LightGray);
  end;
//  OutTextXY (x,y,element);


    if element='.' then 
    begin
      line(x+4,y+3,x+4,y+5);
    end;
    if element=chr(218) then  // ┌
    begin
      line(x+4,y+4,x+4,y+8);
      line(x+4,y+4,x+8,y+4);
    end;
    if element=chr(217) then // ┘ 
    begin
      line(x,y+4,x+4,y+4);
      line(x+4,y+4,x+4,y);
    end;
    if element=chr(191) then // ┐
    begin
      line(x,y+4,x+4,y+4);
      line(x+4,y+4,x+4,y+8);
    end;
    if element=chr(192) then // └ 
    begin
      line(x+4,y,x+4,y+4);
      line(x+4,y+4,x+8,y+4);
    end;
    if element=chr(196) then // ─
    begin
      line(x,y+4,x+8,y+4);
    end;
    if element=chr(124) then // | 
    begin
      line(x+4,y,x+4,y+8);
    end;
    if element='S' then 
    begin
      OutTextXY(x,y,'S');
    end;

end;


begin
  nbligne:=0;
  AssignFile(myFile, 'sample.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    inc(nbligne);
  end;
  CloseFile(myFile);
  SetLength(map, nbligne, length(s));
  maxlines:=nbligne;
  maxcol:=Length(s);
  nbligne:=0;

  AssignFile(myFile, 'sample.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    s:=StringReplace(s,'F',chr(218),[rfReplaceAll]); // ┌
    s:=StringReplace(s,'J',chr(217),[rfReplaceAll]); // ┘
    s:=StringReplace(s,'7',chr(191),[rfReplaceAll]); // ┐
    s:=StringReplace(s,'L',chr(192),[rfReplaceAll]); // └
    s:=StringReplace(s,'-',chr(196),[rfReplaceAll]); // ─
    s:=StringReplace(s,'|',chr(124),[rfReplaceAll]); // | 
    for dummy:=1 to length(s) do 
    begin
      map[nbligne][dummy-1].element:=s[dummy];
      map[nbligne][dummy-1].visited:=0;
      if s[dummy]='.' then 
      begin
         map[nbligne][dummy-1].east:=false;
         map[nbligne][dummy-1].south:=false;
         map[nbligne][dummy-1].north:=false;
         map[nbligne][dummy-1].west:=false;
      end;
      if s[dummy]=chr(218) then 
      begin
         map[nbligne][dummy-1].east:=true;
         map[nbligne][dummy-1].south:=true;
         map[nbligne][dummy-1].north:=false;
         map[nbligne][dummy-1].west:=false;
      end;
      if s[dummy]=chr(217) then 
      begin
         map[nbligne][dummy-1].north:=true;
         map[nbligne][dummy-1].east:=false;
         map[nbligne][dummy-1].south:=false;
         map[nbligne][dummy-1].west:=true;
      end;
      if s[dummy]=chr(191) then 
      begin
         map[nbligne][dummy-1].north:=false;
         map[nbligne][dummy-1].east:=false;
         map[nbligne][dummy-1].south:=true;
         map[nbligne][dummy-1].west:=true;
      end;
      if s[dummy]=chr(192) then 
      begin
         map[nbligne][dummy-1].north:=true;
         map[nbligne][dummy-1].east:=true;
         map[nbligne][dummy-1].south:=false;
         map[nbligne][dummy-1].west:=false;
      end;
      if s[dummy]=chr(196) then 
      begin
         map[nbligne][dummy-1].north:=false;
         map[nbligne][dummy-1].east:=true;
         map[nbligne][dummy-1].south:=false;
         map[nbligne][dummy-1].west:=true;
      end;
      if s[dummy]=chr(124) then 
      begin
         map[nbligne][dummy-1].north:=true;
         map[nbligne][dummy-1].east:=false;
         map[nbligne][dummy-1].south:=true;
         map[nbligne][dummy-1].west:=false;
      end;
      if s[dummy]='S' then 
      begin
         startx:=dummy-1;
         starty:=nbligne;
         map[nbligne][dummy-1].north:=true;
         map[nbligne][dummy-1].east:=true;
         map[nbligne][dummy-1].south:=true;
         map[nbligne][dummy-1].west:=true;
         map[nbligne][dummy-1].visited:=5;
      end;       
    end;
    writeln(s);
    inc(nbligne);
  end;  
  CloseFile(myFile);
  animal[1].score:=0;
  animal[2].score:=0;
  animal[3].score:=0;
  animal[4].score:=0;
  animal[1].active:=false;
  animal[2].active:=false;
  animal[3].active:=false;
  animal[4].active:=false;
  WriteLn('Position du S :'+IntToStr(startx)+','+IntToStr(starty));
  if startx>0 then
  begin
    if map[starty][startx-1].east=true then
    begin
      animal[4].x:=startx-1;
      animal[4].y:=starty;
      animal[4].active:=true;
      animal[4].score:=1;
      writeln('animal 4 actif '+IntToStr(animal[4].x)+','+IntToStr(animal[4].y));
    end;
  end;
  if starty>0 then
  begin
    if map[starty-1][startx].south=true then
    begin
      animal[1].x:=startx;
      animal[1].y:=starty-1;
      animal[1].active:=true;
      animal[1].score:=1;
      writeln('animal 1 actif '+IntToStr(animal[1].x)+','+IntToStr(animal[1].y));
    end;
  end;
  if starty<maxlines-1  then
  begin
    if map[starty+1][startx].north=true then
    begin
      animal[3].x:=startx;
      animal[3].y:=starty+1;
      animal[3].active:=true;
      animal[3].score:=1;
      writeln('animal 3 actif '+IntToStr(animal[3].x)+','+IntToStr(animal[3].y));
    end;
  end;
  if startx<maxcol-1  then
  begin
    if map[starty][startx+1].west=true then
    begin
      animal[2].x:=startx+1;
      animal[2].y:=starty;
      animal[2].active:=true;
      animal[2].score:=1;
      writeln('animal 2 actif '+IntToStr(animal[2].x)+','+IntToStr(animal[2].y));
    end;
  end;

  repeat
    cpt:=0;
    for dummy:=1 to 4 do
      begin
        trigger:=false;
        if animal[dummy].active=true then
        begin
          map[animal[dummy].y][animal[dummy].x].visited:=dummy;
          if animal[dummy].x>0 then    // gauche
          begin
            if (map[animal[dummy].y][animal[dummy].x].west=true)  and (map[animal[dummy].y][animal[dummy].x-1].east=true) and (map[animal[dummy].y][animal[dummy].x-1].visited=0)  then
            begin
              nextx:=animal[dummy].x-1;
              nexty:=animal[dummy].y;
              animal[dummy].score:=animal[dummy].score+1;
              trigger:=true;
            end;
          end;
          if animal[dummy].x<maxcol-1 then  // droite
          begin
            if (map[animal[dummy].y][animal[dummy].x].east=true)  and (map[animal[dummy].y][animal[dummy].x+1].west=true) and (map[animal[dummy].y][animal[dummy].x+1].visited=0)  then
            begin
              nextx:=animal[dummy].x+1;
              nexty:=animal[dummy].y;
              animal[dummy].score:=animal[dummy].score+1;
              trigger:=true;
            end;
          end;
          if animal[dummy].y>0 then  // haut
          begin
            if (map[animal[dummy].y][animal[dummy].x].north=true)  and (map[animal[dummy].y-1][animal[dummy].x].south=true) and (map[animal[dummy].y-1][animal[dummy].x].visited=0)  then
            begin
              nextx:=animal[dummy].x;
              nexty:=animal[dummy].y-1;
              animal[dummy].score:=animal[dummy].score+1;
              trigger:=true;
            end;
          end;
          if animal[dummy].y<maxlines-1 then // bas
          begin
            if (map[animal[dummy].y][animal[dummy].x].south=true)  and (map[animal[dummy].y+1][animal[dummy].x].north=true) and (map[animal[dummy].y+1][animal[dummy].x].visited=0)  then
            begin
              nextx:=animal[dummy].x;
              nexty:=animal[dummy].y+1;
              animal[dummy].score:=animal[dummy].score+1;
              trigger:=true;
            end;
          end;
          if trigger=false then 
          begin
            animal[dummy].active:=false;
          end
          else
          begin
            animal[dummy].x:=nextx;
            animal[dummy].y:=nexty;
          end;
        end
        else
        begin
          inc(cpt)
        end;
      end;
  until cpt=4;
  Writeln('Resultats : ');
  for dummy:=1 to 4 do 
  begin
  // if animal[dummy].score>0 then inc(animal[dummy].score);
   WriteLn('Animal #'+IntToStr(dummy)+' -> '+IntToStr(animal[dummy].score)+'  -  '+IntToStr(animal[dummy].x)+','+IntToStr(animal[dummy].y));
  end;
   gd:=detect; 
   gm:=0; 
   PathToDriver:=''; 
   InitGraph(gd,gm,PathToDriver); 
   if GraphResult<>grok then writeln('error graph');
   py:=0;
   for starty:=0 to maxlines-1 do
   begin
    px:=0;
      for startx:=0 to maxcol-1 do
        begin
          drawelement(px,py,map[starty][startx].visited,map[starty][startx].element);
          px:=px+9;
        end;
    py:=py+9;  
  end;
 repeat
  
 until keypressed;
 Closegraph;

end.