module Cyr
  module Views
    class Intro < Cyr::MenuView

      def show options=nil
        puts ""
        puts ""
        puts "Clean Your ROM v#{Cyr::VERSION}".light_white
        puts ("-"*80).light_blue

        respond_with(options)
      end

    end
  end
end
