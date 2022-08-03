#--------------------------------------------------------------------
# @file    variable.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets interface extractor
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

module WXRuby3

  module Extractor

    # Information about a standalone function.
    class FunctionDef < BaseDef # , FixWxPrefix):
      def initialize(element = nil, **kwargs)
        super()
        @type = nil
        @definition = ''
        @template_params = [] # function is a template
        @args_string = ''
        @rb_args_string = ''
        @is_overloaded = false
        @overloads = []
        @factory = false # a factory function that creates a new instance of the return value
        # @pyReleaseGIL = false     # release the Python GIL for this function call
        # @pyHoldGIL = false        # hold the Python GIL for this function call
        @no_copy = false # don't make a copy of the return value, just wrap the original
        @rb_int = false # treat char types as integers
        @transfer = false # transfer ownership of return value to C++?
        @transfer_back = false # transfer ownership of return value from C++ to Python?
        @transfer_this = false # ownership of 'this' pointer transferred to C++
        @cpp_code = nil # Use this code instead of the default wrapper
        @no_arg_parser = false # set the NoargParser annotation
        @pre_method_code = nil

        update_attributes(**kwargs)
        extract(element) if element
      end

      attr_accessor :type, :definition, :template_params, :args_string, :rb_args_string, :is_overloaded, :overloads, :factory,
                    :no_copy, :rb_int, :transfer, :transfer_back, :transfer_this, :cpp_code, :no_arg_parser, :pre_method_code

      def is_template?
        !template_params.empty?
      end

      def extract(element)
        super
        @type = BaseDef.flatten_node(element.at_xpath('type'))
        @definition = element.at_xpath('definition').text
        element.xpath('templateparamlist/param').each do |node|
          if node.at_xpath('declname')
            txt = node.at_xpath('declname').text
          else
            txt = node.at_xpath('type').text
            txt.sub!('class ', '')
            txt.sub!('typename ', '')
          end
          @template_params << txt
        end
        @args_string = element.at_xpath('argsstring').text
        check_deprecated
        element.xpath('param').each do |node|
          p = ParamDef.new(node)
          items << p
          # TODO: Look at @detailedDoc and pull out any matching
          # parameter description items and assign that value as the
          # briefDoc for this ParamDef object.
        end
      end

      def signature
        sig = "#{@type} #{name}"
        params = items.select {|i| ParamDef === i }
        if params.empty?
          sig << '()'
        else
          sig << '(' << params.collect {|p| p.type }.join(',') << ')'
        end
        sig
      end

      # def releaseGIL(self, release=True):
      #     @pyReleaseGIL = release
      #
      # def holdGIL(self, hold=True):
      #     @pyHoldGIL = hold

      # def setCppCode_sip(self, code):
      #     """
      #     Use the given C++ code instead of that automatically generated by the
      #     back-end. This is similar to adding a new C++ method, except it uses
      #     info we've already received from the source XML such as the argument
      #     types and names, docstring, etc.
      #
      #     The code generated for this version will expect the given code to use
      #     SIP specific variable names, etc. For example::
      #
      #         sipRes = sipCpp->Foo();
      #     """
      #     @cppCode = (code, 'sip')

      # def set_cpp_code(code)
      #     # """
      #     # Use the given C++ code instead of that automatically generated by the
      #     # back-end. This is similar to adding a new C++ method, except it uses
      #     # info we've already received from the source XML such as the argument
      #     # types and names, docstring, etc.
      #     #
      #     # The code generated for this version will put the given code in a
      #     # wrapper function that will enable it to be more independent, not SIP
      #     # specific, and also more natural. For example::
      #     #
      #     #     return self->Foo();
      #     # """
      #     @cpp_code = code

      def check_for_overload(methods)
        methods.each do |m|
          if m.is_a?(FunctionDef) && m.name == @name
            m.overloads << self
            m.is_overloaded = @is_overloaded = true
            return true
          end
        end
        false
      end

      def all
        [self] + overloads
      end

      def find_overload(matchText, isConst = nil, printSig = false)
        # Search for an overloaded method that has matchText in its C++ argsString.
        all.each do |o|
          puts("%s%s" % [o.name, o.args_string]) if printSig
          if o.args_string.gsub(' ','').index(matchText.gsub(' ','')) && !o.ignored
            unless isConst
              return o
            else
              return o if o.is_const == isConst
            end
          end
        end
        nil
      end

      def has_overloads
        # Returns True if there are any overloads that are not ignored.
        overloads.any? { |o| !o.ignored }
      end

      def rename_overload(matchText, newName, **kwargs)
        # Rename the overload with matching matchText in the argsString to
        # newName. The overload is moved out of this function's overload list
        # and directly into the parent module or class so it can appear to be a
        # separate function.
        if self.respond_to?(:module)
          parent = @module
        else
          parent = @klass
        end
        item = find_overload(matchText)
        item.rb_name = newName
        item.update_attributes(**kwargs)

        unless item == self && !has_overloads # unless we're done and there actually is only one instance of this method
          if item == self
            # Make the first overload take the place of this node in the
            # parent, and then insert this item into the parent's list again
            _overloads = @overloads.sort { |o1, o2| o1.ignored ? (o2.ignored ? 0 : 1) : (o2.ignored ? -1 : 0) }
            first = _overloads.first
            @overloads = []
            _overloads.shift
            first.overloads = _overloads
            idx = parent.items.index(self)
            parent.items[idx] = first
            parent.insert_item_after(first, self)
          else
            # Just remove from the overloads list and insert it into the parent.
            overloads.delete(item)
            parent.insert_item_after(self, item)
          end
        end
        item
      end

      def ignore(val = true)
        # In addition to ignoring this item, reorder any overloads to ensure
        # the primary overload is not ignored, if possible.
        super
        if val and @overloads
          reorder_overloads
        end
        self
      end

      def reorder_overloads
        # Reorder a set of overloaded functions such that the primary
        # FunctionDef is one that is not ignored.
        if @overloads && ignored
          all_overloads = [self] + @overloads
          all_overloads.sort { |i1, i2| i1.ignored ? (i2.ignored ? 0 : 1) : (i2.ignored ? -1 : 0) }
          first = all_overloads.shift
          unless first.ignored
            if self.respond_to?(:module)
              parent = @module
            else
              parent = @klass
            end
            @overloads = []
            first.overloads = all_overloads
            idx = parent.items.index(self)
            parent.items[idx] = first
          end
        end
      end

      def _find_items
        _items = @items.dup
        @overloads.each do |o|
          _items.concat(o.items)
        end
        _items
      end

      # def makePyArgsString(self):
      #     """
      #     Create a pythonized version of the argsString in function and method
      #     items that can be used as part of the docstring.
      #
      #     TODO: Maybe (optionally) use this syntax to document arg types?
      #           http://www.python.org/dev/peps/pep-3107/
      #     """
      #     def _cleanName(name):
      #         for txt in ['const', '*', '&', ' ']:
      #             name = name.replace(txt, '')
      #         name = name.replace('::', '.')
      #         name = @fixWxPrefix(name, True)
      #         return name
      #
      #     params = list()
      #     returns = list()
      #     if @type and @type != 'void':
      #         returns.append(_cleanName(@type))
      #
      #     defValueMap = { 'true':  'True',
      #                     'false': 'false',
      #                     'NULL':  'nil',
      #                     'wxString()': '""',
      #                     'wxArrayString()' : '[]',
      #                     'wxArrayInt()' : '[]',
      #                     }
      #     if isinstance(self, CppMethodDef):
      #         # rip apart the argsString instead of using the (empty) list of parameters
      #         lastP = @argsString.rfind(')')
      #         args = @argsString[:lastP].strip('()').split(',')
      #         for arg in args:
      #             if not arg:
      #                 continue
      #             # is there a default value?
      #             default = ''
      #             if '=' in arg:
      #                 default = arg.split('=')[1].strip()
      #                 arg = arg.split('=')[0].strip()
      #                 if default in defValueMap:
      #                     default = defValueMap.get(default)
      #                 else:
      #                     default = @fixWxPrefix(default, True)
      #             # now grab just the last word, it should be the variable name
      #             arg = arg.split()[-1]
      #             if default:
      #                 arg += '=' + default
      #             params.append(arg)
      #     else:
      #         for param in @items:
      #             assert isinstance(param, ParamDef)
      #             if param.ignored:
      #                 continue
      #             if param.arraySize:
      #                 continue
      #             s = param.pyName or param.name
      #             if param.out:
      #                 returns.append(s)
      #             else:
      #                 if param.inOut:
      #                     returns.append(s)
      #                 if param.default:
      #                     default = param.default
      #                     if default in defValueMap:
      #                         default = defValueMap.get(default)
      #
      #                     s += '=' + '|'.join([_cleanName(x) for x in default.split('|')])
      #                 params.append(s)
      #
      #     @pyArgsString = '(' + ', '.join(params) + ')'
      #     if len(returns) == 1:
      #         @pyArgsString += ' -> ' + returns[0]
      #     if len(returns) > 1:
      #         @pyArgsString += ' -> (' + ', '.join(returns) + ')'
      #
      #
      # def collectPySignatures(self):
      #     """
      #     Collect the pyArgsStrings for self and any overloads, and create a
      #     list of function signatures for the docstrings.
      #     """
      #     sigs = list()
      #     for f in [self] + @overloads:
      #         assert isinstance(f, FunctionDef)
      #         if f.ignored:
      #             continue
      #         if not f.pyArgsString:
      #             f.makePyArgsString()
      #
      #         sig = f.pyName or @fixWxPrefix(f.name)
      #         if sig in magicMethods:
      #             sig = magicMethods[sig]
      #         sig += f.pyArgsString
      #         sigs.append(sig)
      #     return sigs
      #
      #
      # def mustHaveApp(self, value=True):
      #     if value:
      #         @preMethodCode = "if (!wxPyCheckForApp()) return NULL;\n"
      #     else:
      #         @preMethodCode = nil

    end # class FunctionDef

    # Represents a class method, ctor or dtor declaration.
    class MethodDef < FunctionDef
      def initialize(element = nil, className = nil, **kwargs)
        super()
        @class_name = className
        @is_virtual = false
        @is_pure_virtual = false
        @is_override = false
        @is_static = false
        @is_const = false
        @is_ctor = false
        @is_dtor = false
        @protection = 'public'
        @default_ctor = false # use this ctor as the default one
        # @no_derived_ctor = false # don't generate a ctor in the derived class for this ctor
        # @cpp_signature = nil
        # @virtual_catcher_code = nil
        update_attributes(**kwargs)
        extract(element) if element
        # elif not hasattr(self, 'isCore'):
        #     @isCore = _globalIsCore
      end

      attr_accessor :class_name, :is_virtual, :is_pure_virtual, :is_override, :is_static, :is_const, :is_ctor, :is_dtor,
                    :protection, :default_ctor
      #, :no_derived_ctor, :cpp_signature, :virtual_catcher_code

      def extract(element)
        super
        @is_static = element['static'] == 'yes'
        @is_virtual = %w[virtual pure-virtual].include?(element['virt'])
        @is_pure_virtual = (element['virt'] == 'pure-virtual')
        @is_override = !!element.at_xpath('reimplements')
        @is_const = (element['const'] == 'yes')
        @is_ctor = (@name == @class_name)
        @is_dtor = (@name == "~#{@class_name}")
        @protection = element['prot']
        unless %w[public protected].include?(@protection)
          raise ExtractorError.new("Invalid protection [#{@protection}")
        end
        # TODO: Should protected items be ignored by default or should we
        #       leave that up to the tweaker code or the generators?
        self.ignore if @protection == 'protected'
      end
    end # class MethodDef

    # A parameter of a function or method.
    class ParamDef < BaseDef
      def initialize(element = nil, **kwargs)
        super()
        @type = '' # data type
        @default = '' # default value
        # @out = false # is it an output arg?
        # @in_out = false # is it both input and output?
        # @rb_int = false # treat char types as integers
        # @array = false # the param is to be treated as an array
        # @array_size = false # the param is the size of the array
        # @transfer = false # transfer ownership of arg to C++?
        # @transfer_back = false # transfer ownership of arg from C++ to Python?
        # @transfer_this = false # ownership of 'this' pointer transferred to this arg
        # @keep_reference = false # an extra reference to the arg is held
        # @constrained = false # limit auto-conversion of similar types (like float -> int)
        update_attributes(**kwargs)
        extract(element) if element
      end

      attr_accessor :type, :default

      def extract(element)
        begin
          @type = BaseDef.flatten_node(element.at_xpath('type'))
          # we've got varags
          if @type == '...'
            @name = ''
          else
            if element.at_xpath('declname')
              @name = element.at_xpath('declname').text
            elsif element.at_xpath('defname')
              @name = element.at_xpath('defname').text
            end
            if element.at_xpath('defval')
              @default = BaseDef.flatten_node(element.at_xpath('defval'))
            end
          end
        rescue Exception
            puts("error when parsing element: #{element.to_s}")
            raise
        end
      end
    end # class ParamDef

    # This class provides information that can be used to add the code for a new
    # method to a wrapper class that does not actually exist in the real C++
    # class, or it can be used to provide an alternate implementation for a
    # method that does exist. The backend generator support for this feature
    # would be things like %extend in SWIG.
    #
    # NOTE: This one is not automatically extracted, but can be added to
    #       classes in the tweaker stage
    # class CppMethodDef < MethodDef
    #   def initialize(type, name, argsString, body, doc=nil, isConst=false,
    #                cppSignature=nil, virtualCatcherCode=nil, **kwargs)
    #       super()
    #       @type = type
    #       @name = name
    #       @use_derived_name = true
    #       @args_string = argsString
    #       @body = body
    #       @brief_doc = doc
    #       @protection = 'public'
    #       @klass = nil
    #       @no_derived_ctor = false
    #       @is_const = isConst
    #       @is_pure_virtual = false
    #       @cpp_signature = cppSignature
    #       @virtual_catcher_code = virtualCatcherCode
    #       # @isCore = _globalIsCore
    #       @is_slot = false
    #       update_attributes(**kwargs)
    #   end
    #
    #   attr_accessor :use_derived_name, :body, :is_slot
    #
    #   # Create a new CppMethodDef that is essentially a copy of a MethodDef,
    #   # so it can be used to write the code for a new wrapper function.
    #   #
    #   # TODO: It might be better to just refactor the code in the generator
    #   # so it can be shared more easily instead of using a hack like this...
    #   def self.FromMethod(method)
    #     m = CppMethodDef.new('', '', '', '')
    #     m.update_attributes(extra_attributes)
    #     m
    #   end
    # end # class CppMethodDef

  end # module Extractor

end # module WXRuby3
