

import 'package:flutter/material.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/blog.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
class VideoBlog extends StatefulWidget {
  const VideoBlog({
    Key key,
    @required this.blogList,

    this.onTap,
  }) : super(key: key);
  final Function onTap;
  final List<Blog> blogList;
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
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: widget.blogList != null && widget.blogList.isNotEmpty
            ? widget.blogList.map((Blog blogProduct) {return Container(
          height: 220,
          width: 140,
          margin: EdgeInsets.only(left: 10),
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
                        height: blogImageHeight,
                        fit: BoxFit.fitWidth,
                      ),
//                  imageUrl: '${PsConfig.ps_app_image_thumbs_url}${widget.blogList[i+1].defaultPhoto.imgPath}',
                      imageUrl: '${PsConfig.ps_app_image_thumbs_url}${blogProduct.defaultPhoto.imgPath}',
//                      height: blogImageHeight,
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
                  ,child: Text('04:00',style: TextStyle(color: Colors.white, fontSize: 12),

                  ), color: Colors.black38,),
                    bottom: 5, right: 5,),
                ],
              ),
              InkWell(
                onTap: () {
                  widget.onTap(blogProduct);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${blogProduct.name}'),
                ),
              )
            ],
          ),
        ); } ).toList()
            : <Widget>[Container()],
      ),
    );
  }
}

