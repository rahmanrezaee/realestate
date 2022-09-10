import 'dart:convert';
import 'dart:async';

import 'package:badam/apiReqeust/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import "package:dio/dio.dart";
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class Auth with ChangeNotifier {
  // final BASE_URL = "http://192.168.43.186/badamsite";
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _phonenumber;
  String _nickname;
  Timer _authTimer;

  String get phoneNumber => _phonenumber;
  String get nickname => _nickname;

  Status _status = Status.Uninitialized;
  Status get status => _status;
  Future<bool> tokenValided() => Future.value(_token == null);
  String get token => this._token;
  Dio dio = new Dio();
  Future<bool> isAuth() async {
    // final prefs = await SharedPreferences.getInstance();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString("userData") != null);
  }

  Future<String> getToken() async {
    // final prefs = await SharedPreferences.getInstance();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future.value(prefs.getString("userData"));
  }

  // bool get isAuth {
  //   return token != null;
  // }

  String get userId {
    return _userId;
  }

  Future _authenticate(String username, String password) async {
    final url = '$BASE_URL/wp-json/jwt-auth/v1/token';

    try {
      final response = await dio.post(url, data: {
        'username': username,
        'password': password,
      });

      final responseData = response.data;

      print(responseData);

      if (responseData['error'] != null) {
        return Future(responseData['error']['message']);
      }
      _token = responseData['token'];
      _userId = responseData['id'].toString();
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['exp'].toString(),
          ),
        ),
      );

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'user_email': responseData['user_email'],
          'user_nicename': responseData['user_nicename'],
          'expiryDate': _expiryDate.toIso8601String(),
          'username': username,
          'password': password,
        },
      );
      prefs.setString('userData', userData);

      return Future.value([true, userData]);
    } on DioError catch (e) {
      if (e.response.statusCode == 403) {
        print(e.response.data['code']);

        return Future.value([false, e.response.data['code']]);
      }
    }
  }

  Future<bool> userAlreadyExits(String phone) async {
    phone = phone.substring(1);
    String phoneEdit = phone.contains("+") ? phone : "+93${phone.substring(0)}";
    print(phoneEdit);
    final url = '$BASE_URL/wp-json/api/v1/alreadyRegister?phone=$phoneEdit';
    print(url);
    try {
      final response = await dio.get(url);

      return Future.value(response.data);
    } on DioError catch (e) {
      print(e.response);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password);
  }

  Future login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<bool> tryGetToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') == null) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    await login(extractedUserData['username'], extractedUserData['password']);
    return true;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') == null) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    // print(extractedUserData);
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _nickname = extractedUserData['user_nicename'];
    _phonenumber = extractedUserData['phoneNumber'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

Future userAlreadyRegisterd(username) async {
  return await http.post(
      BASE_URL + "wp-json/badam/v1/isUserRegisterd",
      body: {
        "username": username,
      }).timeout(Duration(seconds: 30));
}

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;

    print("logut");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future loginWithPhoneNumber({String phone, String password}) async {
    String phoneEdit = phone.contains("+") ? phone : "+93${phone.substring(1)}";

    print(phoneEdit);

    try {
      final response =
          await dio.post("$BASE_URL/wp-json/jwt-auth/v1/token", data: {
        'username': phoneEdit,
        'password': password,
      });

      print("${BASE_URL}/wp-json/api/v1/loginUser");
      final responseData = response.data;
      print(responseData);
      if (responseData["token"] != null) {
        _token = responseData['token'];
        _userId = responseData['id'].toString();
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(
              responseData['exp'].toString(),
            ),
          ),
        );

        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'userId': _userId,
            'user_email': responseData['user_email'],
            'user_nicename': responseData['user_nicename'],
            'expiryDate': _expiryDate.toIso8601String(),
            'phoneNumber': phone,
            'password': password,
          },
        );
        prefs.setString('userData', userData);

        return Future.value([true, userData]);
      } else {
        throw Exception(responseData);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 403) {
        return Future.value([false, e.response.data['message']]);
      }
    }
  }

  Future registerUser({
    @required String registerType,
    @required String fullname,
    @required String phoneNumber,
    String agencyName,
    String agencyAddress,
    String idCard,
    String lyciseId,
    @required String email,
    @required String password,
  }) async {
    String phoneEdit = phoneNumber.contains("+")
        ? phoneNumber
        : "+93${phoneNumber.substring(0)}";
    // print("${BASE_URL}/wp-json/api/v1/user");
    try {
      Map formData = {
        'user_phone': phoneEdit,
        'user_fullname': fullname,
        'email': email,
        'user_password': password,
        'license': lyciseId,
        'identity_number': idCard,
        'agency_address': agencyAddress,
        'agency_name': agencyName,
        'registerType': registerType,
      };
      // print(formData);
      final response =
          await dio.post("${BASE_URL}/wp-json/api/v1/user", data: formData);
      final responseData = response.data;
      // print(responseData);

      return Future.value(responseData);
    } catch (e) {
      print(e.message);
    }
  }

  Future<String> _getToken() async {
    var auth = Auth();
    bool isAuth = await auth.tryAutoLogin();

    return isAuth ? Future.value(auth.token) : Future.value(null);
  }

  Future<bool> addToFavorite(int id) async {
    try {
      var token = await _getToken();

      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      final response = await dio.post(
          "$BASE_URL/wp-json/api/v1/add-to-favorite",
          data: {"property_id": id});
      final responseData = response.data;
      print(responseData);
      return (responseData['added'] < 0)
          ? Future.value(false)
          : Future.value(true);
    } catch (e) {
      print(e.message);
    }
  }

  Future infoMe() async {
    try {
      var token = await _getToken();

      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      final response = await dio.get(
        "${BASE_URL}/wp-json/api/v1/userData",
      );
      final responseData = response.data;

      return Future.value(responseData);
    } catch (e) {
      print(e.message);
    }
  }

  Future<Map> userData() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    return Future.value(extractedUserData);
  }

  Future updateUser({
    @required String registerType,
    @required String fullname,
    String agencyName,
    String agencyAddress,
    String idCard,
    String lyciseId,
    int profileId,
    @required String email,
  }) async {
    try {
      var token = await _getToken();

      if (token != null) {
        dio.options.headers["Authorization"] = "Bearer $token";
      }

      Map formData = {
        "profile_pic": profileId,
        'user_fullname': fullname,
        'email': email,
        'license': lyciseId,
        'identity_number': idCard,
        'agency_address': agencyAddress,
        'agency_name': agencyName,
        'registerType': registerType,
      };
      // print(formData);
      final response =
          await dio.put("${BASE_URL}/wp-json/api/v1/user", data: formData);

      print(formData);
      final responseData = response.data;
      print(responseData);

      return Future.value(responseData);
    } catch (e) {
      print(e.message);
    }
  }
}
