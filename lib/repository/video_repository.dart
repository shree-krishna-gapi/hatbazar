import 'dart:async';
//import 'package:flutterbuyandsell/db/blog_dao.dart';
import 'package:flutterbuyandsell/db/video_dao.dart';
import 'package:flutterbuyandsell/viewobject/video.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/api/ps_api_service.dart';

import 'Common/ps_repository.dart';

class VideoRepository extends PsRepository {
  VideoRepository(
      {@required PsApiService psApiService, @required VideoDao videoDao}) {
    _psApiService = psApiService;
    _videoDao = videoDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  VideoDao _videoDao;

  Future<dynamic> insert(Video video) async {
    return _videoDao.insert(primaryKey, video);
  }

  Future<dynamic> update(Video video) async {
    return _videoDao.update(video);
  }

  Future<dynamic> delete(Video video) async {
    return _videoDao.delete(video);
  }

  Future<dynamic> getAllVideoList(
      StreamController<PsResource<List<Video>>> videoListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    videoListStream.sink.add(await _videoDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Video>> _resource =
          await _psApiService.getVideoList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _videoDao.deleteAll();
        await _videoDao.insertAll(primaryKey, _resource.data);
        videoListStream.sink.add(await _videoDao.getAll());
      }
    }
  }

  Future<dynamic> getNextPageVideoList(
      StreamController<PsResource<List<Video>>> videoListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    videoListStream.sink.add(await _videoDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Video>> _resource =
          await _psApiService.getVideoList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _videoDao.insertAll(primaryKey, _resource.data);
      }
      videoListStream.sink.add(await _videoDao.getAll());
    }
  }
}
