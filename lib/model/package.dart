class Package {
  int? id;
  String? title;
  String? price;
  int? vipProperties;
  int ?normalProperties;
  int? goldProperties;
  final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);

  Package(
      {this.id,
      this.title,
      this.goldProperties,
      this.normalProperties,
      this.price,
      this.vipProperties});

  Package.fromJson(Map<String, dynamic> json) {
    String pric = json['package-detail']['price'];
    List p = pric.split('').toList();
    p.removeWhere((item) => !isNumber(item));

    id = json['id'];
    title = json['title']['rendered'];
    price = p.length > 0 ? (p.join() + " افغانی") : ("رایگان");
    normalProperties = int.parse(json['package-detail']['normal']);
    vipProperties = int.parse(json['package-detail']['vip']);
    goldProperties = int.parse(json['package-detail']['gold']);
  }

  bool isNumber(String item) {
    return '0123456789'.split('').contains(item);
  }
}
