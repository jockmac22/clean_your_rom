module Cyr
  module Views
    class InitializePath < Cyr::MenuView

      def show options=nil
        puts ""
        puts "Initializing path: #{cleanr.base_path}".light_cyan
        cleanr.config[:companies].each do |company|
          key     = company[0]
          company = company[1]

          cleanr.config[:companies][key][:devices].each do |device|
            key         = device[0]
            device      = device[1]
            device_path = cleanr.device_path(device)
            if Dir.exists?(device_path)
              puts "Exists:   ".white + device_path.green
            else
              puts "Creating: ".white + device_path.light_green
              Dir.mkdir(device_path)
            end

            ["_source", "_alternates", "_duplicates"].each do |dir|
              sub_path = "#{device_path}/#{dir}"
              if Dir.exists?(sub_path)
                puts "Exists:   ".white + sub_path.green
              else
                puts "Creating: ".white + sub_path.light_green
                Dir.mkdir(sub_path)
              end
            end
          end
        end

        respond_with(options)
      end

    end
  end
end
