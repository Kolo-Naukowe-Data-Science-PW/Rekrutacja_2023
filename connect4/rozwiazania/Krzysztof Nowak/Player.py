import numpy as np
from abc import ABC, abstractmethod

class Player(ABC):
    """
    An abstract class to represent a player. 
    """
    def __init__(self, board_width: int, board_height: int, lenght_needed: int, train: bool) -> None:
        self.board_width = board_width
        self.board_height = board_height
        self.lenght_needed = lenght_needed
        self.train = train
        self.player_id = None
        """
        Initialize the player. The board width and height are given, as well as the number of pieces needed to win.
        The train parameter can be ignored when writing algorithms. When train is False and the player is trainable the class should load the model state.
        """
        pass
      
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
