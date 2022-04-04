from pprint import pprint
import re
import sys

def detect_win(board, player):
    win_conditions = [
        *(tuple((jj, ii) for ii in range(3)) for jj in range(3)),
        *(tuple((ii, jj) for ii in range(3)) for jj in range(3)),
        tuple((ii, ii) for ii in range(3)),
        tuple((ii, 2-ii) for ii in range(3)),
    ]
    for condition in win_conditions:
        if all(board[x][y] == player for x, y in condition):
            return True
    return False

def moves_remaining(board):
    return any(board[x][y] not in ['x', 'o'] for x in range(3) for y in range(3))

def print_board(board):
    print("-" * 13)
    for ii, row in enumerate(board):
        if ii > 0:
            print("-" * 4 + '+' + "-" * 3 + '+' + "-"*4)
        print("| " + ' | '.join(row) + " |")
    print("-" * 13)

generate_board = lambda: [['_']*3 for _ in range(3)]

def play_game():
    player = 'x'
    board = generate_board()
    move_regex = re.compile(r"(\d) (\d)")

    print("Starting new game")
    while True:
        print_board(board)

        move_valid = False
        while not move_valid:
            move = input(f"{player} make a move> ")
            if match := move_regex.search(move):
                x, y = (int(ii) for ii in match.groups())
                if x >= 0 and x < 3 and y >= 0 and y < 3:
                    if board[x][y] != '_':
                        print(f"{board[x][y]} occupies this space!")
                    else:
                        move_valid = True
                else:
                    print("Move out of range! Both x and y must be >=0 and < 3")
            else:
                print("Invalid move format, Expecting: '<x> <y>'")

        board[x][y] = player

        if detect_win(board, player):
            print(f"Player {player} has won!")
            print_board(board)
            return

        if not moves_remaining(board):
            print("No more moves remaining.  Stalemate!")
            return

        player = 'o' if player == 'x' else 'x'


while True:
    try:
        play_game()
    except KeyboardInterrupt:
        print("Thanks for playing!")
        sys.exit(1)
