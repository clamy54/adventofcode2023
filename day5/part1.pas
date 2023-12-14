{$mode objfpc}{$H+}
uses Sysutils,Classes;
        
type map=record
          source, destination, size : int64;
     end;
           
var
  myFile : TextFile;
  seeds: array of int64;
  seedtosoil: array of map;
  soiltofertilizer: array of map;
  fertilizertowater: array of map; 
  watertolight: array of map; 
  lighttotemperature: array of map;
  temperaturetohumidity: array of map;
  humiditytolocation: array of map;
  boucle: Integer;
  valueseed,valuesoil,valuefertilizer,valuewater,valuelight,valuetemperature,valuehumidity,valuelocation,minlocation: int64;


function isanumber(c: char): Boolean;
begin
  if ((ord(c)>47) and (Ord(c)<58)) then isanumber:=true else isanumber:=false;
end;


function getlocationfromhumidity(n: int64):int64;
var output: int64;
    t: integer;
begin
 output:=n;
 for t:=0 to length(humiditytolocation)-1 do
   begin
    if (n>=humiditytolocation[t].source) and (n<=(humiditytolocation[t].source+humiditytolocation[t].size)-1) then
    begin
      output:= (n-humiditytolocation[t].source)+humiditytolocation[t].destination;
      break;
    end;    
   end;
   getlocationfromhumidity:=output;
end;


function gethumidityfromtemperature(n: int64):int64;
var output: int64;
    t: integer;
begin
 output:=n;
 for t:=0 to length(temperaturetohumidity)-1 do
   begin
    if (n>=temperaturetohumidity[t].source) and (n<=(temperaturetohumidity[t].source+temperaturetohumidity[t].size)-1) then
    begin
      output:= (n-temperaturetohumidity[t].source)+temperaturetohumidity[t].destination;
      break;
    end;    
   end;
   gethumidityfromtemperature:=output;
end;


function gettemperaturefromlight(n: int64):int64;
var output: int64;
    t: integer;
begin
 output:=n;
 for t:=0 to length(lighttotemperature)-1 do
   begin
    if (n>=lighttotemperature[t].source) and (n<=(lighttotemperature[t].source+lighttotemperature[t].size)-1) then
    begin
      output:= (n-lighttotemperature[t].source)+lighttotemperature[t].destination;
      break;
    end;    
   end;
   gettemperaturefromlight:=output;
end;


function getlightfromwater(n: int64):int64;
var output: int64;
    t: integer;
begin
 output:=n;
 for t:=0 to length(watertolight)-1 do
   begin
    if (n>=watertolight[t].source) and (n<=(watertolight[t].source+watertolight[t].size)-1) then
    begin
      output:= (n-watertolight[t].source)+watertolight[t].destination;
      break;
    end;    
   end;
   getlightfromwater:=output;
end;


function getwaterfromfertilizer(n: int64):int64;
var output: int64;
    t: integer;
begin
 output:=n;
 for t:=0 to length(fertilizertowater)-1 do
   begin
    if (n>=fertilizertowater[t].source) and (n<=(fertilizertowater[t].source+fertilizertowater[t].size)-1) then
    begin
      output:= (n-fertilizertowater[t].source)+fertilizertowater[t].destination;
      break;
    end;    
   end;
   getwaterfromfertilizer:=output;
end;


function getfertilizerfromsoil(n: int64):int64;
var output: int64;
    t: integer;
begin
 output:=n;
 for t:=0 to length(soiltofertilizer)-1 do
   begin
    if (n>=soiltofertilizer[t].source) and (n<=(soiltofertilizer[t].source+soiltofertilizer[t].size)-1) then
    begin
      output:= (n-soiltofertilizer[t].source)+soiltofertilizer[t].destination;
      break;
    end;    
   end;
   getfertilizerfromsoil:=output;
end;

function getsoilfromseed(n: int64):int64;
var output: int64;
    t: integer;
begin
 output:=n;
 for t:=0 to length(seedtosoil)-1 do
   begin
    if (n>=seedtosoil[t].source) and (n<=(seedtosoil[t].source+seedtosoil[t].size)-1) then
    begin
      output:= (n-seedtosoil[t].source)+seedtosoil[t].destination;
      break;
    end;    
   end;
   getsoilfromseed:=output;
end;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Assert(Assigned(Strings)) ;
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
   Strings.StrictDelimiter := true;
end;

procedure openfic();
begin
  AssignFile(myFile, 'input.txt');
  Reset(myFile);
end;

procedure closefic();
begin
  CloseFile(myFile);
end;

procedure loadseed();
var s,numstr:string;
    trigger:Boolean;
    cpt,dummy:Byte;

