object FCreateProfile: TFCreateProfile
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1087#1088#1086#1092#1080#1083#1103
  ClientHeight = 224
  ClientWidth = 242
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
    Left = 4
    Top = 4
    Width = 234
    Height = 216
    Caption = #1047#1072#1074#1086#1083#1085#1080#1090#1077' '#1087#1086#1083#1103':'
    TabOrder = 0
    object Label5: TLabel
      Left = 18
      Top = 19
      Width = 95
      Height = 13
      Caption = #1044#1072#1085#1085#1099#1077' '#1082#1086#1085#1090#1072#1082#1090#1072':'
    end
    object Label6: TLabel
      Left = 18
      Top = 108
      Width = 108
      Height = 13
      Caption = #1050#1086#1076' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1080':'
    end
    object Panel1: TPanel
      Left = 5
      Top = 35
      Width = 223
      Height = 64
      BevelKind = bkFlat
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 10
        Top = 9
        Width = 28
        Height = 13
        Caption = 'E-mail'
      end
      object Label2: TLabel
        Left = 10
        Top = 33
        Width = 37
        Height = 13
        Caption = #1055#1072#1088#1086#1083#1100
      end
      object CBpass: TCheckBox
        Left = 199
        Top = 36
        Width = 17
        Height = 17
        Hint = #1055#1086#1082#1072#1079#1072#1090#1100' / '#1089#1082#1088#1099#1090#1100' '#1087#1072#1088#1086#1083#1100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CBpassClick
      end
      object Email: TEdit
        Left = 53
        Top = 6
        Width = 140
        Height = 21
        TabOrder = 1
      end
      object EPass: TEdit
        Left = 53
        Top = 33
        Width = 140
        Height = 21
        PasswordChar = '*'
        TabOrder = 2
      end
    end
    object Panel2: TPanel
      Left = 5
      Top = 126
      Width = 223
      Height = 50
      BevelKind = bkFlat
      BevelOuter = bvNone
      TabOrder = 1
      object Label3: TLabel
        Left = 10
        Top = 9
        Width = 20
        Height = 13
        Caption = #1050#1086#1076
      end
      object Label4: TLabel
        Left = 95
        Top = 28
        Width = 121
        Height = 13
        Caption = #1063#1090#1086' '#1079#1072' '#1089#1077#1082#1088#1077#1090#1085#1099#1081'  '#1082#1086#1076'?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clSilver
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = Label4Click
        OnMouseMove = Label4MouseMove
        OnMouseLeave = Label4MouseLeave
      end
      object CBCode: TCheckBox
        Left = 199
        Top = 9
        Width = 17
        Height = 17
        Hint = #1055#1086#1082#1072#1079#1072#1090#1100' / '#1089#1082#1088#1099#1090#1100' '#1082#1086#1076
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CBCodeClick
      end
      object ECode: TEdit
        Left = 53
        Top = 6
        Width = 140
        Height = 21
        ParentShowHint = False
        PasswordChar = '*'
        ShowHint = False
        TabOrder = 1
      end
    end
    object BCancel: TButton
      Left = 5
      Top = 182
      Width = 84
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 2
      OnClick = BCancelClick
    end
    object BNew: TButton
      Left = 104
      Top = 182
      Width = 126
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1092#1080#1083#1100
      TabOrder = 3
      OnClick = BNewClick
    end
  end
end
