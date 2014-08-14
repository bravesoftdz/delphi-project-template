//{$WARNINGS OFF}
//
//  Windows XP(SP3)    + Delphi XE Pro
//  Windows 7 U64(SP1) + Delphi XE Pro
//
//  Presented by Mr.XRAY
//  http://mrxray.on.coocan.jp/
//=============================================================================
unit fmRotateFlip01;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, GDIPAPI, GDIPOBJ;

type
  TMyPanel = class(TPanel)
  private
    FRotateFlipNo : Integer;
    procedure SetRotateFlipNo(const Value: Integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property RotateFlipNo : Integer read FRotateFlipNo write SetRotateFlipNo;
  end;

  TFormRotateFlip01 = class(TForm)
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private �錾 }
    MyPanel : TMyPanel;
  public
    { Public �錾 }
  end;

var
  FormRotateFlip01: TFormRotateFlip01;

implementation

uses TypInfo;

{$R *.DFM}

//=============================================================================
//  �t�H�[���������̏���
//=============================================================================
procedure TFormRotateFlip01.FormCreate(Sender: TObject);
var
  ATypeInfo : PTypeInfo;
  AInfoData : PTypeData;
  i         : Integer;
begin
  Caption := 'GDI+  RotateFlip';

  //�`�悷��R���g���[���𐶐�
  MyPanel := TMyPanel.Create(Self);
  with MyPanel do begin
    Parent := Self;
    SetBounds(160, 5, Self.ClientWidth - 168, Self.ClientHeight - 10);
    DoubleBuffered   := True;
    ControlStyle     := MyPanel.ControlStyle + [csOpaque];
    BevelOuter       := bvNone;
    Visible          := True;
    Color            := clWhite;
    ParentBackground := False;
  end;


  //�񋓌^�̍ŏ��l�ƍő�l���擾
  ATypeInfo := TypeInfo(TRotateFlipType);
  AInfoData := GetTypeData(ATypeInfo);

  //�񋓌^�̒l�𕶎���Ƃ��Ď擾�DRadioGroup1�ɕ\��
  for i := AInfoData^.MinValue to AInfoData^.MaxValue do begin
    RadioGroup1.Items.Add(GetEnumName(TypeInfo(TRotateFlipType), i));
  end;
  RadioGroup1.ItemIndex := 0;
end;

//=============================================================================
//  RadioGroup1��OnClick�C�x���g����
//  RotateFilp�̒l��ύX������CTMyPanel���ĕ`��
//=============================================================================
procedure TFormRotateFlip01.RadioGroup1Click(Sender: TObject);
begin
  if not Assigned(MyPanel) then exit;
  MyPanel.RotateFlipNo := RadioGroup1.ItemIndex;
end;

{ TMyPanel }

//-----------------------------------------------------------------------------
//  �R���X�g���N�^
//  �e��v���p�e�B�Ɠ����Ŏg�p����ϐ��̏�����
//-----------------------------------------------------------------------------
constructor TMyPanel.Create(AOwner: TComponent);
begin
  inherited;
  FRotateFlipNo := 0;
end;

//-----------------------------------------------------------------------------
//  RotateFlipNo�v���p�e�B�̐ݒ�p���\�b�h
//  ��]�Ɣ��]�̐ݒ肪�ύX�ɂȂ�����ĕ`��
//-----------------------------------------------------------------------------
procedure TMyPanel.SetRotateFlipNo(const Value: Integer);
begin
  if not Assigned(Parent) then exit;

  if FRotateFlipNo <> Value then begin
    FRotateFlipNo := Value;
    Invalidate;
  end;
end;

//-----------------------------------------------------------------------------
//  TMyPanel�N���X��Paint���\�b�h
//  ���ۂ̕`��R�[�h
//-----------------------------------------------------------------------------
procedure TMyPanel.Paint;
var
  ObjWidth      : Integer;
  ObjHeight     : Integer;
  ImageFilePath : String;
  GDPImage      : TGPImage;
  GDPGraphic    : TGPGraphics;
begin
  inherited;

  //�摜�̕\���T�C�Y
  ObjWidth  := 150;
  ObjHeight := 100;

  //�摜�t�@�C�����w��DTGPImaage�C���X�^���X�𐶐����ēǂݍ���
  ImageFilePath := ExtractFilePath(ParamStr(0)) + '503.bmp';
  GDPImage      := TGPImage.Create(ImageFilePath);

  //����TMyPanel��Canvas��`���ɂ���TGPGraphics�̃C���X�^���X�𐶐�
  GDPGraphic := TGPGraphics.Create(Canvas.Handle);

  //��]�Ɣ��]��ݒ�
  GDPImage.RotateFlip(TRotateFlipType(FRotateFlipNo));
  //�`��
  GDPGraphic.DrawImage(GDPImage, 20, 20, ObjWidth, ObjHeight);

  GDPImage.Free;
  GDPGraphic.Free;
end;

end.
