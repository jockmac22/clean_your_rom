# Gems to help with all of this.
require 'active_support'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/hash'
require 'finite_machine'
require 'highline'
require 'colorize'
require 'fileutils'
require 'pathname'

# Debugging
# require 'byebug'
# require 'pry'

# Local files needed to make it all work.
require "#{ROOT_PATH}/lib/cleanr"
require "#{ROOT_PATH}/lib/menu"
require "#{ROOT_PATH}/lib/menu_view"

# Require all of the Views so they are accessible in the code base.
views_path = "#{ROOT_PATH}/lib/views/**/*.rb"
Dir[views_path].each { |file| require file }
