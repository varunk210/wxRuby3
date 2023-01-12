# Copyright 2004-2006 by Kevin Smith
# released under the MIT-style wxruby2 license

require_relative './ext'

# Controller class which creates and manages all windows.
class Wx::App

  # convenience method to retrieve global Wx::App instance
  def self.the_app
    if Wx::const_defined?(:THE_APP) and not $__wx_app_ended__
      Wx::THE_APP
    else
      nil
    end
  end

  # Ruby init callback.
  # Initializes delayed load constants and than calls the user defined 'on_init'
  def on_ruby_init
    Wx.load_delayed_constants
    self.respond_to?(:on_init) ? self.on_init : false
  end
  private :on_ruby_init

  # Make C-ext main_loop method private
  private :main_loop

  # App instance run method.
  # Accepts optional 'on_init' block.
  # The block will be ignored when the (derived) App class
  # already has an 'on_init' method defined.
  def run(&block)
    if block_given?
      if self.respond_to?(:on_init)
        Wx.log_warning("'on_init' block ignored as #{self.class.name} already has an #on_init method defined")
      else
        self.singleton_class.class_eval do
          define_method(:on_init, &block)
        end
      end
    end
    main_loop # run the main loop (which triggers the call to on_init)
  end

  # Convenience class method to create simple apps. Starts an
  # application main_loop, setting up initial windows etc as specified
  # in the passed block.
  # block 
  def self.run(&block)
    app_klass = Class.new(self)
    app_klass.class_eval do
      define_method(:on_init, &block)
    end
    app_klass.new.run
  end


  # This is a class method in Wx, but permit it to be an instance method
  # in wxRuby
  def is_main_loop_running
    Wx::App.is_main_loop_running
  end

  # This method handles failed assertions from within the WxWidgets C++
  # code. These messages are only generated by a DEBUG build of
  # WxRuby. Such messages usually indicate that the API is being used
  # incorrectly; the file/line reference points to the place in the
  # WxWidgets source code where the assertion was made.
  define_method(:on_assert_failure) do | file, line, func, condition, message |
    warn "Wx WARNING: #{message} (#{func}@#{file}:#{line})"
  end

  # For use in development only, of no practical use in production code.
  # This method causes Ruby's garbage collection to run (roughly) at
  # interval +interval+ (seconds) - the default is 1, i.e. every
  # second. This should help ferret out bugs in memory management more
  # quickly.
  def gc_stress(interval = 1)
    # Ruby 1.9 provides this built-in version, but doesn't like the 1.8
    # version at all - results in frequent segfaults.
    if RUBY_VERSION >= "1.9.0"
      GC.stress
    else # Ruby 1.8
      t = Wx::Timer.new(self, 9999)
      evt_timer(9999) { Thread.pass }
      Thread.new { loop { sleep interval; GC.start } }
      t.start(100)
    end
  end
end
