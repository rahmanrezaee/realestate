class CityModel {
  int? term_id;
  String? term_name;
  String? term_slug;
  String ?term_parent_name;
  String? term_parent_slug;
  int? term_parent_id;
  CityModel() {}
  CityModel.fromJson(Map<String, dynamic> json) {
    // print(json['property_meta']['real_estate_property_address'][0]);
    term_id = int.parse(json['id']);
    term_name = json['term_name'];
    term_slug = json['term_slug'];
    term_parent_id = int.parse(json['term_parent_id']);
    term_parent_name = json['term_parent_name'];
    term_parent_slug = json['term_parent_slug'];
  }
}
