import 'package:badam/apiReqeust/constants.dart';

/// This class holds all arguments which can be used to filter posts when using
/// [WordPress.fetchPosts] method.
///
/// [List Posts' Arguments](https://developer.wordpress.org/rest-api/reference/posts/#list-posts)
class ParamsPostList {
  final WordPressContext context;
  final int pageNum;
  final int perPage;
  final String searchQuery;
  final String afterDate;
  final String beforeDate;
  final List<int>? includeAuthorIDs;
  final List<int>? excludeAuthorIDs;
  final List<int>? includePostIDs;
  final List<int>? excludePostIDs;
  final int ?offset;
  final Order order;
  final PostOrderBy orderBy;
  final PostSortMetaBy ?sortBy;
  final String slug;
  final PostPageStatus postStatus;
  final List<int> ?includeCategories;
  final List<int> ?excludeCategories;
  final List<int> ?includeTags;
  final List<int> ?excludeTags;
  final bool ?sticky;
  final StatusProperty ?status;
  final int ?lowerPrice;
  final int ?lowerSize;
  final int ?upperPrice;
  final int ?upperSize;
  final String ?typesProperty;
  final String ?cityProperty;
  final String ?stateProperty;
  final String ?favoriteList;

  ParamsPostList({
    this.context = WordPressContext.view,
    this.pageNum = 1,
    this.perPage = 2,
    this.searchQuery = '',
    this.afterDate = '',
    this.beforeDate = '',
    this.includeAuthorIDs,
    this.sortBy,
    this.excludeAuthorIDs,
    this.includePostIDs,
    this.excludePostIDs,
    this.offset,
    this.order = Order.desc,
    this.orderBy = PostOrderBy.date,
    this.slug = '',
    this.postStatus = PostPageStatus.publish,
    this.includeCategories,
    this.excludeCategories,
    this.includeTags,
    this.excludeTags,
    this.sticky,
    this.status,
    this.upperSize,
    this.lowerSize,
    this.upperPrice,
    this.lowerPrice,
    this.typesProperty,
    this.cityProperty,
    this.stateProperty,
    this.favoriteList,
  });

  Map<String, String> toMap() {
    return {
      'context': '${enumStringToName(this.context.toString())}',
      'page': '${this.pageNum}',
      'per_page': '${this.perPage}',
      'search': '${this.searchQuery}',
      'after': '${this.afterDate}',
      'before': '${this.beforeDate}',
      'author': '${listToUrlString(this.includeAuthorIDs!)}',
      'author_exclude': '${listToUrlString(this.excludeAuthorIDs!)}',
      'include': '${listToUrlString(includePostIDs!)}',
      'exclude': '${listToUrlString(excludePostIDs!)}',
      'offset': '${this.offset == null ? '' : this.offset}',
      'order': '${enumStringToName(this.order.toString())}',
      'orderby': '${enumStringToName(this.orderBy.toString())}',
      'slug': '${this.slug}',
      'status': '${enumStringToName(this.postStatus.toString())}',
      'categories': '${listToUrlString(includeCategories!)}',
      'categories_exclude': '${listToUrlString(excludeCategories!)}',
      'tags': '${listToUrlString(includeTags!)}',
      'tags_exclude': '${listToUrlString(excludeTags!)}',
      'sticky': '${this.sticky == null ? '' : this.sticky}',
      'orderbymeta_value': '${enumStringToName(this.sortBy.toString())}',
      'filter[property-status]':
          '${this.status == null ? '' : enumStringToName(this.status.toString())}',
      'filter[property_city]':
          '${this.cityProperty == null ? '' : this.cityProperty}',
      'filter[property_types]':
          '${this.typesProperty == null ? '' : this.typesProperty }',
      'filter[property-state]':
          '${this.stateProperty == null ? '' : this.stateProperty }',
      'filter[property_size][0]': this.lowerSize == null 
          ? ''
          : this.lowerSize.toString(),
        'filter[property_size][1]':  this.upperSize == null
          ? ''
          :  this.upperSize.toString(),
             
      'filter[property_price][0]':
          this.lowerPrice == null 
              ? ''
              : this.lowerPrice.toString(),
      'filter[property_price][1]':
          this.upperPrice == null 
              ? ''
              : this.upperPrice.toString(),
      'filter[get_favorites]':
          this.favoriteList == null 
              ? ''
              : "${this.favoriteList}",
    };
  }

  @override
  String toString() {
    return constructUrlParams(toMap());
  }
}
