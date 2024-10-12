enum ChessPieceType{pawn , rook, knight, king , queen,bishop}

class ChessPiece{
  final bool isWhite;
  final String imageUrl;
  final ChessPieceType type;

  ChessPiece({
    required this.imageUrl,
    required this.isWhite,
    required this.type
  });
}