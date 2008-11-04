#!/usr/bin/env ruby -w

##
# Lots of this modified from http://www.pragmaticautomation.com/cgi-bin/pragauto.cgi/Monitor/StakingOutFileChanges.rdoc
# I got it from a PeepCode screencast...
#
## Can use Ruby's Dir[] to get file glob. Quote your args to take advantage of this.
#
#  training_wheels **/*.rb
#  => Only watches Ruby files one directory down
#
#  training_wheels '**/*.rb'
#  => Watches all Ruby files in all directories and subdirectories

def growl(title, msg, img, pri=0, sticky="")
  system "growlnotify -n autotest --image ~/.autotest_images/#{img} -p #{pri} -m #{msg.inspect} #{title} #{sticky}"
end

def self.growl_fail(output)
  growl "FAIL", "#{output}", "fail.png", 2
end

def self.growl_pass(output)
  growl "Pass", "#{output}", "pass.png"
end

file_patterns_to_watch = (ARGV.length > 0 ? ARGV : ['**/*.rb'])

files = {}

file_patterns_to_watch.each do |arg|
  Dir[arg].each { |file|
    files[file] = File.mtime(file)
  }
end

puts "Watching #{files.keys.join(', ')} [#{files.keys.length}]\n\n"

trap('INT') do
  puts "\nQuitting..."
  exit
end

loop do

  sleep 1

  changed_file, last_changed = files.find { |file, last_changed|
    File.mtime(file) > last_changed
  }

  if changed_file
    files[changed_file] = File.mtime(changed_file)
    puts "=> #{changed_file} changed"
    results = `echo 'Trainig Wheels!!'`
    puts results

    puts "=> done"
  end

end

