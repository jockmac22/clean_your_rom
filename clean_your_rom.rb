#!/usr/bin/env ruby
ROOT_PATH = File.expand_path(File.dirname(__FILE__))

require "#{ROOT_PATH}/lib/dependencies"

def run
  menu = Cyr::Menu.new
  menu.run
end

# Primary script execution
run
