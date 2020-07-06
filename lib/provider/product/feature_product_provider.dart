import 'dart:async';

import 'package:hatbazar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/provider/common/ps_provider.dart';
import 'package:hatbazar/repository/product_repository.dart';
import 'package:hatbazar/viewobject/holder/product_parameter_holder.dart';
import 'package:hatbazar/viewobject/product.dart';

class FeaturedProductProvider extends PsProvider {
  FeaturedProductProvider({@required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('FeaturedProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();

    subscription =
        productListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _productList = resource;
      _productList.data = Product().checkDuplicate(resource.data);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ProductRepository _repo;
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productList => _productList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> productListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Feature Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getProductList(
        productListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        ProductParameterHolder().getFeaturedParameterHolder());
  }

  Future<dynamic> nextProductList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getProductList(
          productListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          ProductParameterHolder().getFeaturedParameterHolder());
    }
  }
}
