module Cyr
  module Views
    class SelectInitializePath < Cyr::MenuView

      def show options=nil
        puts ""

        # Store the current instance in a context object so it will be available
        # to the internal callbacks in the cli chooser.
        context = self

        self.response = nil
        default_path            = cleanr.base_path
        base_path               = ask_for_path("Enter the path where your ROM duplicates be stored? ", default_path)
        commands                = ["!", "-"]
        cleanr.base_path        = base_path unless commands.include?(base_path)
        response                = base_path

        respond_with(options)
      end

    end
  end
end