begin
  openfic;
  s:='';
  while (pos('seeds:',s)=0) and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
  end;
  closefic;
  if (pos('seeds:',s)=1) then 
  begin
    cpt:=0;
    trigger:=false;
    for dummy:=(pos(':',s)+1) to Length(s) do
      begin
        if isanumber(s[dummy]) then
        begin
          if trigger=False then
          begin
            trigger:=true;
            inc(cpt);
          end;
        end
        else
        begin
          if trigger=true then
          begin
            trigger:=false;
          end;
        end;
      end;
    setLength(seeds, cpt); 
    trigger:=false;
    numstr:='';
    cpt:=0;
    for dummy:=(pos(':',s)+1) to Length(s) do
      begin
        if isanumber(s[dummy]) then
        begin
          if trigger=False then
          begin
            trigger:=true;
          end;
          numstr:=numstr+s[dummy];
        end
        else
        begin
          if trigger=true then
          begin
            seeds[cpt]:=StrToInt64(numstr);
            trigger:=false;
            numstr:='';
            inc(cpt);
          end;
        end;
      end;
    if trigger=true then
    begin
      seeds[cpt]:=StrToInt64(numstr);
      trigger:=false;
      numstr:='';
      inc(cpt);
    end;   
  end;
end;


procedure loadseedtosoilmap();
var s:string;
    cpt:Byte;
    List: TStringList;


  procedure jumptosection;
  begin
    while (pos('seed-to-soil map:',s)=0) and (not(eof(myFile))) do
    begin
      ReadLn(myFile, s);
    end;
  end;

begin
  List := TStringList.Create;
  openfic;
  jumptosection;
  s:=' ';
  cpt:=0;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    inc(cpt);
  end;
  closefic;  
  dec(cpt);
  setLength(seedtosoil, cpt);
  cpt:=0;
  openfic;
  jumptosection;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    if s<>'' then 
    begin
      Split(' ', s, List);
      seedtosoil[cpt].destination:=StrToInt64(List[0]);
      seedtosoil[cpt].source:=StrToInt64(List[1]);
      seedtosoil[cpt].size:=StrToInt64(List[2]);
      inc(cpt);
    end;
  end;
  closefic;  
  List.Free;
end;

procedure loadsoiltofertilizer();
var s:string;
    cpt:Byte;
    List: TStringList;


  procedure jumptosection;
  begin
    while (pos('soil-to-fertilizer map:',s)=0) and (not(eof(myFile))) do
    begin
      ReadLn(myFile, s);
    end;
  end;

begin
  List := TStringList.Create;
  openfic;
  jumptosection;
  s:=' ';
  cpt:=0;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    inc(cpt);
  end;
  closefic;  
  dec(cpt);
  setLength(soiltofertilizer, cpt);
  cpt:=0;
  openfic;
  jumptosection;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    if s<>'' then 
    begin
      Split(' ', s, List);
      soiltofertilizer[cpt].destination:=StrToInt64(List[0]);
      soiltofertilizer[cpt].source:=StrToInt64(List[1]);
      soiltofertilizer[cpt].size:=StrToInt64(List[2]);
      inc(cpt);
    end;
  end;
  closefic;  
  List.Free;
end;


procedure loadfertilizertowater();
var s:string;
    cpt:Byte;
    List: TStringList;


  procedure jumptosection;
  begin
    while (pos('fertilizer-to-water map:',s)=0) and (not(eof(myFile))) do
    begin
      ReadLn(myFile, s);
    end;
  end;

begin
  List := TStringList.Create;
  openfic;
  jumptosection;
  s:=' ';
  cpt:=0;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    inc(cpt);
  end;
  closefic;  
  dec(cpt);
  setLength(fertilizertowater, cpt);
  cpt:=0;
  openfic;
  jumptosection;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    if s<>'' then 
    begin
      Split(' ', s, List);
      fertilizertowater[cpt].destination:=StrToInt64(List[0]);
      fertilizertowater[cpt].source:=StrToInt64(List[1]);
      fertilizertowater[cpt].size:=StrToInt64(List[2]);
      inc(cpt);
    end;
  end;
  closefic;  
  List.Free;
end;

procedure loadwatertolight();
var s:string;
    cpt:Byte;
    List: TStringList;


  procedure jumptosection;
  begin
    while (pos('water-to-light map:',s)=0) and (not(eof(myFile))) do
    begin
      ReadLn(myFile, s);
    end;
  end;

