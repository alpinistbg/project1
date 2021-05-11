program TestBubbleSort;

type
  TItem = integer;   // declare ordinal type for array item
  TArray = array[0..15] of TItem;   // static array

  procedure BubbleSort(var A: TArray);
  var
    Item: TItem;
    K, L, J: integer;

  begin
    L := Low(A) + 1;
    repeat
      K := High(A);
      for J := High(A) downto L do
      begin
        if A[J - 1] > A[J] then
        begin
          Item := A[J - 1];
          A[J - 1] := A[J];
          A[J] := Item;
          K := J;
        end;
      end;
      L := K + 1;
    until L > High(A);
  end;

var
  A: TArray;
  I: integer;

begin
  Randomize;
  for I := Low(A) to High(A) do
    A[I] := Random(100);
  for I := Low(A) to High(A) do
    Write([[A[I], 3]]);
  Writeln([]);
  BubbleSort(A);
  for I := Low(A) to High(A) do
    Write([[A[I], 3]]);
  Writeln([]);
end.
