import 'package:badam/apiReqeust/constants.dart';
import 'package:badam/model/Image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Property {
  /// ID of the post
  int? id;
  String? date;
  String? slug;
 late PostPageStatus status;
  String? postType;
  String? link;
  String? title;
  bool isFavorite = false;
  String? content;
  int? authorID;
  int? featuredMediaID;
  PropertyForm? propertyForm;
  PackageType ?pcckageType;
  String? agentDisplayOption;
  String? otherContactName;
  String? otherContactMail;
  String? otherContactPhone;
  String? score;
  String? propertyLabel;
  String? otherContactDescription;

  String? price;
  String? pricePerfix;
  String? area;
  String? address;
  String? areaPrefix;
  String? propertyId;
  List<ImageProperty> ?gallary;
  List<Map> ?attribute;
  Map ? types = {"term_slug": "apartment", "term_name": "اپارتمان"};
  Map ?state;
  Map ?statusProperty;
  Map ?city;
  String? buildYear;
  String? bedrooms;
  String? bathrooms;
  LatLng? location;
  int? rooms;

  String? prfileUri;
  String? agentName;
  String? email;
  String? agentDescription;
  String? phone;

  Property(
      {this.pcckageType,
      this.propertyForm,
      this.address,
      this.area,
      this.prfileUri,
      this.agentName,
      this.email,
      this.agentDescription,
      this.phone,
      this.areaPrefix,
      this.propertyLabel,
      this.score,
      this.attribute,
      this.authorID,
      this.bathrooms,
      this.bedrooms,
      this.buildYear,
      this.city,
      this.date,
      this.featuredMediaID,
      this.gallary,
      this.id,
      this.price,
      this.state,
      this.statusProperty,
      this.rooms,
      this.content,
      this.location,
      this.propertyId,
      this.title,
      this.postType,
      this.types,
      this.pricePerfix,
      this.agentDisplayOption,
      this.otherContactDescription,
      this.otherContactMail,
      this.otherContactName,
      this.otherContactPhone});

  Property.fromJson(Map<String?, dynamic> json) {
    id = json['id'];
    // date = json['date'].toString?();
    
    isFavorite = json['is_favorite'] == null ? false : json['is_favorite'];
    if (json['status'] != null) {
      PostPageStatus.values.forEach((val) {
        // if (enumString?ToName(val.toString?()) == json['status']) {
        //   status = val;
        //   return;
        // }
      });
    }
    postType = json['type'];
    link = json['link'];
    title = json['title'] != null ? json['title']['rendered'] : null;
    content = json['content'] != null ? json['content']['rendered'] : null;
    authorID = json['author'];
    featuredMediaID = json['featured_media'];

    area = json['property_meta']['real_estate_property_size'] != null
        ? json['property_meta']['real_estate_property_size'][0]
        : null;

    // String? locationString? = json['property_location']['location'];

    // List<String?> locationList = locationString?.split(",");

    // location =
    //     LatLng(double.parse(locationList[0]), double.parse(locationList[1]));

    json['property_meta']['real_estate_property_size'] != null
        ? json['property_meta']['real_estate_property_size'][0]
        : null;

    // buildYear = json['property_meta']['real_estate_property_year'] != null
    //     ? json['property_meta']['real_estate_property_year'][0].toString?()
    //     : null;
    address = json['property_meta']['real_estate_property_address'] != null
        ? json['property_meta']['real_estate_property_address'][0]
        : null;
    price = json['property_meta']['real_estate_property_price'] != null
        ? json['property_meta']['real_estate_property_price'][0]
        : null;
    score = json['property_meta']['score_amount'] != null
        ? json['property_meta']['score_amount'][0]
        : null;
    propertyLabel = json['property_meta']['property_type'] != null
        ? json['property_meta']['property_type'][0]
        : null;
    pricePerfix =
        json['property_meta']['real_estate_property_price_prefix'] != null
            ? json['property_meta']['real_estate_property_price_prefix'][0]
            : null;
    propertyId = json['property_meta']['real_estate_property_identity'] != null
        ? json['property_meta']['real_estate_property_identity'][0]
        : null;

    otherContactName =
        json['property_meta']['real_estate_property_other_contact_name'] != null
            ? json['property_meta']['real_estate_property_other_contact_name']
                [0]
            : null;

    json['property_meta']['real_estate_property_other_contact_name'] != null
        ? json['property_meta']['real_estate_property_other_contact_name'][0]
        : null;
    otherContactDescription = json['property_meta']
                ['real_estate_property_other_contact_description'] !=
            null
        ? json['property_meta']
            ['real_estate_property_other_contact_description'][0]
        : null;
    otherContactMail =
        json['property_meta']['real_estate_property_other_contact_mail'] != null
            ? json['property_meta']['real_estate_property_other_contact_mail']
                [0]
            : null;
    agentDisplayOption =
        json['property_meta']['real_estate_agent_display_option'] != null
            ? json['property_meta']['real_estate_agent_display_option'][0]
            : null;
    otherContactPhone = json['property_meta']
                ['real_estate_property_other_contact_phone'] !=
            null
        ? json['property_meta']['real_estate_property_other_contact_phone'][0]
        : null;

    bathrooms =
        json['property_meta'].containsKey("real_estate_property_bathrooms") &&
                json['property_meta']['real_estate_property_bathrooms'] != null
            ? json['property_meta']['real_estate_property_bathrooms'][0]
            : null;

    bedrooms =
        json['property_meta'].containsKey("real_estate_property_bedrooms") &&
                json['property_meta']['real_estate_property_bedrooms'] != null
            ? json['property_meta']['real_estate_property_bedrooms'][0]
            : null;
    rooms = json['property_meta'].containsKey("real_estate_property_rooms") &&
            json['property_meta']['real_estate_property_rooms'][0] != ""
        ? int.parse(json['property_meta']['real_estate_property_rooms'][0])
        : null;
    // pricePerfix = json['property_meta'].containsKey("real_estate_property_price_postfix")  &&
    //     json['property_meta']['real_estate_property_price_postfix'] != null
    //         ? json['property_meta']['real_estate_property_price_postfix'][0]
    //         : null;

    areaPrefix = "متر";
    List items = json['property_image'];
    // List<ImageProperty> gal = List<ImageProperty>();
    // if (items != null) {
    //   for (var i = 0; i < items.length; i++) {
    //     if (items[i]['source_url'] == false) {
    //       continue;
    //     }
    //     gal.add(
    //       ImageProperty(
    //         id: int.parse(items[i]['id']),
    //         mediaType: items[i]['media_type'],
    //         sourceUrl: items[i]['source_url'],
    //       ),
    //     );
    //   }
    // }
    // gallary = gal;

    var feature = json['property_feature'];

    attribute = [];
    // for (Map item in feature) {
    //   attribute.add(item);
    // }

    types = json['property_types'] != "" ? json['property_types'] : null;
    state = json['property_state'] != "" ? json['property_state'] : null;
    statusProperty =
        json['property_status'] != "" ? json['property_status'] : null;
    city = json['property_city'] != "" ? json['property_city'] : null;

    this.prfileUri = json['property_contact']['profile'];
    this.agentName = json['property_contact']['agent_name'];
    this.email = json['property_contact']['email'];
    this.agentDescription = json['property_contact']['agent_description'];
    this.phone = json['property_contact']['agent_mobile_number'];
  }

  Map<String?, dynamic>? toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();

    if (this.title != null) data['property_title'] = this.title;
    if (this.content != null) data['property_des'] = this.content;
    if (this.propertyForm != null)
      data['property_form'] = this.propertyForm == PropertyForm.submit
          ? "submit-property"
          : "edit-property";
    if (this.price != null) data['property_price_short'] = this.price;
    if (this.pricePerfix != null)
      data['property_price_prefix'] = this.pricePerfix;
    if (this.area != null) data['property_size'] = this.area;
    if (this.rooms != null) data['property_rooms'] = this.rooms;
    if (this.bedrooms != null) data['property_bedrooms'] = this.bedrooms;
    if (this.bathrooms != null) data['property_bathrooms'] = this.bathrooms;
    if (this.buildYear != null) data['property_year'] = this.buildYear;
    // if (this.gallary != null)
    //   data['property_image_ids'] = gallary.map((data) => data.id).toList();
    // if (this.gallary != null) data['featured_image_id'] = gallary[0].id;
    // if (this.types != null) data['property_type'] = [this.types['term_slug']];
    // if (this.statusProperty != null)
    //   data['property_status'] = this.statusProperty['term_slug'];
    // if (this.city != null) data['property_city'] = this.city['term_slug'];

    // if (this.attribute != null && this.attribute.length > 0)
    //   data['property_feature'] =
    //       attribute.map((data) => data['term_slug']).toList();

    // if (this.location != null) data['lat'] = this.location.latitude;
    // if (this.location != null) data['lng'] = this.location.longitude;
    if (this.address != null) data['property_map_address'] = this.address;
    // if (this.pcckageType != null)
    //   data['property_package_type'] =
    //       enumString?ToName(this.pcckageType.toString?());

    if (this.agentDisplayOption != null)
      // data['agent_display_option'] = this.agentDisplayOption.toString?();

    if (this.otherContactDescription != null)
      // data['property_other_contact_description'] =
          // this.otherContactDescription.toString?();
    // if (this.otherContactPhone != null)
    //   data['property_other_contact_phone'] = this.otherContactPhone.toString?();
    // if (this.otherContactName != null)
    //   data['property_other_contact_name'] = this.otherContactName.toString?();
    // if (this.otherContactMail != null)
    //   data['property_other_contact_mail'] = this.otherContactMail.toString?();

    return data;
  }
}
