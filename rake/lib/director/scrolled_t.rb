#--------------------------------------------------------------------
# @file    scrolled_t.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

require_relative './window'

module WXRuby3

  class Director

    class ScrolledT < Window

      def setup
        super
        spec.items.replace %w[wxScrolled]
        spec.gc_as_window
        case spec.module_name
        when 'wxScrolledWindow'
          spec.use_template_as_class('wxScrolled', 'wxScrolledWindow')
          spec.override_base('wxScrolled', 'wxPanel')
          spec.extend_interface('wxScrolled', 'virtual ~wxScrolledWindow();')
          spec.include 'wx/panel.h'
          spec.swig_import %w[
            swig/classes/include/wxObject.h
            swig/classes/include/wxEvtHandler.h
            swig/classes/include/wxWindow.h
            swig/classes/include/wxPanel.h
            ]
          spec.no_proxy 'wxScrolledWindow::SendAutoScrollEvents'
          spec.do_not_generate(:typedefs, :functions)
        when 'wxScrolledCanvas'
          spec.use_template_as_class('wxScrolled', 'wxScrolledCanvas')
          spec.override_base('wxScrolled', 'wxWindow')
          spec.extend_interface('wxScrolled', 'virtual ~wxScrolledCanvas();')
          spec.include 'wx/window.h'
          spec.swig_import %w[
            swig/classes/include/wxObject.h
            swig/classes/include/wxEvtHandler.h
            swig/classes/include/wxWindow.h
            ]
          spec.no_proxy 'wxScrolledCanvas::SendAutoScrollEvents'
          spec.do_not_generate(:typedefs, :functions, :enums) # enums are generated with wxScrolledWindow
        end
        spec.ignore 'wxScrolled::OnDraw'
        spec.ignore 'wxScrolled::GetViewStart(int *,int *)'
        spec.map_apply 'int * OUTPUT' => 'int *'
      end
    end # class ScrolledT

  end # class Director

end # module WXRuby3
