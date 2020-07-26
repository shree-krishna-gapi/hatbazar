import 'dart:async';
import 'package:flutterbuyandsell/repository/video_repository.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/video.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/provider/common/ps_provider.dart';

class VideoProvider extends PsProvider {
  VideoProvider({@required VideoRepository repo, int limit = 0}) : super(repo,limit) {
    if (limit != 0) {
      super.limit = limit;
    }
    _repo = repo;

    print('Video Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    videoListStream = StreamController<PsResource<List<Video>>>.broadcast();
    subscription =
        videoListStream.stream.listen((PsResource<List<Video>> resource) {
      updateOffset(resource.data.length);

      _videoList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  VideoRepository _repo;

  PsResource<List<Video>> _videoList =
      PsResource<List<Video>>(PsStatus.NOACTION, '', <Video>[]);

  PsResource<List<Video>> get videoList => _videoList;
  StreamSubscription<PsResource<List<Video>>> subscription;
  StreamController<PsResource<List<Video>>> videoListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Video Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadVideoList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllVideoList(videoListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextVideoList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageVideoList(videoListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetVideoList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllVideoList(videoListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
