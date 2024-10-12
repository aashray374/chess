bool isWhite(int index){
  int x = index ~/8;
  int y = index % 8;
  return (x+y)%2==0;
}

bool isInBoard(int row, int column){
  if(row>=0 && row<=7 && column>=0 && column<=7){
    return true;
  }
  return false;
}