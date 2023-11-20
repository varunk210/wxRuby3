# Copyright (c) 2023 M.J.N. Corino, The Netherlands
#
# This software is released under the MIT license.

###
# wxRuby3 wxWidgets interface generation specs
###

module WXRuby3

  Director.Package('Wx') { |pkg|
    Director.Spec(pkg, 'wxDefs')
    Director.Spec(pkg, 'wxFunctions')
    Director.Spec(pkg, 'wxGDICommon')
    Director.Spec(pkg, 'wxColour')
    Director.Spec(pkg, 'wxObject')
    Director.Spec(pkg, 'wxKeyboardState')
    Director.Spec(pkg, 'wxMouseState')
    Director.Spec(pkg, 'wxEvent')
    Director.Spec(pkg, 'wxEvtHandler')
    Director.Spec(pkg, 'wxEvents')
    Director.Spec(pkg, 'wxEventFilter')
    Director.Spec(pkg, 'wxGUIEventLoop')
    Director.Spec(pkg, 'wxApp')
    Director.Spec(pkg, 'wxAppTraits')
    Director.Spec(pkg, 'wxConfigBase')
    Director.Spec(pkg, 'wxDC')
    Director.Spec(pkg, 'wxWindowDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxClientDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxPaintDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxMemoryDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxMirrorDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxScreenDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxSVGFileDC', director: Director::DerivedDC, requirements: %w[USE_SVG])
    Director.Spec(pkg, 'wxGCDC', director: Director::DerivedDC, requirements: %w[USE_GRAPHICS_CONTEXT])
    Director.Spec(pkg, 'wxScaledDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxWindow')
    Director.Spec(pkg, 'wxEventBlocker')
    Director.Spec(pkg, 'wxNonOwnedWindow', director: Director::Window)
    Director.Spec(pkg, 'wxPopupWindow')
    Director.Spec(pkg, 'wxTopLevelWindow')
    Director.Spec(pkg, 'wxFrame')
    Director.Spec(pkg, 'wxTaskBarButton', requirements: %w[WXMSW USE_TASKBARBUTTON])
    Director.Spec(pkg, 'wxMiniFrame', director: Director::Frame)
    Director.Spec(pkg, 'wxGDIObject')
    Director.Spec(pkg, 'wxGraphicsObject', requirements: %w[USE_GRAPHICS_CONTEXT])
    Director.Spec(pkg, 'wxGraphicsContext', requirements: %w[USE_GRAPHICS_CONTEXT])
    Director.Spec(pkg, 'wxBrush')
    Director.Spec(pkg, 'wxPen')
    Director.Spec(pkg, 'wxPalette')
    Director.Spec(pkg, 'wxRegion')
    Director.Spec(pkg, 'wxRegionIterator')
    Director.Spec(pkg, 'wxIconLocation')
    Director.Spec(pkg, 'wxBitmap')
    Director.Spec(pkg, 'wxIcon')
    Director.Spec(pkg, 'wxCaret')
    Director.Spec(pkg, 'wxValidator', requirements: %[USE_VALIDATORS])
    Director.Spec(pkg, 'wxTextValidator', requirements: %[USE_VALIDATORS])
    Director.Spec(pkg, 'wxNumValidator', requirements: %[USE_VALIDATORS])
    Director.Spec(pkg, 'wxAccelerator', requirements: %w[USE_ACCEL])
    Director.Spec(pkg, 'wxMenuItem', requirements: %w[USE_MENUS])
    Director.Spec(pkg, 'wxMenuBar', requirements: %w[USE_MENUBAR])
    Director.Spec(pkg, 'wxMenu', requirements: %w[USE_MENUS])
    Director.Spec(pkg, 'wxAboutDialogInfo', requirements: %w[USE_ABOUTDLG])
    Director.Spec(pkg, 'wxDialog')
    Director.Spec(pkg, 'wxMessageDialog', director: Director::Dialog, requirements: %w[USE_MSGDLG])
    Director.Spec(pkg, 'wxSizerItem')
    Director.Spec(pkg, 'wxSizer')
    Director.Spec(pkg, 'wxBoxSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxWrapSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxControl')
    Director.Spec(pkg, 'wxStatusBar', requirements: %w[USE_STATUSBAR])
    Director.Spec(pkg, 'wxTextEntry')
    Director.Spec(pkg, 'wxTextAttr')
    Director.Spec(pkg, 'wxTextCtrl')
    Director.Spec(pkg, 'wxCheckBox', director: Director::Window, requirements: %w[USE_CHECKBOX])
    Director.Spec(pkg, 'wxAnyButton', requirements: Director.AnyOf(*%w[USE_BUTTON USE_TOGGLEBTN]))
    Director.Spec(pkg, 'wxButton', requirements: %w[USE_BUTTON])
    Director.Spec(pkg, 'wxToggleButton', requirements: %w[USE_TOGGLEBTN])
    Director.Spec(pkg, 'wxControlWithItems')
    Director.Spec(pkg, 'wxComboBox', requirements: %w[USE_COMBOBOX])
    Director.Spec(pkg, 'wxBitmapComboBox', requirements: %w[USE_BITMAPCOMBOBOX])
    Director.Spec(pkg, 'wxComboCtrl', requirements: %w[USE_COMBOCTRL])
    Director.Spec(pkg, 'wxRadioBox', requirements: %w[USE_RADIOBOX])
    Director.Spec(pkg, 'wxPanel')
    Director.Spec(pkg, 'wxWithImages')
    Director.Spec(pkg, 'wxBookCtrlEvent', director: Director::Event, requirements: Director.AnyOf(*%w[USE_AUI USE_NOTEBOOK USE_LISTBOOK USE_CHOICEBOOK USE_TOOLBOOK USE_TREEBOOK]))
    Director.Spec(pkg, 'wxBookCtrlBase', director: Director::BookCtrls, requirements: Director.AnyOf(*%w[USE_AUI USE_NOTEBOOK USE_LISTBOOK USE_CHOICEBOOK USE_TOOLBOOK USE_TREEBOOK]))
    Director.Spec(pkg, 'wxNotebook', director: Director::BookCtrls, requirements: Director.AnyOf(*%w[USE_NOTEBOOK]))
    Director.Spec(pkg, 'wxImageList', requirements: %w[USE_IMAGLIST])
    Director.Spec(pkg, 'wxListBox', requirements: %w[USE_LISTBOX])
    Director.Spec(pkg, 'wxChoice', requirements: %w[USE_CHOICE])
    Director.Spec(pkg, 'wxStaticBox', requirements: %w[USE_STATBOX])
    Director.Spec(pkg, 'wxSearchCtrl', requirements: %w[USE_SEARCHCTRL])
    Director.Spec(pkg, 'wxCollapsiblePane', requirements: %w[USE_COLLPANE])
    Director.Spec(pkg, 'wxCollapsiblePaneEvent', requirements: %w[USE_COLLPANE])
    Director.Spec(pkg, 'wxStaticLine', director: Director::Window, requirements: %w[USE_STATLINE ])
    Director.Spec(pkg, 'wxGauge', director: Director::Window, requirements: %w[USE_GAUGE])
    Director.Spec(pkg, 'wxSlider', requirements: %w[USE_SLIDER])
    Director.Spec(pkg, 'wxScrollBar', requirements: %w[USE_SCROLLBAR])
    Director.Spec(pkg, 'wxStaticText', director: Director::Window, requirements: %w[USE_STATTEXT])
    Director.Spec(pkg, 'wxSpinButton', director: Director::Window, requirements: %w[USE_SPINBTN])
    Director.Spec(pkg, 'wxSpinEvent', director: Director::Event, requirements: Director.AnyOf(*%w[USE_SPINBTN USE_SPINCTRL]))
    Director.Spec(pkg, 'wxSpinCtrl', director: Director::Window, requirements: %w[USE_SPINCTRL])
    Director.Spec(pkg, 'wxSpinCtrlDouble', director: Director::Window, requirements: %w[USE_SPINBTN]).spec.do_not_generate(:enums, :variables, :defines)
    Director.Spec(pkg, 'wxSpinDoubleEvent', director: Director::Event, requirements: %w[USE_SPINBTN]).spec.do_not_generate(:enums, :variables, :defines)
    Director.Spec(pkg, 'wxStaticBitmap', requirements: %w[USE_STATBMP])
    Director.Spec(pkg, 'wxBitmapButton', director: Director::Button, requirements: %w[USE_BMPBUTTON])
    Director.Spec(pkg, 'wxCommandLinkButton', director: Director::Button, requirements: %w[USE_BUTTON])
    Director.Spec(pkg, 'wxArtProvider')
    Director.Spec(pkg, 'wxStaticBoxSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxStdDialogButtonSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxCursor')
    Director.Spec(pkg, 'wxRadioButton', director: Director::Window, requirements: %w[USE_RADIOBTN])
    Director.Spec(pkg, 'wxToolTip', requirements: %w[USE_TOOLTIPS])
    Director.Spec(pkg, 'wxLog', requirements: %w[USE_LOG])
    Director.Spec(pkg, 'wxToolBar', requirements: %w[USE_TOOLBAR])
    Director.Spec(pkg, 'wxImage', requirements: %w[USE_IMAGE])
    Director.Spec(pkg, 'wxDragImage', requirements: %w[USE_DRAGIMAGE])
    Director.Spec(pkg, 'wxFont')
    Director.Spec(pkg, 'wxFontData', requirements: %w[USE_FONTDLG])
    Director.Spec(pkg, 'wxFontDialog', director: Director::Dialog, requirements: %w[USE_FONTDLG])
    Director.Spec(pkg, 'wxPickerBase')
    Director.Spec(pkg, 'wxFontPickerEvent', director: Director::Event, requirements: %w[USE_FONTDLG USE_FONTPICKERCTRL])
    Director.Spec(pkg, 'wxFontPickerCtrl', requirements: %w[USE_FONTDLG USE_FONTPICKERCTRL])
    Director.Spec(pkg, 'wxLocale', requirements: %w[USE_INTL])
    Director.Spec(pkg, 'wxSystemSettings')
    Director.Spec(pkg, 'wxSystemOptions', requirements: %w[USE_SYSTEM_OPTIONS])
    Director.Spec(pkg, 'wxPropertySheetDialog', director: Director::Dialog, requirements: Director.AnyOf(*%w[USE_AUI USE_NOTEBOOK USE_LISTBOOK USE_CHOICEBOOK USE_TOOLBOOK USE_TREEBOOK]))
    Director.Spec(pkg, 'wxScrolledWindow', director: Director::ScrolledT)
    Director.Spec(pkg, 'wxScrolledCanvas', director: Director::ScrolledT)
    Director.Spec(pkg, 'wxScrolledControl', director: Director::ScrolledT)
    Director.Spec(pkg, 'wxVScrolledWindow')
    Director.Spec(pkg, 'wxVListBox')
    Director.Spec(pkg, 'wxFindReplaceData', requirements: %w[USE_FINDREPLDLG])
    Director.Spec(pkg, 'wxFindReplaceDialog', director: Director::Dialog, requirements: %w[USE_FINDREPLDLG])
    Director.Spec(pkg, 'wxFindDialogEvent', requirements: %w[USE_FINDREPLDLG])
    Director.Spec(pkg, 'wxToolbook', director: Director::BookCtrls, requirements: %w[USE_TOOLBOOK])
    Director.Spec(pkg, 'wxChoicebook', director: Director::BookCtrls, requirements: %w[USE_CHOICEBOOK])
    Director.Spec(pkg, 'wxListbook', director: Director::BookCtrls, requirements: %w[USE_LISTBOOK])
    Director.Spec(pkg, 'wxTreebook', director: Director::BookCtrls, requirements: %w[USE_TREEBOOK])
    Director.Spec(pkg, 'wxSimplebook', director: Director::BookCtrls, requirements: Director.AnyOf(*%w[USE_AUI USE_NOTEBOOK USE_LISTBOOK USE_CHOICEBOOK USE_TOOLBOOK USE_TREEBOOK]))
    Director.Spec(pkg, 'wxColourDialog', director: Director::Dialog, requirements: %w[USE_COLOURDLG])
    Director.Spec(pkg, 'wxColourPickerEvent', director: Director::Event, requirements: %w[USE_COLOURPICKERCTRL USE_COLOURDLG])
    Director.Spec(pkg, 'wxColourPickerCtrl', requirements: %w[USE_COLOURPICKERCTRL USE_COLOURDLG])
    Director.Spec(pkg, 'wxTextEntryDialog', director: Director::Dialog, requirements: %w[USE_TEXTDLG])
    Director.Spec(pkg, 'wxNumberEntryDialog', director: Director::Dialog, requirements: %w[USE_NUMBERDLG])
    Director.Spec(pkg, 'wxSingleChoiceDialog', director: Director::Dialog, requirements: %w[USE_CHOICEDLG])
    Director.Spec(pkg, 'wxMultiChoiceDialog', director: Director::Dialog, requirements: %w[USE_CHOICEDLG])
    Director.Spec(pkg, 'wxTipProvider', requirements: %w[USE_STARTUP_TIPS])
    Director.Spec(pkg, 'wxDirDialog', director: Director::Dialog, requirements: %w[USE_DIRDLG])
    Director.Spec(pkg, 'wxFileDialog', director: Director::Dialog, requirements: %w[USE_FILEDLG])
    Director.Spec(pkg, 'wxFileDialogCustomizeHook', requirements: %w[USE_FILEDLG])
    Director.Spec(pkg, 'wxFileDialogCustomControl', requirements: %w[USE_FILEDLG])
    Director.Spec(pkg, 'wxFileDirPickerEvent', director: Director::Event, requirements: Director.AnyOf(%w[USE_DIRDLG USE_DIRPICKERCTRL], %w[USE_FILEDLG USE_FILEPICKERCTRL]))
    Director.Spec(pkg, 'wxDirPickerCtrl', requirements: %w[USE_DIRDLG USE_DIRPICKERCTRL])
    Director.Spec(pkg, 'wxFilePickerCtrl', requirements: %w[USE_FILEDLG USE_FILEPICKERCTRL])
    Director.Spec(pkg, 'wxFileCtrl', requirements: %w[USE_FILECTRL])
    Director.Spec(pkg, 'wxFileCtrlEvent', requirements: %w[USE_FILECTRL])
    Director.Spec(pkg, 'wxProgressDialog', director: Director::Dialog, requirements: %w[USE_PROGRESSDLG])
    Director.Spec(pkg, 'wxWindowDisabler')
    Director.Spec(pkg, 'wxBusyInfo', requirements: %w[USE_BUSYINFO])
    Director.Spec(pkg, 'wxListCtrl', requirements: %w[USE_LISTCTRL])
    Director.Spec(pkg, 'wxListEvent', director: Director::Event, requirements: %w[USE_LISTCTRL])
    Director.Spec(pkg, 'wxHeaderCtrl')
    Director.Spec(pkg, 'wxHeaderCtrlEvent', director: Director::Event)
    Director.Spec(pkg, 'wxGridSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxFlexGridSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxGBSizerItem', director: Director::SizerItem)
    Director.Spec(pkg, 'wxGridBagSizer', director: Director::Sizer)
    Director.Spec(pkg, 'wxSplitterEvent', requirements: %w[USE_SPLITTER])
    Director.Spec(pkg, 'wxSplitterWindow', requirements: %w[USE_SPLITTER])
    Director.Spec(pkg, 'wxTreeEvent', requirements: %w[USE_TREECTRL])
    Director.Spec(pkg, 'wxTreeCtrl', requirements: %w[USE_TREECTRL])
    Director.Spec(pkg, 'wxDateEvent', requirements: %w[USE_DATETIME])
    Director.Spec(pkg, 'wxCalendarEvent', director: Director::DateEvent, requirements: %w[USE_CALENDARCTRL])
    Director.Spec(pkg, 'wxCalendarDateAttr', requirements: %w[USE_CALENDARCTRL])
    Director.Spec(pkg, 'wxCalendarCtrl', requirements: %w[USE_CALENDARCTRL])
    Director.Spec(pkg, 'wxDatePickerCtrl', requirements: %w[USE_DATEPICKCTRL])
    Director.Spec(pkg, 'wxTimePickerCtrl', requirements: %w[USE_TIMEPICKCTRL])
    Director.Spec(pkg, 'wxTimerEvent', director: Director::Event, requirements: %w[USE_TIMER])
    Director.Spec(pkg, 'wxTimer', requirements: %w[USE_TIMER])
    Director.Spec(pkg, 'wxSashEvent', requirements: %w[USE_SASH])
    Director.Spec(pkg, 'wxSashWindow', requirements: %w[USE_SASH])
    Director.Spec(pkg, 'wxSashLayoutWindow', requirements: %w[USE_SASH])
    Director.Spec(pkg, 'wxQueryLayoutInfoEvent', director: Director::SashLayoutEvent)
    Director.Spec(pkg, 'wxCalculateLayoutEvent', director: Director::SashLayoutEvent)
    Director.Spec(pkg, 'wxEditableListBox', requirements: %w[USE_EDITABLELISTBOX])
    Director.Spec(pkg, 'wxWizardEvent', director: Director::Event, requirements: %w[USE_WIZARDDLG])
    Director.Spec(pkg, 'wxWizardPage', requirements: %w[USE_WIZARDDLG])
    Director.Spec(pkg, 'wxWizardPageSimple', director: Director::WizardPage, requirements: %w[USE_WIZARDDLG])
    Director.Spec(pkg, 'wxWizard', director: Director::Dialog, requirements: %w[USE_WIZARDDLG])
    Director.Spec(pkg, 'wxCheckListBox', requirements: %w[USE_CHECKLISTBOX])
    Director.Spec(pkg, 'wxRearrangeList', requirements: %w[USE_CHECKLISTBOX])
    Director.Spec(pkg, 'wxRearrangeCtrl', director: Director::Window, requirements: %w[USE_CHECKLISTBOX])
    Director.Spec(pkg, 'wxDataFormat', requirements: %w[USE_CLIPBOARD])
    Director.Spec(pkg, 'wxDataObject', requirements: %w[USE_CLIPBOARD])
    Director.Spec(pkg, 'wxDataObjectSimpleBase', requirements: %w[USE_CLIPBOARD])
    Director.Spec(pkg, 'wxClipboard', requirements: %w[USE_CLIPBOARD])
    Director.Spec(pkg, 'wxDragDrop', requirements: %w[USE_DRAG_AND_DROP])
    Director.Spec(pkg, 'wxContextHelpButton', requirements: %w[USE_HELP])
    Director.Spec(pkg, 'wxHelpProvider', requirements: %w[USE_HELP])
    Director.Spec(pkg, 'wxHelpController', requirements: %w[USE_HELP])
    Director.Spec(pkg, 'wxExtHelpController', director: Director::HelpController, requirements: %w[USE_HELP])
    Director.Spec(pkg, 'wxTaskBarIconEvent', director: Director::Event, requirements: %w[USE_TASKBARICON])
    Director.Spec(pkg, 'wxTaskBarIcon', requirements: %w[USE_TASKBARICON])
    Director.Spec(pkg, 'wxFSFile', requirements: %[USE_FILESYSTEM])
    Director.Spec(pkg, 'wxUtils')
    Director.Spec(pkg, 'wxDirFilterListCtrl', requirements: Director.AnyOf(*%w[USE_DIRDLG USE_FILEDLG]))
    Director.Spec(pkg, 'wxGenericDirCtrl', requirements: Director.AnyOf(*%w[USE_DIRDLG USE_FILEDLG]))
    Director.Spec(pkg, 'wxMDIClientWindow', director: Director::Window, requirements: %w[USE_MDI])
    Director.Spec(pkg, 'wxMDIFrame', requirements: %w[USE_MDI])
    Director.Spec(pkg, 'wxAccessible', requirements: %w[USE_ACCESSIBILITY])
    Director.Spec(pkg, 'wxAnimation', requirements: %w[USE_ANIMATIONCTRL])
    Director.Spec(pkg, 'wxAnimationCtrl', requirements: %w[USE_ANIMATIONCTRL])
    Director.Spec(pkg, 'wxMediaEvent', director: Director::Event, requirements: %w[USE_MEDIACTRL])
    Director.Spec(pkg, 'wxMediaCtrl', requirements: %w[USE_MEDIACTRL])
    Director.Spec(pkg, 'wxXmlNode', requirements: %w[USE_XML])
    Director.Spec(pkg, 'wxXmlResource', requirements: %w[USE_XRC])
    Director.Spec(pkg, 'wxVariant', requirements: %w[USE_VARIANT])
    Director.Spec(pkg, 'wxPlatformInfo')
    Director.Spec(pkg, 'wxSplashScreen', requirements: %w[USE_SPLASH])
    Director.Spec(pkg, 'wxUIActionSimulator', requirements: %w[USE_UIACTIONSIMULATOR])
    Director.Spec(pkg, 'wxActivityIndicator', director: Director::Window, requirements: %w[USE_ACTIVITYINDICATOR])
    Director.Spec(pkg, 'wxHyperlinkCtrl', requirements: %w[USE_HYPERLINKCTRL])
    Director.Spec(pkg, 'wxHyperlinkEvent', requirements: %w[USE_HYPERLINKCTRL])
    Director.Spec(pkg, 'wxBannerWindow', requirements: %w[USE_BANNERWINDOW])
    Director.Spec(pkg, 'wxInfoBar', requirements: %w[USE_INFOBAR])
    Director.Spec(pkg, 'wxFileSystem', requirements: %w[USE_FILESYSTEM])
    Director.Spec(pkg, 'wxDialUpManager', requirements: %w[USE_DIALUP_MANAGER])
    Director.Spec(pkg, 'wxDialUpEvent', requirements: %w[USE_DIALUP_MANAGER])
  }

  Director.Package('Wx::PRT', 'USE_PRINTING_ARCHITECTURE') do |pkg|
    Director.Spec(pkg, 'wxPrinterDC', director: Director::DerivedDC, requirements: Director.AnyOf(*%w[WXMSW WXOSX USE_GTKPRINT]))
    Director.Spec(pkg, 'wxPostScriptDC', director: Director::DerivedDC)
    Director.Spec(pkg, 'wxPrintData')
    Director.Spec(pkg, 'wxPrintDialog')
    Director.Spec(pkg, 'wxPrintAbortDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxPageSetupDialog')
    Director.Spec(pkg, 'wxPreviewFrame')
    Director.Spec(pkg, 'wxPrinter')
  end

  Director.Package('Wx::HTML', 'USE_HTML') { |pkg|
    Director.Spec(pkg, 'wxHtmlWindow')
    Director.Spec(pkg, 'wxHtmlHelpData', requirements: %w[USE_HELP])
    Director.Spec(pkg, 'wxHtmlHelpWindow', requirements: %w[USE_HELP])
    Director.Spec(pkg, 'wxHtmlCellEvent', director: Director::HtmlEvent)
    Director.Spec(pkg, 'wxHtmlLinkEvent', director: Director::HtmlEvent)
    Director.Spec(pkg, 'wxHtmlHelpController', director: Director::HelpController, requirements: %w[USE_HELP])
    Director.Spec(pkg, 'wxHtmlCell')
    Director.Spec(pkg, 'wxHtmlEasyPrinting', requirements: %w[USE_PRINTING_ARCHITECTURE])
    Director.Spec(pkg, 'wxHtmlPrintout', requirements: %w[USE_PRINTING_ARCHITECTURE])
    Director.Spec(pkg, 'wxHtmlListBox')
    Director.Spec(pkg, 'wxHTMLDataObject') if Config.instance.wx_version >= '3.3'
  }

  Director.Package('Wx::RTC', 'USE_RICHTEXT', depends_on: ['Wx::HTML']) { |pkg|
    Director.Spec(pkg, 'wxRichTextObject')
    Director.Spec(pkg, 'wxRichTextImage')
    Director.Spec(pkg, 'wxRichTextCompositeObject')
    Director.Spec(pkg, 'wxRichTextParagraphLayoutBox')
    Director.Spec(pkg, 'wxRichTextBox')
    Director.Spec(pkg, 'wxRichTextEvent')
    Director.Spec(pkg, 'wxRichTextBuffer')
    Director.Spec(pkg, 'wxRichTextCtrl')
    Director.Spec(pkg, 'wxRichTextFileHandler')
    Director.Spec(pkg, 'wxRichTextXMLHandler', director: Director::RichTextFileHandler)
    Director.Spec(pkg, 'wxRichTextHTMLHandler', director: Director::RichTextFileHandler)
    Director.Spec(pkg, 'wxRichTextHeaderFooterData', requirements: %w[USE_PRINTING_ARCHITECTURE])
    Director.Spec(pkg, 'wxRichTextPrinting', requirements: %w[USE_PRINTING_ARCHITECTURE])
    Director.Spec(pkg, 'wxSymbolPickerDialog', director: Director::Dialog)
    Director.Spec(pkg, 'wxRichTextFormattingDialog')
    Director.Spec(pkg, 'wxRichTextStyleOrganiserDialog')
    Director.Spec(pkg, 'wxRichTextStyleListBox')
    Director.Spec(pkg, 'wxRichTextBufferDataObject')
  }

  Director.Package('Wx::STC', 'USE_STC') { |pkg|
    Director.Spec(pkg, 'wxStyledTextEvent')
    Director.Spec(pkg, 'wxStyledTextCtrl')
  }

  Director.Package('Wx::GRID', 'USE_GRID') { |pkg|
    Director.Spec(pkg, 'wxGridEvent', director: Director::Event)
    Director.Spec(pkg, 'wxGridSizeEvent', director: Director::Event)
    Director.Spec(pkg, 'wxGridEditorCreatedEvent', director: Director::Event)
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
    Director.Spec(pkg, 'wxGridTableMessage')
    Director.Spec(pkg, 'wxGridStringTable')
    Director.Spec(pkg, 'wxGridCtrl')
  }

  Director.Package('Wx::AUI', 'USE_AUI') { |pkg|
    Director.Spec(pkg, 'wxAuiPaneInfo')
    Director.Spec(pkg, 'wxAuiManagerEvent')
    Director.Spec(pkg, 'wxAuiDockArt')
    Director.Spec(pkg, 'wxAuiFloatingFrame')
    Director.Spec(pkg, 'wxAuiManager')
    Director.Spec(pkg, 'wxAuiNotebookEvent')
    Director.Spec(pkg, 'wxAuiTabArt')
    Director.Spec(pkg, 'wxAuiNotebook')
    Director.Spec(pkg, 'wxAuiTabCtrl')
    Director.Spec(pkg, 'wxAuiToolBarItem')
    Director.Spec(pkg, 'wxAuiToolBarArt')
    Director.Spec(pkg, 'wxAuiToolBarEvent')
    Director.Spec(pkg, 'wxAuiToolBar')
    Director.Spec(pkg, 'wxAuiMDIClientWindow')
    Director.Spec(pkg, 'wxAuiMDIParentFrame')
    Director.Spec(pkg, 'wxAuiMDIChildFrame')
  }

  Director.Package('Wx::PG', 'USE_PROPGRID') { |pkg|
    Director.Spec(pkg, 'wxPGEditor')
    Director.Spec(pkg, 'wxPGMultiButton')
    Director.Spec(pkg, 'wxPGCell')
    Director.Spec(pkg, 'wxPGProperty')
    Director.Spec(pkg, 'wxNumericPropertyValidator', requirements: %[USE_VALIDATORS])
    Director.Spec(pkg, 'wxPGArrayEditorDialog')
    Director.Spec(pkg, 'wxPGProperties')
    Director.Spec(pkg, 'wxPropertyGridEvent')
    Director.Spec(pkg, 'wxPGValidationInfo')
    Director.Spec(pkg, 'wxPropertyGridPageState')
    Director.Spec(pkg, 'wxPropertyGridPage')
    Director.Spec(pkg, 'wxPropertyGridInterface')
    Director.Spec(pkg, 'wxPropertyGrid')
    Director.Spec(pkg, 'wxPropertyGridManager')
  }

  Director.Package('Wx::RBN', 'USE_RIBBON') { |pkg|
    Director.Spec(pkg, 'wxRibbonBarEvent')
    Director.Spec(pkg, 'wxRibbonButtonBarEvent')
    Director.Spec(pkg, 'wxRibbonGalleryEvent')
    Director.Spec(pkg, 'wxRibbonPanelEvent')
    Director.Spec(pkg, 'wxRibbonToolBarEvent')
    Director.Spec(pkg, 'wxRibbonArtProvider')
    Director.Spec(pkg, 'wxRibbonControl')
    Director.Spec(pkg, 'wxRibbonBar')
    Director.Spec(pkg, 'wxRibbonGallery')
    Director.Spec(pkg, 'wxRibbonPage')
    Director.Spec(pkg, 'wxRibbonPanel')
    Director.Spec(pkg, 'wxRibbonToolBar')
    Director.Spec(pkg, 'wxRibbonButtonBar')
  }
end # module WXRuby3
