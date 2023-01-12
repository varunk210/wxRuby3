###
# wxRuby3 wxWidgets interface director
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './event_handler'

module WXRuby3

  class Director

    class App < EvtHandler

      def setup
        spec.items << 'wxAppConsole'
        spec.fold_bases('wxApp' => 'wxAppConsole')
        spec.override_inheritance_chain('wxApp', %w[wxEvtHandler wxObject])
        spec.ignore %w{
          wxApp.ProcessMessage
          wxAppConsole::OnInit
          wxAppConsole::OnExit
          wxAppConsole::OnRun
          wxAppConsole.OnFatalException
          wxAppConsole::OnExceptionInMainLoop
          wxAppConsole::OnUnhandledException
          wxAppConsole::StoreCurrentException
          wxAppConsole::RethrowStoredException
          wxAppConsole::OnEventLoopEnter
          wxAppConsole::OnEventLoopExit
          wxAppConsole::OnCmdLineError
          wxAppConsole::OnCmdLineHelp
          wxAppConsole::OnCmdLineParsed
          wxAppConsole::OnInitCmdLine
          wxAppConsole::MainLoop
          wxAppConsole::GetMainLoop
          wxAppConsole::HandleEvent
          wxAppConsole::ScheduleForDestruction
          wxAppConsole::IsScheduledForDestruction
          wxAppConsole::SetInstance
          wxAppConsole::GetInstance
          wxAppConsole::argc
          wxAppConsole::argv
          wxDECLARE_APP
          wxIMPLEMENT_APP
          wxDISABLE_DEBUG_SUPPORT
          wxTheApp
          wxGetApp
          wxHandleFatalExceptions
          wxInitialize
          wxUninitialize
          wxWakeUpIdle
          wxYield
          wxSafeYield
          wxExit
        }
        if Config.instance.wx_version > '3.1.5'
          spec.ignore 'wxApp::GetGUIInstance'
        end
        unless Config.instance.wx_abi_version >= '3.2.1' || Config.instance.wx_version < '3.2.1'
          spec.ignore 'wxApp::GTKAllowDiagnosticsControl'
        end
        spec.extend_interface('wxApp', 'int main_loop ()')
        spec.extend_interface('wxApp', 'void _wxRuby_Cleanup()')
        spec.ignore [
          'wxEntry(int &,wxChar **)',
          'wxEntry(HINSTANCE,HINSTANCE,char *,int)'
        ]
        spec.no_proxy %w{
          wxRubyApp::GetDisplayMode
          wxRubyApp::GetTopWindow
          wxRubyApp::ProcessEvent
        }
        spec.include %w{
          wx/init.h
          wx/display.h
        }
        spec.gc_never
        spec.rename_class('wxApp', 'wxRubyApp')
        spec.add_swig_code <<~__HEREDOC
          // The App class in wxRuby is actually a custom-written subclass, but it
          // is presented to the user as Wx::App
          %rename(App) wxRubyApp;
          
          // Leave GC type at GC_NEVER but add a custom marker.
          // Prevents the App being destroyed prematurely when Ruby exits down with
          // an exception. Otherwise GC destroys the C++ object, which can still
          // be needed for final WxWidgets events.
          %markfunc wxRubyApp "wxRubyApp::mark_wxRubyApp";
          __HEREDOC
        spec.add_header_code <<~__HEREDOC
          extern void GC_SetWindowDeleted(void*);
          extern "C" void Init_wxRubyStockObjects();
          extern void wxRuby_MarkProtectedEvtHandlerProcs();
          
          class wxRubyApp : public wxApp
          {
          
          public:
          
          
            virtual ~wxRubyApp()
            {
          #ifdef __WXTRACE__
            std::wcout << "~wxRubyApp" << std::endl;
          #endif
              // unlink
              VALUE the_app = rb_const_get(#{spec.package.module_variable}, rb_intern("THE_APP"));
              if (the_app != Qnil) {
                DATA_PTR(the_app) = 0;
              }
            }
          
            // special event handler for destruction of windows which is done
            // automatically by wxWidgets. Tag the object as having been destroyed
            // by WxWidgets.
            void OnWindowDestroy(wxWindowDestroyEvent &event)
            {
              wxObject* wx_obj = event.GetEventObject();
          #ifdef __WXRB_DEBUG__
              std::wcout << "<= OnWindowDestroy [" << wx_obj << "]" << std::endl;
          #endif
              GC_SetWindowDeleted((void *)wx_obj);
              event.Skip();
          #ifdef __WXRB_DEBUG__
              std::wcout << "=> OnWindowDestroy [" << wx_obj << "]" << std::endl;
          #endif
            }
          
            // When ruby's garbage collection runs, if the app is still active, it
            // cycles through all currently known SWIG objects and calls this
            // function on each to preserve still active Wx::Windows, and also
            // pending Wx::Events which have been queued from the Ruby side (the
            // only sort of events that will be in the tracking hash.
            static void markIterate(void* ptr, VALUE rb_obj)
            {
              // Check if it's a valid object (sometimes SWIG doesn't return what we're
              // expecting), a descendant of Wx::Window (but not a Dialog), and if it has not yet been
              // deleted by WxWidgets; if so, mark it.
              if ( TYPE(rb_obj) == T_DATA )
              {
                if ( rb_obj_is_kind_of(rb_obj, wxRuby_GetWindowClass()) )
                {
                  if ( !rb_obj_is_kind_of(rb_obj, wxRuby_GetDialogClass()) )
                    rb_gc_mark(rb_obj);
                }
                else if (rb_obj_is_kind_of(rb_obj, wxRuby_GetDefaultEventClass()) )
                  rb_gc_mark(rb_obj);
              }
              else if (TYPE(rb_obj) == T_ARRAY )
              {
                VALUE proc = rb_ary_entry(rb_obj, 0);
                if (rb_obj_is_kind_of(proc, rb_cProc) || rb_obj_is_kind_of(proc, rb_cMethod))
                {
                  // keep the async call alive
                  rb_gc_mark(rb_obj);
                }
              }
            }
          
            // Implements GC protection across wxRuby. Always called because
            // Wx::THE_APP is a constant so always checked in GC mark phase.
            static void mark_wxRubyApp(void *ptr)
            {
          
          #ifdef __WXRB_DEBUG__
              std::wcout << "=== Starting App GC mark phase" << std::endl;
          #endif
          
              // If the App has ended, the ruby object will have been unlinked from
              // the C++ one; this implies that all Windows have already been destroyed
              // so there is no point trying to mark them, and doing so may cause
              // errors.
              if ( rb_gv_get("__wx_app_ended__" ) == Qtrue )
              {
          #ifdef __WXRB_DEBUG__
                std::wcout << "=== App has ended, skipping mark phase" << std::endl;
          #endif
                return;
              }
          
              // Mark evt handler procs associated with live windows - see
              // classes/EvtHandler.i
              wxRuby_MarkProtectedEvtHandlerProcs();
          
              // To do the main marking, primarily of Windows, iterate over SWIG's
              // list of tracked objects
              wxRuby_IterateTracking(&wxRubyApp::markIterate);
          
          #ifdef __WXRB_DEBUG__
              std::wcout << "=== App GC mark phase completed" << std::endl;
          #endif
            }
          
            // This is the method run when main_loop is called in Ruby
            // wxEntry calls the C++ App::OnInit method
            int main_loop()
            {
              rb_define_const(#{spec.package.module_variable}, "THE_APP", SWIG_RubyInstanceFor(this));
              this->Connect(wxEVT_DESTROY,
                    wxWindowDestroyEventHandler(wxRubyApp::OnWindowDestroy));
          
          #ifdef __WXRB_DEBUG__
              std::wcout << "Calling wxEntry, this=" << this << std::endl;
          #endif
          
          #ifdef __WXMSW__
              extern int wxEntry(HINSTANCE hInstance,
                         HINSTANCE WXUNUSED(hPrevInstance),
                         wxCmdLineArgType WXUNUSED(pCmdLine),
                         int nCmdShow);
              wxEntry(GetModuleHandle("#{spec.package.libname}.#{RbConfig::CONFIG['DLEXT']}"),
                      (HINSTANCE)0,
                      (wxCmdLineArgType)"",
                      (int)true);
          #else
              int argc = 0;
              char** argv = 0;
              wxEntry(argc, argv);
          #endif
          
          #ifdef __WXRB_DEBUG__
              std::wcout << "returned from wxEntry..." << std::endl;
          #endif
              rb_gc_start();
          #ifdef __WXRB_DEBUG__
              std::wcout << "survived gc" << std::endl;
          #endif
              return 0;
            }
          
            // This method initializes the stock objects (Pens, Brushes, Fonts)
            // before yielding to ruby by calling the App's on_init method.
            // Note that as of wxWidget 2.8, the stock fonts in particular cannot
            // be initialized any earlier than this without crashing
            bool OnInit() override
            {
          #ifdef __WXRB_DEBUG__
              std::wcout << "OnInit..." << std::endl;
          #endif
              // set standard App name
              this->SetAppName(wxString("wxruby"));
              // Signal that we're started
              rb_gv_set("__wx_app_ended__", Qfalse);
              // Set up the GDI objects
              Init_wxRubyStockObjects();
              // Get the ruby representation of the App object, and call the
              // ruby on_init method to set up the initial window state
              VALUE the_app = rb_const_get(#{spec.package.module_variable}, rb_intern("THE_APP"));
              VALUE result  = rb_funcall(the_app, rb_intern("on_ruby_init"), 0, 0);
        
              // If on_init return any (ruby) true value, signal to wxWidgets to
              // enter the main event loop by returning true, else return false
              // which will make wxWidgets exit.
              if ( result == Qfalse || result == Qnil )
              {
                rb_gv_set("__wx_app_ended__", Qtrue); // Don't do any more GC
                return false;
              }
              else
              {
                return true;
              }
            }
          
            int OnExit() override
            {
          #ifdef __WXRB_DEBUG__
              std::wcout << "OnExit..." << std::endl;
          #endif

              // Get the ruby representation of the App object, and call the
              // ruby on_exit method (if any) for application level cleanup
              VALUE the_app = rb_const_get(#{spec.package.module_variable}, rb_intern("THE_APP"));
              ID on_exit_id = rb_intern("on_exit");
              if (rb_funcall(the_app, rb_intern("respond_to?"), 1, ID2SYM(on_exit_id)) == Qtrue)
              {
                rb_funcall(the_app, on_exit_id, 0, 0);
              }

              // perform wxRuby cleanup
              _wxRuby_Cleanup();
      
              // execute base wxWidgets functionality 
              return this->wxApp::OnExit();
            }
          
            // actually implemented in ruby in classes/app.rb
            virtual void OnAssertFailure(const wxChar *file, int line, const wxChar *func, const wxChar *cond, const wxChar *msg)
            {
              std::wcout << "ASSERT fired" << std::endl;
            }

            void _wxRuby_Cleanup()
            {
          #ifdef __WXRB_DEBUG__
              std::wcout << "wxRuby_Cleanup..." << std::endl;
          #endif
              // Note in a global variable that the App has ended, so that we
              // can skip any GC marking later
              rb_gv_set("__wx_app_ended__", Qtrue);
      
              wxLog *oldlog = wxLog::SetActiveTarget(new wxLogStderr);
              SetTopWindow(0);
              if ( oldlog )
              {
                delete oldlog;
              }
            }
          };
          __HEREDOC
        super
      end
    end

  end # class Director

end # module WXRuby3
