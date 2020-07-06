import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/api/ps_api_service.dart';
import 'package:hatbazar/repository/Common/ps_repository.dart';
import 'package:hatbazar/viewobject/item_paid_history.dart';

class ItemPaidHistoryRepository extends PsRepository {
  ItemPaidHistoryRepository({@required PsApiService psApiService}) {
    _psApiService = psApiService;
  }
  String primaryKey = 'id';
  PsApiService _psApiService;

  Future<PsResource<ItemPaidHistory>> postItemPaidHistory(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ItemPaidHistory> _resource =
        await _psApiService.postItemPaidHistory(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ItemPaidHistory>> completer =
          Completer<PsResource<ItemPaidHistory>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
