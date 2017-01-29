module Cyr
  module Views
    class Quit < Cyr::MenuView

      def show options=nil
        puts "\rQuitting!".light_black
        exit
      end

    end
  end
end
