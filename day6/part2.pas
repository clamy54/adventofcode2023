{$mode objfpc}{$H+}
uses Sysutils;

type  typecourse=record
        temps: qword;
        distance: qword;
        nbvictoire: qword;
      end;

const maxcourses=1;

var  course:array[1..maxcourses] of typecourse;
     sumvictoire,cptvictoire: qword; 
     bcl,vitesse,tempsdecourse,distance,t: qword;    

begin
  course[1].temps:=59707878;
  course[1].distance:=430121812131276;

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