import 'dart:async';
import 'package:hatbazar/db/about_us_dao.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/api/ps_api_service.dart';
import 'package:hatbazar/viewobject/about_us.dart';

import 'Common/ps_repository.dart';

class AboutUsRepository extends PsRepository {
  AboutUsRepository(
      {@required PsApiService psApiService, @required AboutUsDao aboutUsDao}) {
    _psApiService = psApiService;
    _aboutUsDao = aboutUsDao;
  }

  String primaryKey = 'about_id';
  PsApiService _psApiService;
  AboutUsDao _aboutUsDao;

  Future<dynamic> insert(AboutUs aboutUs) async {
    return _aboutUsDao.insert(primaryKey, aboutUs);
  }

  Future<dynamic> update(AboutUs aboutUs) async {
    return _aboutUsDao.update(aboutUs);
  }

  Future<dynamic> delete(AboutUs aboutUs) async {
    return _aboutUsDao.delete(aboutUs);
  }

  Future<dynamic> getAllAboutUsList(
      StreamController<PsResource<List<AboutUs>>> aboutUsListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    aboutUsListStream.sink.add(await _aboutUsDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<AboutUs>> _resource =
          await _psApiService.getAboutUsDataList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _aboutUsDao.deleteAll();
        await _aboutUsDao.insertAll(primaryKey, _resource.data);
        aboutUsListStream.sink.add(await _aboutUsDao.getAll());
        //finder: Finder(sortOrders: [SortOrder(primaryKey, false)])));
      }
    }
  }

  Future<dynamic> getNextPageAboutUsList(
      StreamController<PsResource<List<AboutUs>>> aboutUsListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    aboutUsListStream.sink.add(await _aboutUsDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<AboutUs>> _resource =
          await _psApiService.getAboutUsDataList();

      if (_resource.status == PsStatus.SUCCESS) {
        await _aboutUsDao.insertAll(primaryKey, _resource.data);
      }
      aboutUsListStream.sink.add(await _aboutUsDao.getAll());
    }
  }
}
