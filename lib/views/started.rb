module Cyr
  module Views
    class Started < Cyr::MenuView

      def show options=nil
        # Store the current instance in a context object so it will be available
        # to the internal callbacks in the cli chooser.
        context = self
        context.menu.cli.choose do |m|
          m.header = "\nSelect what you would like to do".light_cyan
          m.prompt = "\nPlease select an option the list:".light_white
          m.select_by = :name
          m.index = :none

          m.choice(build_menu_name("a", "Initialize a directory"))  { context.response = "a" }
          m.choice(build_menu_name("b", "Clean a directory"))       { context.response = "b" }
          m.choice(build_menu_name("!", "Quit"))                    { context.response = "!" }
        end

        # Respond to the choice
        respond_with(options)
      end

    end
  end
end
