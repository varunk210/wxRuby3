#--------------------------------------------------------------------
# @file    interfaces.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface generation specs
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  Director.Package('Wx') { |pkg|
    Director.Spec(pkg, 'wxDefs')
    Director.Spec(pkg, 'wxGDICommon')
    Director.Spec(pkg, 'wxColour')
    Director.Spec(pkg, 'wxObject')
    Director.Spec(pkg, 'wxEvent')
    Director.Spec(pkg, 'wxEvtHandler')
    Director.Spec(pkg, 'wxApp')
    Director.Spec(pkg, 'wxDC')
    Director.Spec(pkg, 'wxWindowDC')
    Director.Spec(pkg, 'wxClientDC')
    Director.Spec(pkg, 'wxPaintDC')
    Director.Spec(pkg, 'wxMemoryDC')
    Director.Spec(pkg, 'wxWindow')
    Director.Spec(pkg, 'wxNonOwnedWindow', director: Director::Window)
    Director.Spec(pkg, 'wxTopLevelWindow')
    Director.Spec(pkg, 'wxFrame')
    Director.Spec(pkg, 'wxGDIObject')
    Director.Spec(pkg, 'wxIconLocation')
    Director.Spec(pkg, 'wxMask')
    Director.Spec(pkg, 'wxBitmap')
    Director.Spec(pkg, 'wxIcon')
    Director.Spec(pkg, 'wxAccelerator')
    Director.Spec(pkg, 'wxMenuItem')
    Director.Spec(pkg, 'wxMenuBar')
    Director.Spec(pkg, 'wxMenu')
    Director.Spec(pkg, 'wxAboutDialogInfo')
    Director.Spec(pkg, 'wxDialog')
    Director.Spec(pkg, 'wxMessageDialog', director: Director::TopLevelWindow)
    Director.Spec(pkg, 'wxSizerItem')
    Director.Spec(pkg, 'wxSizer')
    Director.Spec(pkg, 'wxBoxSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxControl', director: Director::Window)
    Director.Spec(pkg, 'wxTextCtrl')
    Director.Spec(pkg, 'wxCheckBox', director: Director::Window)
    Director.Spec(pkg, 'wxAnyButton', director: Director::Window)
    Director.Spec(pkg, 'wxButton')
    Director.Spec(pkg, 'wxToggleButton')
    Director.Spec(pkg, 'wxControlWithItems')
    Director.Spec(pkg, 'wxComboBox')
    Director.Spec(pkg, 'wxRadioBox')
    Director.Spec(pkg, 'wxPanel')
    Director.Spec(pkg, 'wxBookCtrlEvent')
    Director.Spec(pkg, 'wxBookCtrlBase', director: Director::BookCtrls)
    Director.Spec(pkg, 'wxNotebook', director: Director::BookCtrls)
    Director.Spec(pkg, 'wxImageList')
    Director.Spec(pkg, 'wxListBox')
    Director.Spec(pkg, 'wxChoice')
    Director.Spec(pkg, 'wxStaticBox', director: Director::Window)
    Director.Spec(pkg, 'wxGauge', director: Director::Window)
    Director.Spec(pkg, 'wxSlider', director: Director::Window)
    Director.Spec(pkg, 'wxStaticText', director: Director::Window)
    Director.Spec(pkg, 'wxSpinButton', director: Director::Window)
    Director.Spec(pkg, 'wxSpinEvent')
    Director.Spec(pkg, 'wxSpinCtrl', director: Director::Window)
    Director.Spec(pkg, 'wxStaticBitmap')
    Director.Spec(pkg, 'wxBitmapButton', director: Director::Button)
    Director.Spec(pkg, 'wxArtProvider')
    Director.Spec(pkg, 'wxStaticBoxSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxCursor')
    Director.Spec(pkg, 'wxRadioButton', director: Director::Window)
    Director.Spec(pkg, 'wxToolTip')
    Director.Spec(pkg, 'wxLog')
    Director.Spec(pkg, 'wxToolBar')
    Director.Spec(pkg, 'wxImage')
    Director.Spec(pkg, 'wxDragImage')
    Director.Spec(pkg, 'wxFont')
    Director.Spec(pkg, 'wxFontData')
    Director.Spec(pkg, 'wxFontDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxFileDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxLocale')
    Director.Spec(pkg, 'wxSystemSettings')
    Director.Spec(pkg, 'wxPropertySheetDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxScrolledWindow', director: Director::ScrolledT)
    Director.Spec(pkg, 'wxScrolledCanvas', director: Director::ScrolledT)
    Director.Spec(pkg, 'wxFindReplaceData')
    Director.Spec(pkg, 'wxFindReplaceDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxFindDialogEvent')
    Director.Spec(pkg, 'wxToolbook', director: Director::BookCtrls)
    Director.Spec(pkg, 'wxColourData')
    Director.Spec(pkg, 'wxColourDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxTextEntryDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxSingleChoiceDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxMultiChoiceDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxTipProvider')
    Director.Spec(pkg, 'wxDirDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxProgressDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxWindowDisabler')
    Director.Spec(pkg, 'wxBusyInfo')
    Director.Spec(pkg, 'wxListCtrl')
    Director.Spec(pkg, 'wxListEvent')
    Director.Spec(pkg, 'wxGridSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxFlexGridSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxGridBagSizer', director: Director::Sizer)
  }

  Director.Package('Wx::RichText', 'wxUSE_RICHTEXT') { |pkg|
    Director.Spec(pkg, 'wxRichTextEvent')
    Director.Spec(pkg, 'wxRichTextBuffer')
    Director.Spec(pkg, 'wxRichTextCtrl')
    Director.Spec(pkg, 'wxRichTextFileHandler')
    Director.Spec(pkg, 'wxRichTextXMLHandler', director: Director::RichTextFileHandler)
    Director.Spec(pkg, 'wxRichTextHTMLHandler', director: Director::RichTextFileHandler)
  }

  Director.Package('Wx::Stc', 'wxUSE_STC') { |pkg|
    Director.Spec(pkg, 'wxStyledTextEvent')
    Director.Spec(pkg, 'wxStyledTextCtrl')
  }

  Director.Package('Wx::Grid', 'wxUSE_GRID') { |pkg|
    Director.Spec(pkg, 'wxGridEvent')
    Director.Spec(pkg, 'wxGridSizeEvent')
    Director.Spec(pkg, 'wxGridEditorCreatedEvent')
    Director.Spec(pkg, 'wxGridRangeSelectEvent')
    Director.Spec(pkg, 'wxGridTableBase')
    Director.Spec(pkg, 'wxGridCellAttr')
    Director.Spec(pkg, 'wxGridCellEditor')
    Director.Spec(pkg, 'wxGridCellRenderer')
    Director.Spec(pkg, 'wxGridCellActivatableEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellBoolEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellChoiceEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellEnumEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellDateEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellTextEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellFloatEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellNumberEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellAutoWrapStringEditor', director: Director::GridCellEditor)
    Director.Spec(pkg, 'wxGridCellBoolRenderer', director: Director::GridCellRenderer)
    Director.Spec(pkg, 'wxGridCellStringRenderer', director: Director::GridCellRenderer)
    Director.Spec(pkg, 'wxGridCellFloatRenderer', director: Director::GridCellRenderer)
    Director.Spec(pkg, 'wxGridCellAutoWrapStringRenderer', director: Director::GridCellRenderer)
    Director.Spec(pkg, 'wxGridCellDateRenderer', director: Director::GridCellRenderer)
    Director.Spec(pkg, 'wxGridCellDateTimeRenderer', director: Director::GridCellRenderer)
    Director.Spec(pkg, 'wxGridCellEnumRenderer', director: Director::GridCellRenderer)
    Director.Spec(pkg, 'wxGridCellNumberRenderer', director: Director::GridCellRenderer)
  }

end # module WXRuby3
