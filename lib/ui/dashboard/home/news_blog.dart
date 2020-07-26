

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/blog.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
class NewsBlog extends StatefulWidget {
  const NewsBlog({
    Key key,
    @required this.blogList,

    this.onTap,
  }) : super(key: key);
  final Function onTap;
  final List<Blog> blogList;
  @override
  _NewsBlogState createState() => _NewsBlogState();
}

class _NewsBlogState extends State<NewsBlog> {
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
      height: 204,
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
              InkWell(
                onTap: () {
                  widget.onTap(blogProduct);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: PsDimens.space8),
                        child: Text('${blogProduct.name}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: PsDimens.space8),
                        child: Text('${blogProduct.addedDateStr}',style: TextStyle(color: Colors.black38,fontSize: 12),),
                      ),
                    ],
                  ),
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
class FirstRow extends StatelessWidget {
  double videoContainerWidth = 120.0;
  double videoContainerHeight = 80.0;
  double sizedBoxWidth = 10.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
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
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
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
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
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
                Padding(
                  padding: const EdgeInsets.only(left: PsDimens.space8),
                  child: Text('Some phonetically similar Nepali letters:',
                    style: TextStyle(fontSize: 14,color: Colors.black87),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: PsDimens.space8),
                  child: Text('BBC News Nepali',
                    style: TextStyle(fontSize: 12,color: Colors.black38),),
                )
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
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
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
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
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
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),

        ],
      ),
    );
  }
}

