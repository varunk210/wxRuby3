# Copyright (c) 2023 M.J.N. Corino, The Netherlands
#
# This software is released under the MIT license.

###
# wxRuby3 wxWidgets interface director
###

require_relative './event'

module WXRuby3

  class Director

    include Typemap::PGProperty

    class PropertyGridEvent < Event

      def setup
        super
      end
    end # class PropertyGridEvent

  end # class Director

end # module WXRuby3
