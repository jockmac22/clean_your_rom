module Cyr
  module Views
    class EditAlternates < Cyr::MenuView

      def show options=nil
        if cleanr.device.nil?
          puts "A device must be selected first.".light_red
          response = "!"
        else
          puts ""
          default_path            = cleanr.alternates_path
          alternates_path         = ask_for_path("Enter the path where your ROM alternates will be stored? ", default_path)
          commands                = ["!", "-"]
          cleanr.alternates_path  = alternates_path unless commands.include?(alternates_path)
          response                = alternates_path
        end

        respond_with(options)
      end

    end
  end
end
