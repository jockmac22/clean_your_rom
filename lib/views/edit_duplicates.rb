module Cyr
  module Views
    class EditDuplicates < Cyr::MenuView

      def show options=nil
        if cleanr.device.nil?
          puts "A device must be selected first.".light_red
          response = "!"
        else
          puts ""
          default_path            = cleanr.duplicates_path
          duplicates_path         = ask_for_path("Enter the path where your ROM duplicates be stored? ", default_path)
          commands                = ["!", "-"]
          cleanr.duplicates_path  = duplicates_path unless commands.include?(duplicates_path)
          response                = duplicates_path
        end

        respond_with(options)
      end

    end
  end
end
