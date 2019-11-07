class Posts {

  final String SubCat_ID;
  final String SubCat_Name;
  final String FAICON;

  Posts({this.SubCat_ID, this.SubCat_Name, this.FAICON});

  factory Posts.formJson(Map <String, dynamic> json){
    return new Posts(
      SubCat_ID: json['SubCat_ID'],
      SubCat_Name: json['SubCat_Name'],
      FAICON: json['FAICON'],
      );
  }
}