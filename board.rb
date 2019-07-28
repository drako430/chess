require_relative 'pieces.rb'
require_relative 'rook.rb'
require_relative 'NullPiece.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require_relative 'knight.rb'
require_relative 'king.rb'
require_relative 'pawn.rb'
require_relative 'display.rb'


class Board 

    attr_accessor :board
    def initialize
        @board = Array.new(8){Array.new(8)}
        self.populate
        Display.new(@board).render
    end

    def inspect
        {}.inspect
    end

    def dup
        board_clone = @board.dup.map do |row|
            row.dup.map do |piece|
                piece.dup
            end
        end

        board_clone.each do |row|
            row.each do |piece|
                piece.board = @board_clone
            end
        end

        board_clone
    end
    
    def find_king_pos(color)
      @board.each_with_index do |row, i|
        row.each_with_index do |piece, i2|
          return [i, i2] if piece.symbol == :K && piece.color == color
        end
      end
    end

    def in_check?(color)
        all_moves = []
        @board.each_with_index do |row, i|
            row.each_with_index do |piece, i2|
            all_moves.concat(piece.moves) if piece.color != color && piece.symbol != :n
            end
        end
        king_pos = self.find_king_pos(color)
        all_moves.include?(king_pos)
    end

    def checkmate?(color)
        self.in_check?(color) && self.valid_moves.length == 0
    end

    def move_piece(start_pos, end_pos)
        a,b = start_pos
        x,y = end_pos
        # debugger

        raise ArgumentError.new "no piece at starting position :)" if self.board[a][b] == nil
        raise ArgumentError.new "this move would leave you in check :)" if @board[a][b].move_into_check?(end_pos)
        raise ArgumentError.new "not a valid move :)" if !@board[a][b].valid_moves.include?(end_pos)
       
        
        self.board[x][y], self.board[a][b] = self.board[a][b], NullPiece.new
        self.board[x][y].pos = end_pos
        "done"
    end

    def move_piece!(start_pos, end_pos)
        a,b = start_pos
        x,y = end_pos

        self.board[x][y], self.board[a][b] = self.board[a][b], NullPiece.new
        self.board[x][y].pos = end_pos
    end
    
    def populate
        @board[0][0] = Rook.new(:w, self, [0, 0])
        @board[0][1] = Knight.new(:w, self, [0, 1])
        @board[0][2] = Bishop.new(:w, self, [0, 2])
        @board[0][3] = Queen.new(:w, self, [0, 3])
        @board[0][4] = King.new(:w, self, [0, 4])
        @board[0][5] = Bishop.new(:w, self, [0, 5])
        @board[0][6] = Knight.new(:w, self, [0, 6])
        @board[0][7] = Rook.new(:w, self, [0, 7])
        @board[1].map!.with_index {|arr, i| Pawn.new(:w, self, [1, i])}

        @board[2].map!.with_index {|arr, i| NullPiece.new}
        @board[3].map!.with_index {|arr, i| NullPiece.new}
        @board[4].map!.with_index {|arr, i| NullPiece.new}
        @board[5].map!.with_index {|arr, i| NullPiece.new}

        @board[6].map!.with_index {|arr, i| Pawn.new(:b, self, [6, i])}
        @board[7][0] = Rook.new(:b, self, [7, 0])
        @board[7][1] = Knight.new(:b, self, [7, 1])
        @board[7][2] = Bishop.new(:b, self, [7, 2])
        @board[7][3] = Queen.new(:b, self, [7, 3])
        @board[7][4] = King.new(:b, self, [7, 4])
        @board[7][5] = Bishop.new(:b, self, [7, 5])
        @board[7][6] = Knight.new(:b, self, [7, 6])
        @board[7][7] = Rook.new(:b, self, [7, 7])
    end

end