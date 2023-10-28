import numpy as np
from Player import *
import random

class MyPlayer(Player):
    def __init__(self, board_width, board_height, length_needed, train):
        super().__init__(board_width, board_height, length_needed, train)

    def start_game(self, player_id):
        self.player_id = player_id

    def get_move(self, board):
        while True:
            try:
                column = int(input(f"Gracz {self.player_id}, wybierz kolumnę (1-{self.board_width}): "))
                if 1 <= column < self.board_width +1 and board[0, column-1] == 0:
                    return column - 1
                else:
                    print("Ta kolumna jest już pełna lub wpisałeś niepoprawną liczbę!")
            except ValueError:
                print("To musi być LICZBA z przedziału 1-7 ")

    def end_game(self, result):
        pass
        

    def evaluate_position(self, board, player_moving_id):
        return 0

    @property
    def flexible(self):
        return False
    
class AI_Player(Player):
    def __init__(self, board_width, board_height, length_needed, train):
        super().__init__(board_width, board_height, length_needed, train)
        self.max_depth = 3

    def start_game(self, player_id):
        self.player_id = player_id

    def get_move(self, board):
    
        best_move, _ = self.minimax(board, self.max_depth, -float('inf'), float('inf'), False)
        return best_move

    def minimax(self, board, depth, alpha, beta, maximizing_player):
        if depth == 0 or self.is_terminal(board):
            return None, self.evaluate_position(board, self.player_id)

        best_move = None
        if maximizing_player:
            max_eval = -float('inf')
            for col in range(self.board_width):
                if self.is_valid_move(col, board):
                    board_copy = np.copy(board)
                    new_board = self.make_move(col, self.player_id, board_copy)
                    _, eval_score = self.minimax(new_board, depth - 1, alpha, beta, False)
                    if eval_score > max_eval:
                        max_eval = eval_score
                        best_move = col
                    alpha = max(alpha, eval_score)
                    if beta <= alpha:
                        break
            return best_move, max_eval
        else:
            min_eval = float('inf')
            for col in range(self.board_width):
                if self.is_valid_move(col, board):
                    board_copy = np.copy(board)
                    new_board = self.make_move(col, 3 - self.player_id, board_copy)
                    _, eval_score = self.minimax(new_board, depth - 1, alpha, beta, True)
                    if eval_score < min_eval:
                        min_eval = eval_score
                        best_move = col
                    beta = min(beta, eval_score)
                    if beta <= alpha:
                        break
            return best_move, min_eval

    def is_terminal(self, board):
        winner = self.check_winner(board)
        if winner != -1:
            return True
        return np.count_nonzero(board) == board.size

    def evaluate_position(self, board, player_moving_id):

        heur = 0
        score = 0
        # ocena pozioma
        for row in range(self.board_height):
            for col in range(self.board_width - 3):
                score += self.evaluate_window(board[row, col:col+4], player_moving_id)

        # ocena pionowa
        for row in range(self.board_height - 3):
            for col in range(self.board_width):
                score += self.evaluate_window(board[row:row+4, col], player_moving_id)

        # ocena po przekątnej (w dwie strony)
        for row in range(self.board_height - 3):
            for col in range(self.board_width - 3):
                window = [board[row+i, col+i] for i in range(4)]
                score += self.evaluate_window(window, player_moving_id)

                window = [board[row+i, col+3-i] for i in range(4)]
                score += self.evaluate_window(window, player_moving_id)
                heur += score
        return heur
    
    def evaluate_window(self, window, player_moving_id):
       
        opponent_id = 3 - player_moving_id
        player_count = np.count_nonzero(window == player_moving_id)
        empty_count = np.count_nonzero(window == 0)
        opponent_count = np.count_nonzero(window == opponent_id)

        if player_count == 4:
            return 100000
        elif player_count == 3 and empty_count == 1:
            return 100
        elif player_count == 2 and empty_count == 2:
            return 1
        elif opponent_count == 3 and empty_count == 1:
            return -100000
        else:
            return 0
    
    #------------------------------------------------

    def is_valid_move(self, column, board):
        return 0 <= column < self.board_width and board[0, column] == 0

    def make_move(self, column, player_id, board):
        for row in range(self.board_height - 1, -1, -1):
            if board[row, column] == 0:
                board[row, column] = player_id
                return board


    def check_winner(self, board):
        # sprawdzanie poziomo
        for row in range(self.board_height):
            for col in range(self.board_width - 3):
                if (
                    board[row, col] == board[row, col + 1] == board[row, col + 2] == board[row, col + 3]
                    and board[row, col] != 0
                ):
                    return board[row, col]

        # sprawdzanie pionowo
        for row in range(self.board_height - 3):
            for col in range(self.board_width):
                if (
                    board[row, col] == board[row + 1, col] == board[row + 2, col] == board[row + 3, col]
                    and board[row, col] != 0
                ):
                    return board[row, col]

        # sprawdzanie przekątnej (góra-lewa do dół-prawa)
        for row in range(self.board_height - 3):
            for col in range(self.board_width - 3):
                if (
                    board[row, col] == board[row + 1, col + 1] == board[row + 2, col + 2] == board[row + 3, col + 3]
                    and board[row, col] != 0
                ):
                    return board[row, col]

        # sprawdzanie przekątnej (prawo-góra do dół-lewa)
        for row in range(self.board_height - 3):
            for col in range(3, self.board_width):
                if (
                    board[row, col] == board[row + 1, col - 1] == board[row + 2, col - 2] == board[row + 3, col - 3]
                    and board[row, col] != 0
                ):
                    return board[row, col]

        return -1  

    
