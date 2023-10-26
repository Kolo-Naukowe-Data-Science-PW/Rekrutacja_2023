import numpy as np
from abc import ABC, abstractmethod

import random
from typing import *


class Player(ABC):
    """
    An abstract class to represent a player. 
    """
    def __init__(self, board_width: int, board_height: int, lenght_needed: int, train: bool) -> None:
        """
        Initialize the player. The board width and height are given, as well as the number of pieces needed to win.
        The train parameter can be ignored when writing algorithms. When train is False and the player is trainable the class should load the model state.
        """
        self.board_width = board_width
        self.board_height = board_height
        self.lenght_needed = lenght_needed        
      
    @abstractmethod
    def start_game(self, player_id: int) -> None:
        """
        Called when a new game starts.
        The player_id is 1 if the player is player 1 and 2 if the player is player 2.
        It is imortant reading the board.
        """
        pass
      
    @abstractmethod
    def get_move(self, board: np.ndarray) -> int:
        """
        Returns the column the player wants to play in (0 based indexing). The move must be a valid move.
        the board is represented as a numpy array of size (board_height, board_width) with 0 for empty, 1 for player 1 and 2 for player 2.
        """
        pass
      
    def end_game(self, result: int) -> None:
        """
        Called when the game is over. The result is 1 if the player won, 0 if it was a draw and -1 if the player lost.
        This method can be used to perform learning and can be ignored when writing algorithms.
        """
        pass
      
    def evaluate_position(self, board: np.ndarray, player_moving_id: int) -> float:
        """
        Evaluate the position of the board. The result should be between -1 and 1. 
        Negative values meaning the player 1 is winning, positive values meaning player 2 is winning.
        """
        return 0
      
    @property
    def flexible(self):
        """
        Return True if the player is flexible (can use any board size and lenght needed to win), False otherwise.
        """
        return False

