module LCS
  class NeedlemanWunsch
    # Needleman-Wunsch Algorithm
    def initialize(a, b)
      @a = a
      @b = b
    end

    def matrix
      return @matrix if @matrix
      @matrix = []
      (0..@a.length-1).each do |row|
        @matrix[row] = []
        (0..@b.length-1).each do |col|
          @matrix[row][col] = if @a[row].eql? @b[col]
                                cell_value(row - 1,col - 1) + 1
                              else
                                cell1 = cell_value(row, col-1)
                                cell2 = cell_value(row-1, col)
                                [cell1, cell2].max
                              end
        end
      end
      @matrix
    end

    def result
      @lcs = []
      x, y = @a.length-1, @b.length-1
      while x >= 0 and y >= 0 do
        if @a[x].eql? @b[y]
          @lcs.push @a[x]
          x, y = x - 1, y - 1
        else
          if matrix[x - 1][y] > matrix[x][y - 1]
            x = x - 1
          else
            y = y - 1
          end
        end
      end
      @lcs.reverse
    end

    private

    def cell_value(x, y)
      (x < 0 or y < 0) ? 0 : @matrix[x][y]
    end
  end
end