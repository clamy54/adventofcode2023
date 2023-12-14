{$mode objfpc}{$H+}
uses Sysutils;

type  typecourse=record
        temps: integer;
        distance: integer;
        nbvictoire: LongInt;
      end;

const maxcourses=4;

var  course:array[1..maxcourses] of typecourse;
     sumvictoire,cptvictoire: longint; 
     bcl,vitesse,tempsdecourse,distance,t: integer;    

begin
  course[1].temps:=59;
  course[1].distance:=430;

  course[2].temps:=70;
  course[2].distance:=1218;

  course[3].temps:=78;
  course[3].distance:=1213;

  course[4].temps:=78;
  course[4].distance:=1276;

  for bcl:=1 to maxcourses do 
  begin
    cptvictoire:=0;
    for t:=1 to (course[bcl].temps-1) do
    begin
      vitesse:=t;
      tempsdecourse:=course[bcl].temps-t;
      distance:=tempsdecourse*vitesse;
      if distance>course[bcl].distance then inc(cptvictoire);
    end;
    writeln('Nombre de victoire dans la course '+IntToStr(bcl)+': '+IntToStr(cptvictoire));
    course[bcl].nbvictoire:=cptvictoire;
  end;

  sumvictoire:=1;
  for bcl:=1 to maxcourses do sumvictoire:=sumvictoire*course[bcl].nbvictoire;
  writeln('Score total '+IntToStr(sumvictoire));

end.