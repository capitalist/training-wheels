require 'spec'

Given /a specific directory$/ do
  @dir = File.dirname(__FILE__) + "/../sample_dir"
end

When /training wheels is run$/ do
  @results = `#{File.dirname(__FILE__) + "/../../bin/training_wheels.rb features/sample_dir/**"}`
end

Then /it should detect files based on a glob argument$/ do
  @results.should == "Parsing features/sample_dir/im_not_ruby.yml, features/sample_dir/so_am_i.rb, features/sample_dir/im_a_ruby_file.rb [3]\n\n"
end
