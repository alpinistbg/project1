# Intro

# Supported subroutines

| Type | Subroutine  |
| :------------ | :------------ |
| Ordinals | `Inc` `Dec` `Pred` `Succ` |
| String  | `Pos` `Copy` `Delete` `Insert` `Length` `UpperCase` `LowerCase` `Trim`  |
| String conversion | `IntToStr` `StrToInt` `StrToIntDef` `FloatToStr` `StrToFloat`  |
| Floating point  | `Sin` `Cos` `Sqrt` `Round` `Trunc` |
| Set  | `Include` `Exclude` |
| Array  | `Low` `High` `SetLength` |

# Others

| Type | Subroutine  |
| :------------ | :------------ |
| Others | `Random` `Randomize` |

# Write, WriteLn

`Write` and `WriteLn` are special features of the Pascal language and not part of the script language. They are substituted by procedures with the same name and just one parameter. Thus, when used with just one argument, they look the same as the originals, when used with zero or more than one arguments, an array `[]` must be given. 

| Statement  | Equivalent  | Comment |
| :------------ | :------------ | :------------ |
| `Write(A);`  | `Write(A);`  | Single argument |
| `Write(A,B,C);`  | `Write([A,B,C]);`  | Multiple args. Must be enclosed in square brackets |
| `WriteLn;` | `WriteLn([]);` | No argument |
| `Write(S:10);`  | `Write([[S,10]]);` | Width specifier. Width must be enclosed in square brackets together with the printable |
| `Write(S:10,P:10);`  | `Write([[S,10],[P,10]]);` | Multiple args with widths |
| `Write(F:10:4);` | `WriteLn([[F,10,4]]);` | Width and precision. Must be enclosed in square brackets together with the printable  |

`Write` and `WriteLn` are not implemented for files.

# Read, ReadLn
`Read` and `ReadLn` are also special features. `ReadLn` is substituted by a function returning string.

| Statement  | Equivalent  | Comment |
| :------------ | :------------ | :------------ |
| `Write('Enter A:'); ReadLn(A);`  | `A := StrToInt(ReadLn('Enter A:'));`  | Single argument |

`ReadLn` is not implemented for files.
