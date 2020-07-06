import 'package:flutter/material.dart';
import '../../product.dart';

class ProductDetailIntentHolder {
  const ProductDetailIntentHolder({
    this.id,
    @required this.product,
    this.heroTagImage,
    this.heroTagTitle,
  });

  final String id;
  final Product product;
  final String heroTagImage;
  final String heroTagTitle;
}
