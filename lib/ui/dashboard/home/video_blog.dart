

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
    return Text('');
  }
}

