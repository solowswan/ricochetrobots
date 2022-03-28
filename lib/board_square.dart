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
  bool rightarrow;
  bool leftarrow;
  bool uparrow;
  bool downarrow;

  BoardPosition({this.redposition = false, this.blueposition = false, this.greenposition = false,
    this.yellowposition = false,this.obstaclenorth = false, this.obstacleeast = false, this.obstaclesouth = false, this.obstaclewest = false, this.collectible="",
    this.rightarrow = false,
    this.leftarrow = false,
    this.uparrow = false,
    this.downarrow = false,
  });

}

class RoundResults {
  int moves;
  RoundResults({this.moves = 0
  });
}

class RoundMoves {
  String color;
  int from;
  int to;
  RoundMoves({this.color = "", this.from = 0, this.to = 0
  });
}


class Players {

  String EMail;
  int bet;

  Players({this.EMail = "", this.bet = 99});

}