class Posts {

  final String Adv_Image_ID;
  final String ImageData;
  final String Adv_ID;

  Posts({this.Adv_Image_ID, this.ImageData, this.Adv_ID});

  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      Adv_Image_ID: json['Adv_Image_ID'],
      ImageData: json['ImageData'],
      Adv_ID: json['Adv_ID'],
      );
  }
}