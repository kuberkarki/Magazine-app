class Magazines {
  String status;
  String message;
  List<Magazine> magazine;

  Magazines({this.status, this.message, this.magazine});

  Magazines.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      magazine = new List<Magazine>();
      json['data'].forEach((v) {
        magazine.add(new Magazine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.magazine != null) {
      data['data'] = this.magazine.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Magazine {
  int id;
  String name;
  String image;
  String zipFile;
  String identifier;
  String extractedFile;
  String introduction;
  String isFree;
  String article;
  String isFlipper;
  String issuedDate;
  String updateTime;
  String content;
  int version;
  int isLiked;
  int isDownloaded;

  Magazine(
      {this.id,
      this.name,
      this.image,
      this.zipFile,
      this.identifier,
      this.extractedFile,
      this.introduction,
      this.isFree,
      this.article,
      this.isFlipper,
      this.issuedDate,
      this.updateTime,
      this.content,
      this.version,
      this.isLiked,
      this.isDownloaded});

  Magazine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    zipFile = json['zip_file'];
    identifier = json['identifier'];
    extractedFile = json['extracted_file'];
    introduction = json['introduction'];
    isFree = json['is_free'];
    article = json['article'];
    isFlipper = json['is_flipper'];
    issuedDate = json['issued_date'];
    updateTime = json['update_time'];
    content = json['content'];
    version = json['version'];
  }
  Magazine.fromJsonWithDetal(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    zipFile = json['zip_file'];
    identifier = json['identifier'];
    extractedFile = json['extracted_file'];
    introduction = json['introduction'];
    isFree = json['is_free'];
    article = json['article'];
    isFlipper = json['is_flipper'];
    issuedDate = json['issued_date'];
    updateTime = json['update_time'];
    content = json['content'];
    version = json['version'];
    isLiked = json['isLiked'];
    isDownloaded = json['isDownloaded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['zip_file'] = this.zipFile;
    data['identifier'] = this.identifier;
    data['extracted_file'] = this.extractedFile;
    data['introduction'] = this.introduction;
    data['is_free'] = this.isFree;
    data['article'] = this.article;
    data['is_flipper'] = this.isFlipper;
    data['issued_date'] = this.issuedDate;
    data['update_time'] = this.updateTime;
    data['content'] = this.content;
    data['version'] = this.version;
    return data;
  }
}
