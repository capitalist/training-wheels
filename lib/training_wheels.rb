require 'rubygems'
require 'parse_tree'
require 'sexp_processor'
require 'unified_ruby'
require 'lib/ruby_extensions'

module TrainingWheels

  # This class parses any files passed in when training wheels is run.
  # It passes off method calls to an instance of the 'bike' which passes them on to the wheels.
  # If a wheel is triggered, it adds a second trigger or delivers a message
  class Processor < SexpProcessor
    include UnifiedRuby
  
    def initialize(files)
      super()
      @files = files
      @bike = Bike.new
      @bike.assemble_wheels
      puts "Running wheels: #{@bike.wheels.collect{|wheel| wheel.class.to_s}.join(', ')}"
      @parse_tree = ParseTree.new
    end
  
    # Parse each file and pass tree off to handle_nodes
    def spin_wheels
      @files.each do |file|
        code = File.read(file)
        sexp = @parse_tree.parse_tree_for_string(code, file)
        # puts sexp.inspect
        handle_nodes(sexp)
      end
    end
    
    # Called recursively for each array in the parse tree, arrays are passed to the bike
    def handle_nodes exp
      exp.each do |node|
        if node.is_a? Array
          @bike.handle_node(node)
          handle_nodes(node)
        end
      end
    end
  end

  class Bike
    attr_accessor :wheels, :new_wheels
    
    def initialize
      @wheels = []
      @new_wheels = []
      Wheel.bike = self
    end
    
    def assemble_wheels
      Dir[File.dirname(__FILE__) + '/../examples/wheels/*.rb'].each do |file| 
        if file.match('.rb$')
           require file
           klass = file.split('/').last.gsub(/(?:^|_)(.)/) { $1.upcase }.gsub(/.rb$/, '')
           @wheels << Kernel.const_get(klass).new
         end
      end
    end
    
    def add_wheel(wheel)
      @new_wheels.push(wheel)
    end
    
    def remove_wheel(wheel)
      @wheels = @wheels.delete_if{|weel| wheel == weel}
    end
    
    # Handle nodes coming from processor, checking trigger patterns against nodes
    def handle_node(exp)
      @wheels.each{ |wheel| wheel.test_node(exp) }
      @wheels = @wheels + @new_wheels
      @new_wheels = []
    end
  end

  class Wheel
    attr_accessor :trigger_pattern, :trigger_block, :suggest_pattern, :gist_id
    superclass_delegating_accessor :bike

    def metaclass
      class << self
        self
      end
    end

    def trigger pattern, &block      
      self.trigger_pattern = process_pattern(pattern).first
      self.trigger_block = block
    end

    def suggest pattern
      self.suggest_pattern = pattern
    end
    
    def gist(gid)
      raise "Just pass the gist ID" unless gid =~ /\d*/
      self.gist_id = gid
    end
      
    
    def process_pattern pattern
      PatternProcessor.new.pattern(pattern)
    end

    def trigger_matched
      unless trigger_block.nil?
        trigger_block.call(self)
        self.bike.add_wheel self.class.new
      else
        run_suggest
        run_gist
        self.bike.remove_wheel(self)
      end
    end

    # Provide the suggestion to the developer.
    # Other means of suggestion, besides STDOUT could be included here.
    #
    # TODO: Add Growl Support
    def run_suggest
        puts suggest_pattern if suggest_pattern
    end
    
    # Open a Gist explaining the Wheel.
    #
    # TODO: Add support for platforms besides the Mac.
    def run_gist
      `open http://gist.github.com/#{gist_id}` if gist_id
    end    
    
    def test_node exp
      # Wow, this pattern matching is super primitive huh. Need a lot of work here to make this useful.
      # TODO: Make pattern matching suck less
      raise "No trigger pattern provided for #{self.class.to_s}!" if trigger_pattern.nil?
      case self.trigger_pattern[0]
      when :fcall
        trigger_matched if exp[0] == :fcall && exp[1] == self.trigger_pattern[1]
      when :if
        trigger_matched if exp[0] == :if && exp[1].last == self.trigger_pattern[1].last
      else
      end
    end
    
  end

  class PatternProcessor < SexpProcessor
    include UnifiedRuby
    
    def initialize
      super
      @pt = ParseTree.new
    end
    
    def pattern(str)
      @pt.parse_tree_for_string(str)
    end
  end
end