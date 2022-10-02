#--------------------------------------------------------------------
# @file    richtext_ctrl.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  class Director

    class RichTextCtrl < Window

      def setup
        super
        spec.ignore_bases('wxRichTextCtrl' => %w[wxTextCtrlIface wxScrollHelper])
        spec.include 'wx/dc.h'
        spec.ignore [
          'wxRichTextCtrl::GetSelection(long *,long *) const',
          'wxRichTextCtrl::GetSelection() const',
          'wxRichTextCtrl::SetStyle(long,long,const wxTextAttr &)',
          'wxRichTextCtrl::SetStyle(const wxRichTextRange &,const wxTextAttr &)',
          'wxRichTextCtrl::SetStyle(wxRichTextObject *,const wxRichTextAttr &,int)',
          'wxRichTextCtrl::GetStyleForRange(const wxRichTextRange &,wxTextAttr &)',
          'wxRichTextCtrl::HitTest(const wxPoint &,long *)',
          'wxRichTextCtrl::SetListStyle(const wxRichTextRange &,wxRichTextListStyleDefinition *,int,int,int)',
          ]
        # TODO : not supported (yet)
        spec.ignore %w[
          wxRichTextCtrl::WriteTextBox
          wxRichTextCtrl::WriteField
          wxRichTextCtrl::WriteTable
          wxRichTextCtrl::PaintBackground
          wxRichTextCtrl::PaintAboveContent
          ]
        spec.no_proxy %w[
          wxRichTextCtrl::GetDefaultStyleEx
          wxRichTextCtrl::GetBasicStyle
          ]
        spec.swig_include 'swig/shared/richtext.i'
        spec.swig_import 'swig/classes/include/wxRichTextBuffer.h'
        spec.add_swig_runtime_code <<~__HEREDOC
          %warnfilter(402) wxRichTextAttr;

          // Deal with some output values from TextCtrl methods - PositionToXY
          %apply long * OUTPUT { long * }
          %apply long * OUTPUT { wxTextCoord *col, wxTextCoord *row }
          
          // GetViewStart
          %apply int * OUTPUT { int * }
          
          %apply SWIGTYPE *DISOWN { wxRichTextStyleSheet* styleSheet };
          __HEREDOC
      end
    end # class RichTextCtrl

  end # class Director

end # module WXRuby3
