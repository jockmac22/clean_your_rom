module Cyr
  class MenuView

    attr_reader :menu, :flow
    attr_accessor :response

    def initialize menu, flow
      @menu = menu
      @response = nil
      @flow = flow
    end

    def show options=nil
      # Define the show behavior for the menu

      respond_with(options)
    end

    # A view context object for use with the highline callbacks.  This ensures
    # that the `self` is available as a property and prevents the inherent
    # change of the meaning of `self` when the context shifts
    protected def view
      self
    end

    protected def respond_with options=nil
      return if options.nil?
      flow_key = ((self.response) and options.has_key?(self.response.to_sym)) ? options[self.response.to_sym] : options["*".to_sym]
      puts "Flow Key: #{flow_key}"
      self.flow.send(flow_key) unless flow_key.nil?
    end

    protected def cleanr
      self.menu.cleanr
    end

    protected def cli
      @cli ||= self.menu.cli
    end

    protected def ask_for_path(question, default_path)
      path = nil
      while not path_exists(path)
        options   = []
        options   << "CR = Default"
        options   << "! = Quit"
        options   << "- = Back"
        question  = question.light_cyan + "[" + options.join(", ").light_yellow + "]\n" +
                      default_path.light_green
        path      = cli.ask(question)
        path      = default_path if path.empty?
        puts "The specified path does not exist!".light_red unless path_exists(path)
      end
      path
    end

    protected def build_menu_name(index, name)
      option = "#{index.to_s}#{")".light_black} #{name.light_green}"
    end

    protected def path_exists path, bail_outs=["!","-"]
      # The path exists if it's not nil and not empty and is one of the bail out values or actually exists
      return (path.present? && (bail_outs.include?(path) || Dir.exists?(path)))
    end

  end
end
