import 'dart:async';
import 'dart:io';

import 'package:badam/apiReqeust/constants.dart';
import 'package:badam/apiReqeust/requests/params_post_list.dart';
import 'package:badam/model/Image.dart';
import 'package:badam/model/Invoice.dart';
import 'package:badam/model/package.dart';
import 'package:badam/model/property.dart';
import 'package:badam/util/error_handle.dart';
import 'package:flutter/widgets.dart';
import "package:dio/dio.dart";
import 'package:badam/provider/auth_provider.dart';

class PropertyProvider with ChangeNotifier {
  Dio dio = new Dio();

  Completer<bool> _completer;

  Future<String> _getToken() async {
    var auth = Auth();
    bool isAuth = await auth.tryAutoLogin();

    return isAuth ? Future.value(auth.token) : Future.value(null);
  }

  ParamsPostList getParms(
      {StatusProperty status,
      int index,
      PostSortMetaBy meta,
      typesProperty,
      cityProperty,
      upperPrice,
      lowerPrice,
      upperSize,
      lowerSize,
      stateProperty}) {
    return ParamsPostList(
        context: WordPressContext.view,
        pageNum: index,
        perPage: 3,
        lowerPrice: lowerPrice,
        upperPrice: upperPrice,
        lowerSize: lowerSize,
        upperSize: upperSize,
        cityProperty: cityProperty,
        typesProperty: typesProperty,
        status: status,
        order: Order.desc,
        stateProperty: stateProperty,
        orderBy: PostOrderBy.date,
        sortBy: meta);
  }

