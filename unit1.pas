unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, StdActns, Menus, Buttons, uPSComponent, SynEdit, SynHighlighterPas,
  SynEditTypes, SynEditMarkupSpecialLine, uPSUtils, SynGutterBase, SynEditMarks,
  SynCompletion;

type

  { TForm1 }

  TForm1 = class(TForm)
    actCompile: TAction;
    actBreakpoint: TAction;
    actFind: TAction;
    actFindNext: TAction;
    Action1: TAction;
    actFindPrev: TAction;
    actWatch: TAction;
    actNew: TAction;
    actStop: TAction;
    actStepOver: TAction;
    actStepInto: TAction;
    actPause: TAction;
    actRun: TAction;
    actSave: TAction;
    ActionList1: TActionList;
    actCopy: TEditCopy;
    actCut: TEditCut;
    actDelete: TEditDelete;
    actPaste: TEditPaste;
    actSelectAll: TEditSelectAll;
    actUndo: TEditUndo;
    actExit: TFileExit;
    actOpen: TFileOpen;
    actSaveAs: TFileSaveAs;
    cbFindWhat: TComboBox;
    ImageList1: TImageList;
    ImageList2: TImageList;
    lblCaretPosition: TLabel;
    MainMenu1: TMainMenu;
    memoMessages: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlSearchTools: TPanel;
    pnlToolbar: TPanel;
    pnlBott: TPanel;
    pnlMenuTools: TPanel;
    Script: TPSScriptDebugger;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Splitter1: TSplitter;
    Editor: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    procedure actBreakpointExecute(Sender: TObject);
    procedure actCompileExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindNextExecute(Sender: TObject);
    procedure actFindPrevExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actOpenBeforeExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure actOpenAccept(Sender: TObject);
    procedure actSaveAsAccept(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actStepOverExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actWatchExecute(Sender: TObject);
    procedure cbFindWhatKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure memoMessagesDblClick(Sender: TObject);
    procedure pnlMenuToolsClick(Sender: TObject);
    procedure ScriptAfterExecute(Sender: TPSScript);
    procedure ScriptBreakpoint(Sender: TObject; const FileName: tbtstring;
      Posit_, Row, Col: Cardinal);
    procedure ScriptCompile(Sender: TPSScript);
    procedure ScriptExecute(Sender: TPSScript);
    procedure ScriptIdle(Sender: TObject);
    procedure ScriptLine(Sender: TObject);
    procedure ScriptLineInfo(Sender: TObject; const FileName: tbtstring;
      Posit, Row, Col: Cardinal);
    procedure EditorGutterClick(Sender: TObject; X, Y, Line: integer;
      mark: TSynEditMark);
    procedure EditorSpecialLineColors(Sender: TObject; Line: integer;
      var Special: boolean; var FG, BG: TColor);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
  private
    FCompiled: Boolean;
    FFileName: String;
    FIdling: Boolean;
    FExecuting: Boolean;
    FInfoRow: Cardinal;
    FResume: Boolean;
    FActiveLine: Integer;
    procedure SetFileName(AValue: String);
    procedure UpdateTitle;
    procedure UpdateStatus;
    procedure UpdateActs;
    function Compile: Boolean;
    function Execute: Boolean;
    function CheckSaved: Boolean;
    function CheckStopped: Boolean;
    procedure CaretPos(ALine, ACol: LongInt; ACenter: Boolean = True);
    procedure Find(Opt: TSynSearchOptions);
    procedure ToggleBreakpoint(Line: LongInt);
    function GetErrorLine(AMess: String): TPoint;
    procedure ClearAllBookmarks;
  public

    property FileName: String read FFileName write SetFileName;

  end;

var
  Form1: TForm1;

implementation

uses
  math, Variants, StrUtils, uPSRuntime, uPSDebugger;

{$R *.lfm}

resourcestring
  rsNoname = 'Noname';

const
  ID_FIRST = ['A'..'Z', 'a'..'z', '_'];
  ID_SYMBOL = ID_FIRST + ['0'..'9'];
  ID_DELIMITERS = [#9..#127] - ID_SYMBOL;

procedure MyWriteLn(const S: String);
begin
  Form1.memoMessages.Lines.Add(S);
end;

function MyReadLn(const Question: String): String;
begin
  Result := InputBox(Question, '', '');
end;

procedure MyVariantWrite(V: Variant);
var
  S: String;
  I, N: Integer;

  function FormatV(V: Variant): String; // [v, w, p]
  var
    I, N, W, P: Integer;
    U: Variant;
  begin
    Result := '';
    case (VarType(V) and not vartypemask) of
      0: Result := VarToStr(V);
      vararray:
        begin
          W := 0; P := 4;
          I := VarArrayLowBound(V, 1);
          N := VarArrayHighBound(v, 1);
          U := V[I];
          if Succ(I) <= N then
            W := V[Succ(I)];
          if Succ(Succ(I)) <= N then
            P := V[Succ(Succ(I))];
          if (VarType(U) = varsingle) or (VarType(U) = vardouble) then
            WriteStr(Result, Double(U):W:P) else
            WriteStr(Result, U:W);
        end;
    end;
  end;

begin
  case (VarType(V) and not vartypemask) of
    0: S := VarToStr(V);
    vararray:
      begin
        S := '';
        I := VarArrayLowBound(V, 1);
        N := VarArrayHighBound(v, 1);
        while I <= N do
        begin
          S := S + FormatV(V[I]);
          Inc(I);
        end;
      end;
  end;

  Form1.memoMessages.Lines.Add(S);
end;

procedure MyVariantWriteLn(V: Variant);
begin
  MyVariantWrite(V);
end;

{ TForm1 }

procedure TForm1.actOpenBeforeExecute(Sender: TObject);
begin
  if not CheckStopped or not CheckSaved then
    Abort;
end;

procedure TForm1.actPauseExecute(Sender: TObject);
begin
  Script.Pause;
end;

procedure TForm1.actRunExecute(Sender: TObject);
begin
  if Script.Running then
    FResume := True
  else
  begin
    if Compile then
      Execute;
  end;
end;

procedure TForm1.UpdateActs;
begin
  actPause.Enabled := FExecuting and not FIdling;
  actStepInto.Enabled := not FExecuting or FIdling;
  actStepOver.Enabled := not FExecuting or FIdling;
  actStop.Enabled := FExecuting or FIdling;
  actWatch.Enabled := FExecuting or FIdling;
end;

procedure TForm1.actCompileExecute(Sender: TObject);
begin
  Compile;
end;

procedure TForm1.actFindExecute(Sender: TObject);
var
  S: String;
begin
  S := Editor.SelText;
  if S <> '' then
    cbFindWhat.Text := S;
  cbFindWhat.SetFocus;
end;

procedure TForm1.actFindNextExecute(Sender: TObject);
begin
  Find([]);
end;

procedure TForm1.actFindPrevExecute(Sender: TObject);
begin
  Find([ssoBackwards]);
end;

procedure TForm1.actBreakpointExecute(Sender: TObject);
begin
  ToggleBreakpoint(Editor.CaretY);
end;

procedure TForm1.ToggleBreakpoint(Line: LongInt);
begin
  if Script.HasBreakPoint(Script.MainFileName, Line) then
    Script.ClearBreakPoint(Script.MainFileName, Line)
  else
    Script.SetBreakPoint(Script.MainFileName, Line);
  Editor.Refresh;
end;

function TForm1.GetErrorLine(AMess: String): TPoint;
var
  R, C: String;
  lp, scp, rp: Integer;
begin
  lp := Pos('(', AMess);
  scp := Pos(':', AMess);
  rp := Pos(')', AMess);
  if (lp > 0) and (scp > lp) and (rp > scp) then
  begin
    R := Copy(AMess, lp + 1,scp - lp - 1);
    C := Copy(AMess, scp+1, rp - scp - 1);
    Result.X := StrToInt(Trim(C));
    Result.Y := StrToInt(Trim(R));
  end
  else
    Result := Point(1, 1);
end;

procedure TForm1.actNewExecute(Sender: TObject);
begin
  if CheckStopped and CheckSaved then
  begin
    Editor.ClearAll;
    Editor.Lines.Text := 'begin' + LineEnding + 'end.';
    Editor.Modified := False;
    FileName := '';
    ClearAllBookmarks;
    Script.ClearBreakPoints;
    FCompiled := False;
  end;
end;

procedure TForm1.actSaveExecute(Sender: TObject);
begin
  if FileName = '' then
    actSaveAs.Execute
  else
  begin
    Editor.Lines.SaveToFile(FileName);
    Editor.Modified := False;
  end;
end;

procedure TForm1.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := Editor.Modified ;
end;

procedure TForm1.ClearAllBookmarks;
var
  I: Integer;
begin
  for I in [0..9] do Editor.ClearBookMark(I);
end;

procedure TForm1.actOpenAccept(Sender: TObject);
var
  I: Integer;
begin
  Editor.Lines.LoadFromFile(actOpen.Dialog.FileName);
  FileName := actOpen.Dialog.FileName;
  FCompiled := False;
  ClearAllBookmarks;
  Script.ClearBreakPoints;
  UpdateTitle; // to put the name on the title
end;

procedure TForm1.actSaveAsAccept(Sender: TObject);
begin
  Editor.Lines.SaveToFile(actSaveAs.Dialog.FileName);
  FileName := actSaveAs.Dialog.FileName;
  FCompiled := False;
  Editor.Modified := False;
  UpdateTitle; // to put the name on the title
end;

procedure TForm1.actStepIntoExecute(Sender: TObject);
begin
  if Script.Exec.Status in [isRunning, isPaused] then
     Script.StepInto
  else
  begin
   if Compile then
   begin
     Script.StepInto;
     Execute;
   end;
  end;
end;

procedure TForm1.actStepOverExecute(Sender: TObject);
begin
  if Script.Exec.Status in [isRunning, isPaused] then
     Script.StepOver
  else
  begin
   if Compile then
   begin
     Script.StepInto;
     Execute;
   end;
  end;
end;

procedure TForm1.actStopExecute(Sender: TObject);
begin
  Script.Stop;
end;

procedure TForm1.actWatchExecute(Sender: TObject);
var
  S, SID, Cont: String;
  I: Integer = 0;
begin
  S := Trim(Editor.SelText);
  if S = '' then
    S := Trim(InputBox('Watch', 'Variable', ''));
  if S = '' then
    Exit;
  for I := 1 to 10 do
  begin
    SID := ExtractWord(I, S, ID_DELIMITERS);
    if SID = '' then
      Break;
    if not (SID[1] in ID_FIRST) then
      Continue;
    Cont := Script.GetVarContents(SID);
    memoMessages.Lines.Add(SID + ' = ' + Cont);
  end;
end;

procedure TForm1.cbFindWhatKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    actFindNext.Execute;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := CheckStopped and CheckSaved;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  UpdateTitle;
  UpdateActs;
end;

procedure TForm1.memoMessagesDblClick(Sender: TObject);
begin
  Editor.CaretXY := GetErrorLine(memoMessages.Lines[memoMessages.CaretPos.Y]);
  Editor.SetFocus;
end;

procedure TForm1.pnlMenuToolsClick(Sender: TObject);
begin

end;

procedure TForm1.ScriptAfterExecute(Sender: TPSScript);
begin
  FActiveLine := 0;
  Editor.Refresh;
  FExecuting := False;
  FIdling := False;
  UpdateTitle;
  UpdateActs;
end;

procedure TForm1.ScriptBreakpoint(Sender: TObject;
  const FileName: tbtstring; Posit_, Row, Col: Cardinal);
begin
  FActiveLine := Row;
  CaretPos(FActiveLine, 1);
  Editor.Refresh;
end;

procedure TForm1.ScriptCompile(Sender: TPSScript);
begin
  //Sender.AddFunction(@MyWriteLn, 'procedure WriteLn(S: String);');
  Sender.AddFunction(@MyReadLn, 'function ReadLn(Question: String): String;');
  Sender.AddFunction(@MyVariantWrite, 'procedure Write(V: Variant);');
  Sender.AddFunction(@MyVariantWriteLn, 'procedure WriteLn(V: Variant);');
end;

procedure TForm1.ScriptExecute(Sender: TPSScript);
begin
  FExecuting := True;
  UpdateTitle;
  UpdateActs;
end;

procedure TForm1.ScriptIdle(Sender: TObject);
begin
  if not FIdling then
  begin
    FIdling := True;
    UpdateTitle;
    UpdateActs;
    FActiveLine := FInfoRow;
    CaretPos(FActiveLine, 1);
    Editor.Refresh;
  end;
  Application.ProcessMessages;
  if FResume then
  begin
    FResume := False;
    FIdling := False;
    Script.Resume;
    FActiveLine := 0;
    Editor.Refresh;
    UpdateTitle;
    UpdateActs;
  end;
end;

procedure TForm1.ScriptLine(Sender: TObject);
begin
  ;
end;

procedure TForm1.ScriptLineInfo(Sender: TObject;
  const FileName: tbtstring; Posit, Row, Col: Cardinal);
begin
  FInfoRow := Row;
  if (Script.Exec.DebugMode <> dmRun) and
    (Script.Exec.DebugMode <> dmStepOver)
  then
  begin
    FActiveLine := Row;
    CaretPos(FActiveLine, 1);
    Editor.Refresh;
  end
  else
    Application.ProcessMessages;
end;

procedure TForm1.EditorGutterClick(Sender: TObject; X, Y, Line: integer;
  mark: TSynEditMark);
begin
  ToggleBreakpoint(Line);
end;

procedure TForm1.EditorSpecialLineColors(Sender: TObject; Line: integer;
  var Special: boolean; var FG, BG: TColor);
begin
  if Script.HasBreakPoint(Script.MainFileName, Line) then
  begin
    Special := True;
    if Line = FActiveLine then
    begin
      BG := clWhite;
      FG := clRed;
    end else
    begin
      FG := clWhite;
      BG := clRed;
    end;
  end
  else if Line = FActiveLine then
  begin
    Special := True;
    FG := clWhite;
    bg := clBlue;
  end
  else
    Special := False;
end;

procedure TForm1.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if [scCaretX, scCaretY, scInsertMode] * Changes <> [] then
    UpdateStatus;
  if scModified in Changes then
  begin
    FCompiled := False;
    UpdateTitle;
  end;
end;


procedure TForm1.UpdateTitle;
begin
  Caption :=
    Application.Title + ' | ' +
    IfThen(Editor.Modified, '*') +
    IfThen(FileName <> '', FileName, rsNoname) +
    IfThen(FExecuting, ' (running) ') +
    IfThen(FIdling, ' (paused) ')
    ;
end;

procedure TForm1.SetFileName(AValue: String);
begin
  if FFileName = AValue then Exit;
  FFileName := AValue;
  Script.MainFileName := ExtractFileName(FFileName);
  if Script.MainFileName = '' then
    Script.MainFileName := rsNoname;
end;

procedure TForm1.UpdateStatus;
begin
  lblCaretPosition.Caption := Format('Line: %d, Col: %d (%s)', [Editor.CaretY,
    Editor.CaretX, IfThen(Editor.InsertMode, 'INS', 'OVR')]);
end;

function TForm1.Compile: Boolean;
var
  I: Integer;
  Msgs: String;
begin
  Script.Script.Assign(Editor.Lines);
  FCompiled := Script.Compile;
  Msgs := '';
  for I := 0 to Pred(Script.CompilerMessageCount) do
    Msgs := Msgs + Script.CompilerMessages[I].MessageToString + LineEnding;
  if FCompiled then
    Msgs := Msgs + 'Successfuly compiled.' else
    Msgs := Msgs + 'Compilation failed.';
  memoMessages.Text := Msgs;

  if FCompiled then
  begin
    //Script.Comp.GetDebugOutput(Msgs);
    //Script.Execute;
  end;
  Result := FCompiled;
end;

function TForm1.Execute: Boolean;
begin
  //debugoutput.Output.Clear;
  if Script.Execute then
  begin
    memoMessages.Lines.Add('Successfuly executed.');
    Result := True;
  end
  else
  begin
    memoMessages.Lines.Add(Format('[Runtime error] %s(%d:%d), bytecode(%d:%d): %s',
      [ExtractFileName(FileName), Script.ExecErrorRow,
      Script.ExecErrorCol, Script.ExecErrorProcNo,
      Script.ExecErrorByteCodePosition, Script.ExecErrorToString]));
    Result := False;
  end;

end;

function TForm1.CheckSaved: Boolean;
var
  Saved: Boolean;
begin
  Result := True;
  if Editor.Modified then
    case QuestionDlg('', 'Source modified. Do you want to save changes?',
      mtWarning, [mrYes, 'Save', 'isdefault', mrNo, 'Discard changes',
      mrCancel, 'Cancel'], 0)
    of
      mrNo: ;
      mrCancel: Result := False;
      mrYes:
        begin
          if FileName <> '' then
           actSave.Execute else
           actSaveAs.Execute;
          Result := FileName <> '';
        end;
      end;
end;

function TForm1.CheckStopped: Boolean;
begin
  Result := True;
  if Script.Exec.Status in [isRunning, isPaused] then
  case QuestionDlg('', 'Program is running. Do you want to stop it?',
    mtWarning, [mrYes, 'Stop it', 'isdefault', mrCancel, 'Cancel'], 0)
  of
    mrCancel: Result := False;
    mrYes: actStop.Execute;
  end;
end;

procedure TForm1.CaretPos(ALine, ACol: LongInt; ACenter: Boolean);
begin
  if ACenter then
    if (ALine < Editor.TopLine + 2) or
      (ALine > Editor.TopLine + Editor.LinesInWindow - 2)
    then
      Editor.TopLine := ALine - (Editor.LinesInWindow div 2);
  Editor.CaretY := ALine;
  Editor.CaretX := ACol;
end;

procedure TForm1.Find(Opt: TSynSearchOptions);
begin
  //if cbMatchCase.Checked then Include(Opt, ssoMatchCase);
  //if cbWholeWord.Checked then Include(Opt, ssoWholeWord);
  //if cbInSelection.Checked then Include(Opt, ssoSelectedOnly);
  //if cbRegEx.Checked then Include(Opt, ssoRegExpr);
  //if cbFindText.Items.IndexOf(cbFindText.Text) < 0 then
  //  cbFindText.Items.Insert(0, cbFindText.Text);
  if Editor.SearchReplace(cbFindWhat.Text, '', Opt) = 0 then
    Beep;
end;

end.

