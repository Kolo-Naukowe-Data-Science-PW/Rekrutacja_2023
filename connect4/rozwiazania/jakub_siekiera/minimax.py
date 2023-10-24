import numpy as np

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
            best_move, _ = self.minimax(board, self.player_id, 4, float("-inf"), float("+inf"))
            assert(type(best_move) is int)
            return best_move
        else:
            column = int(input(f"Choose a column (0-6): "))
            assert(type(column) is int)
            return column


    
    def print_board(self, board: np.ndarray):
        # Print the board with nice formatting
        for row in board:
            print(" ".join(map(str, row)))
        print("")

    
    def minimax(self, board, player, depth, alpha, beta):
        # Base case: If the game is over or max depth is reached, evaluate the position
        if depth == 0:
            return None, self.evaluate_position(board, self.player_id)

        # Find all legal moves (non-full columns)
        legal_moves = [col for col in range(self.board_width) if 0 in board[:, col]]

        if player == self.player_id:
            # Maximize the score
            best_column = None
            best_value = -float('inf')
            for move in legal_moves:
                next_board = self.make_move(board, move, player)
                assert len(next_board) == self.board_height
                assert len(next_board[0]) == self.board_width

                _, value = self.minimax(next_board, self.opponent_id, depth - 1, alpha, beta)

                if value > best_value:
                    best_value = value
                    best_column = move

                alpha = max(alpha, best_value)

                if beta <= alpha:
                    break

            return best_column, best_value
        else:
            # Minimize the score
            best_column = None
            best_value = float('inf')
            for move in legal_moves:
                next_board = self.make_move(board, move, player)
                assert len(next_board) == self.board_height
                assert len(next_board[0]) == self.board_width

                _, value = self.minimax(next_board, self.player_id, depth - 1, alpha, beta)

                if value < best_value:
                    best_value = value
                    best_column = move

                beta = min(beta, best_value)

                if beta <= alpha:
                    break

            return best_column, best_value

        
    def make_move(self, board, column, player):
        assert(type(column) is int)
        # Make a copy of the current board and apply the move
        next_board = np.copy(board)
        for row in reversed(range(self.board_height)):
            assert(type(row) is int)
            if next_board[row][column] == 0:
                next_board[row][column] = player
                return next_board
      
    def end_game(self, result: int) -> None:
        """
        Called when the game is over. The result is 1 if the player won, 0 if it was a draw, and -1 if the player lost.
        This method can be used to perform learning and can be ignored when writing algorithms.
        """
        if self.train:
            # If the player is trainable, you can perform learning updates here based on the game result.
            if result == 1:
                # Your learning update code for a win
                pass
            elif result == -1:
                # Your learning update code for a loss
                pass
            else:
                # Your learning update code for a draw
                pass


    # def evaluate_position(self, board: np.ndarray, player_moving_id: int) -> float:
    #     """
    #     Evaluate the position of the board. The result should be between -1 and 1.
    #     Negative values mean the player 1 is winning, positive values mean player 2 is winning.
    #     """
    #     if player_moving_id == self.player_id:
    #         opponent_id = self.opponent_id
    #     else:
    #         opponent_id = self.player_id

    #     # Check if the player has won
    #     if self.is_winner(board, player_moving_id):
    #         return 1.0
    #     # Check if the opponent has won
    #     elif self.is_winner(board, opponent_id):
    #         return -1.0
    #     # If it's a draw, return 0
    #     elif np.all(board != 0):
    #         return 0.0
    #     else:
    #         # Calculate a simple heuristic based on the number of pieces in rows, columns, and diagonals
    #         player_score = self.calculate_score(board, player_moving_id)
    #         opponent_score = self.calculate_score(board, opponent_id)
    #         return (player_score - opponent_score) / self.length_needed
    def calculate_connected(self, board: np.ndarray, player_id: int) -> int:
        connected_count = 0

        for row in range(self.board_height):
            for col in range(self.board_width):
                if board[row][col] == player_id:
                    # Check horizontal, vertical, and diagonal (bottom-left to top-right) directions
                    if self.check_connected(board, player_id, row, col, 1, 0):
                        connected_count += 1
                    if self.check_connected(board, player_id, row, col, 0, 1):
                        connected_count += 1
                    if self.check_connected(board, player_id, row, col, 1, 1):
                        connected_count += 1
                    if self.check_connected(board, player_id, row, col, 1, -1):
                        connected_count += 1

        return connected_count

    def calculate_threats(self, board: np.ndarray, player_id: int) -> int:
        threats = 0

        for row in range(self.board_height):
            for col in range(self.board_width):
                if board[row][col] == 0:
                    # If the cell is empty, check if placing a disc here creates a threat
                    if self.check_threat(board, player_id, row, col):
                        threats += 1

        return threats

    def calculate_winning_opportunities(self, board: np.ndarray, player_id: int) -> int:
        opportunities = 0

        for col in range(self.board_width):
            # Check if placing a disc in this column creates a winning opportunity
            if self.is_winning_opportunity(board, player_id, col):
                opportunities += 1

        return opportunities

    def check_connected(self, board, player, row, col, dr, dc):
        # Check if there are 4 consecutive pieces of the same player in a given direction (dr, dc)
        for i in range(self.length_needed):
            r = row + i * dr
            c = col + i * dc
            if r < 0 or r >= self.board_height or c < 0 or c >= self.board_width or board[r][c] != player:
                return False
        return True

    def check_threat(self, board: np.ndarray, player_id: int, row: int, col: int) -> bool:
        # Check if placing a disc in this cell creates a threat (i.e., the opponent would have a chance to win on the next move)
        # We simulate the placement and check if the opponent can win
        board_copy = np.copy(board)
        board_copy[row][col] = player_id
        return self.is_winner(board_copy, self.opponent_id)

    def is_winning_opportunity(self, board: np.ndarray, player_id: int, col: int) -> bool:
        # Check if placing a disc in this column creates a winning opportunity for the player
        if 0 in board[:, col]:
            row = np.where(board[:, col] == 0)[0][-1]  # Find the lowest empty row in the column
            board_copy = np.copy(board)
            board_copy[row][col] = player_id
            return self.is_winner(board_copy, player_id)
        return False


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
        if self.is_winner(board, opponent_id):
            return -1.0

        # Calculate the player's advantage based on the number of connected discs
        player_connected = self.calculate_connected(board, player_moving_id)
        opponent_connected = self.calculate_connected(board, opponent_id)

        # Calculate the potential threats for the player and opponent
        player_threats = self.calculate_threats(board, player_moving_id)
        opponent_threats = self.calculate_threats(board, opponent_id)

        # Calculate the number of opportunities for the player and opponent to win
        player_winning_opportunities = self.calculate_winning_opportunities(board, player_moving_id)
        opponent_winning_opportunities = self.calculate_winning_opportunities(board, opponent_id)

        # Calculate the advantage based on the above factors
        advantage = (
            (player_connected - opponent_connected) +
            (player_threats - opponent_threats) +
            (player_winning_opportunities - opponent_winning_opportunities)
        )

        return advantage / self.length_needed


    def is_winner(self, board, player):
        # Check if the player has won in any direction (horizontal, vertical, diagonal)
        for row in range(self.board_height):
            for col in range(self.board_width):
                if self.check_connected(board, player, row, col, 1, 0):
                    return True  # Horizontal
                if self.check_connected(board, player, row, col, 0, 1):
                    return True  # Vertical
                if self.check_connected(board, player, row, col, 1, 1):
                    return True  # Diagonal (bottom-left to top-right)
                if self.check_connected(board, player, row, col, 1, -1):
                    return True  # Diagonal (top-left to bottom-right)
        return False

    def calculate_score(self, board, player):
        # Calculate a simple heuristic score based on the number of pieces in rows, columns, and diagonals
        score = 0
        for row in range(self.board_height):
            for col in range(self.board_width):
                if board[row][col] == player:
                    # Check horizontal, vertical, and diagonal (bottom-left to top-right)
                    score += self.check_score_in_direction(board, player, row, col, 1, 0)
                    score += self.check_score_in_direction(board, player, row, col, 0, 1)
                    score += self.check_score_in_direction(board, player, row, col, 1, 1)
                    score += self.check_score_in_direction(board, player, row, col, 1, -1)
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
      
    @property
    def flexible(self):
        """
        Return True if the player is flexible (can use any board size and lenght needed to win), False otherwise.
        """
        return False


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
        if current_player.is_winner(board, current_player.player_id):
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
    board_width = 5
    board_height = 5
    length_needed = 4
    player1 = MyPlayer(board_width=board_width, board_height=board_height, length_needed=length_needed, train=False)
    player2 = MyPlayer(board_width=board_width, board_height=board_height, length_needed=length_needed, train=False)

    player1.start_game(1)
    player2.start_game(2)

    run_game(player1, player2, board_width=board_width, board_height=board_height, bot_vs_bot=False)