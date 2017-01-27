object FAddPrivileges: TFAddPrivileges
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = #1044#1072#1073#1072#1074#1080#1090#1100' '#1087#1088#1072#1074#1072' '#1085#1072' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
  ClientHeight = 386
  ClientWidth = 467
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
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 467
    Height = 386
    Align = alClient
    TabOrder = 0
    OnNavigateComplete2 = WebBrowser1NavigateComplete2
    ExplicitWidth = 494
    ExplicitHeight = 597
    ControlData = {
      4C00000044300000E52700000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
