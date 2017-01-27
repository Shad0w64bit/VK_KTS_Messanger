object fHistory: TfHistory
  Left = 0
  Top = 0
  Caption = #1048#1089#1090#1086#1088#1080#1080' '#1082#1086#1085#1090#1072#1082#1090#1072
  ClientHeight = 414
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 509
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      509
      41)
    object Label1: TLabel
      Left = 134
      Top = 14
      Width = 12
      Height = 13
      Caption = '10'
    end
    object Label2: TLabel
      Left = 8
      Top = 14
      Width = 123
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1081':'
    end
    object Label3: TLabel
      Left = 289
      Top = 14
      Width = 56
      Height = 13
      Caption = #1057#1084#1077#1097#1077#1085#1080#1077':'
    end
    object TBMessage: TTrackBar
      Left = 152
      Top = 11
      Width = 137
      Height = 24
      Max = 100
      Min = 10
      Position = 10
      TabOrder = 0
      TickStyle = tsNone
      OnChange = TBMessageChange
    end
    object Edit1: TEdit
      Left = 351
      Top = 11
      Width = 49
      Height = 21
      Alignment = taRightJustify
      TabOrder = 1
      Text = '0'
      OnChange = Edit1Change
    end
    object Button1: TButton
      Left = 472
      Top = 10
      Width = 27
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '->'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 441
      Top = 10
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1047
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object ChatRE: TRichEdit
    Left = 0
    Top = 41
    Width = 509
    Height = 373
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
