#!/usr/bin/env ruby -w

file_patterns_to_parse = (ARGV.length > 0 ? ARGV : ['**/*.rb'])
files = {}
file_patterns_to_parse.each do |arg|
  Dir[arg].each { |file|
    files[file] = File.mtime(file)
  }
end

puts "Parsing #{files.keys.join(', ')} [#{files.keys.length}]\n\n"