  Future fetchPosts({
    @required ParamsPostList postParams,
  }) async {
    // await _headerSetToken();
    final StringBuffer url = new StringBuffer(BASE_URL + URL_PROPERTY);
    var token = await _getToken();
    url.write(postParams.toString());
    print(url);
    try {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }

      final response = await dio.get(
        url.toString(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<Property> properties = new List<Property>();

        final list = response.data;

        for (var property in list) {
          properties.add(Property.fromJson(property));
        }
        return Future.value([properties, response.headers['x-wp-total']]);
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  Future<List<Property>> fetchFavoritePosts() async {
    // await _headerSetToken();
    final StringBuffer url = new StringBuffer(
        BASE_URL + URL_PROPERTY + "?filter[get_favorites]=all");

    var token = await _getToken();
    try {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      final response = await dio.get(
        url.toString(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<Property> properties = new List<Property>();

        final list = response.data;

        for (var property in list) {
          properties.add(Property.fromJson(property));
        }

        notifyListeners();
        // print(properties[0].title.rendered);
        return Future.value(properties);
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  Future fetchMyProperty(int page, String state) async {
    // await _headerSetToken();
    final StringBuffer url = new StringBuffer(BASE_URL + URL_PROPERTY);
    var token = await _getToken();
    url.write(
        "?context=view&page=$page&per_page=5&order=desc&orderby=date&status=$state");
    print(url);
    try {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }

      final response = await dio.get(
        url.toString(),
      );
      

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<Property> properties = new List<Property>();

        final list = response.data;

        for (var property in list) {
          properties.add(Property.fromJson(property));
        }
        print(["", response.headers['x-wp-total']]);
        return Future.value([properties, response.headers['x-wp-total']]);
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } catch (e) {
      print(e.response);
    }
  }

  Future<List> getCities({
    @required String search,
  }) async {
    _completer = Completer<bool>();
    final StringBuffer url = new StringBuffer(BASE_URL + URL_SEARCH_CITY);

    url.write("?city_state=" + search.toString());

    try {
      final response = await dio.get(
        url.toString(),
        // options: Options(headers: _urlHeader),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // List<CityModel> cityModel = new List<CityModel>();

        final list = response.data;

        // for (var city in list) {
        //   cityModel.add(CityModel.fromJson(city));
        // }

        notifyListeners();
        // print(properties[0].title.rendered);
        return Future.value(list);
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  Future addOrRemoveFavorite(int property_id) async {
    final StringBuffer url =
        new StringBuffer(BASE_URL + "/wp-json/api/v1/add-to-favorite");
    print(url);
    var token = await _getToken();
    try {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      final response =
          await dio.post(url.toString(), data: {"property_id": property_id});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.data;
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  Future<Map> propertyFeature() async {
    final StringBuffer url =
        new StringBuffer(BASE_URL + "/wp-json/api/v1/getAttibuteProperty");
    Dio dio = new Dio();
    var token = await _getToken();
    try {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";

        print(dio.options.headers);
      }
      final response = await dio.get(url.toString());

      return response.data;
    } on DioError catch (e) {
      print(e);
    }
  }

  Future<ImageProperty> uploadImage(File imageFile, processfunction) async {
    final StringBuffer url =
        new StringBuffer(BASE_URL + "/wp-json/wp/v2/media");
    Dio dio = new Dio();
    var token = await _getToken();

    try {
      FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(imageFile.path)},
      );
      print(url);
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";

        print(dio.options.headers);
      }
      var response = await dio.post(
        url.toString(),
        data: formData,
        onSendProgress: processfunction,
      );

      var respon = response.data;
      ImageProperty result = ImageProperty(
          id: respon['id'],
          mediaType: respon['type'],
          sourceUrl: respon['source_url']);

      return Future.value(result);
    } on DioError catch (e) {
      print(e);
    }
  }

  Future sumbitProperty(Property property) async {
    try {
      final StringBuffer url =
          new StringBuffer(BASE_URL + "/wp-json/api/v1/registerProperty");
      Dio dio = new Dio();
      var token = await _getToken();

      try {
        if (token != null) {
          dio.options.headers["Authorization"] = "Bearer $token";
        }
        final response =
            await dio.post(url.toString(), data: property.toJson());
        return response;
      } on DioError catch (e) {
        print(e);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Package>> getPackages() async {
    try {
      final StringBuffer url =
          new StringBuffer(BASE_URL + "/wp-json/wp/v2/package");
      Dio dio = new Dio();
      var token = await _getToken();

      try {
        if (token != null) {
          dio.options.headers["Authorization"] = "Bearer $token";
        }

        print(token);
        final response = await dio.get(url.toString());

        List<Package> listPackage = [];
        for (var item in response.data) {
          listPackage.add(new Package.fromJson(item));
        }

        return listPackage;
      } on DioError catch (e) {
        print(e.response);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map> getPaymentInvoice(int packageId) async {
    try {
      final StringBuffer url = new StringBuffer(
          BASE_URL + "/wp-json/api/v1/paymentInvoice?package_id=$packageId");
      Dio dio = new Dio();
      var token = await _getToken();

      try {
        if (token != null) {
          dio.options.headers["Authorization"] = "Bearer $token";
        }

        print(url);
        final response = await dio.get(url.toString());
        print(response.data);

        return response.data;
      } on DioError catch (e) {
        print(e.response);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future sumbitDetailPayment(File imagesPick, String name, String phone) async {
    final StringBuffer url = new StringBuffer(
        BASE_URL + "/wp-json/contact-form-7/v1/contact-forms/4841/feedback");
    Dio dio = new Dio();
    var token = await _getToken();

    try {
      FormData formData = FormData.fromMap(
        {
          "text-697": name,
          "number-227": phone,
          "file-687": await MultipartFile.fromFile(imagesPick.path),
        },
      );
      print(url);
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";

        print(dio.options.headers);
      }
      var response = await dio.post(
        url.toString(),
        data: formData,
        // onSendProgress: processfunction,
      );

      var respon = response.data;

      print(respon);

      return Future.value(respon);
    } on DioError catch (e) {
      print(e);
    }
  }

  Future addPackageUser(int packageId) async {
    try {
      final StringBuffer url =
          new StringBuffer(BASE_URL + "/wp-json/api/v1/addPackageUser");
      Dio dio = new Dio();
      var token = await _getToken();

      try {
        if (token != null) {
          dio.options.headers["Authorization"] = "Bearer $token";
        }
        print(url);
        final response =
            await dio.post(url.toString(), data: {"package_id": packageId});

        print(response.data);

        return response.data;
      } on DioError catch (e) {
        print(e.response);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchInvoiceList(int page) async {
    // await _headerSetToken();
    final StringBuffer url = new StringBuffer(BASE_URL + URL_INVOICE);
    var token = await _getToken();

    print(url);
    try {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }

      print(token);

      final response = await dio.get(
        url.toString(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<Invoice> invoices = new List<Invoice>();

        final list = response.data;

        for (var invoice in list) {
          invoices.add(Invoice.fromJson(invoice));
        }
        return Future.value([invoices, response.headers['x-wp-total']]);
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  Future getPageDetail(String id) async {
   
    final StringBuffer url = new StringBuffer(BASE_URL + URL_PAGES + "/$id");

    print(url);

    try {
      final response = await dio.get(
        url.toString(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
      
        return Future.value(response.data);
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }

  Future deleteProperty(id)  async{

     final StringBuffer url =
        new StringBuffer(BASE_URL + URL_PROPERTY+"/$id");
    print(url);
    var token = await _getToken();
    try {
      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      final response =
          await dio.delete(url.toString());

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.data;
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }
}
