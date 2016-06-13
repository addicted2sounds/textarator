require_relative '../lcs/lcs'

class Comparator
  attr_reader :origin, :edited

  def initialize(origin, edited)
    @origin = origin
    @edited = edited
  end

  def lcs
    @lcs ||= LCS::NeedlemanWunsch.new(@origin, @edited).result
  end

  def next_lcs_index
    {
        origin: origin.index(lcs[index[:lcs]]),
        edited: edited.index(lcs[index[:lcs]])
    }
  end

  def lcs_start
    @lcs_start ||= {
        origin: origin.index(lcs[0]),
        edited: edited.index(lcs[0])
    }
  end

  def lcs_end
    @lcs_end ||= {
        origin: origin.rindex(lcs[-1]),
        edited: origin.rindex(lcs[-1])
    }
  end

  def index
    @index ||= {
        operation: 0,
        origin: 0,
        edited: 0,
        lcs: 0
    }
  end

  def print
    while index[:origin] < origin.length or index[:edited] < edited.length
      index[:operation] += 1
      puts "#{index[:operation]}\t#{operation_status! index}"
    end
  end

  private
  def operation_status!(index)
    case
      when (index[:origin] < origin.length and (next_lcs_index[:origin].nil? or index[:origin] < next_lcs_index[:origin]))
        case
          when (index[:edited] < edited.length and (next_lcs_index[:edited].nil? or index[:edited] < next_lcs_index[:edited]))
            status = "*\t#{origin[index[:origin]]}|#{edited[index[:edited]]}"
            index[:origin] += 1
            index[:edited] += 1
            status
          when (next_lcs_index[:edited].nil? or index[:edited] >= next_lcs_index[:edited])
            status = "-\t#{origin[index[:origin]]}"
            index[:origin] += 1
            status
        end
      else
        case
          when (next_lcs_index[:edited].nil? or index[:edited] < next_lcs_index[:edited])
            status = "+\t#{edited[index[:edited]]}"
            index[:edited] += 1
            status
          else
            status = "\t#{origin[index[:origin]]}"
            index[:origin] += 1
            index[:edited] += 1
            index[:lcs] += 1
            status
        end
    end
  end
end