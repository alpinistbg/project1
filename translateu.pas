unit translateu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function TranslateFromResource(const Language: String; ForceUpdate: Boolean =
  True; const ResFile: String = 'TRANSLATION'): Boolean;

implementation

uses
  LCLTranslator, LResources, Translations, LCLType, Forms;

function TranslateFromResource(const Language: String; ForceUpdate: Boolean;
  const ResFile: String): Boolean;
var
  Res: TResourceStream;
  PoFile: TPOFile;
  LocalTranslator: TUpdateTranslator;
  I: Integer;
begin
  Res := TResourceStream.Create(HInstance, ResFile + '.' + Language, RT_RCDATA);
  try
    PoFile := TPOFile.Create(Res);
    Result := TranslateResourceStrings(PoFile);
    LocalTranslator := TPOTranslator.Create(PoFile);
    if Assigned(LRSTranslator) then
      LRSTranslator.Free;
    LRSTranslator := LocalTranslator;
    if ForceUpdate then
    begin
      for I := 0 to Pred(Screen.CustomFormCount) do
        LocalTranslator.UpdateTranslation(Screen.CustomForms[I]);
      for I := 0 to Pred(Screen.DataModuleCount) do
        LocalTranslator.UpdateTranslation(Screen.DataModules[I]);
    end;
  finally
    Res.Free;
  end;
end;

end.
