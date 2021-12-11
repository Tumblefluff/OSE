unit ose_source;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, shellapi, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    Switch_ID: TToggleSwitch;
    F_Open: TOpenDialog;
    F_Save: TSaveDialog;
    Logo: TImage;
    Label1_Inc_Dec: TLabel;
    Switch_File: TToggleSwitch;
    Label2_File_Offset: TLabel;
    Number_List: TMemo;
    Label3_Number_List: TLabel;
    NL_Open: TOpenDialog;
    NL_Save: TSaveDialog;
    Button1: TButton;
    Img_Load: TImage;
    Img_Save: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure Label2Click(Sender: TObject);
    procedure Img_LoadClick(Sender: TObject);
    procedure Img_SaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  tempstring:string;
  temp:integer;
  fileoffset:uint64;
  keysize,soff,sb,db:byte;
  sf,df:file of byte;
  key:array of byte;
  tf: textfile;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  keysize:=Number_List.Lines.Count;
  setlength(key,keysize);
  Number_List.Lines.SaveToFile('temp3x6y76jfWdt.txt');
  assignfile(tf,'temp3x6y76jfWdt.txt');
  reset(tf);
  for I := 1 to keysize do
    begin
      readln(tf,tempstring);
      db:=strtoint(tempstring) mod 256;
      key[(I-1)]:=db;
    end;
  closefile(tf);
  Deletefile('temp3x6y76jfWdt.txt');
  F_Open.Execute();
  F_Save.Execute();
  assignfile(sf,F_Open.FileName);
  assignfile(df,F_Save.FileName);
  reset(sf);
  rewrite(df);
  fileoffset:=0;
  while not eof(sf) do
    begin
      soff:= fileoffset mod 256;
      begin
        read(sf, sb);
        if Switch_File.State=tssOn then temp:=key[fileoffset mod keysize]
          else temp:=key[fileoffset mod keysize]+soff mod 256;
        if Switch_ID.State=tssOff then db:=(sb+temp) mod 256
          else db:=(sb+256-temp) mod 256;
        write(df, db);
      end;
      fileoffset:=fileoffset+1;
    end;
  closefile(sf);
  closefile(df);
  showmessage('Encryption Complete');
end;

procedure TForm1.Img_LoadClick(Sender: TObject);
begin
  NL_Open.Execute();
  tempstring:=NL_Open.FileName;
  if tempstring='' then exit;
  Number_List.Lines.LoadFromFile(tempstring);
end;

procedure TForm1.Img_SaveClick(Sender: TObject);
begin
  NL_Save.Execute();
  tempstring:=NL_Save.FileName;
  if tempstring='' then exit;
  Number_List.Lines.SaveToFile(tempstring);
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
  ShellExecute(self.WindowHandle,'open','https://github.com/Tumblefluff/OSE',nil,nil, SW_SHOWNORMAL);
end;

end.
