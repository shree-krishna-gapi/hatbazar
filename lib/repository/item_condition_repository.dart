import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hatbazar/db/item_condition_dao.dart';
import 'package:hatbazar/viewobject/condition_of_item.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/api/ps_api_service.dart';
import 'package:hatbazar/repository/Common/ps_repository.dart';

class ItemConditionRepository extends PsRepository {
  ItemConditionRepository(
      {@required PsApiService psApiService,
      @required ItemConditionDao itemConditionDao}) {
    _psApiService = psApiService;
    _itemConditionDao = itemConditionDao;
  }

  PsApiService _psApiService;
  ItemConditionDao _itemConditionDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.insert(_primaryKey, conditionOfItem);
  }

  Future<dynamic> update(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.update(conditionOfItem);
  }

  Future<dynamic> delete(ConditionOfItem conditionOfItem) async {
    return _itemConditionDao.delete(conditionOfItem);
  }

  Future<dynamic> getItemConditionList(
      StreamController<PsResource<List<ConditionOfItem>>>
          itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ConditionOfItem>> _resource =
        await _psApiService.getItemConditionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      await _itemConditionDao.insertAll(_primaryKey, _resource.data);
      itemConditionListStream.sink.add(await _itemConditionDao.getAll());
    }
  }

  Future<dynamic> getNextPageItemConditionList(
      StreamController<PsResource<List<ConditionOfItem>>>
          itemConditionListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    itemConditionListStream.sink
        .add(await _itemConditionDao.getAll(status: status));

    final PsResource<List<ConditionOfItem>> _resource =
        await _psApiService.getItemConditionList(limit, offset);

    if (_resource.status == PsStatus.SUCCESS) {
      _itemConditionDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        itemConditionListStream.sink.add(await _itemConditionDao.getAll());
      });
    } else {
      itemConditionListStream.sink.add(await _itemConditionDao.getAll());
    }
  }
}
