#--------------------------------------------------------------------
# @file    busy_info.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface director
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  class Director

    class BusyInfo < Director

      def setup
        super
        spec.items << 'wxBusyInfoFlags'
        spec.disable_proxies
        # again C++ type guards do not work with Ruby
        # need to Rubify this
        spec.make_abstract 'wxBusyInfo'
        spec.ignore %w[
          wxBusyInfo::wxBusyInfo
          ]
        spec.add_swig_code <<~__HEREDOC
          // BusyInfo is an exception to the general rule in typemap.i - it
          // accepts a wxWindow* parent argument which may be null - but it does
          // not inherit from TopLevelWindow - so special typemap for this class.
          %typemap(check) wxWindow* parent {
            if ( ! rb_const_defined(mWxruby3, rb_intern("THE_APP") ) )
            { 
              rb_raise(rb_eRuntimeError,
                   "Cannot create BusyInfo before App.main_loop has been called");
            }
          }
          __HEREDOC
        spec.add_extend_code 'wxBusyInfo', <<~__HEREDOC
          static VALUE busy(const wxString& message, wxWindow *parent = NULL)
          {
            VALUE rb_busyinfo = Qnil;
            wxBusyInfo *p_busyinfo = 0 ;
            if (rb_block_given_p())
            {
              wxBusyInfo disabler(message,parent);
              p_busyinfo = &disabler;
              rb_busyinfo = SWIG_NewPointerObj(SWIG_as_voidptr(p_busyinfo), SWIGTYPE_p_wxBusyInfo, 0 |  0 );
              return rb_yield(rb_busyinfo);
            }
            return Qnil;
          }
          static VALUE busy(const wxBusyInfoFlags &flags)
          {
            VALUE rb_busyinfo = Qnil;
            wxBusyInfo *p_busyinfo = 0 ;
            if (rb_block_given_p())
            {
              wxBusyInfo disabler(flags);
              p_busyinfo = &disabler;
              rb_busyinfo = SWIG_NewPointerObj(SWIG_as_voidptr(p_busyinfo), SWIGTYPE_p_wxBusyInfo, 0 |  0 );
              return rb_yield(rb_busyinfo);
            }
            return Qnil;
          }
          __HEREDOC
      end
    end # class BusyInfo

  end # class Director

end # module WXRuby3