{$mode objfpc}{$H+}

uses Sysutils;


type node=record
          nodename: string;
          left : string;
          right: string;
     end;


var 
    myFile : TextFile;
    map: array of node;
    ghosts: array of string;
    resultats: array of longint;
    sequence:string;
    s:string;
    dummy,curseur:integer;
    noeudcourant,gauche,droite:string;
    cpt,etape:longint;
    lcm:int64;

function getGCD(a, b: Int64): Int64;
var
  temp: Int64;
begin
  while b <> 0 do
  begin
    temp := b;
    b := a mod b;
    a := temp
  end;
  result := a;
end;

function getLCM(a, b: Int64): Int64;
begin
  result := b * (a div getGCD(a, b));
end;

begin
  SetLength(map,0);
  SetLength(ghosts,0);
  SetLength(resultats,0);

  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  if not Eof(myFile) then ReadLn(myFile, sequence);
  if not Eof(myFile) then ReadLn(myFile, s); // passer le saut de ligne

  while not Eof(myFile) do
  begin
    s:='';
    ReadLn(myFile, s);
    if s<>'' then
    begin
        SetLength(map,length(map)+1);
        map[length(map)-1].left:='';
        map[length(map)-1].right:='';        
        map[length(map)-1].nodename:=s[1]+s[2]+s[3];
        for dummy:=(pos('(',s)+1) to (pos(',',s)-1) do
            map[length(map)-1].left:=map[length(map)-1].left+s[dummy];
        for dummy:=(pos(',',s)+2) to (pos(')',s)-1) do
            map[length(map)-1].right:=map[length(map)-1].right+s[dummy];
    end;
  end; 
  CloseFile(myFile);

  for dummy:=0 to length(map)-1 do
  begin
   if map[dummy].nodename[3]='A' then
   begin
     SetLength(ghosts,length(ghosts)+1);
     ghosts[Length(ghosts)-1]:=map[dummy].nodename;   
   end;
  end;

  WriteLn('Nombre de departs : '+IntToStr(length(ghosts)));
  SetLength(resultats,length(ghosts));
  
  for cpt:=0 to length(ghosts)-1 do
  begin
    writeln('Ghost #'+IntToStr(cpt)+' - Starting at '+ghosts[cpt]);
    noeudcourant:=ghosts[cpt];
    curseur:=1;
    etape:=0;
    repeat
      for dummy:=Low(map) to High(map) do 
      begin
          if map[dummy].nodename=noeudcourant then
          begin
              gauche:=map[dummy].left;
              droite:=map[dummy].right;
              break;
          end;
      end;
      if sequence[curseur]='L' then noeudcourant:=gauche else noeudcourant:=droite;
      inc(curseur);
      if curseur>length(sequence) then curseur:=1;
      inc(etape);
    until (noeudcourant[3]='Z') or (etape>2147483647);
    writeln('Noeud de sortie : '+noeudcourant);    
    resultats[cpt]:=etape;
    writeln('Ghost #'+IntToStr(cpt)+' : '+IntToStr(etape));
  end;
  
  lcm:=getLCM(resultats[0],resultats[1]);

  for cpt:=2 to Length(resultats)-1 do
    lcm:=getLCM(lcm,resultats[cpt]);

  
  writeln('Resultat : '+IntToStr(lcm));
end.
