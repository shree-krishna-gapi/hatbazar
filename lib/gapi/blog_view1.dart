//import 'dart:async';
//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
//import 'package:hatbazar/api/common/ps_admob_banner_widget.dart';
//import 'package:hatbazar/config/ps_colors.dart';
//import 'package:hatbazar/config/ps_config.dart';
//import 'package:hatbazar/constant/ps_dimens.dart';
//import 'package:hatbazar/ui/common/ps_back_button_with_circle_bg_widget.dart';
//import 'package:hatbazar/ui/common/ps_ui_widget.dart';
//import 'package:hatbazar/utils/utils.dart';
//import 'package:hatbazar/viewobject/blog.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//class BlogView1 extends StatefulWidget {
//  BlogView1({this.heroTagImage,this.img});
//  final heroTagImage; final img;
//  @override
//  _BlogView1State createState() => _BlogView1State();
//}
//
//class _BlogView1State extends State<BlogView1> {
////  final String heroTagImage;
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
//
//    return Scaffold(
//        body: CustomScrollView(
//          shrinkWrap: true,
//          slivers: <Widget>[
//            SliverAppBar(
//              brightness: Utils.getBrightnessForAppBar(context),
//              expandedHeight: PsDimens.space300,
//              floating: true,
//              pinned: true,
//              snap: false,
//              elevation: 0,
//              leading: PsBackButtonWithCircleBgWidget(
//                  isReadyToShow: isReadyToShowAppBarIcons),
//              backgroundColor: PsColors.mainColor,
//              flexibleSpace: FlexibleSpaceBar(
//                background: PsNetworkImage(
//                  photoKey: widget.heroTagImage,
//                  height: PsDimens.space300,
//                  width: double.infinity,
////                  defaultPhoto: widget.img,
//
//                  boxfit: BoxFit.cover,
//                ),
//              ),
//            ),
////            SliverToBoxAdapter(
////              child: TextWidget(
////                blog: widget.blog,
////              ),
////            )
//          ],
//        ));
//  }
//}
