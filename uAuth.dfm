object FAuth: TFAuth
  Left = 560
  Top = 269
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 122
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  HelpFile = 'help.chm'
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 4
    Top = 4
    Width = 245
    Height = 114
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1088#1086#1092#1080#1083#1100':'
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 22
      Width = 32
      Height = 13
      Caption = 'E-mail:'
    end
    object Label2: TLabel
      Left = 8
      Top = 51
      Width = 24
      Height = 13
      Caption = #1050#1086#1076':'
    end
    object EMail: TComboBox
      Left = 55
      Top = 21
      Width = 154
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object ECode: TEdit
      Left = 55
      Top = 48
      Width = 154
      Height = 21
      PasswordChar = '*'
      TabOrder = 1
      OnKeyDown = ECodeKeyDown
    end
    object BNewProfile: TButton
      Left = 5
      Top = 78
      Width = 124
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1092#1080#1083#1100
      TabOrder = 2
      OnClick = BNewProfileClick
    end
    object BOK: TButton
      Left = 140
      Top = 78
      Width = 97
      Height = 25
      Caption = #1042#1093#1086#1076
      TabOrder = 3
      OnClick = BOKClick
    end
    object Bsettings: TButton
      Left = 215
      Top = 21
      Width = 22
      Height = 21
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1092#1080#1083#1103
      DisabledImageIndex = 2
      HotImageIndex = 2
      ImageIndex = 2
      Images = IconsList
      ParentShowHint = False
      PressedImageIndex = 2
      SelectedImageIndex = 2
      ShowHint = True
      TabOrder = 4
      OnClick = BsettingsClick
    end
  end
  object IconsList: TImageList
    Left = 16
    Top = 96
  end
end
