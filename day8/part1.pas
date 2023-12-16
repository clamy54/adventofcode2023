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
    sequence:string;
    s:string;
    dummy,curseur:integer;
    noeudcourant,gauche,droite:string;
    etape:word;


begin
  SetLength(map,0);
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

  //for dummy:=Low(map) to High(map) do writeln(map[dummy].nodename+' = ('+map[dummy].left+', '+map[dummy].right+')');
 
  noeudcourant:='AAA';
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
  until (noeudcourant='ZZZ') or (etape>65534);

  writeln('Noeud de sortie : '+noeudcourant);
  writeln('en '+IntToStr(etape)+' etapes');
end.
