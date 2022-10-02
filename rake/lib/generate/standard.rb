#--------------------------------------------------------------------
# @file    standard.rb
# @author  Martin Corino
#
# @brief   wxRuby3 wxWidgets standard interface generator
#
# @copyright Copyright (c) M.J.N. Corino, The Netherlands
#--------------------------------------------------------------------

require_relative './base'

module WXRuby3

  class StandardGenerator < Generator

    def gen_swig_header(fout, spec)
      fout << <<~__HEREDOC
        /**
         * This file is automatically generated by the WXRuby3 interface generator.
         * Do not alter this file.
         */

        %include "../common.i"

        %module(directors="1") #{spec.module_name}
        __HEREDOC
    end

    def gen_swig_gc_types(fout, spec)
      spec.def_items.each do |item|
        if Extractor::ClassDef === item
          unless spec.is_folded_base?(item.name)
            fout.puts "#{spec.gc_type(item)}(#{spec.class_name(item)});"
          end
          item.innerclasses.each do |inner|
            fout.puts "#{spec.gc_type(inner)}(#{spec.class_name(inner)});"
          end
        end
      end
    end

    def gen_swig_begin_code(fout, spec)
      unless spec.disowns.empty?
        fout.puts
        spec.disowns.each do |dis|
          fout.puts "%apply SWIGTYPE *DISOWN { #{dis} };"
        end
      end
      if spec.swig_begin_code && !spec.swig_begin_code.empty?
        fout.puts
        fout << spec.swig_begin_code
      end
      unless spec.includes.empty?
        fout.puts "%header %{"
        spec.includes.each do |inc|
          fout.puts "#include \"#{inc}\"" unless inc.index('wx.h')
        end
        fout.puts "%}"
      end
      if spec.begin_code && !spec.begin_code.empty?
        fout.puts
        fout.puts "%begin %{"
        fout.puts "spec.begin_code"
        fout.puts "%}"
      end
    end

    def gen_swig_runtime_code(fout, spec)
      if spec.disabled_proxies
        spec.def_classes.each do |cls|
          if !cls.ignored && !cls.is_template?
            unless spec.is_folded_base?(cls.name)
              fout.puts "%feature(\"nodirector\") #{spec.class_name(cls)};"
            end
          end
        end
      else
        spec.def_classes.each do |cls|
          unless cls.ignored && cls.is_template? || cls.all_methods.any? { |m| m.is_virtual }
            fout.puts "%feature(\"nodirector\") #{spec.class_name(cls)};"
          end
        end
      end
      unless spec.no_proxies.empty?
        fout.puts
        spec.no_proxies.each do |name|
          fout.puts "%feature(\"nodirector\") #{name};"
        end
      end
      unless spec.renames.empty?
        fout.puts
        spec.renames.each_pair do |to, from|
          from.each { |org| fout.puts "%rename(#{to}) #{org};" }
        end
      end
      if spec.swig_runtime_code && !spec.swig_runtime_code.empty?
        fout.puts
        fout.puts spec.swig_runtime_code
      end
      if spec.runtime_code && !spec.runtime_code.empty?
        fout.puts
        fout.puts "%runtime %{"
        fout.puts spec.runtime_code
        fout.puts "%}"
      end
    end

    def gen_swig_header_code(fout, spec)
      if spec.swig_header_code && !spec.swig_header_code.empty?
        fout.puts
        fout.puts spec.swig_header_code
      end
      if spec.header_code && !spec.header_code.empty?
        fout.puts
        fout.puts "%header %{"
        fout.puts spec.header_code
        fout.puts "%}"
      end
    end

    def gen_swig_wrapper_code(fout, spec)
      if spec.wrapper_code && !spec.wrapper_code.empty?
        fout.puts
        fout.puts "%wrapper %{"
        fout.puts spec.wrapper_code
        fout.puts "%}"
      end
    end

    def gen_swig_init_code(fout, spec)
      if spec.init_code && !spec.init_code.empty?
        fout.puts
        fout.puts "%init %{"
        fout.puts spec.init_code
        fout.puts "%}"
      end
    end

    def gen_swig_extensions(fout, spec)
      spec.def_items.each do |item|
        if Extractor::ClassDef === item && !item.ignored && !spec.is_folded_base?(item.name)
          extension = spec.extend_code(spec.class_name(item.name))
          unless extension.empty?
            fout.puts "\n%extend #{spec.class_name(item.name)} {"
            fout.puts extension
            fout.puts '};'
          end
        end
      end
    end

    def gen_swig_interface_code(fout, spec)
      spec.def_items.each do |item|
        if Extractor::ClassDef === item && !item.ignored && !spec.is_folded_base?(item.name)
          fout.puts ''
          spec.base_list(item).reverse.each do |base|
            unless spec.def_item(base)
              fout.puts %Q{%import "#{WXRuby3::Config.instance.interface_dir}/#{base}.h"}
            end
          end
        end
      end

      unless spec.swig_imports.empty?
        fout.puts ''
        spec.swig_imports.each do |inc|
          fout .puts %Q{%import "#{inc}"}
        end
      end

      unless spec.swig_includes.empty?
        fout.puts ''
        spec.swig_includes.each do |inc|
          fout.puts %Q{%include "#{inc}"}
        end
      end

      if spec.swig_interface_code && !spec.swig_interface_code.empty?
        fout.puts
        fout.puts spec.swig_interface_code
      end
      if spec.interface_code && !spec.interface_code.empty?
        fout.puts
        fout.puts spec.interface_code
      end
    end

    def gen_swig_interface_file(spec)
      File.open(spec.interface_file, File::CREAT|File::TRUNC|File::RDWR) do |fout|
        gen_swig_interface_specs(fout, spec)
      end
    end

    def gen_swig_interface_specs(fout, spec)
      gen_swig_header(fout, spec)

      gen_swig_gc_types(fout, spec)

      gen_swig_begin_code(fout, spec)

      gen_swig_runtime_code(fout, spec)

      gen_swig_header_code(fout, spec)

      gen_swig_init_code(fout, spec)

      gen_swig_extensions(fout, spec)

      gen_swig_interface_code(fout, spec)

      gen_swig_wrapper_code(fout, spec)
    end

    def gen_interface_include(spec)
      File.open(spec.interface_include_file, File::CREAT|File::TRUNC|File::RDWR) do |fout|
        gen_interface_include_code(fout, spec)
      end
    end

    def gen_interface_include_header(fout, spec)
      fout << <<~HEREDOC
        /**
         * This file is automatically generated by the WXRuby3 interface generator.
         * Do not alter this file.
         */
                 
        #ifndef __#{spec.module_name.upcase}_H_INCLUDED__
        #define __#{spec.module_name.upcase}_H_INCLUDED__
      HEREDOC
    end

    def gen_interface_include_footer(fout, spec)
      fout << "\n#endif /* __#{spec.module_name.upcase}_H_INCLUDED__ */"
    end

    def gen_interface_include_code(fout, spec)
      gen_interface_include_header(fout, spec)

      gen_typedefs(fout, spec) unless spec.no_gen?(:typedefs)

      gen_interface_classes(fout, spec) unless spec.no_gen?(:classes)

      gen_variables(fout, spec) unless spec.no_gen?(:variables)

      gen_enums(fout, spec) unless spec.no_gen?(:enums)

      gen_defines(fout, spec) unless spec.no_gen?(:defines)

      gen_functions(fout, spec) unless spec.no_gen?(:functions)

      gen_interface_include_footer(fout, spec)
    end

    def run(spec)
      gen_swig_interface_file(spec)

      gen_interface_include(spec)
    end

  end # class ClassGenerator

end # module WXRuby3
