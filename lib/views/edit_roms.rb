module Cyr
  module Views
    class EditRoms < Cyr::MenuView

      def show options=nil
        if cleanr.device.nil?
            puts "A device must be selected first.".light_red
            self.response = "!"
        else
          puts ""
          default_path      = cleanr.roms_path
          roms_path         = ask_for_path("Enter the path where your good ROMs be stored? ", default_path)
          commands          = ["!", "-"]
          cleanr.base_path  = roms_path unless commands.include?(roms_path)
          cleanr.roms_path  = roms_path unless commands.include?(roms_path)
          self.response     = roms_path
        end

        respond_with(options)
      end

    end
  end
end
