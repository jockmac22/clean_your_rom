module Cyr
  module Views
    class EditSource < Cyr::MenuView

      def show options=nil
        if cleanr.device.nil?
          puts "A device must be selected first.".light_red
          response = "!"
        else
          puts ""
          default_path        = cleanr.source_path
          source_path         = ask_for_path("Enter the path where your ROM sources are located? ", default_path)
          commands            = ["!", "-"]
          cleanr.source_path  = source_path unless commands.include?(source_path)
          response            = source_path
        end

        respond_with(options)
      end

    end
  end
end
