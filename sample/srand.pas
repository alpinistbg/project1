const
  RAND_MAX = $7fffffff;
var
  rand_next: longword;

function Rand: integer;
begin
  rand_next := rand_next * 1103515245 + 12345;
  Result := rand_next mod longword(RAND_MAX + 1);
  //Result := Result mod Mx;
end;

procedure SRand(Seed: longword);
begin
  rand_next := Seed;
end;

begin
  srand(666);
  write([rand, ' ', rand, ' ', rand]);
end.
