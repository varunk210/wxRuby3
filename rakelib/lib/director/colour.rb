###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

module WXRuby3

  class Director

    class Colour < Director

      def setup
        spec.require_app 'wxColour::wxColour(const wxColour&)'
        spec.ignore(%w[
          wxColour::GetPixel wxTransparentColour wxColour::operator!=
          wxBLACK wxBLUE wxCYAN wxGREEN wxYELLOW wxLIGHT_GREY wxRED wxWHITE
          ])
        # rename static method to prevent masking the instance method
        spec.rename_for_ruby 'create_disabled' => 'wxColour::MakeDisabled(unsigned char *r, unsigned char *g, unsigned char *b, unsigned char brightness=255)',
                             # for consistency
                             'create_mono' => 'wxColour::MakeMono',
                             'create_grey' => 'wxColour::MakeGrey'
        spec.add_wrapper_code <<~__HEREDOC
          WXRUBY_EXPORT bool wxRuby_IsRubyColour(VALUE rbcol)
          {
            swig_class *sklass = (swig_class *) SWIGTYPE_p_wxColour->clientdata;
            return (TYPE(rbcol) == T_STRING || 
                    TYPE(rbcol) == T_SYMBOL || 
                    (TYPE(rbcol) == T_DATA && rb_obj_is_kind_of(rbcol, sklass->klass)));
          }
          WXRUBY_EXPORT wxColour wxRuby_ColourFromRuby(VALUE rbcol)
          {
            if (TYPE(rbcol) == T_STRING || TYPE(rbcol) == T_SYMBOL)
            {
              wxString colstr;
              if (TYPE(rbcol) == T_STRING)
              { colstr = RSTR_TO_WXSTR(rbcol); }
              else
              { colstr = rb_id2name(SYM2ID(rbcol)); }
              return wxColour(colstr);
            }
            else if (TYPE(rbcol) == T_DATA)
            {
              void *colp;
              int res = SWIG_ConvertPtr(rbcol, &colp, SWIGTYPE_p_wxColour, 0);
              if (SWIG_IsOK(res) && colp) 
              {
                return *reinterpret_cast<wxColour *>(colp);
              }
            }
            return wxColour();
          }
          WXRUBY_EXPORT VALUE wxRuby_ColourToRuby(const wxColour& col, bool own)
          {
            if (own)
              return SWIG_NewPointerObj(new wxColour(col), SWIGTYPE_p_wxColour, SWIG_POINTER_OWN);
            else
              return SWIG_NewPointerObj(SWIG_as_voidptr(&col), SWIGTYPE_p_wxColour, 0);
          }
          __HEREDOC
        super
      end
    end # class Colour

  end # class Director

end # module WXRuby3
