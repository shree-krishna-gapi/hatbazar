import 'package:flutter/material.dart';

import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
class BlogVideo extends StatefulWidget {
  @override
  _BlogVideoState createState() => _BlogVideoState();
}

class _BlogVideoState extends State<BlogVideo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _videoPlayerController2 = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:

       showControls: true,
       materialProgressColors: ChewieProgressColors(
      playedColor: Colors.green,
      handleColor: Colors.green[700],
      backgroundColor: Colors.grey,
      bufferedColor: Colors.green[200],
    ),
       placeholder: Container(
         color: Colors.grey,
       ),
       autoInitialize: true,
    );
  }
  double videoContainerWidth = 120.0;
  double videoContainerHeight = 80.0;
  double sizedBoxWidth = 10.0;
  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(),
        body: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar(
                    brightness: Utils.getBrightnessForAppBar(context),
                    expandedHeight: 240.0, //PsDimens.space300
                    floating: true,
                    pinned: true,
                    snap: false,
                    elevation: 0,
                    backgroundColor: PsColors.mainColor,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(top:24),
                      child: Chewie(
                          controller: _chewieController,
                        ),
                    ),

                  ),


                ],
              ),
              Expanded(child: Container(
                height: 110,
//      color: Colors.black12,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(width: sizedBoxWidth),
                    Container(
                      width: videoContainerWidth,
                      child:   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: videoContainerHeight,
                            color: Colors.lightGreen[300],
                          ),
                          Text('BBC News Nepali',
                            style: TextStyle(fontSize: 12,color: Colors.black38),)
                        ],
                      ),
                    ),
                    SizedBox(width: sizedBoxWidth),
                    Container(
                      width: videoContainerWidth,
                      child:   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: videoContainerHeight,
                            color: Colors.green,
                          ),
                          Text('BBC News Nepali',
                            style: TextStyle(fontSize: 12,color: Colors.black38),)
                        ],
                      ),
                    ),
                    SizedBox(width: sizedBoxWidth),
                    Container(
                      width: videoContainerWidth,
                      child:   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: videoContainerHeight,
                            color: Colors.green[200],
                          ),
                          Text('BBC News Nepali',
                            style: TextStyle(fontSize: 12,color: Colors.black38),)
                        ],
                      ),
                    ),
                    SizedBox(width: sizedBoxWidth),
                    Container(
                      width: videoContainerWidth,
                      child:   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: videoContainerHeight,
                            color: Colors.lightGreen[300],
                          ),
                          Text('BBC News Nepali',
                            style: TextStyle(fontSize: 12,color: Colors.black38),)
                        ],
                      ),
                    ),
                    SizedBox(width: sizedBoxWidth),
                    Container(
                      width: videoContainerWidth,
                      child:   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: videoContainerHeight,
                            color: Colors.green,
                          ),
                          Text('BBC News Nepali',
                            style: TextStyle(fontSize: 12,color: Colors.black38),)
                        ],
                      ),
                    ),
                    SizedBox(width: sizedBoxWidth),
                    Container(
                      width: videoContainerWidth,
                      child:   Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: videoContainerHeight,
                            color: Colors.green[200],
                          ),
                          Text('BBC News Nepali',
                            style: TextStyle(fontSize: 12,color: Colors.black38),)
                        ],
                      ),
                    ),

                  ],
                ),
              ))
            ],
          ),
        )
    );
  }
}
