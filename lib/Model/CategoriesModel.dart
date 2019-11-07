class Posts {

  final String Cat_ID;
  final String Cat_Name;
  final String FAICON;

  Posts({this.Cat_ID, this.Cat_Name, this.FAICON});

  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      Cat_ID: json['Cat_ID'],
      Cat_Name: json['Cat_Name'],
      FAICON: json['FAICON'],
      );
  }
}