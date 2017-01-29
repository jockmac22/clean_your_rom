module Cyr
  module Views
    class EditIncludes < Cyr::MenuView

      def show options=nil

        codes_view        = :countries
        response    = nil
        alpha       = [*("a".."z")]

        while (!["!","-"].include?(response))
          puts ""
          response = cli.choose do |m|
            if codes_view == :countries
              m.header    = "Set the countries you want to include while cleaning".light_cyan
              m.prompt    = "\nEnter the letter next to the country you want to switch on or off:".light_white
            else
              m.header    = "Set the codes you want to include while cleaning".light_cyan if codes_view == :countries
              m.prompt    = "\nEnter the letter next to the code you want to switch on or off:".light_white
            end

            m.select_by = :name
            m.index     = :none
            idx         = 0
            codes       = (codes_view == :countries ? COUNTRIES : CODES)

            codes.each do |key, settings|
              selected  = cleanr.include_codes.include?(key)
              name      = selected ? settings[:name].light_green : settings[:name].light_black
              m.choice("#{alpha[idx]}" + ") ".light_black +  "#{name}") { toggle_key(key, selected) }
              idx       += 1
            end

            m.choice(">" + ") ".light_black + "Codes".light_green)      { codes_view = :codes } if codes_view == :countries
            m.choice("<" + ") ".light_black + "Countries".light_green)  { codes_view = :countries } if codes_view == :codes
            m.choice("-" + ") ".light_black + "Back".light_green)       { view.response = "-" }
            m.choice("!" + ") ".light_black + "Quit".light_green)       { view.response = "!" }
          end
        end

        respond_with(options)
      end

      def toggle_key key, selected
        selected ? view.cleanr.remove_include_code(key) : view.cleanr.add_include_code(key)
      end

    end
  end
end
