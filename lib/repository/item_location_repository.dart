import 'dart:async';
import 'package:hatbazar/db/item_loacation_dao.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/api/ps_api_service.dart';
import 'package:hatbazar/viewobject/item_location.dart';

import 'Common/ps_repository.dart';

class ItemLocationRepository extends PsRepository {
  ItemLocationRepository(
      {@required PsApiService psApiService,
      @required ItemLocationDao itemLocationDao}) {
    _psApiService = psApiService;
    _itemLocationDao = itemLocationDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ItemLocationDao _itemLocationDao;

  Future<dynamic> insert(ItemLocation itemLocation) async {
    return _itemLocationDao.insert(primaryKey, itemLocation);
  }

  Future<dynamic> update(ItemLocation itemLocation) async {
    return _itemLocationDao.update(itemLocation);
  }

  Future<dynamic> delete(ItemLocation itemLocation) async {
    return _itemLocationDao.delete(itemLocation);
  }

  Future<dynamic> getAllItemLocationList(
      StreamController<PsResource<List<ItemLocation>>> itemLocationListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemLocationListStream.sink
        .add(await _itemLocationDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemLocation>> _resource =
          await _psApiService.getItemLocationList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemLocationDao.deleteAll();
        await _itemLocationDao.insertAll(primaryKey, _resource.data);
        itemLocationListStream.sink.add(await _itemLocationDao.getAll());
        //finder: Finder(sortOrders: [SortOrder(primaryKey, false)])));
      }
    }
  }

  Future<dynamic> getNextPageItemLocationList(
      StreamController<PsResource<List<ItemLocation>>> itemLocationListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemLocationListStream.sink
        .add(await _itemLocationDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ItemLocation>> _resource =
          await _psApiService.getItemLocationList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _itemLocationDao.insertAll(primaryKey, _resource.data);
      }
      itemLocationListStream.sink.add(await _itemLocationDao.getAll());
    }
  }
}
