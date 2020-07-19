import 'package:hatbazar/api/common/ps_admob_banner_widget.dart';
import 'package:hatbazar/config/ps_config.dart';
//import 'package:hatbazar/provider/blog/blog_provider.dart';
//import 'package:hatbazar/repository/blog_repository.dart';
//import 'package:hatbazar/ui/blog/item/blog_list_item.dart';
import 'package:hatbazar/provider/video/video_provider.dart';
import 'package:hatbazar/repository/video_repository.dart';
import 'package:hatbazar/ui/video/item/video_list_item.dart';

import 'package:flutter/material.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/constant/route_paths.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';

class VideoListView extends StatefulWidget {
  const VideoListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _VideoListViewState createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  VideoProvider _videoProvider;
  Animation<double> animation;

  @override
  void dispose() {
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _videoProvider.nextVideoList();
      }
    });

    super.initState();
  }

  VideoRepository repo1;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    repo1 = Provider.of<VideoRepository>(context);

    print(
        '............................Build UI Again ............................');

    return ChangeNotifierProvider<VideoProvider>(
      lazy: false,
      create: (BuildContext context) {
        final VideoProvider provider = VideoProvider(repo: repo1);
        provider.loadVideoList();
        _videoProvider = provider;
        return _videoProvider;
      },
      child: Consumer<VideoProvider>(
        builder: (BuildContext context, VideoProvider provider, Widget child) {
          return Column(
            children: <Widget>[
              const PsAdMobBannerWidget(),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space16,
                            right: PsDimens.space16,
                            top: PsDimens.space8,
                            bottom: PsDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      if (provider.videoList.data != null ||
                                          provider.videoList.data.isNotEmpty) {
                                        final int count =
                                            provider.videoList.data.length;
                                        return VideoListItem(
                                          animationController:
                                          widget.animationController,
                                          animation: Tween<double>(
                                              begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                              widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          video: provider.videoList.data[index],
                                          onTap: () {
                                            print(provider.videoList.data[index]
                                                .defaultPhoto.imgPath);
                                            Navigator.pushNamed(
                                                context, RoutePaths.videoDetail,
                                                arguments: provider
                                                    .videoList.data[index]);
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount: provider.videoList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider.resetVideoList();
                          },
                        )),
                    PSProgressIndicator(provider.videoList.status)
                  ],
                ),
              )
            ],
          );
        },
      ),
      // ),
    );
  }
}
