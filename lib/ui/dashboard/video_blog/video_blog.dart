
//https://www.youtube.com/embed/nPt8bK2gbaU

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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:flutter/rendering.dart';

class BlogVideo extends StatefulWidget {
  BlogVideo({this.title,this.description,this.videoSrc});
  final String title;
  final String description;
  final String videoSrc;
  @override
  _BlogVideoState createState() => _BlogVideoState();
}

class _BlogVideoState extends State<BlogVideo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String usedTitle;
  String usedDescription;
  String videoId;
  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.videoSrc);
    playFn(widget.title,widget.description,widget.videoSrc);
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,

//          endAt: 10
      ),
    );
  }
  playFn(title,description,url) {
    String videoId;
    setState(() {
      videoId = YoutubePlayer.convertUrlToId(url);
      usedTitle = title;
      usedDescription = description;
    });
    if(videoId != null) {

      _idController = TextEditingController();
      _seekToController = TextEditingController();
      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    }
    else {

    }
  }

  bool test = false;
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: PsColors.mainColor,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },

      ),
      builder: (context, player) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black54,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            player,
            Padding(
              padding: const EdgeInsets.fromLTRB(12,10,15,5),
              child: Text('$usedDescription',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 18,
                      color: Colors.white.withOpacity(0.8))),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space12,
                    right: PsDimens.space12,
                    bottom: PsDimens.space36),
                child:  Text('$usedTitle',style: TextStyle(
                    fontSize: 12,color: Colors.white.withOpacity(0.8)
                ),)
            ),

          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.close,color: Colors.white.withOpacity(0.8),size: 26,),
          backgroundColor: Colors.transparent , //Colors.white24,
          onPressed: () {Navigator.of(context).pop();},
        ),
      ),
    );
  }
}