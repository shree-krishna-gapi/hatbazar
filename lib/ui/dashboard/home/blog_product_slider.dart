import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/viewobject/blog.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/ui/common/ps_hero.dart';
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
  ScrollController _controller = new ScrollController();
  String _currentId;
  String url = 'me url';
  double blogHeight = 100.0;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
//      height: widget.blogList.length == null ? blogHeight : blogHeight*widget.blogList.length,
        height: 420.0,
        //color: Colors.cyan,
          padding: EdgeInsets.all(0.0),
          margin: EdgeInsets.all(0.0),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(), // new
            controller: _controller,
            padding: EdgeInsets.all(0.0),
//        scrollDirection: Axis.vertical,
//        shrinkWrap: true,
            itemCount: widget.blogList.length == null ? 0 : widget.blogList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
//            shrinkWrap: true,
//            scrollDirection: Axis.vertical,
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
                        Expanded(child: PsHero(
                          transitionOnUserGestures: true,
                          tag: 'photoKey$index',
                          child: GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text('${widget.blogList[index].name}'),
                            ),
                          ),
                        ),flex: 5,),
                      ],
                    ),
                    SizedBox(height: 7,),
                    Divider(height: 1,)
                  ],


              );
            },
          ),
        ),
    );
  }
}


//class oldCode extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
//        if (widget.blogList != null && widget.blogList.isNotEmpty)
//          CarouselSlider(
//            options: CarouselOptions(
//              enlargeCenterPage: true,
//              autoPlay: false,
//              viewportFraction: 0.9,
//              autoPlayInterval: const Duration(seconds: 5),
//              onPageChanged: (int i, CarouselPageChangedReason reason) {
//                setState(() {
//                  _currentId = widget.blogList[i].id;
//                });
//              },
//            ),
//            items: widget.blogList.map((Blog blogProduct) {
//              return Container(
//                decoration: BoxDecoration(
//                  border: Border.all(
//                    color: PsColors.mainLightShadowColor,
//                  ),
//                  borderRadius:
//                  const BorderRadius.all(Radius.circular(PsDimens.space8)),
//                  boxShadow: <BoxShadow>[
//                    BoxShadow(
//                        color: PsColors.mainLightShadowColor,
//                        offset: const Offset(1.1, 1.1),
//                        blurRadius: PsDimens.space8),
//                  ],
//                ),
//                child: Stack(
//                  children: <Widget>[
//                    ClipRRect(
//                      borderRadius: BorderRadius.circular(PsDimens.space4),
//                      child: PsNetworkImage(
//                          photoKey: '',
//                          defaultPhoto: blogProduct.defaultPhoto,
//                          width: MediaQuery.of(context).size.width,
//                          height: double.infinity,
//                          onTap: () {
//                            widget.onTap(blogProduct);
//                          }),
//                    ),
//                    Align(
//                      alignment: Alignment.bottomCenter,
//                      child: InkWell(
//                        onTap: () {
//                          widget.onTap(blogProduct);
//                        },
//                        child: Container(
//                          height: 60,
//                          width: MediaQuery.of(context).size.width,
//                          decoration: BoxDecoration(
//                              color: PsColors.black.withAlpha(200)),
//                          padding: const EdgeInsets.only(
//                              top: PsDimens.space8,
//                              left: PsDimens.space8,
//                              right: PsDimens.space8,
//                              bottom: PsDimens.space20),
//                          child: Ink(
//                            color: PsColors.backgroundColor,
//                            child: Text(
//                              blogProduct.name,
//                              textAlign: TextAlign.left,
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .bodyText2
//                                  .copyWith(
//                                  fontSize: PsDimens.space16,
//                                  color: PsColors.white),
//                            ),
//                          ),
//                        ),
//                      ),
//                    )
//                  ],
//                ),
//              );
//            }).toList(),
//          )
//        else
//          Container(),
//
//        // ),
//        Positioned(
//            bottom: 5.0,
//            left: 0.0,
//            right: 0.0,
//            child: Row(
//              mainAxisSize: MainAxisSize.min,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: widget.blogList != null && widget.blogList.isNotEmpty
//                  ? widget.blogList.map((Blog blogProduct) {
//                return Builder(builder: (BuildContext context) {
//                  return Container(
//                      width: 8.0,
//                      height: 8.0,
//                      margin: const EdgeInsets.symmetric(
//                          vertical: 10.0, horizontal: 2.0),
//                      decoration: BoxDecoration(
//                          shape: BoxShape.circle,
//                          color: _currentId == blogProduct.id
//                              ? PsColors.mainColor
//                              : PsColors.grey));
//                });
//              }).toList()
//                  : <Widget>[Container()],
//            ))
//      ],
//    );
//}
