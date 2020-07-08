import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/viewobject/blog.dart';
import 'package:hatbazar/config/ps_config.dart';
class BlogSliderView extends StatefulWidget {
  const BlogSliderView({
    Key key,
    @required this.blogList,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final List<Blog> blogList;

  @override
  _BlogSliderState createState() => _BlogSliderState();
}

class _BlogSliderState extends State<BlogSliderView> {
  String _currentId;
  String url = 'me url';
  double blogHeight = 160.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.blogList.length == null ? blogHeight : blogHeight*widget.blogList.length,
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(0.0),
      child: ListView.builder(
        padding: EdgeInsets.all(0.0),
        scrollDirection: Axis.vertical,
        itemCount: widget.blogList.length == null ? 0 : widget.blogList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              SizedBox(height: 7,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Image.asset(
                        'assets/images/placeholder_image.png',
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      imageUrl: '${PsConfig.ps_app_image_thumbs_url}${widget.blogList[index].defaultPhoto.imgPath}',fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/placeholder_image.png',
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),flex:3),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text('${widget.blogList[index].name}'),
                  ),flex: 5,),
                ],
              ),
              SizedBox(height: 7,),
              Divider(height: 1,)
            ],

          );
        },
      ),
    );
  }
}
