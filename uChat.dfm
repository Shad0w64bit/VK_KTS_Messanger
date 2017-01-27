object fChat: TfChat
  Left = 0
  Top = 0
  Caption = 'fChat'
  ClientHeight = 428
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 596
    Height = 428
    Align = alClient
    Images = ImageList
    MultiLine = True
    TabOrder = 0
    OnChange = PageControl1Change
    OnChanging = PageControl1Changing
    OnMouseDown = PageControl1MouseDown
  end
  object ImageList: TImageList
    Left = 96
    Top = 48
  end
end
