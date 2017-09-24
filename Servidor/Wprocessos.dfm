object Form5: TForm5
  Left = 410
  Top = 164
  BorderIcons = [biSystemMenu]
  Caption = 'Gerenciador de Tarefas'
  ClientHeight = 338
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 274
    Height = 338
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Processos'
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
  end
  object PopupMenu1: TPopupMenu
    Left = 216
    Top = 136
    object Atualizar1: TMenuItem
      Caption = 'Atualizar'
      ShortCut = 116
      OnClick = Atualizar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Finalizar: TMenuItem
      Caption = 'Finalizar'
      ShortCut = 46
      OnClick = FinalizarClick
    end
    object executar: TMenuItem
      Caption = 'Comandos'
      OnClick = executarClick
    end
  end
end
