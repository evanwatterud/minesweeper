require_relative "space"

class Minefield
  attr_reader :row_count, :column_count

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count
    @field = Array.new(row_count) { Array.new(column_count) }
    row_count.times do |row|
      column_count.times do |col|
        @field[row][col] = Space.new
      end
    end
    mine_count.times do
      while true
        rand_row = rand(0...row_count)
        rand_col = rand(0...column_count)
        unless @field[rand_row][rand_col].mine
          @field[rand_row][rand_col].mine = true
          break
        end
      end
    end
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    if @field[row][col].uncovered
      return true
    end
    false
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    @field[row][col].uncovered = true
    if adjacent_mines(row, col) == 0
      clear(row+1, col) if row+1 <= row_count-1 && !@field[row+1][col].uncovered
      clear(row-1, col) if row-1 >= 0 && !@field[row-1][col].uncovered
      clear(row, col+1) if col+1 <= column_count-1 && !@field[row][col+1].uncovered
      clear(row, col-1) if col-1 >= 0 && !@field[row][col-1].uncovered
    end
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    row_count.times do |row|
      column_count.times do |col|
        return true if @field[row][col].mine && @field[row][col].uncovered
      end
    end
    false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    row_count.times do |row|
      column_count.times do |col|
        return false if !cell_cleared?(row, col) && !contains_mine?(row, col)
      end
    end
    true
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    adjacent = 0
    if row+1 <= row_count-1
      adjacent += 1 if @field[row+1][col].mine
      if col+1 <= column_count-1
        adjacent += 1 if @field[row+1][col+1].mine
      end
    end

    if row-1 >= 0
      adjacent += 1 if @field[row-1][col].mine
      if col-1 >= 0
        adjacent += 1 if @field[row-1][col-1].mine
      end
    end

    if col+1 <= column_count-1
      adjacent += 1 if @field[row][col+1].mine
      if row-1 >= 0
        adjacent += 1 if @field[row-1][col+1].mine
      end
    end

    if col-1 >= 0
      adjacent += 1 if @field[row][col-1].mine
      if row+1 <= row_count-1
        adjacent += 1 if @field[row+1][col-1].mine
      end
    end
    adjacent
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    if @field[row][col].mine
      return true
    end
    false
  end
end
