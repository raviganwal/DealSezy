class MyAdvsPosts {
  final String Adv_ID;
  final String Title;
  final String Cat_ID;
  final String SubCat_ID;
  final String Price;
  final String Description;
  final String Features;
  final String Condition;
  final String ReasonofSelling;
  final String User_ID;
  final String Post_Time;
  final String Visible_To;
  final String Status;
  final String Image;


  MyAdvsPosts({
    this.Adv_ID,
    this.Title,
    this.Cat_ID,
    this.SubCat_ID,
    this.Price,
    this.Description,
    this.Features,
    this.Condition,
    this.ReasonofSelling,
    this.User_ID,
    this.Post_Time,
    this.Visible_To,
    this.Status,
    this.Image,
   });


  factory MyAdvsPosts.formJson(Map <String, dynamic> json){
    return new MyAdvsPosts(
      Adv_ID: json['Adv_ID'],
      Title: json['Title'],
      Cat_ID: json['Cat_ID'],
      SubCat_ID: json['SubCat_ID'],
      Price: json['Price'],
      Description: json['Description'],
      Features: json['Features'],
      Condition: json['Condition'],
      ReasonofSelling: json['Reason of Selling'],
      User_ID: json['User_ID'],
      Post_Time: json['Post_Time'],
      Visible_To: json['Visible_To'],
      Status: json['Publish_Status'],
      Image: json['image'],

      );
  }
}