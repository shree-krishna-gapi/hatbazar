import 'dart:async';
import 'package:hatbazar/repository/contact_us_repository.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/api_status.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/provider/common/ps_provider.dart';

class ContactUsProvider extends PsProvider {
  ContactUsProvider({@required ContactUsRepository repo, int limit = 0}) : super(repo,limit) {
    _repo = repo;
    print('ContactUs Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  ContactUsRepository _repo;

  PsResource<ApiStatus> _contactUs =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _contactUs;

  @override
  void dispose() {
    isDispose = true;
    print('ContactUs Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postContactUs(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _contactUs = await _repo.postContactUs(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _contactUs;
  }
}
