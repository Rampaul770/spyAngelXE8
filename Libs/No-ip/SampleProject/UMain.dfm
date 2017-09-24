object FrmMain: TFrmMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'No-IP Client Update - By Manoel Campos'
  ClientHeight = 294
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    505
    294)
  PixelsPerInch = 96
  TextHeight = 13
  object lbIP: TLabel
    Left = 16
    Top = 144
    Width = 43
    Height = 25
    Caption = 'lbIP'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbStatus: TLabel
    Left = 16
    Top = 195
    Width = 79
    Height = 23
    Caption = 'lbStatus'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbEmail: TLabel
    Left = 120
    Top = 237
    Width = 285
    Height = 46
    Cursor = crHandPoint
    Alignment = taCenter
    Caption = 'Manoel Campos da Silva Filho'#13#10'manoelcampos@gmail.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    OnClick = lbEmailClick
  end
  object lbSendUpdate: TLabel
    Left = 191
    Top = 93
    Width = 133
    Height = 23
    Caption = 'lbSendUpdate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbEdtEmail: TLabeledEdit
    Left = 16
    Top = 24
    Width = 297
    Height = 21
    EditLabel.Width = 54
    EditLabel.Height = 13
    EditLabel.Caption = 'No-IP Email'
    MaxLength = 50
    TabOrder = 0
  end
  object lbEdtPassword: TLabeledEdit
    Left = 319
    Top = 24
    Width = 163
    Height = 21
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = 'No-IP Password'
    PasswordChar = '*'
    TabOrder = 1
  end
  object lbEdtHostName: TLabeledEdit
    Left = 16
    Top = 64
    Width = 466
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 52
    EditLabel.Height = 13
    EditLabel.Caption = 'Host Name'
    TabOrder = 2
  end
  object btnUpdate: TBitBtn
    Left = 16
    Top = 91
    Width = 169
    Height = 25
    Caption = 'Update IP on No-IP Server'
    TabOrder = 3
    OnClick = btnUpdateClick
  end
  object cbxAutoUpdate: TCheckBox
    Left = 16
    Top = 122
    Width = 265
    Height = 17
    Caption = 'Auto Update IP on No-IP server when IP change'
    TabOrder = 4
    OnClick = cbxAutoUpdateClick
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 336
    Top = 160
  end
  object NoIpClientUpdate1: TNoIpClientUpdate
    CheckIpHttpServerURL = 'http://ip1.dynupdate.no-ip.com'
    CheckIpInterval = 1000
    Active = True
    OnIpChange = NoIpClientUpdate1IpChange
    AfterIpUpdate = NoIpClientUpdate1AfterIpUpdate
    AutoUpdateIp = False
    Left = 240
    Top = 152
  end
end