class MyGame:
    def __init__(self, player1, player2, board_width, board_height):
        self.board = np.zeros((board_height, board_width), dtype=np.uint64)  
        self.players = [player1, player2]

    def start(self):
        print("Witaj w grze Connect4!")

    def play_game(self):
        current_player = random.randint(1, 2) #wybieramy losowo gracza
        self.start()
        while True:
            #self.display_board()
            player = self.players[current_player - 1]  
            player.start_game(current_player)
            column = player.get_move(self.board)
            if self.is_valid_move(column):
                self.make_move(column, current_player)
                self.display_board()
                result = self.check_winner()
                if result != -1:
                    self.display_board()
                    self.end_game(result, current_player)
                    break
            current_player = 3 - current_player

    def is_valid_move(self, column):
        return 0 <= column < self.board.shape[1] and self.board[0, column] == 0

    def make_move(self, column, player_id):
        for row in range(self.board.shape[0] - 1, -1, -1):
            if self.board[row, column] == 0:
                self.board[row, column] = player_id
                break

    def check_winner(self):
        for player_id in [1, 2]:
            for row in range(self.board.shape[0]):
                for col in range(self.board.shape[1]):
                    if self.board[row, col] == player_id:
                        if self.check_direction(row, col, player_id, 1, 0):
                            return player_id
                        if self.check_direction(row, col, player_id, 0, 1):
                            return player_id
                        if self.check_direction(row, col, player_id, 1, 1):
                            return player_id
                        if self.check_direction(row, col, player_id, 1, -1):
                            return player_id
        if np.count_nonzero(self.board) == self.board.size:
            return 0  # Remis
        return -1

    def check_direction(self, row, col, player_id, dr, dc):
        for _ in range(self.players[0].lenght_needed - 1):
            row += dr
            col += dc
            if row < 0 or row >= self.board.shape[0] or col < 0 or col >= self.board.shape[1] or self.board[row, col] != player_id:
                return False
        return True

    def display_board(self):
        for row in range(self.board.shape[0]):
            row_str = "|"
            for col in range(self.board.shape[1]):
                cell_value = self.board[row, col]
                if cell_value == 0:
                    row_str += " 0 |"
                else:
                    row_str += f" {int(cell_value)} |"
            print(row_str)
        print(" -" * (2 * self.board.shape[1]))
        print("  " + "   ".join(str(i) for i in range(1,self.board.shape[1]+1)))


    def end_game(self, result, player_id):
        if result == player_id:
            print(f"Gracz {player_id} wygrywa!")
        elif result == 0:
            print("No kurczaki, REMIS!")

if __name__ == "__main__":
    player1 = AI_Player(7, 6, 4, False)
    player2 = MyPlayer(7, 6, 4, False)
    game = MyGame(player1, player2, 7, 6)
    game.play_game()
