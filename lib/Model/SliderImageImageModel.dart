class Posts {
  bool status;
  List<Data> data;

  Posts({this.status, this.data});

  Posts.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String advImageID;
  String imageData;
  String advID;

  Data({this.advImageID, this.imageData, this.advID});

  Data.fromJson(Map<String, dynamic> json) {
    advImageID = json['Adv_Image_ID'];
    imageData = json['ImageData'];
    advID = json['Adv_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Adv_Image_ID'] = this.advImageID;
    data['ImageData'] = this.imageData;
    data['Adv_ID'] = this.advID;
    return data;
  }
}