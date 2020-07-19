import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';
import 'package:hatbazar/viewobject/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoListItem extends StatelessWidget {
  const VideoListItem(
      {Key key,
      @required this.video,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Video video;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
            onTap: onTap,
            child: Container(
                margin: const EdgeInsets.all(PsDimens.space8),
                child: Ink(
                    color: PsColors.backgroundColor,
                    child: VideoListItemWidget(video: video)))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}

class VideoListItemWidget extends StatelessWidget {
  const VideoListItemWidget({
    Key key,
    @required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        ClipRRect(
//          borderRadius: BorderRadius.circular(PsDimens.space4),
//          child: PsNetworkImage(
//            height: PsDimens.space200,
//            width: double.infinity,
//            photoKey: video.id,
//
//            defaultPhoto: video.defaultPhoto,
//            boxfit: BoxFit.cover,
//          ),
//        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space12),
          child: Text(
            video.title,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