begin
  List := TStringList.Create;
  openfic;
  jumptosection;
  s:=' ';
  cpt:=0;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    inc(cpt);
  end;
  closefic;  
  dec(cpt);
  setLength(watertolight, cpt);
  cpt:=0;
  openfic;
  jumptosection;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    if s<>'' then 
    begin
      Split(' ', s, List);
      watertolight[cpt].destination:=StrToInt64(List[0]);
      watertolight[cpt].source:=StrToInt64(List[1]);
      watertolight[cpt].size:=StrToInt64(List[2]);
      inc(cpt);
    end;
  end;
  closefic;  
  List.Free;
end;

procedure loadlighttotemperature();
var s:string;
    cpt:Byte;
    List: TStringList;


  procedure jumptosection;
  begin
    while (pos('light-to-temperature map:',s)=0) and (not(eof(myFile))) do
    begin
      ReadLn(myFile, s);
    end;
  end;

begin
  List := TStringList.Create;
  openfic;
  jumptosection;
  s:=' ';
  cpt:=0;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    inc(cpt);
  end;
  closefic;  
  dec(cpt);
  setLength(lighttotemperature, cpt);
  cpt:=0;
  openfic;
  jumptosection;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    if s<>'' then 
    begin
      Split(' ', s, List);
      lighttotemperature[cpt].destination:=StrToInt64(List[0]);
      lighttotemperature[cpt].source:=StrToInt64(List[1]);
      lighttotemperature[cpt].size:=StrToInt64(List[2]);
      inc(cpt);
    end;
  end;
  closefic;  
  List.Free;
end;

procedure loadtemperaturetohumidity();
var s:string;
    cpt:Byte;
    List: TStringList;


  procedure jumptosection;
  begin
    while (pos('temperature-to-humidity map:',s)=0) and (not(eof(myFile))) do
    begin
      ReadLn(myFile, s);
    end;
  end;

begin
  List := TStringList.Create;
  openfic;
  jumptosection;
  s:=' ';
  cpt:=0;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    inc(cpt);
  end;
  closefic;  
  dec(cpt);
  setLength(temperaturetohumidity, cpt);
  cpt:=0;
  openfic;
  jumptosection;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    if s<>'' then 
    begin
      Split(' ', s, List);
      temperaturetohumidity[cpt].destination:=StrToInt64(List[0]);
      temperaturetohumidity[cpt].source:=StrToInt64(List[1]);
      temperaturetohumidity[cpt].size:=StrToInt64(List[2]);
      inc(cpt);
    end;
  end;
  closefic;  
  List.Free;
end;

procedure loadhumiditytolocation();
var s:string;
    cpt:Byte;
    List: TStringList;


  procedure jumptosection;
  begin
    while (pos('humidity-to-location map:',s)=0) and (not(eof(myFile))) do
    begin
      ReadLn(myFile, s);
    end;
  end;

begin
  List := TStringList.Create;
  openfic;
  jumptosection;
  s:=' ';
  cpt:=0;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    inc(cpt);
  end;
  closefic;  
  dec(cpt);
  setLength(humiditytolocation, cpt);
  cpt:=0;
  openfic;
  jumptosection;
  while (s<>'') and (not(eof(myFile))) do
  begin
    ReadLn(myFile, s);
    if s<>'' then 
    begin
      Split(' ', s, List);
      humiditytolocation[cpt].destination:=StrToInt64(List[0]);
      humiditytolocation[cpt].source:=StrToInt64(List[1]);
      humiditytolocation[cpt].size:=StrToInt64(List[2]);
      inc(cpt);
    end;
  end;
  closefic;  
  List.Free;
end;

begin
  loadseed();
  loadseedtosoilmap();
  loadsoiltofertilizer();
  loadfertilizertowater();
  loadwatertolight();
  loadlighttotemperature();
  loadtemperaturetohumidity();
  loadhumiditytolocation();

  minlocation:=0;

  for boucle:=0 to length(seeds)-1 do
    begin
      valueseed:=seeds[boucle];
      valuesoil:=getsoilfromseed(valueseed);
      valuefertilizer:=getfertilizerfromsoil(valuesoil);
      valuewater:=getwaterfromfertilizer(valuefertilizer);
      valuelight:=getlightfromwater(valuewater);
      valuetemperature:=gettemperaturefromlight(valuelight);
      valuehumidity:=gethumidityfromtemperature(valuetemperature);
      valuelocation:=getlocationfromhumidity(valuehumidity);
     
      if minlocation=0 then
      begin
        minlocation:=valuelocation;
      end
      else
      begin
        if valuelocation<minlocation then minlocation:=valuelocation;
      end;
  end;
  WriteLn('lowest location number : ',IntToStr(minlocation));
end.