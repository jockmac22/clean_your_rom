module Cyr
  class Menu

    STATE_QUITTING = :quitting

    def initialize

    end

    def flow
      @flow ||= FiniteMachine.define do
        initial       :intro

        events {
          # Starting point
          event :start,                   :any                            => :started

          # Initialize workflow
          event :select_initialize_path,  :started                        => :select_initialize_path
          event :initialize_path,         :select_initialize_path         => :initialize_path

          # Clean workflow (Step-by-step)
          event :select_company,          [ :started,
                                            :select_device ]              => :select_company
          event :select_device,           [ :select_company,
                                            :select_roms ]                => :select_device
          event :select_roms,             [ :select_device,
                                            :confirm_setup ]              => :select_roms
          event :confirm_setup,           :any                            => :confirm_setup
          event :clean_roms,              :confirm_setup                  => :clean_roms

          # Clean workflow (Edit)
          event :edit_company,            :confirm                        => :edit_company
          event :edit_device,             [ :confirm_setup,
                                            :edit_company ]               => :edit_device
          event :edit_source,             :confirm_setup                  => :edit_source
          event :edit_alternates,         :confirm_setup                  => :edit_alternates
          event :edit_duplicates,         :confirm_setup                  => :edit_duplicates
          event :edit_roms,               :confirm_setup                  => :edit_roms
          event :edit_includes,           :confirm_setup                  => :edit_includes
          event :edit_excludes,           :confirm_setup                  => :edit_excludes

          # Exit the process
          event :quit,                    :any                            => :stopped
        }
      end
    end

    # Main execution loop.
    def run

      # Since all of the edit options in the ConfirmSetup view have the same
      # flow, we set them up in their own hash so they can be referenced more
      # easily in the menu_flow hash.
      edit_flow = {
        "!": :quit,
        "*": :confirm_setup
      }

      while (flow.current != :stopped) do

        # Establish the menu workflow by setting up options that direct the
        # options a user enters to the appropriate finite state.  This is a
        # hash whose keys match the states established by the flow (Finite
        # Machine) object.
        menu_flow = {
          intro: { "*": :start },

          started: {
            "a": :select_initialize_path,
            "b": :select_company,
            "!": :quit
          },

          select_initialize_path: {
            "-": :start,
            "!": :quit,
            "*": :initialize_path
          },

          initialize_path: {
            "*": :start
          },

          select_company: {
            "-": :start,
            "!": :quit,
            "*": :select_device
          },

          select_device: {
            "-": :select_company,
            "!": :quit,
            "*": :select_roms
          },

          select_roms: {
            "-": :select_device,
            "!": :quit,
            "*": :confirm_setup
          },

          confirm_setup: {
            "a": :edit_company,
            "b": :edit_device,
            "c": :edit_roms,
            "d": :edit_source,
            "e": :edit_alternates,
            "f": :edit_duplicates,
            "g": :edit_includes,
            "h": :edit_excludes,
            "#": :start,
            "!": :quit,
            "+": :clean_roms
          },

          edit_company: {
            "!": :quit,
            "*": :edit_device
          },

          edit_device: edit_flow,
          edit_source: edit_flow,
          edit_alternate: edit_flow,
          edit_duplicates: edit_flow,
          edit_roms: edit_flow,
          edit_includes: edit_flow,
          edit_exclude: edit_flow,
          clean_roms: { "*": :quit }
        }

        # Take the current state from the flow and show it's associated view,
        # passing in the appropriate option responses from the menu_flow.
        previous_view ||= nil

        if previous_view != flow.current
          previous_view = flow.current
          puts "Flow Current: #{flow.current}"
        end

        show_view(flow.current, menu_flow[flow.current]) if flow.current != :none
      end

      show_view(:quit)
    rescue Interrupt
      show_view(:quit)
    end

    def cli
      @cli ||= HighLine.new
    end

    def cleanr
      if @cleanr.nil?
        @cleanr = Cyr::Cleanr.new()
        @cleanr.add_exclude_codes(ALL_CODES.keys)
        @cleanr.add_include_codes([:us,:ver])
        @cleanr.skip_codes([:ntsc])
      end

      @cleanr
    end

    def views
      if @views.nil?
        @views = {}
        Dir["#{ROOT_PATH}/lib/views/**/*.rb"].each do |view_file|
          name        = Pathname.new(view_file).basename.to_s.gsub(".rb", "")
          view_class  = "Cyr::Views::#{name.camelcase}".constantize
          @views[name.to_sym] = view_class.new(self, self.flow)
        end
      end

      @views
    end

    def show_view key, options=nil
      self.views[key].show(options)
    rescue Exception => e
      puts "Key: #{key}"
      raise
    end
  end
end
