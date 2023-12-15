{$mode objfpc}{$H+}
uses Sysutils,Classes;


type game=record
          cartes : string;
          enchere: LongInt;
     end;

var 
    myFile : TextFile;
    List: TStringList;
    s: string;
    trifinal,cartehaute,unepaire,deuxpaires,brelan,full,carre,quinte: array of game;
    szcartehaute,szunepaire,szdeuxpaires,szbrelan,szfull,szcarre,szquinte: Integer;
    cpt,t: LongInt;
    score: QWord;


function valeurcarte(c: char):integer;
begin
  if ((ord(c)>49) and (Ord(c)<58)) then valeurcarte:=StrToInt(c);
  if c='T' then valeurcarte:=10;
  if c='J' then valeurcarte:=1;
  if c='Q' then valeurcarte:=12;
  if c='K' then valeurcarte:=13;
  if c='A' then valeurcarte:=14;
  if c='W' then valeurcarte:=15;
  if c='X' then valeurcarte:=16;
  if c='Y' then valeurcarte:=17;
  if c='Z' then valeurcarte:=18;

end;

function valeurcartepourtri(c: char):integer;
begin
  if ((ord(c)>49) and (Ord(c)<58)) then valeurcartepourtri:=StrToInt(c);
  if c='T' then valeurcartepourtri:=10;
  if c='J' then valeurcartepourtri:=1;
  if c='Q' then valeurcartepourtri:=12;
  if c='K' then valeurcartepourtri:=13;
  if c='A' then valeurcartepourtri:=14;
end;

function comparetwohands(a,b : string): Boolean;
// return true if hand a is better than hand b
var cpt : byte;
    trigger:Boolean;

begin
  trigger:=true;
  for cpt:=1 to Length(a) do
  begin 
    if (trigger=true) and (valeurcartepourtri(b[cpt])>valeurcartepourtri(a[cpt])) then 
    begin
      trigger:=false;
      break;    
    end;
    if (trigger=true) and (valeurcartepourtri(b[cpt])<valeurcartepourtri(a[cpt])) then 
    begin
      break;    
    end;
  end;
  comparetwohands:=trigger;
end;

procedure fartinbathsort(var liste: array of game);
var cpt1,cpt2: integer;
    trigger:boolean;
    tampon:game;
begin
  if length(liste)>0 then
  begin
    for cpt1:=0 to Length(liste)-1 do
    begin
        trigger:=false;
        for cpt2:=0 to Length(liste)-2 do
        begin
          if (comparetwohands(liste[cpt2].cartes,liste[cpt2+1].cartes)=true) then
          begin
            tampon.cartes:=liste[cpt2].cartes;
            tampon.enchere:=liste[cpt2].enchere;
            liste[cpt2].cartes:=liste[cpt2+1].cartes;
            liste[cpt2].enchere:=liste[cpt2+1].enchere;
            liste[cpt2+1].cartes:=tampon.cartes;
            liste[cpt2+1].enchere:=tampon.enchere;
            trigger:=true;
          end;
        end;
        if trigger=False then break;  // si une iteration sans deplacement, on arrete le tri
    end;
  end;
end;


function detectemain(s: string):integer;
var cpt1,cpt2: integer;
    tampon: char;
    c1,c2,c3,c4,c5: integer;
    nbjoker:Integer;
    trig:boolean;

