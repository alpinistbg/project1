program HeapSortDemo;

const
  RAND_MAX = $7fffffff;

type
  TIntArray = array[4..15] of integer;

var
  data: TIntArray;
  i: integer;
  rand_next: LongWord;

function Random(Mx: Integer): Integer;
begin
  rand_next := rand_next * 1103515245 + 12345;
  Result := rand_next mod LongWord(RAND_MAX + 1);
  Result := Result mod Mx;
end;

procedure Randomize(Seed: LongWord);
begin
  rand_next := Seed;
end;

procedure siftDown(var a: TIntArray; start, ende: integer);
  var
    root, child, swap: integer;
  begin
    root := start;
    while root * 2 - start + 1 <= ende do
    begin
      child := root * 2 - start + 1;
      if (child + 1 <= ende) and (a[child] < a[child + 1]) then
        inc(child);
      if a[root] < a[child] then
      begin
	swap     := a[root];
        a[root]  := a[child];
        a[child] := swap;
        root := child;
      end
      else
        exit;
    end;
  end;

procedure heapify(var a: TIntArray);
  var
    start, count: integer;
  begin
    count := length(a);
    start := low(a) + count div 2 - 1;
    while start >= low(a) do
    begin
      siftdown(a, start, high(a));
      dec(start);
    end;
  end;

procedure heapSort(var a: TIntArray);
  var
    ende, swap: integer;
  begin
    heapify(a);
    ende := high(a);
    while ende > low(a) do
    begin
      swap := a[low(a)];
      a[low(a)] := a[ende];
      a[ende] := swap;
      dec(ende);
      siftdown(a, low(a), ende);
    end;
  end;

begin
  Randomize(7878);
  writeln('The data before sorting:');
  for i := low(data) to high(data) do
  begin
    data[i] := Random(high(data));
    write([[data[i],4]]);
  end;
  writeln([]);
  heapSort(data);
  writeln('The data after sorting:');
  for i := low(data) to high(data) do
  begin
    write([[data[i],4]]);
  end;
  writeln([]);
end.
