//import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:http/http.dart' as http;
//import 'videoService.dart';
//class TestVideo extends StatefulWidget {
//  const TestVideo({
//    Key key,
//    @required this.animationController,
//    @required this.animation,
//  }) : super(key: key);
//
//  final AnimationController animationController;
//  final Animation<double> animation;
//  @override
//  _TestVideoState createState() => _TestVideoState();
//}
//
//class _TestVideoState extends State<TestVideo> {
//  @override
//  Widget build(BuildContext context) {
//    const int count = 6;
//    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
//        .animate(CurvedAnimation(
//        parent: animationController,
//        curve: const Interval((1 / count) * 1, 1.0,
//            curve: Curves.fastOutSlowIn)));
//
//    return SliverToBoxAdapter(
//      child: Consumer<BlogProvider>(builder:
//          (BuildContext context, BlogProvider blogProvider, Widget child) {
//        return AnimatedBuilder(
//            animation: animationController,
//            child: (blogProvider.blogList != null &&
//                blogProvider.blogList.data.isNotEmpty)
//                ? Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                _MyHeaderWidget(
//                  headerName:
//                  Utils.getString(context, 'home__menu_drawer_blog'),
//                  headerDescription: Utils.getString(context, ''),
//                  viewAllClicked: () {
//                    Navigator.pushNamed(
//                      context,
//                      RoutePaths.blogList,
//                    );
//                  },
//                ),
//                NewsBlog(
//                  blogList: blogProvider.blogList.data,
//                  onTap: (Blog blog) {
//                    print(RoutePaths.blogDetail);
//                    print(blog);
//                    Navigator.pushNamed(context, RoutePaths.blogDetail,
//                        arguments: blog);
//                  },
//                ),
//              ],
//            )
//                : Container(),
//            builder: (BuildContext context, Widget child) {
//              return FadeTransition(
//                  opacity: animation,
//                  child: Transform(
//                      transform: Matrix4.translationValues(
//                          0.0, 100 * (1.0 - animation.value), 0.0),
//                      child: child));
//            });
//      }),
//    );
//  }
//
////      child: FutureBuilder<List<VideoServices>>(
////          future: FetchVideoServices(http.Client()),
////    builder: (context, snapshot) {
////    if (snapshot.hasError) ;
////    return snapshot.hasData ?
////    ListView.builder(
////    itemCount: snapshot.data == null ? 0 : snapshot.data.length,
////    itemBuilder: (BuildContext context,int index) {
////    return Text('sdfsd'); } ) : CircularProgressIndicator(); } )
//
//
//}
