#This file is just here to run the sample wheels against.
class FakeRailsStuff
  def link_to
    "Good ol' fashioned link to"
  end
  
  def link_to_with_tip(*args)
    link_to_without_tip args
  end
  
  alias_method :link_to_without_tip, :link_to
  alias_method :link_to, :link_to_with_tip
  
  def my_array
    @my_array = [] if @my_array.nil?
  end
end