import 'package:flutter/cupertino.dart';
import 'package:hatbazar/provider/promotion/item_promotion_provider.dart';
import 'package:hatbazar/viewobject/product.dart';

class PaidHistoryHolder {
  const PaidHistoryHolder(
      {@required this.product,
      @required this.amount,
      @required this.howManyDay,
      @required this.paymentMethod,
      @required this.stripePublishableKey,
      @required this.startDate,
      @required this.startTimeStamp,
      @required this.itemPaidHistoryProvider});

  final Product product;
  final String amount;
  final String howManyDay;
  final String paymentMethod;
  final String stripePublishableKey;
  final String startDate;
  final String startTimeStamp;
  final ItemPromotionProvider itemPaidHistoryProvider;
}
