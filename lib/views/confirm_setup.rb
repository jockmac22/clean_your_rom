module Cyr
  module Views
    class ConfirmSetup < Cyr::MenuView

      def show options=nil
        response  = nil

        self.cli.choose do |m|
          m.header = "\nPlease confirm the cleaning configuration".light_cyan
          m.prompt = "\nEnter a letter from the list to edit or confirm the settingsg:".light_white
          m.select_by = :name
          m.index = :none

          m.choice(build_menu_name("a", "Company:         ".light_green + view.cleanr.company[:name].light_yellow))     { view.response = "a" }
          m.choice(build_menu_name("b", "Device:          ".light_green + view.cleanr.device[:name].light_yellow))      { view.response = "b" }
          m.choice(build_menu_name("c", "Clean ROMS:      ".light_green + view.cleanr.roms_path.light_yellow))          { view.response = "c" }
          m.choice(build_menu_name("d", "Source ROMS:     ".light_green + view.cleanr.source_path.light_yellow))        { view.response = "d" }
          m.choice(build_menu_name("e", "Alternate ROMS:  ".light_green + view.cleanr.alternates_path.light_yellow))    { view.response = "e" }
          m.choice(build_menu_name("f", "Duplicate ROMS:  ".light_green + view.cleanr.duplicates_path.light_yellow))    { view.response = "f" }
          m.choice(build_menu_name("g", "Include Codes:   ".light_green + view.cleanr.include_codes_str.light_yellow))  { view.response = "g" }
          m.choice(build_menu_name("h", "Exclude Codes:   ".light_green + view.cleanr.exclude_codes_str.light_yellow))  { view.response = "h" }
          m.choice(build_menu_name("#", "Main Menu"))                                                                   { view.response = "#" }
          m.choice(build_menu_name("!", "Quit"))                                                                        { view.response = "!" }
          m.choice(build_menu_name("+", "Confirm and clean the ROMS"))                                                  { view.response = "+" }
        end

        respond_with(options)
      end

    end
  end
end
