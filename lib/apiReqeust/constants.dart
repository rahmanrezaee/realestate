const URL_JWT_BASE = '/wp-json/jwt-auth/v1';
const URL_WP_BASE = '/wp-json/wp/v2';
const URL_WP_CUSTOME = '/wp-json/api/v1';

const URL_JWT_TOKEN = '$URL_JWT_BASE/token';
const URL_JWT_TOKEN_VALIDATE = '$URL_JWT_BASE/token/validate';

const URL_CATEGORIES = '$URL_WP_BASE/categories';
const BASE_URL = 'https://www.badam.af';
const URL_COMMENTS = '$URL_WP_BASE/comments';
const URL_MEDIA = '$URL_WP_BASE/media';
const URL_PAGES = '$URL_WP_BASE/pages';
const URL_POSTS = '$URL_WP_BASE/posts';
const URL_PROPERTY = '$URL_WP_BASE/property';
const URL_INVOICE = '$URL_WP_BASE/invoice';
const URL_TAGS = '$URL_WP_BASE/tags';
const URL_USERS = '$URL_WP_BASE/users';
const URL_SEARCH_CITY = '$URL_WP_CUSTOME/town-or-city';

enum WordPressAuthenticator {
  JWT,
  ApplicationPasswords,
}
enum WordPressContext { view, embed, edit }

enum Order {
  asc,
  desc,
}

enum PostOrderBy {
  author,
  date,
  id,
  include,
  modified,
  parent,
  relevance,
  slug,
  title,
}

enum PostSortMetaBy {
  real_estate_property_price,
  real_estate_property_land,
  real_estate_property_size,

}

enum PostPageStatus {
  publish,
  future,
  draft,
  pending,
  private,
}
enum PropertyForm {
  submit,
  edit,
}
enum PackageType {
  gold,
  featured,
  normal
}

enum StatusProperty {
  forrent,
  forsale,
  forexchange,
  formortage

}


enum PostCommentStatus {
  open,
  closed,
}
enum PostPingStatus {
  open,
  closed,
}
enum PostFormat {
  standard,
  aside,
  chat,
  gallery,
  link,
  image,
  quote,
  status,
  video,
  audio,
}

enum UserOrderBy {
  id,
  include,
  name,
  registered_date,
  slug,
  email,
  url,
}
enum UserRole {
  subscriber,
  contributor,
  author,
  editor,
  administrator,
}

enum CommentOrderBy {
  date,
  date_gmt,
  id,
  include,
  post,
  parent,
  type,
}
enum CommentStatus {
  all,
  approve,
  hold,
  spam,
  trash,
}
enum CommentType {
  comment,
  
  //TODO: Add all comment types
}

enum CategoryTagOrderBy {
  id,
  include,
  name,
  slug,
  term_group,
  description,
  count,
}

enum PageOrderBy {
  author,
  date,
  id,
  include,
  modified,
  parent,
  relevance,
  slug,
  title,
  menu_order,
}

enum MediaOrderBy {
  author,
  date,
  id,
  include,
  modified,
  parent,
  relevance,
  slug,
  title,
}
enum MediaStatus {
  inherit,
  publish,
  future,
  draft,
  pending,
  private,
}
enum MediaType {
  image,
  video,
  audio,
  application,
}

/// Converts an enum string to enum value name.
String enumStringToName(String enumString) {
  return enumString.split('.')[1];
}

/// Formats a list of [items] to a comma(,) separated string to pass it as a
/// URL parameter.
String listToUrlString<T>(List<T> items) {
  if (items == null || items.length == 0) return '';

  return items.join(',');
}

/// Formats a [Map] of parameters to a string of URL friendly parameters.
String constructUrlParams(Map<String, String> params) {
  StringBuffer p = new StringBuffer('/?');
  params.forEach((key, value) {
    if (value != '') {
      p.write('$key=$value');
      p.write('&');
    }
  });
  return p.toString();
}



   final List<Map<String, String>> PROVINCES_LIST = [
    {"display": '????????????', "value": 'Uruzgan'},
    {"display": '????????????', "value": 'Badghis'},
    {"display": '????????????', "value": 'Bamyan'},
    {"display": '????????????', "value": 'Badakhshan'},
    {"display": '??????????', "value": 'Baghlan'},
    {"display": '??????', "value": 'Balkh'},
    {"display": '??????????', "value": 'Parwan'},
    {"display": '??????????', "value": 'Paktia'},
    {"display": '????????????', "value": 'Paktika'},
    {"display": '????????????', "value": 'Panjshir'},
    {"display": '????????', "value": 'Takhar'},
    {"display": '????????????', "value": 'Jowzjan'},
    {"display": '????????', "value": 'Khost'},
    {"display": '??????????????', "value": 'Daykundi'},
    {"display": '????????', "value": 'Zabul'},
    {"display": '????????', "value": 'SarePol'},
    {"display": '????????', "value": 'Ghazni'},
    {"display": '??????', "value": 'Ghor'},
    {"display": '????????????', "value": 'Faryab'},
    {"display": '????????', "value": 'Farah'},
    {"display": '????????????', "value": 'kandahar'},
    {"display": '??????????', "value": 'Kunduz'},
    {"display": '????????', "value": 'kabul'},
    {"display": '????????????', "value": 'Kapisa'},
    {"display": '??????', "value": 'konar'},
    {"display": '??????????', "value": 'lagman'},
    {"display": '????????', "value": 'logar'},
    {"display": '???????? ????????', "value": 'mazaresharif'},
    {"display": '?????????? ????????', "value": 'maydanwardak'},
    {"display": '??????????????', "value": 'nooristan'},
    {"display": '????????????', "value": 'nemroz'},
    {"display": '????????', "value": 'herat'},
    {"display": '??????????', "value": 'helmand'},
  ];
