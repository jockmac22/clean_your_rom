module Cyr
  module Views
    class EditCompany < Cyr::MenuView

      def show options=nil

        cli.choose do |m|
          m.header = "\nSelect a company".light_cyan
          m.prompt = "\nPlease select a company from the list:".light_white
          m.select_by = :name
          m.index = :none

          indices = [*('a'..'z')]
          view.menu.cleanr.companies.each_with_index do |val, idx|
            m.choice(build_menu_name(indices[idx], val[1])) do
              view.menu.cleanr.company = val[0];
              view.response = indices[idx]
            end
          end

          m.choice(build_menu_name("-", "Back")) { view.response = "-" }
          m.choice(build_menu_name("!", "Quit")) { view.response = "!" }
        end

        respond_with(options)
      end
    end
  end
end
