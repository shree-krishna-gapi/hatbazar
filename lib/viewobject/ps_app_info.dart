import 'package:flutterbuyandsell/viewobject/common/ps_object.dart';
import 'package:flutterbuyandsell/viewobject/delete_object.dart';
import 'package:flutterbuyandsell/viewobject/ps_app_version.dart';

class PSAppInfo extends PsObject<PSAppInfo> {
  PSAppInfo(
      {this.psAppVersion,
      this.deleteObject,
      this.oneDay,
      this.currencySymbol,
      this.currencyShortForm,
      this.stripePublishableKey,
      this.paypalEnable,
      this.stripeEnable});
  PSAppVersion psAppVersion;
  List<DeleteObject> deleteObject;
  String oneDay;
  String currencySymbol;
  String currencyShortForm;
  String stripePublishableKey;
  String stripeEnable;
  String paypalEnable;

  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  PSAppInfo fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PSAppInfo(
          psAppVersion: PSAppVersion().fromMap(dynamicData['version']),
          deleteObject:
              DeleteObject().fromMapList(dynamicData['delete_history']),
          oneDay: dynamicData['oneday'],
          currencySymbol: dynamicData['currency_symbol'],
          currencyShortForm: dynamicData['currency_short_form'],
          stripePublishableKey: dynamicData['stripe_publishable_key'],
          paypalEnable: dynamicData['paypal_enabled'],
          stripeEnable: dynamicData['stripe_enabled']);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['version'] = PSAppVersion().fromMap(object.psAppVersion);
      data['delete_history'] = object.deleteObject.toList();
      data['oneday'] = object.oneDay;
      data['currency_symbol'] = object.currencySymbol;
      data['currency_short_form'] = object.currencyShortForm;
      data['stripe_publishable_key'] = object.stripePublishableKey;
      data['stripe_enabled'] = object.stripeEnable;
      data['paypal_enabled'] = object.paypalEnable;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PSAppInfo> fromMapList(List<dynamic> dynamicDataList) {
    final List<PSAppInfo> psAppInfoList = <PSAppInfo>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          psAppInfoList.add(fromMap(json));
        }
      }
    }
    return psAppInfoList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList;
  }
}
