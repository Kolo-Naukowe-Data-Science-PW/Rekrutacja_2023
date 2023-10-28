import numpy as np
import math

def is_winner(board, player, board_height, board_width):
    # Check if the player has won in any direction (horizontal, vertical, diagonal)
    for row in range(board_height):
        for col in range(board_width):
            if check_connect_four(board, player, row, col, 1, 0):
                return True  # Horizontal
            if check_connect_four(board, player, row, col, 0, 1):
                return True  # Vertical
            if check_connect_four(board, player, row, col, 1, 1):
                return True  # Diagonal (bottom-left to top-right)
            if check_connect_four(board, player, row, col, 1, -1):
                return True  # Diagonal (top-left to bottom-right)
    return False

def check_connect_four(board, player, row, col, dr, dc):
    # Check if there are 4 consecutive pieces of the same player in a given direction (dr, dc)
    for i in range(length_needed):
        r = row + i * dr
        c = col + i * dc
        if r < 0 or r >= board_height or c < 0 or c >= board_width or board[r][c] != player:
            return False
    return True

def calculate_score(board, player):
    # Calculate a simple heuristic score based on the number of pieces in rows, columns, and diagonals
    score = 0
    for row in range(board_height):
        for col in range(board_width):
            if board[row][col] == player:
                # Check horizontal, vertical, and diagonal (bottom-left to top-right)
                score += check_score_in_direction(board, player, row, col, 1, 0)
                score += check_score_in_direction(board, player, row, col, 0, 1)
                score += check_score_in_direction(board, player, row, col, 1, 1)
                score += check_score_in_direction(board, player, row, col, 1, -1)
    return score

def check_score_in_direction(self, board, player, row, col, dr, dc):
    # Calculate the score in a given direction (dr, dc)
    score = 0
    for i in range(1, self.length_needed):
        r = row + i * dr
        c = col + i * dc
        if r < 0 or r >= self.board_height or c < 0 or c >= self.board_width:
            return score
        if board[r][c] == player:
            score += 1
        else:
            return score
    return score

class MyPlayer:
    """
    An abstract class to represent a player. 
    """
    def __init__(self, board_width: int, board_height: int, length_needed: int, train: bool) -> None:
        """
        Initialize the player. The board width and height are given, as well as the number of pieces needed to win.
        The train parameter can be ignored when writing algorithms. When train is False and the player is trainable, the class should load the model state.
        """
        self.board_width = board_width
        self.board_height = board_height
        self.length_needed = length_needed
        self.train = train
        self.player_id = None  # The player's ID (1 or 2)
        self.opponent_id = None  # The opponent's ID
        self.model = None  # You can initialize your AI model here
        
    def start_game(self, player_id: int) -> None:
        """
        Called when a new game starts. The player_id is 1 if the player is player 1 and 2 if the player is player 2.
        It is important to read the board.
        """
        self.player_id = player_id
        self.opponent_id = 3 - player_id  # Opponent's ID is the other player (1 if self is 2, and vice versa)

        assert(self.player_id == 1 or self.player_id == 2)

    def get_move(self, board: np.ndarray, bot: False) -> int:
        """
        Returns the column the player wants to play in (0-based indexing). The move must be a valid move.
        The board is represented as a numpy array of size (board_height, board_width) with 0 for empty, 1 for player 1, and 2 for player 2.
        """
        assert(board is not None)
        assert(len(board[0] == self.board_width))
        assert(len(board == self.board_height))
        if bot:
            best_move = self.mcts_move(board, self.player_id, self.opponent_id, simulations=10)
            # assert(type(best_move) is int, f"Type of best move is {type(best_move)}")
            return best_move
        else:
            column = int(input(f"Choose a column (0-6): "))
            assert(type(column) is int)
            return column
        
    def mcts_move(self, board: np.ndarray, player_id: int, opponent_id: int, simulations: int) -> int:
      root = MCTSNode(board, player_id, opponent_id, None, None, self.board_height, self.board_width)

      for _ in range(simulations):
          node = root
          while not node.is_leaf() and node.is_fully_expanded():
              node = node.select_child()

          if not node.is_fully_expanded() and not node.is_terminal():
              node = node.expand()

          if not node.is_terminal():
              result = node.simulate()
          else:
              result = node.value

          node.backpropagate(result)

      best_child = root.best_child()
      return best_child.action

    
    def print_board(self, board: np.ndarray):
        # Print the board with nice formatting
        for row in board:
            print(" ".join(map(str, row)))
        print("")
    
        
    def make_move(self, board, column, player):
        # assert(type(column) is int)
        # Make a copy of the current board and apply the move
        next_board = np.copy(board)
        for row in reversed(range(self.board_height)):
            assert(type(row) is int)
            if next_board[row][column] == 0:
                next_board[row][column] = player
                return next_board


    def evaluate_position(self, board: np.ndarray, player_moving_id: int) -> float:
        """
        Evaluate the position of the board. The result should be between -1 and 1.
        Negative values mean the player 1 is winning, positive values mean player 2 is winning.
        """
        if player_moving_id == self.player_id:
            opponent_id = self.opponent_id
        else:
            opponent_id = self.player_id

        # Check if the player has won
        if self.is_winner(board, player_moving_id):
            return 1.0
        # Check if the opponent has won
        elif self.is_winner(board, opponent_id):
            return -1.0
        # If it's a draw, return 0
        elif np.all(board != 0):
            return 0.0
        else:
            # Calculate a simple heuristic based on the number of pieces in rows, columns, and diagonals
            player_score = self.calculate_score(board, player_moving_id)
            opponent_score = self.calculate_score(board, opponent_id)
            return (player_score - opponent_score) / self.length_needed
      
    @property
    def flexible(self):
        """
        Return True if the player is flexible (can use any board size and lenght needed to win), False otherwise.
        """
        return False

