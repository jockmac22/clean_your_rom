module Cyr
  module Views
    class EditDevice < Cyr::MenuView

      def show options=nil
        if self.menu.cleanr.company.nil?
          puts "A company must be selected first.".light_red
          self.response = "!"
        else

          cli.choose do |m|
            m.header = "\nSelect a system".light_cyan
            m.prompt = "\nPlease select a system from the list:".light_white
            m.select_by = :name
            m.index = :none

            idx = 0
            indices = [*('a'..'z')]
            view.cleanr.company[:devices].each do |key, sys|
              m.choice(build_menu_name(indices[idx], sys[:name])) do
                view.cleanr.device = key
                view.response = indices[idx]
              end
              idx += 1
            end

            m.choice(build_menu_name("-", "Back")) { view.response = "-" }
            m.choice(build_menu_name("!", "Quit")) { view.response = "!" }
          end
        end

        respond_with(options)
      end

    end
  end
end
