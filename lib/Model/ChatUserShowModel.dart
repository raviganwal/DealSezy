class ChatUserShowModel {

  String toID;
  String toName;
  String advID;
  String advTitle;

  ChatUserShowModel({this.toID, this.toName, this.advID, this.advTitle});

  factory ChatUserShowModel.formJson(Map <String, dynamic> json){
    return new ChatUserShowModel(
      toID: json['To_ID'],
      toName: json['To_Name'],
      advID: json['Adv_ID'],
      advTitle: json['Adv_Title'],
      );
  }
}