class MCTSNode:
    def __init__(self, state, player_id, opponent_id, action, parent, board_height, board_width):
        self.state = state
        self.player_id = player_id
        self.opponent_id = opponent_id
        self.action = action
        self.parent = parent
        self.children = []
        self.visits = 0
        self.value = 0
        self.board_height = board_height
        self.board_width = board_width

    def is_leaf(self):
        return not self.children

    def is_fully_expanded(self):
        return len(self.children) == len(self.valid_actions())

    def is_terminal(self):
        return is_winner(self.state, self.player_id, self.board_height, self.board_width) or is_winner(self.state, self.opponent_id, self.board_height, self.board_width) or np.all(self.state != 0)

    def valid_actions(self):
        return [col for col in range(self.state.shape[1]) if self.state[0][col] == 0]


    def select_child(self):
        # Implement UCB1 formula to select a child node
        C = 1.0  # Exploration parameter
        return max(self.children, key=lambda child: (child.value / child.visits) + C * math.sqrt(math.log(self.visits) / child.visits))

    def expand(self):
        valid_actions = self.valid_actions()
        action = np.random.choice(valid_actions)
        next_state = self.simulate_action(self.state, action, self.player_id)
        child = MCTSNode(next_state, self.opponent_id, self.player_id, action, self, board_height, board_width)
        self.children.append(child)
        return child

    def simulate_action(self, state, action, player_id):
        next_state = state.copy()
        for row in range(state.shape[0] - 1, -1, -1):
            if next_state[row][action] == 0:
                next_state[row][action] = player_id
                break
        return next_state

    def simulate(self):
        current_player = self.player_id
        state = self.state.copy()
        while not np.all(state != 0):
            valid_actions = self.valid_actions()
            action = np.random.choice(valid_actions)
            state = self.simulate_action(state, action, current_player)
            current_player = 3 - current_player  # Switch players
            if is_winner(self.state, current_player, self.board_height, self.board_width):
                return -1
        return 0

    def backpropagate(self, result):
        self.visits += 1
        self.value += result
        if self.parent:
            self.parent.backpropagate(result)

    def best_child(self):
        return max(self.children, key=lambda child: child.visits)

def run_game(player1, player2, board_width, board_height, bot_vs_bot=False):
    # Initialize the board as an empty numpy array
    board = np.zeros((board_height, board_width), dtype=int)

    # Print the initial empty board
    player1.print_board(board)

    current_player = player1

    bot = bot_vs_bot

    while True:
        # Get the current player's move
        move = current_player.get_move(board, bot)

        # Apply the move to the board
        board = current_player.make_move(board, move, current_player.player_id)

        # Print the updated board
        current_player.print_board(board)

        # Check if the game is over (player wins, draw, or continue)
        if is_winner(board, current_player.player_id, board_height, board_width):
            print(f"Player {current_player.player_id} wins!")
            break
        elif np.all(board != 0):
            print("It's a draw!")
            break

        # Switch to the other player
        current_player = player2 if current_player == player1 else player1

        if bot_vs_bot == False:
            bot = not bot

if __name__ == "__main__":
    board_width = 10
    board_height = 10
    length_needed = 4
    player1 = MyPlayer(board_width=board_width, board_height=board_height, length_needed=length_needed, train=False)
    player2 = MyPlayer(board_width=board_width, board_height=board_height, length_needed=length_needed, train=False)

    player1.start_game(1)
    player2.start_game(2)

    run_game(player1, player2, board_width=board_width, board_height=board_height, bot_vs_bot=False)