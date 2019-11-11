class ChatReciveDataModel {

  final String Chat_ID;
  final String From_ID;
  final String From_Name;
  final String To_ID;
  final String To_Name;
  final String Message_TIME;
  final String Message;
  final String Adv_ID;
  final String Adv_Title;

  ChatReciveDataModel(
      {
        this.Chat_ID,
        this.From_ID,
        this.From_Name,
        this.To_ID,
        this.To_Name,
        this.Message_TIME,
        this.Message,
        this.Adv_ID,
        this.Adv_Title,
      });

  factory ChatReciveDataModel.formJson(Map <String, dynamic> json){
    return new ChatReciveDataModel(
      Chat_ID: json['Chat_ID'],
      From_ID: json['From_ID'],
      From_Name: json['From_Name'],
      To_ID: json['To_ID'],
      To_Name: json['To_Name'],
      Message_TIME: json['Message_TIME'],
      Message: json['Message'],
      Adv_ID: json['Adv_ID'],
      Adv_Title: json['Adv_Title'],
      );
  }
}