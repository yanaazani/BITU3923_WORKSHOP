class Room{
  int roomId = 0;
  String number = "";

  Room(this.roomId, this.number);

  int get _Id => roomId;
  set _Id(int value) => roomId = value;

  String get _roomNumber => number;
  set _roomNumber(String value) => number = value;

  Room.fromJson(Map<String, dynamic> json){
    roomId = json["id"];
    number = json["roomNumber"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": roomId,
      "roomNumber": number,
    };
  }

}