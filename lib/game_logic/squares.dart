import 'package:chess/game_logic/pieces.dart';
import 'package:flutter/material.dart';

class Squares extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValid;
  final bool isCapturable;
  final void Function()? onTap;

  const Squares({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.isValid,
    required this.onTap,
    required this.isCapturable,
  });

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (isSelected) {
      color = Colors.green[500];
    }else if(isValid){
      // color = Colors.green[300];
      if(isCapturable){
        color = Colors.red[300];
      }else{
        color = Colors.green[300];
      }
    } else {
      color = isWhite ? Colors.grey[400] : Colors.grey[600];
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(isValid? 8:0) ,
        padding: const EdgeInsets.all(8),
        color: color,
        child: piece != null ? Image.asset(piece!.imageUrl, color: piece!.isWhite? Colors.white:Colors.black) : null,
      ),
    );
  }
}
