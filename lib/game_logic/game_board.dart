import 'package:chess/game_logic/functions.dart';
import 'package:chess/game_logic/pieces.dart';
import 'package:chess/game_logic/squares.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;
  ChessPiece? selectedPiece;

  bool whitePlayer = true;
  bool isWhiteCheck = false;
  bool isBlackCheck = false;

  List<int> whiteKing = [7, 4];
  List<int> blackKing = [0, 4];
  bool isCheck = false;

  int selectedRow = -1;
  int selectedColumn = -1;

  List<List<int>> validMoves = [];
  List<List<int>> captureAbleMove = [];

  List<ChessPiece> whiteCapturedPieces = [];
  List<ChessPiece> blackCapturedPieces = [];

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  bool doesThisPositionGivesCheck() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null) continue;
        if (board[i][j]!.isWhite == selectedPiece!.isWhite) continue;
        if (board[i][j]!.isWhite != selectedPiece!.isWhite) {
          List<List<int>> moves = vilidMovesHelper(i, j, board[i][j]);
          if (moves.any((move) => move[0] == (selectedPiece!.isWhite ? whiteKing[0] : blackKing[0]) &&
                                 move[1] == (selectedPiece!.isWhite ? whiteKing[1] : blackKing[1]))) {
            return true;
          }
        }
      }
    }
    return false;
  }

  List<List<int>> vilidMovesHelper(int row,int column,ChessPiece? piece){
    List<List<int>> moves = [];

    if (piece == null) {
      return moves;
    }

    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        if (isInBoard(row + direction, column) &&
            board[row + direction][column] == null) {
          moves.add([row + direction, column]);
        }

        if ((row == 1 && !piece.isWhite || row == 6 && piece.isWhite) &&
            board[row + 2 * direction][column] == null &&
            board[row + direction][column] == null) {
          moves.add([row + 2 * direction, column]);
        }

        if (isInBoard(row + direction, column - 1) &&
            board[row + direction][column - 1] != null &&
            board[row + direction][column - 1]!.isWhite != piece.isWhite) {
          moves.add([row + direction, column - 1]);
        }

        if (isInBoard(row + direction, column + 1) &&
            board[row + direction][column + 1] != null &&
            board[row + direction][column + 1]!.isWhite != piece.isWhite) {
          moves.add([row + direction, column + 1]);
        }

        break;
      case ChessPieceType.rook:
        List<List<int>> directions = [
          [0, 1],
          [1, 0],
          [0, -1],
          [-1, 0]
        ];

        for (var direction in directions) {
          int i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite == piece.isWhite) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite != piece.isWhite) {
              moves.add([newRow, newColumn]);
              break;
            }
            moves.add([newRow, newColumn]);
            i++;
          }
        }

        break;
      case ChessPieceType.bishop:
        List<List<int>> directions = [
          [1, 1],
          [1, -1],
          [-1, -1],
          [-1, 1]
        ];

        for (var direction in directions) {
          int i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite == piece.isWhite) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite != piece.isWhite) {
              moves.add([newRow, newColumn]);
              break;
            }
            moves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        List<List<int>> potentialMoves = [
          [row + 2, column + 1],
          [row + 2, column - 1],
          [row - 2, column + 1],
          [row - 2, column - 1],
          [row + 1, column + 2],
          [row + 1, column - 2],
          [row - 1, column + 2],
          [row - 1, column - 2],
        ];

        for (var move in potentialMoves) {
          int r = move[0];
          int c = move[1];
          if (isInBoard(r, c) &&
              (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite)) {
            moves.add([r, c]);
          }
          if (isInBoard(r, c) &&
              board[r][c] != null &&
              board[r][c]!.isWhite != piece.isWhite) {
          }
        }
        break;
      case ChessPieceType.king:
        List<List<int>> directions = [
          [1, 1],
          [1, -1],
          [-1, -1],
          [-1, 1],
          [0, 1],
          [1, 0],
          [0, -1],
          [-1, 0]
        ];

        for (var i in directions) {
          int newRow = row + i[0];
          int newColumn = column + i[1];
          if (!isInBoard(newRow, newColumn)) {
            continue;
          }
          if (board[newRow][newColumn] != null &&
              board[newRow][newColumn]!.isWhite == piece.isWhite) {
            continue;
          }
          if (board[newRow][newColumn] != null &&
              board[newRow][newColumn]!.isWhite != piece.isWhite) {
            moves.add([newRow, newColumn]);
            continue;
          }
          moves.add([newRow, newColumn]);
        }
        break;
      case ChessPieceType.queen:
        List<List<int>> directions = [
          [1, 1],
          [1, -1],
          [-1, -1],
          [-1, 1],
          [0, 1],
          [1, 0],
          [0, -1],
          [-1, 0]
        ];

        for (var direction in directions) {
          int i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite == piece.isWhite) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite != piece.isWhite) {
              moves.add([newRow, newColumn]);
              break;
            }
            moves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
    }

    
    return moves;
  }

  bool isReallyaValidMove(int row, int column, int initialRow, int initialColumn) {
    ChessPiece? originalPiece = board[row][column];
    board[row][column] = board[initialRow][initialColumn];
    board[initialRow][initialColumn] = null;
    selectedRow = row;
    selectedColumn = column;

    bool isCheck = doesThisPositionGivesCheck();

    selectedRow = initialRow;
    selectedColumn = initialColumn;
    board[initialRow][initialColumn] = board[row][column];
    board[row][column] = originalPiece;

    return !isCheck;
  }

  void pieceSelected(int row, int column) {
    setState(() {
      // player initially selecting a piece
      if (selectedPiece == null && board[row][column] != null) {
        if (board[row][column]!.isWhite == whitePlayer) {
          selectedColumn = column;
          selectedRow = row;
          selectedPiece = board[row][column];
          validMoves = calculateAllValidMoves(row, column, selectedPiece);
        }
      } else if (selectedPiece != null &&
          selectedPiece!.isWhite == whitePlayer) {
        // player selecting another piece instead of the current selected piece
        if (board[row][column] != null &&
            board[row][column]!.isWhite == selectedPiece!.isWhite) {
          selectedColumn = column;
          selectedRow = row;
          selectedPiece = board[row][column];
          validMoves = calculateAllValidMoves(row, column, selectedPiece);
        } // player trying to make a move
        else if (validMoves
            .any((move) => move[0] == row && move[1] == column)) {
          //move piece
          if (board[row][column] == null) {
            board[row][column] = selectedPiece;
          } //capture piece
          else {
            if (board[selectedRow][selectedColumn]!.isWhite !=
                board[row][column]!.isWhite) {
              if (board[row][column]!.isWhite) {
                whiteCapturedPieces.add(board[row][column]!);
              } else {
                blackCapturedPieces.add(board[row][column]!);
              }
            }
            board[row][column] = selectedPiece;
          }
          //deselect the piece
          board[selectedRow][selectedColumn] = null;
          selectedPiece = null;
          selectedRow = -1;
          selectedColumn = -1;
          validMoves = [];
          captureAbleMove = [];
          whitePlayer = !whitePlayer;
        } //clicking on open space to deselect the piece
        else {
          selectedPiece = null;
          selectedRow = -1;
          selectedColumn = -1;
          validMoves = [];
          captureAbleMove = [];
        }
      }
    });
  }

  List<List<int>> calculateAllValidMoves(
      int row, int column, ChessPiece? piece) {
    List<List<int>> moves = [];

    if (piece == null) {
      return moves;
    }

    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        if (isInBoard(row + direction, column) &&
            board[row + direction][column] == null) {
          moves.add([row + direction, column]);
        }

        if ((row == 1 && !piece.isWhite || row == 6 && piece.isWhite) &&
            board[row + 2 * direction][column] == null &&
            board[row + direction][column] == null) {
          moves.add([row + 2 * direction, column]);
        }

        if (isInBoard(row + direction, column - 1) &&
            board[row + direction][column - 1] != null &&
            board[row + direction][column - 1]!.isWhite != piece.isWhite) {
          moves.add([row + direction, column - 1]);
          captureAbleMove.add([row + direction, column - 1]);
        }

        if (isInBoard(row + direction, column + 1) &&
            board[row + direction][column + 1] != null &&
            board[row + direction][column + 1]!.isWhite != piece.isWhite) {
          moves.add([row + direction, column + 1]);
          captureAbleMove.add([row + direction, column + 1]);
        }

        break;
      case ChessPieceType.rook:
        List<List<int>> directions = [
          [0, 1],
          [1, 0],
          [0, -1],
          [-1, 0]
        ];

        for (var direction in directions) {
          int i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite == piece.isWhite) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite != piece.isWhite) {
              moves.add([newRow, newColumn]);
              captureAbleMove.add([newRow, newColumn]);
              break;
            }
            moves.add([newRow, newColumn]);
            i++;
          }
        }

        break;
      case ChessPieceType.bishop:
        List<List<int>> directions = [
          [1, 1],
          [1, -1],
          [-1, -1],
          [-1, 1]
        ];

        for (var direction in directions) {
          int i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite == piece.isWhite) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite != piece.isWhite) {
              moves.add([newRow, newColumn]);
              captureAbleMove.add([newRow, newColumn]);
              break;
            }
            moves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        List<List<int>> potentialMoves = [
          [row + 2, column + 1],
          [row + 2, column - 1],
          [row - 2, column + 1],
          [row - 2, column - 1],
          [row + 1, column + 2],
          [row + 1, column - 2],
          [row - 1, column + 2],
          [row - 1, column - 2],
        ];

        for (var move in potentialMoves) {
          int r = move[0];
          int c = move[1];
          if (isInBoard(r, c) &&
              (board[r][c] == null || board[r][c]!.isWhite != piece.isWhite)) {
            moves.add([r, c]);
          }
          if (isInBoard(r, c) &&
              board[r][c] != null &&
              board[r][c]!.isWhite != piece.isWhite) {
            captureAbleMove.add([r, c]);
          }
        }
        break;
      case ChessPieceType.king:
        List<List<int>> directions = [
          [1, 1],
          [1, -1],
          [-1, -1],
          [-1, 1],
          [0, 1],
          [1, 0],
          [0, -1],
          [-1, 0]
        ];

        for (var i in directions) {
          int newRow = row + i[0];
          int newColumn = column + i[1];
          if (!isInBoard(newRow, newColumn)) {
            continue;
          }
          if (board[newRow][newColumn] != null &&
              board[newRow][newColumn]!.isWhite == piece.isWhite) {
            continue;
          }
          if (board[newRow][newColumn] != null &&
              board[newRow][newColumn]!.isWhite != piece.isWhite) {
            moves.add([newRow, newColumn]);
            captureAbleMove.add([newRow, newColumn]);
            continue;
          }
          moves.add([newRow, newColumn]);
        }
        break;
      case ChessPieceType.queen:
        List<List<int>> directions = [
          [1, 1],
          [1, -1],
          [-1, -1],
          [-1, 1],
          [0, 1],
          [1, 0],
          [0, -1],
          [-1, 0]
        ];

        for (var direction in directions) {
          int i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite == piece.isWhite) {
              break;
            }
            if (board[newRow][newColumn] != null &&
                board[newRow][newColumn]!.isWhite != piece.isWhite) {
              moves.add([newRow, newColumn]);
              captureAbleMove.add([newRow, newColumn]);
              break;
            }
            moves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
    }

    List<List<int>> finalList = [];
    for(List<int> x in moves){
      if(isReallyaValidMove(x[0], x[1], selectedRow, selectedColumn)){
        finalList.add(x);
      }
    }
    return finalList;
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          imageUrl: "assets/images/pawn.png",
          isWhite: false,
          type: ChessPieceType.pawn);
      newBoard[6][i] = ChessPiece(
          imageUrl: "assets/images/pawn.png",
          isWhite: true,
          type: ChessPieceType.pawn);
    }

    newBoard[0][0] = ChessPiece(
        imageUrl: "assets/images/rook.png",
        isWhite: false,
        type: ChessPieceType.rook);
    newBoard[0][7] = ChessPiece(
        imageUrl: "assets/images/rook.png",
        isWhite: false,
        type: ChessPieceType.rook);
    newBoard[7][0] = ChessPiece(
        imageUrl: "assets/images/rook.png",
        isWhite: true,
        type: ChessPieceType.rook);
    newBoard[7][7] = ChessPiece(
        imageUrl: "assets/images/rook.png",
        isWhite: true,
        type: ChessPieceType.rook);

    newBoard[0][1] = ChessPiece(
        imageUrl: "assets/images/horse.png",
        isWhite: false,
        type: ChessPieceType.knight);
    newBoard[0][6] = ChessPiece(
        imageUrl: "assets/images/horse.png",
        isWhite: false,
        type: ChessPieceType.knight);
    newBoard[7][6] = ChessPiece(
        imageUrl: "assets/images/horse.png",
        isWhite: true,
        type: ChessPieceType.knight);
    newBoard[7][1] = ChessPiece(
        imageUrl: "assets/images/horse.png",
        isWhite: true,
        type: ChessPieceType.knight);

    newBoard[0][2] = ChessPiece(
        imageUrl: "assets/images/bishop.png",
        isWhite: false,
        type: ChessPieceType.knight);
    newBoard[0][5] = ChessPiece(
        imageUrl: "assets/images/horse.png",
        isWhite: false,
        type: ChessPieceType.bishop);
    newBoard[7][5] = ChessPiece(
        imageUrl: "assets/images/bishop.png",
        isWhite: true,
        type: ChessPieceType.bishop);
    newBoard[7][2] = ChessPiece(
        imageUrl: "assets/images/bishop.png",
        isWhite: true,
        type: ChessPieceType.bishop);

    newBoard[0][3] = ChessPiece(
        imageUrl: "assets/images/Queen.png",
        isWhite: false,
        type: ChessPieceType.queen);
    newBoard[7][3] = ChessPiece(
        imageUrl: "assets/images/Queen.png",
        isWhite: true,
        type: ChessPieceType.queen);

    newBoard[0][4] = ChessPiece(
        imageUrl: "assets/images/king.png",
        isWhite: false,
        type: ChessPieceType.king);
    newBoard[7][4] = ChessPiece(
        imageUrl: "assets/images/king.png",
        isWhite: true,
        type: ChessPieceType.king);

    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: blackCapturedPieces.length,
              itemBuilder: (context, index) {
                // print(whiteCapturedPieces.length);
                return Image.asset(
                  blackCapturedPieces[index].imageUrl,
                  height: 50,
                  width: 50,
                  color: Colors.black,
                );
              },
            ),
          ),
          Expanded(
            flex: 6,
            child: GridView.builder(
              itemCount: 64,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int column = index % 8;

                bool isCaptueAble = false;

                bool isSelected =
                    selectedRow == row && selectedColumn == column;
                bool isValid = false;
                for (var i in validMoves) {
                  if (i[0] == row && i[1] == column) {
                    isValid = true;
                    break;
                  }
                }

                for (var i in captureAbleMove) {
                  if (i[0] == row && i[1] == column) {
                    isCaptueAble = true;
                    break;
                  }
                }

                return Squares(
                  isWhite: isWhite(index),
                  piece: board[row][column],
                  isSelected: isSelected,
                  isValid: isValid,
                  isCapturable: isCaptueAble,
                  onTap: () => pieceSelected(row, column),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: whiteCapturedPieces.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  whiteCapturedPieces[index].imageUrl,
                  height: 50,
                  width: 50,
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
