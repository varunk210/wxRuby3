###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './window'

module WXRuby3

  class Director

    class PropertyGridManager < Window

      include Typemap::PGPropArg

      def setup
        super
        spec.override_inheritance_chain('wxPropertyGridManager', %w[wxPanel wxWindow wxEvtHandler wxObject])
        spec.add_swig_code 'typedef const wxPGPropArgCls& wxPGPropArg;'
        # mixin PropertyGridInterface
        spec.include_mixin 'wxPropertyGridManager', 'Wx::PG::PropertyGridInterface'
        # for AddPage and InsertPage
        spec.disown 'wxPropertyGridPage *pageObj'
        spec.suppress_warning(473, 'wxPropertyGridManager::InsertPage')
        # do not expose iterator class; #each_property provided by PropertyGridInterface mixin
        spec.ignore 'wxPropertyGridManager::GetVIterator'
      end
    end # class PropertyGridManager

  end # class Director

end # module WXRuby3
