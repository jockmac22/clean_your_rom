module Cyr
  module Views
    class CleanRoms < Cyr::MenuView

      def show options=nil
        cleanr.clean
        respond_with(options)
      end

    end
  end
end
