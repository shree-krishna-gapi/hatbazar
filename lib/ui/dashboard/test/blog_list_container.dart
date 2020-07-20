import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'videoService.dart';
import '../test/videoService.dart';
import '../test/video_blog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatbazar/gapi/fadeAnimation.dart';
class VideoListContainerView extends StatefulWidget {
  @override
  _VideoListContainerViewState createState() => _VideoListContainerViewState();
}

class _VideoListContainerViewState extends State<VideoListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
            (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(Utils.getString(context, 'news__section__main__tab__heading3'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.mainColorWithWhite)),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.coreBackgroundColor,
          height: double.infinity,
          child: BlogListView(
            animationController: animationController,
          ),
        ),
      ),
    );
  }
}



class BlogListView extends StatefulWidget {
  const BlogListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _BlogListViewState createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

//  BlogProvider _blogProvider;
  Animation<double> animation;

  @override
  void dispose() {
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
//        _blogProvider.nextBlogList();
      }
    });

    super.initState();
  }

//  BlogRepository repo1;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    print(
        '............................Build UI Again ............................');

    return Container(
      child: FutureBuilder<List<VideoServices>>(
          future: FetchVideoServices(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) ;
            return snapshot.hasData ?

            ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context,int index) {
                  return FadeAnimation(
                    0.3, Container(
//                    height: 220,
//                    width: 140,

                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BlogVideo(
                                  title:snapshot.data[index].title,
                                  description: snapshot.data[index].description,
                                  videoSrc: snapshot.data[index].videoUrl
                              )));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
//                                  color: Colors.green,
                                  width: double.infinity,
                                  height: 200,
                                  child: CachedNetworkImage(
                                    alignment: Alignment.topLeft,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/placeholder_image.png',
                                      width: double.infinity,
//                                    height: 80.0,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    imageUrl: '${PsConfig.ps_app_image_url}${snapshot.data[index].imgPath}',
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
                                  ,child: Text('${snapshot.data[index].addedDateStr}',style: TextStyle(color: Colors.white, fontSize: 12),

                                ), color: Colors.black38,),
                                  bottom: 5, right: 5,),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:8.0,bottom:3.0),
                              child: Text('${snapshot.data[index].description}'),
                            ),
                            Text('${snapshot.data[index].title}',style: TextStyle(
                                fontSize: 12,color: Colors.black38
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ); } ) : FadeAnimation(0.3, Center(child: CircularProgressIndicator())); } ),
    );
  }
}
//AnimatedBuilder(
//animation: animationController,
//child: InkWell(
//onTap: onTap,
//child: Container(
//margin: const EdgeInsets.all(PsDimens.space8),
//child: Ink(
//color: PsColors.backgroundColor,
//child: BlogListItemWidget(blog: blog)))),
//builder: (BuildContext context, Widget child) {
//return FadeTransition(
//opacity: animation,
//child: Transform(
//transform: Matrix4.translationValues(
//0.0, 100 * (1.0 - animation.value), 0.0),
//child: child));
//})