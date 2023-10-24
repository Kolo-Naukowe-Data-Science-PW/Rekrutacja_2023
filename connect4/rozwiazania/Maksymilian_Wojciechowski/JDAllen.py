from abc import ABC
import numpy as np
from connect4.Player import Player


def show_map_mode(position, mask, width, height):
    position_b = str(bin(position ^ mask)[2:])
    mask = str(bin(mask)[2:])
    position_a = str(bin(position)[2:])

    value = 0
    for letter in mask:
        if letter == '1':
            value += 1
    value = value % 2

    table = [[0 for _ in range(width)] for _ in range(height)]

    for i, letter in enumerate(position_a[::-1]):
        if letter == '1':
            if value == 0:
                table[i % (height + 1)][i // width] = 1
            else:
                table[i % (height + 1)][i // width] = 2
    for i, letter in enumerate(position_b[::-1]):
        if letter == '1':
            if value == 0:
                table[i % (height + 1)][i // width] = 2
            else:
                table[i % (height + 1)][i // width] = 1
    for i in range(len(table) - 1, -1, -1):
        print(table[i])
    print('-----------------')


def connect_programing(n):
    x = bin(n)[2:]
    programing = [2 ** i for i in range(1, len(x) - 1)]
    if int(x[1:], 2) > 0:
        programing.append(int(x[1:], 2))
    return programing


class Roy(Player, ABC):
    def __init__(self, board_width: int, board_height: int, length_needed: int, train: bool):
        super().__init__(board_width, board_height, length_needed, train)
        self.board_height = board_height
        self.board_width = board_width
        self.id = 0
        self.programing = connect_programing(length_needed)
        self.search_depth = 2
        self.mask = 0
        self.position = 0

    def is_valid_mode(self, mask, col):
        if mask & 1 << (self.board_height - 1 + col * (self.board_height + 1)):
            return False
        else:
            return True

    def make_move_mode(self, position, mask, col):
        new_position = position ^ mask  # XOR to get other player coins
        new_mask = mask | (mask + (1 << (col * (self.board_height + 1))))  # binary OR
        return new_position, new_mask

    def start_game(self, player_id: int) -> None:
        self.id = player_id

    def to_bitmap_mode(self, board: np.ndarray) -> None:
        position, mask = '', ''
        for j in range(self.board_width - 1, -1, -1):
            mask += '0'
            position += '0'
            for i in range(self.board_height):
                if board[i, j] != 0:
                    mask += '1'
                else:
                    mask += '0'
                if board[i, j] == self.id:
                    position += '1'
                else:
                    position += '0'
        self.position = int(position, 2)
        self.mask = int(mask, 2)

    def connected_four_mode(self, position):
        # Horizontal check mode
        m = position & (position >> (self.board_height + 1))
        for move in self.programing:
            m = m & (m >> (move * (self.board_height + 1)))
        if m:
            return True
        # Diagonal check mode \
        m = position & (position >> self.board_height)
        for move in self.programing:
            m = m & (m >> (move * self.board_height + 1))
        if m:
            return True
        # Diagonal check mode /
        m = position & (position >> (self.board_height + 2))
        for move in self.programing:
            m = m & (m >> (move * (self.board_height + 2)))
        if m:
            return True
        # Vertical check mode
        m = position & (position >> 1)
        for move in self.programing:
            m = m & (m >> move)
        if m:
            return True
        # Nothing found
        return False

    def mini_max_mode(self, position, mask, depth, is_me):

        if depth == 0:
            return 0

        if self.connected_four_mode(position):
            if is_me:
                return depth
            else:
                return -depth
        if self.connected_four_mode(position ^ mask):
            if is_me:
                return depth
            else:
                return -depth

        if not is_me:
            value = -float('inf')
            for i in range(self.board_width):
                if self.is_valid_mode(mask, i):
                    new_position, new_mask = self.make_move_mode(position, mask, i)
                    # show_map_mode(new_position, new_mask, self.board_width, self.board_height)
                    option_i = self.mini_max_mode(new_position, new_mask, depth - 1, not is_me)
                    if option_i > value:
                        value = option_i
        else:
            value = float('inf')
            for i in range(self.board_width):
                if self.is_valid_mode(mask, i):
                    new_position, new_mask = self.make_move_mode(position, mask, i)
                    # show_map_mode(new_position, new_mask, self.board_width, self.board_height)
                    option_i = self.mini_max_mode(new_position, new_mask, depth - 1, not is_me)
                    if option_i < value:
                        value = option_i
        return value

    def get_move(self, board: np.ndarray) -> int:
        self.to_bitmap_mode(board)

        value = -float('inf')
        best_move = 0
        for move in range(self.board_width):
            if self.is_valid_mode(self.mask, move):
                new_position, new_mask = self.make_move_mode(self.position, self.mask, move)
                # show_map_mode(new_position, new_mask, self.board_width, self.board_height)
                option_i = self.mini_max_mode(new_position, new_mask, self.search_depth, True)
                if option_i > value:
                    best_move = move
                    value = option_i

        return best_move

    def evaluate_position(self, board: np.ndarray, player_moving_id: int) -> float:
        pass


if __name__ == '__main__':
    player1 = Roy(8, 6, 4, False)
    player1.start_game(1)
    z = np.array([[0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0],
                  [0, 0, 0, 0, 0, 0, 0, 0],
                  [1, 2, 1, 2, 1, 2, 1, 2]])
    player1.search_depth = 6
    print(player1.get_move(z))
