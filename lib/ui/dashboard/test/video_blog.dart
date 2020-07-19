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
import '../test/videoService.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatbazar/gapi/fadeAnimation.dart';
import 'package:hatbazar/config/ps_config.dart';
class BlogVideo extends StatefulWidget {
  BlogVideo({this.title,this.description,this.videoSrc});
  final String title;
  final String description;
  final String videoSrc;
  @override
  _BlogVideoState createState() => _BlogVideoState();
}

class _BlogVideoState extends State<BlogVideo> {
//  TargetPlatform _platform;

  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
//  String playUrl = 'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4';
  String playUrl;
  String usedTitle;
  String usedDescription;
  @override
  void initState() {
    super.initState();
    this.play(playUrl);
  }
  play(url){
    print('url $url');
    if(url == null || url == '') {
      _videoPlayerController1 = VideoPlayerController.network(widget.videoSrc);
    }
    else {
      _videoPlayerController1 = VideoPlayerController.network(url);
    }

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
//    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    usedTitle = widget.title;
    usedDescription = widget.description;
    return Scaffold(
//      appBar: AppBar(),
        body: SafeArea(
          top: false,
          child: FadeAnimation(
            0.3, Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverAppBar(
                      brightness: Utils.getBrightnessForAppBar(context),
                      expandedHeight: 276.0,
                      floating: true,
                      pinned: true,
                      snap: false,
                      elevation: 0,

                      backgroundColor: PsColors.mainColor,
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.only(top:24),
                        child: Container(
                          color: Colors.lightGreen,
                          width: double.infinity,
                          child: Chewie(
                            controller: _chewieController,
                          ),
                        ),
                      ),

                    ),

                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12,10,15,5),
                    child: Text('$usedDescription',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 18,
                            color: PsColors.textPrimaryDarkColor)),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space12,
                            right: PsDimens.space12,
                            bottom: PsDimens.space4),
                        child:  Text('$usedTitle',style: TextStyle(
                            fontSize: 12,color: Colors.black38
                        ),)
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only( top: PsDimens.space10,
                      left: PsDimens.space16,
                      right: PsDimens.space16,
                      bottom: PsDimens.space10),
                  child: Text( Utils.getString(context, 'news__section__main__tab__pages_heading3'),
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.w700,
                          color: PsColors.textPrimaryDarkColor)),
                ),
                Expanded(child: Container(
                  height: 120,
//      color: Colors.black12,
                  child: FutureBuilder<List<VideoServices>>(
                      future: FetchVideoServices(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) ;
                        return snapshot.hasData ?
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                            itemBuilder: (BuildContext context,int index) {
                              return Container(
                                height: 220,
                                width: 140,
                                margin: EdgeInsets.only(left: 10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      usedTitle = snapshot.data[index].title;
                                      usedDescription = snapshot.data[index].description;
                                    });
                                    play(snapshot.data[index].videoUrl);

                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            color: Colors.green,
                                            width: double.infinity,
                                            height: 100,
                                            child: CachedNetworkImage(
                                              alignment: Alignment.topLeft,
                                              placeholder: (context, url) => Image.asset(
                                                'assets/images/placeholder_image.png',
                                                width: double.infinity,
                                                height: 80.0,
                                                fit: BoxFit.fitWidth,
                                              ),
                                              imageUrl: '${PsConfig.ps_app_image_thumbs_url}${snapshot.data[index].imgPath}',
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Image.asset(
                                                'assets/images/placeholder_image.png',
                                                width: double.infinity,
//                      height: blogImageHeight,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          Positioned(child: Container(
                                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2)
                                            ,child: Text('${snapshot.data[index].addedDateStr}',style: TextStyle(color: Colors.white, fontSize: 12),

                                          ), color: Colors.black38,),
                                            bottom: 5, right: 5,),

                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:8.0,bottom:3.0),
                                        child: Text('${snapshot.data[index].description}'),
                                      ),
                                      Text('${snapshot.data[index].title}',style: TextStyle(
                                          fontSize: 12,color: Colors.black38
                                      ),)
                                    ],
                                  ),
                                ),
                              ); } ) : Center(child: CircularProgressIndicator()); } ),
                ))
              ],
            ),
          ),
        )
    );
  }
}