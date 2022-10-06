#--------------------------------------------------------------------
# @file    tip_provider.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  class Director

    class TipProvider < Director

      def setup
        spec.gc_as_object
        spec.add_header_code <<~__HEREDOC
          // Custom subclass implementation. 
          // Provides access to currentTip member.
          class wxRubyTipProvider : public wxTipProvider
          {
          public:
            wxRubyTipProvider(size_t currentTip) : wxTipProvider(currentTip) {}
            void SetCurrentTip(size_t currentTip) { m_currentTip = currentTip; }
          };
          __HEREDOC
        # make wxRubyTipProvider known in Ruby as wxTipProvider
        spec.add_swig_code '%rename(wxTipProvider) wxRubyTipProvider;'
        # but generate from interface wxRubyTipProvider
        spec.rename_class('wxTipProvider', 'wxRubyTipProvider')
        # add setter to class def
        spec.extend_class('wxTipProvider', 'void SetCurrentTip(size_t currentTip);')
        super
      end
    end # class TipProvider

  end # class Director

end # module WXRuby3