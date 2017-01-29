#!/usr/bin/env ruby
require 'fileutils'

ROOT_PATH       = File.expand_path(File.dirname(__FILE__))
CYR_SCRIPT      = "#{ROOT_PATH}/clean_your_rom.rb"
CYR_BIN_SCRIPT  = "/usr/bin/clean_your_rom"

puts "Installing Clean Your ROM..."

begin
  puts " - Installing dependencies..."
  `bundle install`

  puts " - Generating script..."
  File.delete(CYR_BIN_SCRIPT) if File.exist?(CYR_BIN_SCRIPT)
  File.open(CYR_BIN_SCRIPT, "w+") do |script|
    script.write("#! /bin/bash\n")
    script.write("ruby #{CYR_SCRIPT}\n")
  end

  puts " - Making scripts executable..."
  FileUtils.chmod "u=wrx,go=rx", CYR_SCRIPT
  FileUtils.chmod "u=wrx,go=rx", CYR_BIN_SCRIPT

  puts "Clean Your Rom successfully installed!"
rescue Exception => e
  puts "\n\n"
  puts "-"*80
  puts "A problem ocurred during the install."
  puts "Error: #{e.message}"
  puts
  puts "Make sure you have Ruby installed and are using the following command:"
  puts "  sudo ruby install.rb"
end
