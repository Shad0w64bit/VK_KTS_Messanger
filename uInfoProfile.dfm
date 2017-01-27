object fInfoProfile: TfInfoProfile
  Left = 0
  Top = 0
  AutoSize = True
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1092#1080#1083#1103
  ClientHeight = 225
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 137
    Height = 225
    Align = alLeft
  end
  object Panel1: TPanel
    Left = 137
    Top = 0
    Width = 264
    Height = 225
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 53
      Width = 26
      Height = 13
      Caption = #1053#1080#1082': '
    end
    object LName: TLabel
      Left = 16
      Top = 13
      Width = 83
      Height = 18
      Caption = #1048#1084#1103' '#1060#1072#1080#1083#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LNick: TLabel
      Left = 48
      Top = 53
      Width = 19
      Height = 13
      Caption = #1053#1080#1082
    end
    object Label3: TLabel
      Left = 16
      Top = 72
      Width = 26
      Height = 13
      Caption = #1055#1086#1083': '
    end
    object LOnOff: TLabel
      Left = 207
      Top = 37
      Width = 48
      Height = 13
      Caption = #1054#1092#1092#1083#1072#1081#1085
      Visible = False
    end
    object LSex: TLabel
      Left = 48
      Top = 72
      Width = 23
      Height = 13
      Caption = 'LSex'
    end
    object LDPhone: TLabel
      Left = 16
      Top = 144
      Width = 120
      Height = 13
      Caption = #1044#1086#1084'. '#1058#1077#1083#1077#1092#1086#1085': 7976645'
    end
    object LSPhone: TLabel
      Left = 16
      Top = 163
      Width = 151
      Height = 13
      Caption = #1057#1086#1090'. '#1058#1077#1083#1077#1092#1086#1085': +79533200536'
    end
    object Label4: TLabel
      Left = 16
      Top = 98
      Width = 87
      Height = 13
      Caption = #1044#1077#1085#1100' '#1088#1086#1078#1076#1077#1085#1080#1103': '
    end
    object LBDay: TLabel
      Left = 109
      Top = 98
      Width = 30
      Height = 13
      Caption = 'LBDay'
    end
  end
end
