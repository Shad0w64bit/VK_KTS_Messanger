object fSettingsProfile: TfSettingsProfile
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1086#1092#1080#1083#1103
  ClientHeight = 160
  ClientWidth = 241
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  HelpFile = 'help.chm'
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 5
    Top = 8
    Width = 228
    Height = 115
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1074#1086#1080' '#1076#1072#1085#1085#1099#1077
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 23
      Width = 28
      Height = 13
      Caption = 'E-mail'
    end
    object Label4: TLabel
      Left = 16
      Top = 48
      Width = 37
      Height = 13
      Caption = #1053'. '#1055#1072#1089#1089
    end
    object Label2: TLabel
      Left = 16
      Top = 73
      Width = 20
      Height = 13
      Caption = #1050#1086#1076
    end
    object Label3: TLabel
      Left = 112
      Top = 95
      Width = 107
      Height = 13
      Caption = #1045#1089#1083#1080' '#1103' '#1085#1077#1087#1086#1084#1085#1102' '#1082#1086#1076'?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label3Click
      OnMouseMove = Label3MouseMove
      OnMouseLeave = Label3MouseLeave
    end
    object Email: TEdit
      Left = 59
      Top = 20
      Width = 160
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object Epass: TEdit
      Left = 59
      Top = 45
      Width = 140
      Height = 21
      Hint = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 1
    end
    object ECode: TEdit
      Left = 59
      Top = 70
      Width = 140
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
    end
    object CBpass: TCheckBox
      Left = 205
      Top = 47
      Width = 17
      Height = 17
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' / '#1089#1082#1088#1099#1090#1100' '#1087#1072#1088#1086#1083#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = CBpassClick
    end
    object CBCode: TCheckBox
      Left = 205
      Top = 72
      Width = 17
      Height = 17
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' / '#1089#1082#1088#1099#1090#1100' '#1082#1086#1076
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = CBCodeClick
    end
  end
  object Button1: TButton
    Left = 143
    Top = 129
    Width = 90
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 5
    Top = 129
    Width = 132
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1092#1080#1083#1100
    TabOrder = 2
    OnClick = Button2Click
  end
end