begin

  nbjoker:=0;

  for cpt1:=1 to Length(s) do if s[cpt1]='J' then inc(nbjoker);

  // trie la main par valeur
  for cpt1:=1 to length(s)-1 do
    for cpt2:=1 to length(s)-1 do
    begin
      if valeurcarte(s[cpt2])>valeurcarte(s[cpt2+1]) then 
      begin
        tampon:=s[cpt2];
        s[cpt2]:=s[cpt2+1];
        s[cpt2+1]:=tampon;
      end;
    end;
  
  // Permet d'eviter que les J interferent dans le classement de la main
  s:=StringReplace(s,'J','W',[]);
  s:=StringReplace(s,'J','X',[]);
  s:=StringReplace(s,'J','Y',[]);
  s:=StringReplace(s,'J','Z',[]);

  c1:=valeurcarte(s[1]);
  c2:=valeurcarte(s[2]);
  c3:=valeurcarte(s[3]);
  c4:=valeurcarte(s[4]);
  c5:=valeurcarte(s[5]);

  if (c1=c2) and (c2=c3) and (c3=c4) and (c4=c5) then
  begin
    detectemain:=7;  // Five of a kind
  end
  else 
  begin
    if ((c1=c2) and (c2=c3) and (c3=c4) and (c4<>c5)) or ((c1<>c2) and (c2=c3) and (c3=c4) and (c4=c5)) then
    begin
      detectemain:=6;  // Four of a kind
    end
    else
    begin
      if ((c1=c2) and (c2=c3) and (c4=c5)) or ((c1=c2) and (c3=c4) and (c4=c5)) then
      begin
        detectemain:=5;  // Full House
      end
      else
      begin
        if ((c1=c2) and (c2=c3)) or ((c2=c3) and (c3=c4)) or ((c3=c4) and (c4=c5)) then
        begin
          detectemain:=4;  // Three of a kind
        end 
        else
        begin
          if ((c1=c2) and (c3=c4)) or ((c2=c3) and (c4=c5)) or ((c1=c2) and (c4=c5)) then
          begin
            detectemain:=3;  // Two pairs
          end
          else
          begin
            if (c1=c2) or (c2=c3) or (c3=c4) or (c4=c5) then
            begin
              detectemain:=2; // One pair
            end
            else
              detectemain:=1; //High card
          end;
        end;
      end;
    end;
  end;
  if (nbjoker=5) then detectemain:=7;
  if (detectemain=6) and (nbjoker=1) then detectemain:=7;
  if (detectemain=4) and (nbjoker>=1) then
    if (nbjoker=1) then detectemain:=6 else detectemain:=7;
  if (detectemain=3) and (nbjoker=1) then detectemain:=5;
  if (detectemain=2) and (nbjoker>=1) then
  begin
    if nbjoker=1 then detectemain:=4;
    if nbjoker=2 then detectemain:=6;
    if nbjoker=3 then detectemain:=7;
  end;
  if (detectemain=1) and (nbjoker>=1) then
  begin
    if nbjoker=1 then detectemain:=2;
    if nbjoker=2 then detectemain:=4;
    if nbjoker=3 then detectemain:=6;
    if nbjoker=4 then detectemain:=7;
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
  List := TStringList.Create;
  szcartehaute:=0;
  szunepaire:=0;
  szdeuxpaires:=0;
  szbrelan:=0;
  szfull:=0;
  szcarre:=0;
  szquinte:=0;
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
  while not Eof(myFile) do
  begin
    ReadLn(myFile, s);
    Split(' ', s, List);
    if s<>'' then
    begin
      Split(' ', s, List);
      // stockage dans les tableaux dynamiques correspondants 
      // si carte haute
      if detectemain(List[0])=1 then
      begin
        inc(szcartehaute);
        SetLength(cartehaute,szcartehaute);
        cartehaute[szcartehaute-1].cartes:=List[0];
        cartehaute[szcartehaute-1].enchere:=StrToInt(List[1]);
      end;
      // si une paire
      if detectemain(List[0])=2 then
      begin
        inc(szunepaire);
        SetLength(unepaire,szunepaire);
        unepaire[szunepaire-1].cartes:=List[0];
        unepaire[szunepaire-1].enchere:=StrToInt(List[1]);
      end;
      // si deux paires
      if detectemain(List[0])=3 then
      begin
        inc(szdeuxpaires);
        SetLength(deuxpaires,szdeuxpaires);
        deuxpaires[szdeuxpaires-1].cartes:=List[0];
        deuxpaires[szdeuxpaires-1].enchere:=StrToInt(List[1]);
      end;
      // si brelan
      if detectemain(List[0])=4 then
      begin
        inc(szbrelan);
        SetLength(brelan,szbrelan);
        brelan[szbrelan-1].cartes:=List[0];
        brelan[szbrelan-1].enchere:=StrToInt(List[1]);
      end;
      // si full
      if detectemain(List[0])=5 then
      begin
        inc(szfull);
        SetLength(full,szfull);
        full[szfull-1].cartes:=List[0];
        full[szfull-1].enchere:=StrToInt(List[1]);
      end;
      // si carre
      if detectemain(List[0])=6 then
      begin
        inc(szcarre);
        SetLength(carre,szcarre);
        carre[szcarre-1].cartes:=List[0];
        carre[szcarre-1].enchere:=StrToInt(List[1]);
      end;
      // si quinte
      if detectemain(List[0])=7 then
      begin
        inc(szquinte);
        SetLength(quinte,szquinte);
        quinte[szquinte-1].cartes:=List[0];
        quinte[szquinte-1].enchere:=StrToInt(List[1]);
      end;      
    end;
  end;
  CloseFile(myFile);
  List.Free;

  Writeln('Nombre de main stockees :');
  WriteLn('Carte Haute : '+IntToStr(Length(cartehaute)));
  WriteLn('Une paire : '+IntToStr(Length(unepaire)));
  WriteLn('Deux paires : '+IntToStr(Length(deuxpaires)));
  WriteLn('Brelan : '+IntToStr(Length(brelan)));
  WriteLn('Full : '+IntToStr(Length(full)));
  WriteLn('Carre : '+IntToStr(Length(carre)));
  WriteLn('Quinte : '+IntToStr(Length(quinte)));

  fartinbathsort(cartehaute);
  fartinbathsort(unepaire);
  fartinbathsort(deuxpaires);
  fartinbathsort(brelan);
  fartinbathsort(full);
  fartinbathsort(carre);
  fartinbathsort(quinte);

  writeln();


  SetLength(trifinal,Length(cartehaute)+Length(unepaire)+Length(deuxpaires)+Length(brelan)+Length(full)+Length(carre)+Length(quinte));
  t:=0;
  if Length(cartehaute)>0 then
    for cpt:=Low(cartehaute) to High(cartehaute) do 
    begin 
    trifinal[t]:=cartehaute[cpt];
    inc(t);
    end;

  if Length(unepaire)>0 then
    for cpt:=Low(unepaire) to High(unepaire) do 
    begin 
    trifinal[t]:=unepaire[cpt];
    inc(t);
    end;

  if Length(deuxpaires)>0 then
    for cpt:=Low(deuxpaires) to High(deuxpaires) do 
    begin 
    trifinal[t]:=deuxpaires[cpt];
    inc(t);
    end;

  if Length(brelan)>0 then
    for cpt:=Low(brelan) to High(brelan) do 
    begin 
    trifinal[t]:=brelan[cpt];
    inc(t);
    end;

  if Length(full)>0 then
    for cpt:=Low(full) to High(full) do 
    begin 
    trifinal[t]:=full[cpt];
    inc(t);
    end;

  if Length(carre)>0 then
    for cpt:=Low(carre) to High(carre) do 
    begin 
    trifinal[t]:=carre[cpt];
    inc(t);
    end;

  if Length(quinte)>0 then
    for cpt:=Low(quinte) to High(quinte) do 
    begin 
    trifinal[t]:=quinte[cpt];
    inc(t);
    end;


  WriteLn('Affichage des resultats');
  
  for t:=Low(trifinal) to High(trifinal) do writeln(trifinal[t].cartes);
  
  writeln('Nb d entrees dans le tableau final : '+IntToStr(length(trifinal)));
  score:=0;

 
  for t:=0 to Length(trifinal)-1 do score:=score+trifinal[t].enchere*(t+1);

  writeln();
  writeln('score : '+IntToStr(score));  
   

end.