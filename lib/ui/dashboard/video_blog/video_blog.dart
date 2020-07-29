import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';





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
class BlogVideo extends StatefulWidget {
  BlogVideo({this.title,this.description,this.videoSrc});
  final String title;
  final String description;
  final String videoSrc;
  @override
  _BlogVideoState createState() => _BlogVideoState();
}

class _BlogVideoState extends State<BlogVideo> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  String url;
  @override
  Widget build(BuildContext context) {
    url = widget.videoSrc;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Builder(builder: (BuildContext context) {
            return CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
               SliverAppBar(
                expandedHeight: 540.0,
                floating: false,
                pinned: true,
              backgroundColor: Colors.grey,
              flexibleSpace: WebView(
                initialUrl: url, //https://www.youtube.com/embed/mdvJJMAjZlc
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),

               )],
            );
          },
          ),
          SizedBox(height: 20,),
          Container(
              height: 220,
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
//    usedTitle = snapshot.data[index].title;
//    usedDescription = snapshot.data[index].description;
                                  url = 'https://www.youtube.com/embed/mdvJJMAjZlc';
                                });
//    play(snapshot.data[index].videoUrl);

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
                          ); } ) : Center(child: CircularProgressIndicator()); } ))
        ],
      ),
    );
  }
}






