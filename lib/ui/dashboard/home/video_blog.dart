

import 'package:flutter/material.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/video.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
class VideoBlog extends StatefulWidget {
  const VideoBlog({
    Key key,
    @required this.videoList,

    this.onTap,
  }) : super(key: key);
  final Function onTap;
  final List<Video> videoList;
  @override
  _VideoBlogState createState() => _VideoBlogState();
}

class _VideoBlogState extends State<VideoBlog> {
  ScrollController _controller = new ScrollController();
  String _currentId;
  double blogImageHeight = 80.0;
  int i=0;
  double videoContainerWidth = 120.0;
  double videoContainerHeight = 80.0;
  double sizedBoxWidth = 10.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.deepPurple,
      child: Text('sfdds'),
    );
  }
}

//ListView(
//shrinkWrap: true,
//scrollDirection: Axis.horizontal,
//children: widget.videoList != null && widget.videoList.isNotEmpty
//? widget.videoList.map((Video videoProduct) {return Container(
//height: 220,
//width: 140,
//margin: EdgeInsets.only(left: 10),
//child: Column(
//mainAxisAlignment: MainAxisAlignment.start,
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Stack(
//children: <Widget>[
//Container(
//color: Colors.green,
//width: double.infinity,
//height: 100,
//child: CachedNetworkImage(
//alignment: Alignment.topLeft,
//placeholder: (context, url) => Image.asset(
//'assets/images/placeholder_image.png',
//width: double.infinity,
//height: blogImageHeight,
//fit: BoxFit.fitWidth,
//),
////                  imageUrl: '${PsConfig.ps_app_image_thumbs_url}${widget.blogList[i+1].defaultPhoto.imgPath}',
//imageUrl: '${PsConfig.ps_app_image_thumbs_url}${videoProduct.defaultPhoto.imgPath}',
////                      height: blogImageHeight,
//fit: BoxFit.cover,
//errorWidget: (context, url, error) => Image.asset(
//'assets/images/placeholder_image.png',
//width: double.infinity,
////                      height: blogImageHeight,
//fit: BoxFit.fitWidth,
//),
//),
//),
//Positioned(child: Container(
//padding: EdgeInsets.fromLTRB(5, 2, 5, 2)
//,child: Text('04:00',style: TextStyle(color: Colors.white, fontSize: 12),
//
//), color: Colors.black38,),
//bottom: 5, right: 5,),
//],
//),
//InkWell(
//onTap: () {
//widget.onTap(videoProduct);
//},
//child: Padding(
//padding: const EdgeInsets.only(top: 8),
//child: Text('${videoProduct.title}'),
//),
//)
//],
//),
//); } ).toList()
//    : <Widget>[Container()],
//)