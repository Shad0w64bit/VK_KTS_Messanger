object fSettings: TfSettings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 396
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  HelpFile = 'help.chm'
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 137
    Height = 396
    Style = lbOwnerDrawFixed
    Align = alLeft
    ItemHeight = 30
    Items.Strings = (
      #1054#1073#1097#1080#1077
      #1047#1074#1091#1082#1080
      #1054#1087#1086#1074#1077#1097#1077#1085#1080#1077
      #1057#1087#1088#1072#1074#1082#1072)
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object ImageList1: TImageList
    Height = 32
    Width = 32
    Left = 160
    Top = 248
  end
end
