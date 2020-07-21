//import 'dart:async';
//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
//import 'package:hatbazar/api/common/ps_admob_banner_widget.dart';
//import 'package:hatbazar/config/ps_colors.dart';
//import 'package:hatbazar/config/ps_config.dart';
//import 'package:hatbazar/constant/ps_dimens.dart';
//import 'package:hatbazar/ui/common/ps_back_button_with_circle_bg_widget.dart';
//import 'package:hatbazar/ui/common/ps_ui_widget.dart';
//import 'package:hatbazar/utils/utils.dart';
////import 'package:hatbazar/viewobject/blog.dart';
//import 'package:hatbazar/viewobject/video.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class VideoView extends StatefulWidget {
//  const VideoView({Key key, @required this.video, @required this.heroTagImage})
//      : super(key: key);
//
//  final Video video;
//  final String heroTagImage;
//
//  @override
//  _VideoViewState createState() => _VideoViewState();
//}
//
//class _VideoViewState extends State<VideoView> {
//  bool isReadyToShowAppBarIcons = false;
//
//  @override
//  Widget build(BuildContext context) {
//    if (!isReadyToShowAppBarIcons) {
//      Timer(const Duration(milliseconds: 800), () {
//        setState(() {
//          isReadyToShowAppBarIcons = true;
//        });
//      });
//    }
//    print(widget.video.runtimeType);
//    return Scaffold(
//        body: CustomScrollView(
//      shrinkWrap: true,
//      slivers: <Widget>[
//        SliverAppBar(
//          brightness: Utils.getBrightnessForAppBar(context),
//          expandedHeight: PsDimens.space300,
//          floating: true,
//          pinned: true,
//          snap: false,
//          elevation: 0,
//          leading: PsBackButtonWithCircleBgWidget(
//              isReadyToShow: isReadyToShowAppBarIcons),
//          backgroundColor: PsColors.mainColor,
//          flexibleSpace: FlexibleSpaceBar(
//            background: PsNetworkImage(
//              photoKey: widget.heroTagImage,
//              height: PsDimens.space300,
//              width: double.infinity,
////              defaultPhoto: widget.video.defaultPhoto,
//              boxfit: BoxFit.cover,
//            ),
//          ),
//        ),
//        SliverToBoxAdapter(
//          child: TextWidget(
//            video: widget.video,
//          ),
//        )
//      ],
//    ));
//  }
//}
//
//class TextWidget extends StatefulWidget {
//  const TextWidget({
//    Key key,
//    @required this.video,
//  }) : super(key: key);
//
//  final Video video;
//
//  @override
//  _TextWidgetState createState() => _TextWidgetState();
//}
//
//class _TextWidgetState extends State<TextWidget> {
//  bool isConnectedToInternet = false;
//  bool isSuccessfullyLoaded = true;
//
//  void checkConnection() {
//    Utils.checkInternetConnectivity().then((bool onValue) {
//      isConnectedToInternet = onValue;
//      if (isConnectedToInternet && PsConfig.showAdMob) {
//        setState(() {});
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (!isConnectedToInternet && PsConfig.showAdMob) {
//      print('loading ads....');
//      checkConnection();
//    }
//    return Container(
//      color: PsColors.backgroundColor,
//      child: SingleChildScrollView(
//        child: Column(
//          mainAxisSize: MainAxisSize.max,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(PsDimens.space12),
//              child: Text(
//                widget.video.title,
//                style: Theme.of(context)
//                    .textTheme
//                    .headline6
//                    .copyWith(fontWeight: FontWeight.bold),
//              ),
//            ),
//            Padding(
//                padding: const EdgeInsets.only(
//                    left: PsDimens.space12,
//                    right: PsDimens.space12,
//                    bottom: PsDimens.space12),
//                child: HtmlWidget(widget.video.description)
//                //  Text(
//                //   widget.blog.description,
//                //   style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
//                // ),
//                ),
//            const PsAdMobBannerWidget(),
//          ],
//        ),
//      ),
//    );
//  }
//}
