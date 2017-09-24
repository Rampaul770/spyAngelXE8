object Form2: TForm2
  Left = 229
  Top = 150
  Caption = 'spyAngel - Desktop Remoto de "fulano"'
  ClientHeight = 457
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 430
    Width = 746
    Height = 27
    Align = alBottom
    TabOrder = 0
    object CheckBox2: TCheckBox
      Left = 303
      Top = 6
      Width = 105
      Height = 17
      TabStop = False
      Caption = 'Teclado Remoto'
      TabOrder = 3
      OnClick = CheckBox2Click
      OnExit = CheckBox2Exit
      OnKeyDown = CheckBox2KeyDown
    end
    object CheckBox3: TCheckBox
      Left = 494
      Top = 6
      Width = 137
      Height = 17
      TabStop = False
      Caption = 'Redimensionar Imagem'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBox3Click
      OnExit = CheckBox3Exit
      OnKeyDown = CheckBox3KeyDown
    end
    object Button1: TButton
      Left = 663
      Top = 6
      Width = 75
      Height = 17
      Caption = 'PrintScreen'
      TabOrder = 5
      OnClick = Button1Click
    end
    object RadioButton1: TRadioButton
      Left = 39
      Top = 6
      Width = 113
      Height = 17
      Caption = 'Mouse Remoto'
      TabOrder = 1
      OnExit = RadioButton1Exit
    end
    object RadioButton2: TRadioButton
      Left = 144
      Top = 6
      Width = 139
      Height = 17
      Caption = 'Mouse (Somente Clicks)'
      TabOrder = 2
      OnExit = RadioButton2Exit
    end
    object RadioButton3: TRadioButton
      Left = 8
      Top = 6
      Width = 17
      Height = 17
      Hint = 'Desativar'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnExit = RadioButton3Exit
    end
    object CheckBox1: TCheckBox
      Left = 414
      Top = 6
      Width = 74
      Height = 17
      Caption = 'WebCam'
      TabOrder = 6
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 746
    Height = 430
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    Color = clDefault
    ParentColor = False
    TabOrder = 1
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 742
      Height = 426
      Align = alClient
      Stretch = True
      OnDblClick = Image1DblClick
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
      ExplicitLeft = -2
      ExplicitTop = -2
      ExplicitWidth = 233
      ExplicitHeight = 161
    end
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 136
    Top = 16
  end
  object SaveDialog: TSavePictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 496
    Top = 176
  end
end
