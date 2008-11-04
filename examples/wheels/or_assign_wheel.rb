class OrAssignWheel < TrainingWheels::Wheel
  def initialize
    trigger <<-PATTERN
      if @my_var.nil?
        @my_var = []
      end
    PATTERN
    
    suggest <<-PATTERN
      Ruby has an ||= operator that only performs the assignment if the variable is nil.
    PATTERN
  end
end