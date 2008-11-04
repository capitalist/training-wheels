class AliasMethodChainWheel < TrainingWheels::Wheel
  def initialize
    trigger <<-PATTERN do
      alias_method :some_method, :some_original_method 
    PATTERN
      trigger <<-PATTERN
        alias_method :some_method, :some_original_method 
      PATTERN
    end

    suggest <<-PATTERN
      You called alias_method twice, you might want to consider using:
      alias_method_chain :some_method, :feature
    PATTERN
    
    gist "22239"
  end
end
