###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

module WXRuby3

  class Director

    class PrintData < Director

      include Typemap::PrintData

      def setup
        super
        spec.disable_proxies # fixed and final data structures
        spec.items << 'wxPrintDialogData' << 'wxPageSetupDialogData'
        spec.ignore 'wxPrintDialogData::SetSetupDialog' # deprecated since 2.5.4
      end
    end # class PrintData

  end # class Director

end # module WXRuby3