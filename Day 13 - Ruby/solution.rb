file_name = "./input.txt"
board_size = 1500 # Must be greater than the highest number in file
print_debug = false

def print_board(board)
  board.each do |row|
    puts row.join("")
  end
end

def read_points_to_board(lines, board)
  lines.each do |line|
    if match = line.match(/(^\d+),(\d+).*/i)
      x, y = match.captures
      board[y.to_i][x.to_i] = "#"
    end
  end
end

class Fold
  attr_reader :direction, :line

  def initialize(direction, line)
    @direction = direction
    @line = line.to_i
  end

  def to_s
    "Fold along axis #@direction on line #@line"
  end
end

def print_folds(folds)
  folds.each do |fold|
    puts fold
  end
end

def read_folds(lines, folds)
  i = 0
  lines.each do |line|
    if match = line.match(/^fold along (y|x)=(\d+).*/i)
      type, line = match.captures
      folds[i] = Fold.new(type, line)
      i += 1
    end
  end
end

def fold_up(board, line)
  if $print_debug
    puts "Folding up at line #{line}"
  end

  (line..board.length()-1).each do |y|
    row = board[y]
    y_assgn = 2*line - y
    (0..row.length()-1).each do |x|
      if board[y][x].eql? "#"
        board[y_assgn][x] = "#"
      end
    end
  end

  until board.length() == line do
    board.pop()
  end
end

def fold_left(board, line)
  if $print_debug
    puts "Folding left at line #{line}"
  end

  (0..board.length()-1).each do |y|
    row = board[y]

    (line..row.length()-1).each do |x|
      if board[y][x].eql? "#"
        x_assgn = 2*line - x
        board[y][x_assgn] = "#"
      end
    end

    until row.length() == line do
        row.pop()
      end

  end

end

def fold(board, fold)
  if($print_debug)
    puts ""
  end

  if fold.direction.eql? "y"
    fold_up(board, fold.line)
  else
    fold_left(board, fold.line)
  end

  if($print_debug)
    print_board(board)
  end
end

def count_dots(board)
  sum = 0
  board.each do |row|
    row.each do |n|
      if n.eql? "#"
        sum += 1
      end
    end
  end
  return sum
end

if __FILE__ == $0
  board = Array.new(board_size) {Array.new(board_size) {' '}}
  lines = File.readlines(file_name)
  folds = Array.new(1) {nil}

  read_points_to_board(lines, board)
  read_folds(lines, folds)

  if $print_debug
    print_board(board)
    print_folds(folds)
  end

  fold(board, folds[0])
  puts "Part 1: #{count_dots(board)}"

  (1..folds.length()-1).each do |i|
    fold(board, folds[i])
  end

  puts ""
  puts "Part 2:"
  print_board(board)
end
