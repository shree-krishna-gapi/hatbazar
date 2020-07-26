//to changed normal player into youtube player
//past this code in ui/dashboard/video_blog/video_blog.dart
//


import 'package:flutter/material.dart';

import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import '../video_blog/videoService.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterbuyandsell/gapi/fadeAnimation.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class BlogVideo extends StatefulWidget {
  BlogVideo({this.title,this.description,this.videoSrc});
  final String title;
  final String description;
  final String videoSrc;
  @override
  _BlogVideoState createState() => _BlogVideoState();
}

class _BlogVideoState extends State<BlogVideo> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//class BlogVideo extends StatefulWidget {
//  BlogVideo({this.title,this.description,this.videoSrc});
//  final String title;
//  final String description;
//  final String videoSrc;
//  @override
//  _BlogVideoState createState() => _BlogVideoState();
//}
//
//class _BlogVideoState extends State<BlogVideo> {
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//  YoutubePlayerController _controller;
//  TextEditingController _idController;
//  TextEditingController _seekToController;
//
//  PlayerState _playerState;
//  YoutubeMetaData _videoMetaData;
//  double _volume = 100;
//  bool _muted = false;
//  bool _isPlayerReady = false;
//  String usedTitle;
//  String usedDescription;
//  String videoId;
//
//  @override
//  void initState() {
//    super.initState();
//    playFn(widget.videoSrc);
//  }
//  playFn(String url) {
//    videoId = YoutubePlayer.convertUrlToId(url);
//    _controller = YoutubePlayerController(
//      initialVideoId: videoId,
//      flags: const YoutubePlayerFlags(
//        mute: false,
//        autoPlay: true,
//        disableDragSeek: false,
//        loop: false,
//        isLive: false,
//        forceHD: false,
//        enableCaption: true,
//      ),
//    )..addListener(listener);
//    _idController = TextEditingController();
//    _seekToController = TextEditingController();
//    _videoMetaData = const YoutubeMetaData();
//    _playerState = PlayerState.unknown;
//  }
//  void listener() {
//    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
//      setState(() {
//        _playerState = _controller.value.playerState;
//        _videoMetaData = _controller.metadata;
//      });
//    }
//  }
//
//  @override
//  void deactivate() {
//    // Pauses video while navigating to next page.
//    _controller.pause();
//    super.deactivate();
//  }
//
//  @override
//  void dispose() {
//    _controller.dispose();
//    _idController.dispose();
//    _seekToController.dispose();
//    super.dispose();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
////    usedTitle = widget.title;
////    usedDescription = widget.description;
//    return YoutubePlayerBuilder(
////      onExitFullScreen: () {
////        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
////        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
////      },
//      player: YoutubePlayer(
//        controller: _controller,
//        showVideoProgressIndicator: true,
//        progressIndicatorColor: Colors.green,
//        topActions: <Widget>[
//          const SizedBox(width: 8.0),
//          Text(
//            _controller.metadata.title,
//            style: const TextStyle(
//              color: Colors.white,
//              fontSize: 18.0,
//            ),
//            overflow: TextOverflow.ellipsis,
//            maxLines: 1,
//          )
//
//        ],
//        onReady: () {
//          _isPlayerReady = true;
//        },
//
//        onEnded: (data) {
//          _controller
//              .load(videoId);
//          _showSnackBar('Next Video Started!');
//        },
//      ),
//      builder: (context, player) => Scaffold(
//        key: _scaffoldKey,
//
//
//        body: ListView(
//          children: [
//            player,
//            Column(
//              mainAxisSize: MainAxisSize.max,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(12,10,15,5),
//                  child: Text('$usedDescription',
//                      style: Theme.of(context).textTheme.headline6.copyWith(
//                          fontWeight: FontWeight.w600, fontSize: 18,
//                          color: PsColors.textPrimaryDarkColor)),
//                ),
//                Padding(
//                    padding: const EdgeInsets.only(
//                        left: PsDimens.space12,
//                        right: PsDimens.space12,
//                        bottom: PsDimens.space4),
//                    child:  Text('$usedTitle',style: TextStyle(
//                        fontSize: 12,color: Colors.black38
//                    ),)
//                ),
//
//              ],
//            ),
//            Padding(
//              padding: const EdgeInsets.only( top: PsDimens.space18,
//                  left: PsDimens.space16,
//                  right: PsDimens.space16,
//                  bottom: PsDimens.space10),
//              child: Text( Utils.getString(context, 'news__section__main__tab__pages_heading3'),
//                  style: Theme.of(context).textTheme.headline6.copyWith(
//                      fontWeight: FontWeight.w700,
//                      color: PsColors.textPrimaryDarkColor)),
//            ),
//            Expanded(
//              child: Container(
//                height: 220,
////                color: Colors.red,
//                child: FutureBuilder<List<VideoServices>>(
//                    future: FetchVideoServices(http.Client()),
//                    builder: (context, snapshot) {
//                      if (snapshot.hasError) ;
//                      return snapshot.hasData ?
//                      ListView.builder(
//                          scrollDirection: Axis.horizontal,
//                          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
//                          itemBuilder: (BuildContext context,int index) {
//                            return Container(
//                              height: 220,
//                              width: 140,
//                              margin: EdgeInsets.only(left: 10),
//                              child: InkWell(
//                                onTap: () {
//                                  setState(() {
//                                    usedTitle = snapshot.data[index].title;
//                                    usedDescription = snapshot.data[index].description;
//                                  });
//                                  playFn(snapshot.data[index].videoUrl);
//                                },
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Stack(
//                                      children: <Widget>[
//                                        Container(
//                                          color: Colors.green,
//                                          width: double.infinity,
//                                          height: 100,
//                                          child: CachedNetworkImage(
//                                            alignment: Alignment.topLeft,
//                                            placeholder: (context, url) => Image.asset(
//                                              'assets/images/placeholder_image.png',
//                                              width: double.infinity,
//                                              height: 80.0,
//                                              fit: BoxFit.fitWidth,
//                                            ),
//                                            imageUrl: '${PsConfig.ps_app_image_thumbs_url}${snapshot.data[index].imgPath}',
//                                            fit: BoxFit.cover,
//                                            errorWidget: (context, url, error) => Image.asset(
//                                              'assets/images/placeholder_image.png',
//                                              width: double.infinity,
////                      height: blogImageHeight,
//                                              fit: BoxFit.fitWidth,
//                                            ),
//                                          ),
//                                        ),
//                                        Positioned(child: Container(
//                                          padding: EdgeInsets.fromLTRB(5, 2, 5, 2)
//                                          ,child: Text('${snapshot.data[index].addedDateStr}',style: TextStyle(color: Colors.white, fontSize: 12),
//
//                                        ), color: Colors.black38,),
//                                          bottom: 5, right: 5,),
//
//                                      ],
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.only(top:8.0,bottom:3.0),
//                                      child: Text('${snapshot.data[index].description}'),
//                                    ),
//                                    Text('${snapshot.data[index].title}',style: TextStyle(
//                                        fontSize: 12,color: Colors.black38
//                                    ),)
//                                  ],
//                                ),
//                              ),
//                            ); } ) : Center(child: CircularProgressIndicator()); } ),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }  void _showSnackBar(String message) {
//    _scaffoldKey.currentState.showSnackBar(
//      SnackBar(
//        content: Text(
//          message,
//          textAlign: TextAlign.center,
//          style: const TextStyle(
//            fontWeight: FontWeight.w300,
//            fontSize: 16.0,
//          ),
//        ),
//        backgroundColor: Colors.green,
//        behavior: SnackBarBehavior.floating,
//        elevation: 1.0,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(50.0),
//        ),
//      ),
//    );
//  }
//}