class AI(Player):
    INF = 999999999

    def __init__(self, board_width: int, board_height: int, lenght_needed: int, train: bool) -> None:
        super().__init__(board_width, board_height, lenght_needed, train)

        self.depth = 4
        
        depth_points = board_height * board_width * lenght_needed

        if depth_points >= 100 * 6*7*4:
            self.depth = 2
        elif depth_points >= 10 * 6*7*4:
            self.depth = 3
    

    def start_game(self, player_id: int) -> None:
        self.player_id = player_id
        self.opponent_id = 3 - player_id

    # Generates list of colums that are not filled yet
    def gen_valid_columns(self, board: np.ndarray) -> List[int]:
        valid_columns = []
        for i in range(self.board_width):
            if board[0, i] == 0:
                valid_columns.append(i)
        return valid_columns
    
    # Check if there are any possible moves left in the game
    def possible_move(self, board: np.ndarray) -> bool:
        for i in range(self.board_width):
            if board[0, i] == 0:
                return True
        return False
    
    # Get the row where a token will be placed
    def get_drop_row(self, board: np.ndarray, col: int) -> int:
        for i in range(self.board_height-1, -1, -1):
            if board[i , col] == 0:
                return i; 
        raise ValueError("Incorrect move - board unchanged")

    # Drop a token in the specified position on the board
    def drop_token(self, board: np.ndarray, pos: Tuple[int, int], player_id: int) -> None:
        board[pos] = player_id

    # Evaluates a window
    def evaluate_window(self, window: List[int]) -> float:
        score = 0
        player_tokens = window.count(self.player_id)
        opponent_tokens = window.count(self.opponent_id)
        empty_places = window.count(0)

        multiplier = 1
        
        for i in range(self.lenght_needed , self.lenght_needed // 3, -1):
            if player_tokens == i and empty_places == self.lenght_needed -i:
                score = 100 * multiplier
                break
            else:
                multiplier *= 0.8   

        multiplier = 1

        for i in range(self.lenght_needed ,  self.lenght_needed // 2, -1):
            if opponent_tokens == i and empty_places == self.lenght_needed - i:
                score = -60 * multiplier
                break
            else:
                multiplier *= 0.5        
    
        return score
        

    def evaluate_board(self, board: np.ndarray) -> int:
        score = 0

        # Proritize centre of board
        centre_column = [int(i) for i in list(board[:, self.board_width // 2])]
        score = centre_column.count(self.player_id) * 3


        # Horizontally
        for r in range(self.board_height):
            row = [int(i) for i in list(board[r, :])]
            for c in range(self.board_width - self.lenght_needed + 1):
                window = row[c: c + self.lenght_needed]
                score += self.evaluate_window(window)

        # Vertically
        for c in range(self.board_width):
            col = [int(i) for i in list(board[:, c])]
            for r in range(self.board_height - self.lenght_needed + 1):
                window = col[r : r + self.lenght_needed]
                score += self.evaluate_window(window)

        # Diagonally (top-left to bottom-right)
        for r in range(self.board_height - self.lenght_needed + 1):
            for c in range(self.board_width - self.lenght_needed + 1):
                window = [board[r+i][c+i] for i in range(self.lenght_needed)]
                score += self.evaluate_window(window)

        # Diagonally (bottom-left to top-right)
        for r in range(self.board_height -1,  self.board_height - self.lenght_needed, -1):
            for c in range(self.board_width - self.lenght_needed + 1):
                window = [board[r-i][c+i] for i in range(self.lenght_needed)]
                score += self.evaluate_window(window)

        return score;

    # 2,1 for winning state, 0  draw, -1 when the game isn't over yet
    def winning_move(self, board, pos: Tuple[int,int]) -> int:
        token_counter = 1
        player_id = board[pos]
        # Check horizontally (left to right)
        for i in range(1, min(self.lenght_needed, self.board_width - pos[1])): #
            if board[pos] == board[pos[0], pos[1] + i]:
                token_counter += 1
            else:
                break
        
        for i in range(1, min(self.lenght_needed, pos[1] + 1) ):
            if board[pos] == board[pos[0], pos[1]-i]:
                token_counter += 1
            else:
                break

        if token_counter >= self.lenght_needed:
            return player_id
        
        # Check vertically (up to down)
        token_counter = 1

        for i in range(1, min(self.lenght_needed, self.board_height - pos[0])): # 
            if board[pos] == board[pos[0]+i, pos[1]]:
                token_counter += 1
            else:
                break
        
        for i in range(1, min(self.lenght_needed, pos[0] + 1) ):
            if board[pos] == board[pos[0]-i, pos[1]]:
                token_counter += 1
            else:
                break

        if token_counter >= self.lenght_needed:
            return player_id
        
        # Check diagonally (upwards, top-left to bottom-right)
        token_counter = 1
        # right side
        for i in range(1, min(self.lenght_needed, min(self.board_width - pos[1], self.board_height - pos[0]) )):
            if board[pos] == board[pos[0] + i, pos[1] + i]:
                token_counter += 1
            else:
                break
        # left side
        for i in range(1, min(self.lenght_needed, min(pos[0], pos[1]) + 1)):
            if board[pos] == board[pos[0] - i, pos[1] - i]:
                token_counter += 1
            else:
                break

        if token_counter >= self.lenght_needed:
            return player_id
        

        # Check diagonally (downwards, bottom-left to top-right)
        token_counter = 1
        # right side
        for i in range(1, min(self.lenght_needed, min(self.board_width - pos[1], pos[0] + 1) )):
            if board[pos] == board[pos[0] - i, pos[1] + i]:
                token_counter += 1
            else:
                break
        # left side
        for i in range(1, min(self.lenght_needed, min(self.board_height - pos[0], pos[1] + 1) )):
            if board[pos] == board[pos[0] + i, pos[1] - i]:
                token_counter += 1
            else:
                break

        if token_counter >= self.lenght_needed:
            return player_id

        # Not possible moves:
        if self.possible_move(board) == False:
            return 0
        
        return -1


    def minimax(self, board, depth, alpha, beta, maximisingPlayer):
        valid_columns = self.gen_valid_columns(board)
        
        if depth == 0:
            return (None, self.evaluate_board(board))
        
        if maximisingPlayer:
            value = -self.INF
            
            column = random.choice(valid_columns)
            for col in valid_columns:
                row = self.get_drop_row(board, col)
                b_copy = board.copy()
                self.drop_token(b_copy, (row, col), self.player_id)
                
                # evaluated for copy_board
                game_status = self.winning_move(b_copy, (row, col))
                if game_status == -1: 
                    new_score = self.minimax(b_copy, depth-1, alpha, beta, False)[1]
                elif game_status >= 1:
                    new_score = self.INF * (self.depth - depth + 1)
                elif game_status == 0:
                    new_score == 0

                if new_score > value:
                    value = new_score
                    column = col
                    alpha = max(alpha, value)
                    if alpha >= beta:
                        break
            return column, value
        # minimising Player   
        else:
            value = self.INF

            column = random.choice(valid_columns)
            for col in valid_columns:
                row = self.get_drop_row(board, col)
                b_copy = board.copy()
                self.drop_token(b_copy, (row, col), self.opponent_id)
                
                game_status = self.winning_move(b_copy, (row, col))
                if game_status == -1: 
                    new_score = self.minimax(b_copy, depth-1, alpha, beta, True)[1]
                elif game_status >= 1:
                    new_score = -self.INF * (self.depth - depth + 1)
                elif game_status == 0:
                    new_score == 0

                if new_score < value:
                    value = new_score
                    column = col
                    beta = min(beta, value)
                    if alpha >= beta:
                        break
            return column, value
            

    # Get the AI move
    def get_move(self, board: np.ndarray) -> int:
        result_col = self.minimax(board, self.depth , -self.INF, self.INF, True)[0]
        if result_col is None:
            raise ValueError("AI couldn't generate valid move")
        return result_col 

    @property
    def flexible(self):
        return True


class Game:
    def __init__(self, board_width: int = 7, board_height: int = 6, lenght_needed: int = 4) -> None:
        self.board_width = board_width
        self.board_height = board_height
        self.lenght_needed = lenght_needed
    
    def correct_move(self, pos_x: int) -> bool:
        if pos_x < 0 or pos_x >= self.board_width or self.board[0, pos_x] != 0:
            return False
        return True
    
    def token_position(self, pos_x: int) -> Tuple[int,int]:
        for i in range(self.board_height-1, -1, -1):
            if self.board[i , pos_x] == 0:
                return (i, pos_x); 
        raise ValueError("Incorrect move - board unchanged")
        
    def make_move(self, pos: Tuple[int,int], player_id: int) -> None:
        self.board[pos] = player_id

    def possible_move(self) -> bool:
        for i in range(0, self.board_width):
            if self.board[0,i] == 0:
                return True
        return False


    def print_board(self) -> None:
            for i in range(0, self.board_width):
                print(f"  {i}", end="")

            print()
            print(self.board)

    def play_game(self) -> None:
        
        self.bot = AI(self.board_width, self.board_height, self.lenght_needed, True)
        self.board = np.zeros( (self.board_height, self.board_width) )
        
        self.user_id = random.randint(1,2)
        self.bot.start_game(3 - self.user_id)

        print(f"Game start - player_id {self.user_id}, bot_id {self.bot.player_id}")

        actual_player_id = 1
        last_move = (-1,-1)

        while True:
            if actual_player_id == self.user_id:
                self.print_board()
                # Getting user input:
                while True:
                    u_input = int(input(f"Enter column nr [0, {self.board_width-1}] to place a token: "))
                    if self.correct_move(u_input):
                        last_move = self.token_position(u_input) 
                        self.make_move(last_move, self.user_id)
                        break

            elif actual_player_id == self.bot.player_id:
                last_move = self.token_position(self.bot.get_move(self.board))
                print(f"Bot has placed token at position: {last_move}")
                self.make_move(last_move, self.bot.player_id)

            actual_player_id = 3 - actual_player_id
            
            end_game = self.bot.winning_move(self.board, last_move)
            
            if end_game >= 0:
                self.print_board()
                if end_game == 0:
                    print("-----> Draw <------")
                elif end_game == self.user_id:
                    print("Victory - Player > AI :)")
                elif end_game == self.bot.player_id:
                    print("Failure - Player < AI :(")
                break

if __name__ == '__main__':
    
    game = Game()
    game.play_game()
