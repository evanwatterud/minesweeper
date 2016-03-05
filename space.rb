class Space
  attr_accessor :mine, :uncovered

  def initialize(mine = false)
    @mine = mine
    @uncovered = false
  end
end
