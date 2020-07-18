import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/viewobject/sub_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatbazar/config/ps_config.dart';
class SubCategorySearchListItem1 extends StatelessWidget {
  const SubCategorySearchListItem1(
      {Key key,
        @required this.subCategory,
        this.onTap,
        this.animationController,
        this.animation})
      : super(key: key);

  final SubCategory subCategory;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      child: Container(
        color: Colors.black12,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: <Widget>[

             Container(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    alignment: Alignment.topLeft,
                    placeholder: (context, url) => Image.asset(
                      'assets/images/placeholder_image.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
//                  imageUrl: '${PsConfig.ps_app_image_thumbs_url}${widget.blogList[i+1].defaultPhoto.imgPath}',
                    imageUrl: '${PsConfig.ps_app_image_thumbs_url}${subCategory.defaultPhoto.imgPath}',
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
                  color: Colors.black38,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        subCategory.name,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                  )
              ),bottom: 0, left:0 , right: 0,
              ),
            ],
          ),
        ),
      ),
      builder: (BuildContext contenxt, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: child),
        );
      },
    );
  }
}
