import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import './auth_service.dart';

class AuthServiceFirebase extends AuthService {
  String token;
  DateTime tokenCreationDate;
  int tokenLifetimeInMinutes = 5;
  BuildContext context;
  String phoneNumber;
  String userId;

  AuthServiceFirebase({@required this.context});

  @override
  Future<String> submitPhoneNumber({String phoneNumber}) async {
    Completer<String> c = Completer();

    PhoneCodeSent codeSent = (verificationId, [forceResendingToken]) {
      print('SMS sent');
      c.complete(verificationId);
    };

    PhoneVerificationFailed phoneVerificationFailed = (authException) {
      print('phone verification failed');
      // authException.code
      print(authException.message);
      c.completeError(authException);
    };

    PhoneVerificationCompleted phoneVerificationCompleted = (firebaseUser) {
    
      FirebaseAuth.instance
          .signInWithCredential(firebaseUser)
          .catchError((err) {
        c.completeError(err);
      });

      c.complete("done");
    };

    String phoneEdit = phoneNumber.contains("+")
        ? phoneNumber
        : "+93${phoneNumber.substring(0)}";

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneEdit,
        timeout: Duration(seconds: 100),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: null);

    return c.future;
  }

  @override
  Future<UserAuthData> confirmSMSCode(
      {String verificationId, String smsCode}) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    var firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return UserAuthData(
        uid: firebaseUser.user.uid,
        phoneNr: firebaseUser.user.phoneNumber ?? '');
  }

  @override
  Future<UserAuthData> getCurrentUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser == null) return null;
    return UserAuthData(  uid: firebaseUser.uid, phoneNr: firebaseUser.phoneNumber ?? '');
  }

  @override
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  @override
  Future<String> getToken() async {
    if (_tokenIsExpired()) {
      await _refreshToken();
    }
    return token;
  }

  bool _tokenIsExpired() {
    if (token == null) return true;
    if (token != null &&
        DateTime.now().difference(tokenCreationDate).abs().inMinutes >
            tokenLifetimeInMinutes) return true;
    return false;
  }

  Future<void> _refreshToken() async {
    var user = await FirebaseAuth.instance.currentUser();
    tokenCreationDate = DateTime.now();
    token = (await user.getIdToken()) as String;

    // print(user.getIdToken());
  }
}
