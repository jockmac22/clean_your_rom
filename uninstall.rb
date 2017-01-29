#!/usr/bin/env ruby
require 'fileutils'

ROOT_PATH       = File.expand_path(File.dirname(__FILE__))
CYR_SCRIPT      = "#{ROOT_PATH}/clean_your_rom.rb"
CYR_BIN_SCRIPT  = "/usr/bin/clean_your_rom"

puts "Uninstalling Clean Your ROM..."

begin
  puts " - Removing script..."
  File.delete(CYR_BIN_SCRIPT) if File.exist?(CYR_BIN_SCRIPT)
  puts "Clean Your Rom successfully uninstalled!"
rescue Exception => e
  puts "\n\n"
  puts "-"*80
  puts "A problem ocurred during the uninstall."
  puts "Error: #{e.message}"
  puts
  puts "Make sure you have Ruby installed and are using the following command:"
  puts "  sudo ruby uninstall.rb"
end
