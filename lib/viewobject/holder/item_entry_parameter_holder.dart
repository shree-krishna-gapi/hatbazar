import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart'
    show PsHolder;

class ItemEntryParameterHolder extends PsHolder<ItemEntryParameterHolder> {
  ItemEntryParameterHolder({
    this.catId,
    this.subCatId,
    this.itemTypeId,
    this.itemPriceTypeId,
    this.itemCurrencyId,
    this.conditionOfItemId,
    this.itemLocationId,
    this.dealOptionRemark,
    this.description,
    this.highlightInfomation,
    this.price,
    this.dealOptionId,
    this.brand,
    this.businessMode,
    this.isSoldOut,
    this.title,
    this.address,
    this.latitude,
    this.longitude,
    this.id,
    this.addedUserId,
    this.stateId,
    this.districtId,
    this.municipalityId,
  });

  final String catId;
  final String subCatId;
  final String itemTypeId;
  final String itemPriceTypeId;
  final String itemCurrencyId;
  final String conditionOfItemId;
  final String itemLocationId;
  final String dealOptionRemark;
  final String description;
  final String highlightInfomation;
  final String price;
  final String dealOptionId;
  final String brand;
  final String businessMode;
  final String isSoldOut;
  final String title;
  final String address;
  final String latitude;
  final String longitude;
  final String id;
  final String addedUserId;
  final int stateId;
  final int districtId;
  final int municipalityId;
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['cat_id'] = catId;
    map['sub_cat_id'] = subCatId;
    map['item_type_id'] = itemTypeId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['condition_of_item_id'] = conditionOfItemId;
    map['item_location_id'] = itemLocationId;
    map['deal_option_remark'] = dealOptionRemark;
    map['description'] = description;
    map['highlight_info'] = highlightInfomation;
    map['price'] = price;
    map['deal_option_id'] = dealOptionId;
    map['brand'] = brand;
    map['business_mode'] = businessMode;
    map['is_sold_out'] = isSoldOut;
    map['title'] = title;
    map['address'] = address;
    map['lat'] = latitude;
    map['lng'] = longitude;
    map['id'] = id;
    map['added_user_id'] = addedUserId;
    map['state_id']= stateId;
    map['district_id'] = districtId;
    map['municipality_id'] = municipalityId;
    return map;
  }

  @override
  ItemEntryParameterHolder fromMap(dynamic dynamicData) {
    return ItemEntryParameterHolder(
      catId: dynamicData['cat_id'],
      subCatId: dynamicData['sub_cat_id'],
      itemTypeId: dynamicData['item_type_id'],
      itemPriceTypeId: dynamicData['item_price_type_id'],
      itemCurrencyId: dynamicData['item_currency_id'],
      conditionOfItemId: dynamicData['condition_of_item_id'],
      itemLocationId: dynamicData['item_location_id'],
      dealOptionRemark: dynamicData['deal_option_remark'],
      description: dynamicData['description'],
      highlightInfomation: dynamicData['highlight_info'],
      price: dynamicData['price'],
      dealOptionId: dynamicData['deal_option_id'],
      brand: dynamicData['brand'],
      businessMode: dynamicData['business_mode'],
      isSoldOut: dynamicData['is_sold_out'],
      title: dynamicData['title'],
      address: dynamicData['address'],
      latitude: dynamicData['lat'],
      longitude: dynamicData['lng'],
      id: dynamicData['id'],
      addedUserId: dynamicData['added_user_id'],
      stateId: dynamicData['state_id'],
      districtId: dynamicData['district_id'],
      municipalityId: dynamicData['municipality_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (catId != '') {
      key += catId;
    }
    if (subCatId != '') {
      key += subCatId;
    }
    if (itemTypeId != '') {
      key += itemTypeId;
    }
    if (itemPriceTypeId != '') {
      key += itemPriceTypeId;
    }
    if (itemCurrencyId != '') {
      key += itemCurrencyId;
    }
    if (conditionOfItemId != '') {
      key += conditionOfItemId;
    }
    if (itemLocationId != '') {
      key += itemLocationId;
    }
    if (dealOptionRemark != '') {
      key += dealOptionRemark;
    }
    if (description != '') {
      key += description;
    }
    if (highlightInfomation != '') {
      key += highlightInfomation;
    }
    if (price != '') {
      key += price;
    }
    if (dealOptionId != '') {
      key += dealOptionId;
    }
    if (brand != '') {
      key += brand;
    }
    if (businessMode != '') {
      key += businessMode;
    }
    if (isSoldOut != '') {
      key += isSoldOut;
    }
    if (title != '') {
      key += title;
    }
    if (address != '') {
      key += address;
    }
    if (latitude != '') {
      key += latitude;
    }
    if (longitude != '') {
      key += longitude;
    }
    if (id != '') {
      key += id;
    }
    if (addedUserId != '') {
      key += addedUserId;
    }
    return key;
  }
}
