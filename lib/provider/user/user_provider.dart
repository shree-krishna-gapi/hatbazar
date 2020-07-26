import 'dart:async';
import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/apple_login_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/shipping_city.dart';
import 'package:flutterbuyandsell/viewobject/shipping_country.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';

class UserProvider extends PsProvider {
  UserProvider(
      {@required UserRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('User Provider: $hashCode');
    userListStream = StreamController<PsResource<User>>.broadcast();
    subscription = userListStream.stream.listen((PsResource<User> resource) {
      if (resource != null && resource.data != null) {
        _user = resource;
        holderUser = resource.data;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository _repo;
  PsValueHolder psValueHolder;
  User holderUser;
  ShippingCountry selectedCountry;
  ShippingCity selectedCity;
  bool isCheckBoxSelect = false;
  UserParameterHolder userParameterHolder =
      UserParameterHolder().getOtherUserData();

  PsResource<User> _user = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> _holderUser = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> get user => _user;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

  StreamSubscription<PsResource<User>> subscription;
  StreamController<PsResource<User>> userListStream;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('User Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postUserRegister(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserRegister(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserEmailVerify(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserEmailVerify(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postImageUpload(
    String userId,
    String platformName,
    File imageFile,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postImageUpload(userId, platformName, imageFile,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postForgotPassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postForgotPassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postChangePassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postChangePassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postProfileUpdate(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _holderUser = await _repo.postProfileUpdate(jsonMap, isConnectedToInternet,
        PsStatus.SUCCESS); //it is success for this case
    if (_holderUser.status == PsStatus.ERROR &&
        _holderUser != null &&
        _holderUser.data != null) {
      return _user;
    } else {
      _user = _holderUser;
      return _holderUser;
    }
  }

  Future<dynamic> postPhoneLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postPhoneLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserFollow(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserFollow(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postFBLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postFBLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postAppleLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postAppleLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postGoogleLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postGoogleLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postResendCode(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postResendCode(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> getUser(
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getUser(userListStream, loginUserId, isConnectedToInternet,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getUserFromDB(String loginUserId) async {
    isLoading = true;

    await _repo.getUserFromDB(
        loginUserId, userListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getOtherUserData(
      Map<dynamic, dynamic> jsonMap, String otherUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.getOtherUserData(userListStream, jsonMap, otherUserId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> userReportItem(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.userReportItem(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postDeleteUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postDeleteUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<void> loginWithAppleId(
      BuildContext context, Function onAppleIdSignInSelected) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Apple Id Login
        ///
        final FirebaseUser firebaseUser = await _getFirebaseUserWithAppleId();

        if (firebaseUser != null) {
          ///
          /// Got Firebase User
          ///
          Utils.psPrint('User id : ${firebaseUser.uid}');

          ///
          /// Show Progress Dialog
          ///
          PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User> resourceUser =
              await _submitLoginWithAppleId(firebaseUser);

          if (resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onAppleIdSignInSelected != null) {
              onAppleIdSignInSelected(resourceUser.data.userId);
            } else {
              Navigator.pop(context, resourceUser.data);
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: resourceUser.message,
                  );
                });
          }

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
              message: Utils.getString(context, 'login__warning_agree_privacy'),
            );
          });
    }
  }

  Future<PsResource<User>> _submitLoginWithAppleId(FirebaseUser user) async {
    if (user != null) {
      final AppleLoginParameterHolder appleLoginParameterHolder =
          AppleLoginParameterHolder(
              appleId: user.uid,
              userName: user.displayName,
              userEmail: user.email,
              profilePhotoUrl: user.photoUrl,
              deviceToken: psValueHolder.deviceToken);

      final PsResource<User> _apiStatus =
          await postAppleLogin(appleLoginParameterHolder.toMap());

      if (_apiStatus.data != null) {
        replaceVerifyUserData('', '', '', '');
        replaceLoginUserId(_apiStatus.data.userId);
      }
      return _apiStatus;
    } else {
      return null;
    }
  }

  Future<FirebaseUser> _getFirebaseUserWithAppleId() async {
    final List<Scope> scopes = <Scope>[Scope.email, Scope.fullName];

    // 1. perform the sign-in request
    final AuthorizationResult result = await AppleSignIn.performRequests(
        <AppleIdRequest>[AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential;
        const OAuthProvider oAuthProvider =
            OAuthProvider(providerId: 'apple.com');
        final OAuthCredential credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final AuthResult authResult =
            await _firebaseAuth.signInWithCredential(credential);
        FirebaseUser firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final UserUpdateInfo updateUser = UserUpdateInfo();
          updateUser.displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';

          await firebaseUser.updateProfile(updateUser);
        }

        firebaseUser = await _firebaseAuth.currentUser();

        return firebaseUser;
      case AuthorizationStatus.error:
        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }
}
