import 'dart:async';
import 'package:flutterbuyandsell/db/category_map_dao.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/category_map.dart';
import 'package:flutterbuyandsell/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/api/ps_api_service.dart';
import 'package:flutterbuyandsell/db/cateogry_dao.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:sembast/sembast.dart';
import 'Common/ps_repository.dart';

class CategoryRepository extends PsRepository {
  CategoryRepository(
      {@required PsApiService psApiService,
      @required CategoryDao categoryDao}) {
    _psApiService = psApiService;
    _categoryDao = categoryDao;
  }

  String primaryKey = 'cat_id';
  String mapKey = 'map_key';
  PsApiService _psApiService;
  CategoryDao _categoryDao;

  void sinkCategoryListStream(
      StreamController<PsResource<List<Category>>> categoryListStream,
      PsResource<List<Category>> dataList) {
    if (dataList != null && categoryListStream != null) {
      categoryListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Category category) async {
    return _categoryDao.insert(primaryKey, category);
  }

  Future<dynamic> update(Category category) async {
    return _categoryDao.update(category);
  }

  Future<dynamic> delete(Category category) async {
    return _categoryDao.delete(category);
  }

  Future<dynamic> getCategoryList(
      StreamController<PsResource<List<Category>>> categoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      // CategoryParameterHolder holder,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkCategoryListStream(
        categoryListStream, await _categoryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Category>> _resource =
          await _psApiService.getCategoryList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Delete and Insert Map Dao
        await _categoryDao.deleteAll();

        // Insert Category
        await _categoryDao.insertAll(primaryKey, _resource.data);
      }

      // Load updated Data from Db and Send to UI
      sinkCategoryListStream(categoryListStream, await _categoryDao.getAll());
    }
  }

  Future<dynamic> getAllCategoryList(
      StreamController<PsResource<List<Category>>> categoryListStream,
      bool isConnectedToInternet,
      CategoryParameterHolder holder,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final CategoryMapDao categoryMapDao = CategoryMapDao.instance;

    sinkCategoryListStream(
        categoryListStream,
        await _categoryDao.getAllByMap(
            primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap(),
            status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Category>> _resource =
          await _psApiService.getAllCategoryList(holder.toMap());

      if (_resource.status == PsStatus.SUCCESS) {
        final List<CategoryMap> categoryMapList = <CategoryMap>[];
        int i = 0;
        for (Category data in _resource.data) {
          categoryMapList.add(CategoryMap(
              id: data.catId + paramKey,
              mapKey: paramKey,
              categoryId: data.catId,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        await categoryMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        await categoryMapDao.insertAll(primaryKey, categoryMapList);

        // Insert Category
        await _categoryDao.insertAll(primaryKey, _resource.data);
      }
      // Load updated Data from Db and Send to UI
      sinkCategoryListStream(
          categoryListStream,
          await _categoryDao.getAllByMap(
              primaryKey, mapKey, paramKey, categoryMapDao, CategoryMap()));
    }
  }

  Future<dynamic> getNextPageCategoryList(
      StreamController<PsResource<List<Category>>> categoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao

    sinkCategoryListStream(
        categoryListStream, await _categoryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Category>> _resource =
          await _psApiService.getCategoryList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _categoryDao.getAll();

        await _categoryDao.insertAll(primaryKey, _resource.data);
      }
      sinkCategoryListStream(categoryListStream, await _categoryDao.getAll());
    }
  }

  Future<PsResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postTouchCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
