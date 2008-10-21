unless defined?(TRAINING_WHEELS_SPEC_HELPER)
  TRAINING_WHEELS_SPEC_HELPER = true 

  require 'rubygems'
  require 'fileutils'
 
  require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib training_wheels]))
end