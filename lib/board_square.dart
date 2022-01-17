class BoardSquare {

  bool hasBomb;
  int bombsAround;

  BoardSquare({this.hasBomb = false, this.bombsAround = 0});

}

class BoardPosition {

  bool redposition;
  bool blueposition;
  bool greenposition;
  bool yellowposition;
  bool obstaclenorth;
  bool obstacleeast;
  bool obstaclesouth;
  bool obstaclewest;
  String collectible;

  BoardPosition({this.redposition = false, this.blueposition = false, this.greenposition = false,this.yellowposition = false,this.obstaclenorth = false, this.obstacleeast = false, this.obstaclesouth = false, this.obstaclewest = false, this.collectible=""});

}

class Players {

  String EMail;
  int bet;

  Players({this.EMail = "", this.bet = 99});

}