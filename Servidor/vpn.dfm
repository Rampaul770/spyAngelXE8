object Form6: TForm6
  Left = 411
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'VPN'
  ClientHeight = 324
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object VPN: TGroupBox
    Left = 6
    Top = 0
    Width = 105
    Height = 81
    Caption = 'VPN'
    TabOrder = 0
    object Desligado: TLabel
      Left = 37
      Top = 63
      Width = 46
      Height = 13
      Caption = 'Desligado'
    end
    object Ligado: TLabel
      Left = 37
      Top = 21
      Width = 31
      Height = 13
      Caption = 'Ligado'
    end
    object vpnBar: TTrackBar
      Left = 3
      Top = 16
      Width = 33
      Height = 65
      Max = 1
      Orientation = trVertical
      TabOrder = 0
      OnChange = vpnBarChange
    end
  end
  object Memo1: TMemo
    Left = 117
    Top = 8
    Width = 106
    Height = 73
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 229
    Top = 0
    Width = 186
    Height = 81
    Caption = 'Streaming'
    TabOrder = 2
    object cb1: TComboBox
      Left = 16
      Top = 22
      Width = 161
      Height = 21
      TabOrder = 0
      Text = 'Desativado'
      OnChange = cb1Change
      Items.Strings = (
        'Desativado'
        'WebCam'
        'Desktop')
    end
    object Edit1: TEdit
      Left = 16
      Top = 49
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'IP:Porta'
    end
    object btn1: TButton
      Left = 143
      Top = 49
      Width = 34
      Height = 21
      Caption = 'OK'
      Enabled = False
      TabOrder = 2
      OnClick = btn1Click
    end
  end
end
