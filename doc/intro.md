# Intro

**project1** is a minimalistic IDE for coding in Pascal Script. It is intended to provide just the minimum needed for beginners in programming. Any additional features are considered unneeded and distracting.
  
# Supported subroutines

| Type | Subroutine  |
| :------------ | :------------ |
| Ordinals | `Inc` `Dec` `Pred` `Succ` |
| Strings  | `Pos` `Copy` `Delete` `Insert` `Length` `UpperCase` `LowerCase` `Trim`  |
| String conversion | `IntToStr` `StrToInt` `StrToIntDef` `FloatToStr` `StrToFloat`  |
| Floating point  | `Sin` `Cos` `Sqrt` `Round` `Trunc` |
| Set  | `Include` `Exclude` |
| Array  | `Low` `High` `SetLength` |

# Others

| Type | Subroutine  |
| :------------ | :------------ |
| Others | `Random` `Randomize` |

# Write, WriteLn

`Write` and `WriteLn` are special features of the Pascal and not part of the script language. They are substituted with procedures with the same name and just one parameter. Thus, when used with just one argument, they look the same as the originals, when used with zero or more than one arguments, an empty string or array `[]` must be given. 

| Statement  | Equivalent  | Comment | 
| :------------ | :------------ | :------------ |
| `Write(A);`  | `Write(A);`  | Single argument |
| `Write(A,B,C);`  | `Write([A,B,C]);`  | Multiple args. Must be enclosed in square brackets |
| `WriteLn;` | `WriteLn('');` or `WriteLn([]);  | No argument |
| `Write(S:10);`  | `Write([[S,10]]);` | Width specifier. Width must be enclosed in square brackets together with the printable |
| `Write(S:10,P:10);`  | `Write([[S,10],[P,10]]);` | Multiple args with widths |
| `Write(F:10:4);` | `WriteLn([[F,10,4]]);` | Width and precision. Must be enclosed in square brackets together with the printable  |

# Read, ReadLn
`Read` and `ReadLn` are also special features. `ReadLn` is substituted with a function with a single parameter.

| Statement  | Equivalent  | Comment |
| :------------ | :------------ | :------------ |
| `ReadLn(A);`  | `ReadLn(A);`  | Single argument |
| `ReadLn(A,B);` |  | Not possible |

# Missing features

- `Write`, `WriteLn` and `ReadLn` are not implemented for files
- `Read` is not implemented

# Pascal Script peculiarities

Compared to Pascal, the script has the following important differences:

- No subrange types, e.g. `type month=1..12;` 
- No `File` type 
- No nested subroutines
- No typed constants
- No multidimensional arrays like `a[i,j]`, although `array of array` construct is possible, e.g. `a[i][j]` 
- Array subscription in form n..m, n,m integers. `array[boolen] of...` not possible
- `ord` `pred` `succ` are functions, not intrinsics. Can't be used in definitions of types or constants




