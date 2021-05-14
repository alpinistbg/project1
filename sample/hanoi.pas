(* Автор:    Tao Yue
   Дата:      13 July 2000
   Описание:
      Решение на задачата за Ханойските кули
   Версия:
      1.0 - оригинална версия
*)

program TowersofHanoi;

var
   numdiscs : integer;

(********************************************************)

procedure DoTowers (NumDiscs, OrigPeg, NewPeg, TempPeg : integer);
(* Описание на параметрите:
      NumDiscs -- брой на дисковете на колче OrigPeg
      OrigPeg -- номер на колче на кулата
      NewPeg -- номер на колче, където да се премести кулата
      TempPeg -- колче за временно използване
*)

begin
   (* Обработване на базовия случай -- един диск *)
   if NumDiscs = 1 then
      writeln ([OrigPeg, ' ---> ', NewPeg])
   (* Обработване на всички останали случаи *)
   else
      begin
         (* Първо, преместване на всички дискове без на-долния
            на колче TempPeg, използвайки NewPeg за временно колче
            за преместването *)
         DoTowers (NumDiscs-1, OrigPeg, TempPeg, NewPeg);
         (* После, преместване на най-долния диск от колче OrigPeg
            на колче NewPeg *)
         writeln ([OrigPeg, ' ---> ', NewPeg]);
         (* Накрая, преместване на дисковете, които са в момента на
            колче TempPeg на колче NewPeg, използвайки OrigPeg като временно
            колче за преместването *)
         DoTowers (NumDiscs-1, TempPeg, NewPeg, OrigPeg)
      end
end;

(********************************************************)

begin    (* Main *)
   write ('Моля въведете броя на дисковете в кулата ===> ');
   readln (numdiscs);
   writeln('');
   DoTowers (numdiscs, 1, 3, 2)
end.     (* Main *)
