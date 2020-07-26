import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterbuyandsell/api/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/provider/blog/blog_provider.dart';
import 'package:flutterbuyandsell/provider/video/video_provider.dart';
import 'package:flutterbuyandsell/provider/chat/user_unread_message_provider.dart';
import 'package:flutterbuyandsell/provider/common/notification_provider.dart';
import 'package:flutterbuyandsell/provider/item_location/item_location_provider.dart';
import 'package:flutterbuyandsell/provider/product/item_list_from_followers_provider.dart';
import 'package:flutterbuyandsell/provider/product/recent_product_provider.dart';
import 'package:flutterbuyandsell/provider/product/popular_product_provider.dart';
import 'package:flutterbuyandsell/repository/Common/notification_repository.dart';
import 'package:flutterbuyandsell/repository/blog_repository.dart';
import 'package:flutterbuyandsell/repository/video_repository.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/repository/user_unread_message_repository.dart';
import 'package:flutterbuyandsell/ui/category/item/category_horizontal_list_item.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget_with_icon.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/blog_product_slider.dart';
import 'package:flutterbuyandsell/ui/item/item/product_horizontal_list_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/blog.dart';
import 'package:flutterbuyandsell/viewobject/video.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/category_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'news_blog.dart';
//import 'video_blog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import '../test/testVideo.dart';
import '../video_blog/videoService.dart';
import '../video_blog/video_blog.dart';
class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
      this.scrollController,
      this.animationController,
      this.animationControllerForFab,
      this.context,
      this.onNotiClicked,
      this.onChatNotiClicked);

  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController animationControllerForFab;

  final BuildContext context;
  final Function onNotiClicked;
  final Function onChatNotiClicked;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState extends State<HomeDashboardViewWidget> {
  PsValueHolder valueHolder;
  CategoryRepository repo1;
  ProductRepository repo2;
  BlogRepository repo3;
//  VideoRepository repo;
  ItemLocationRepository repo4;
  NotificationRepository notificationRepository;
  CategoryProvider _categoryProvider;
  UserUnreadMessageProvider userUnreadMessageProvider;
  UserUnreadMessageRepository userUnreadMessageRepository;
  final int count = 8;
  final CategoryParameterHolder trendingCategory = CategoryParameterHolder();
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  final TextEditingController userInputItemNameTextEditingController =
  TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (_categoryProvider != null) {
      _categoryProvider.loadCategoryList();
    }

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // setState(() {
        //   _isVisible = false;
        //   //print('**** $_isVisible up');
        // });
        if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.reverse();
        }
      }
      if (widget.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        // setState(() {
        //   _isVisible = true;
        //   //print('**** $_isVisible down');
        // });
        if (widget.animationControllerForFab != null) {
          widget.animationControllerForFab.forward();
        }
      }

      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        _categoryProvider.nextCategoryList();
      }
    });

    // if (Platform.isIOS) {
    //   _fcm.requestNotificationPermissions(const IosNotificationSettings());
    // }

    // _fcm.configure(onMessage: (Map<String, dynamic> message) async {
    //   print('onResume: $message');
    //   Utils.takeDataFromNoti(
    //       context, message, _categoryProvider.psValueHolder.loginUserId);
    // }, onLaunch: (Map<String, dynamic> message) async {
    //   print('onResume: $message');
    //   Utils.takeDataFromNoti(
    //       context, message, _categoryProvider.psValueHolder.loginUserId);
    // }, onResume: (Map<String, dynamic> message) async {
    //   print('onResume: $message');
    //   Utils.takeDataFromNoti(
    //       context, message, _categoryProvider.psValueHolder.loginUserId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<BlogRepository>(context);
//    repo5 = Provider.of<VideoRepository>(context);
    repo4 = Provider.of<ItemLocationRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);

    notificationRepository = Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<NotificationProvider>(
              lazy: false,
              create: (BuildContext context) {
                final NotificationProvider provider = NotificationProvider(
                    repo: notificationRepository, psValueHolder: valueHolder);
                if (provider.psValueHolder.deviceToken == null ||
                    provider.psValueHolder.deviceToken == '') {
                  final FirebaseMessaging _fcm = FirebaseMessaging();
                  Utils.saveDeviceToken(_fcm, provider);
                } else {
                  print(
                      'Notification Token is already registered. Notification Setting : true.');
                }
                return provider;
              }),

          // TODO: Home page category
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _categoryProvider ??= CategoryProvider(
                    repo: repo1,
                    psValueHolder: valueHolder,
                    limit: PsConfig.CATEGORY_LOADING_LIMIT);
                _categoryProvider.loadCategoryList();
                return _categoryProvider;
              }),
          ChangeNotifierProvider<RecentProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                final RecentProductProvider provider = RecentProductProvider(
                    repo: repo2, limit: PsConfig.RECENT_ITEM_LOADING_LIMIT);
                provider.productRecentParameterHolder.itemLocationId =
                    valueHolder.locationId;
                provider.loadProductList(provider.productRecentParameterHolder);
                return provider;
              }),
          ChangeNotifierProvider<PopularProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                final PopularProductProvider provider = PopularProductProvider(
                    repo: repo2, limit: PsConfig.POPULAR_ITEM_LOADING_LIMIT);
                provider.productPopularParameterHolder.itemLocationId =
                    valueHolder.locationId;
                provider
                    .loadProductList(provider.productPopularParameterHolder);
                return provider;
              }),
          ChangeNotifierProvider<BlogProvider>(
              lazy: false,
              create: (BuildContext context) {
                final BlogProvider provider = BlogProvider(
                    repo: repo3, limit: PsConfig.BLOCK_SLIDER_LOADING_LIMIT);
                provider.loadBlogList();
                return provider;
              }),
//          ChangeNotifierProvider<VideoProvider>(
//              lazy: false,
//              create: (BuildContext context) {
//                final VideoProvider provider = VideoProvider(
////                    repo: repo31,
//                    limit: PsConfig.BLOCK_SLIDER_LOADING_LIMIT1);
//                provider.loadVideoList();
//                return provider;
//              }),
          ChangeNotifierProvider<UserUnreadMessageProvider>(
              lazy: false,
              create: (BuildContext context) {
                userUnreadMessageProvider = UserUnreadMessageProvider(
                    repo: userUnreadMessageRepository);

                if (valueHolder.loginUserId != null &&
                    valueHolder.loginUserId != '') {
                  final UserUnreadMessageParameterHolder
                  userUnreadMessageHolder =
                  UserUnreadMessageParameterHolder(
                      userId: valueHolder.loginUserId,
                      deviceToken: valueHolder.deviceToken);
                  userUnreadMessageProvider
                      .userUnreadMessageCount(userUnreadMessageHolder);
                }
                return userUnreadMessageProvider;
              }),
          ChangeNotifierProvider<ItemLocationProvider>(
              lazy: false,
              create: (BuildContext context) {
                final ItemLocationProvider provider = ItemLocationProvider(
                    repo: repo4, psValueHolder: valueHolder);
                provider.loadItemLocationList();
                return provider;
              }),
          ChangeNotifierProvider<ItemListFromFollowersProvider>(
              lazy: false,
              create: (BuildContext context) {
                final ItemListFromFollowersProvider provider =
                ItemListFromFollowersProvider(
                    repo: repo2,
                    psValueHolder: valueHolder,
                    limit: PsConfig.FOLLOWER_ITEM_LOADING_LIMIT);
                provider.loadItemListFromFollowersList(
                    Utils.checkUserLoginId(provider.psValueHolder));
                return provider;
              }),
        ],
        child: Scaffold(
          body: Container(
            color: PsColors.coreBackgroundColor,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              controller: widget.scrollController,
              slivers: <Widget>[
                // FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
                _HomeHeaderWidget(
                  animationController:
                  widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  psValueHolder: valueHolder,
                  itemNameTextEditingController:
                  userInputItemNameTextEditingController,
                ),
                _HomeCategoryHorizontalListWidget(
                  psValueHolder: valueHolder,
                  animationController:
                  widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 2, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
                _RecentProductHorizontalListWidget(
                  psValueHolder: valueHolder,
                  animationController:
                  widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
                _HomePopularProductHorizontalListWidget(
                  psValueHolder: valueHolder,
                  animationController:
                  widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 4, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
                _HomeBlogProductSliderListWidget(
                  animationController:
                  widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 5, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
                _HomeVideoBlogListWidget(
                  animationController:
                  widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 5, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
//                _HomeBlogProductSliderListWidget1(
//                  animationController:
//                  widget.animationController, //animationController,
//                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
//                      CurvedAnimation(
//                          parent: widget.animationController,
//                          curve: Interval((1 / count) * 5, 1.0,
//                              curve: Curves.fastOutSlowIn))), //animation
//                ),

                _HomeItemListFromFollowersHorizontalListWidget(
                  animationController:
                  widget.animationController, //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 4, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
              ],
            ),
          ),
        ));
  }
}

class _HomePopularProductHorizontalListWidget extends StatelessWidget {
  const _HomePopularProductHorizontalListWidget(
      {Key key,
        @required this.animationController,
        @required this.animation,
        @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PopularProductProvider>(
        builder: (BuildContext context, PopularProductProvider productProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (productProvider.productList.data != null &&
                productProvider.productList.data.isNotEmpty)
                ? Column(
              children: <Widget>[
                _MyHeaderWidget(
                  headerName: Utils.getString(
                      context, 'home__drawer_menu_popular_item'),
                  headerDescription: Utils.getString(
                      context, 'dashboard__category_desc'),
                  viewAllClicked: () {
                    Navigator.pushNamed(
                        context, RoutePaths.filterProductList,
                        arguments: ProductListIntentHolder(
                            appBarTitle: Utils.getString(context,
                                'home__drawer_menu_popular_item'),
                            productParameterHolder:
                            ProductParameterHolder()
                                .getPopularParameterHolder()));
                  },
                ),
                Container(
                    height: PsDimens.space340,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                        productProvider.productList.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (productProvider.productList.status ==
                              PsStatus.BLOCK_LOADING) {
                            return Shimmer.fromColors(
                                baseColor: PsColors.grey,
                                highlightColor: PsColors.white,
                                child: Row(children: const <Widget>[
                                  PsFrameUIForLoading(),
                                ]));
                          } else {
                            final Product product =
                            productProvider.productList.data[index];
                            return ProductHorizontalListItem(
                              coreTagKey:
                              productProvider.hashCode.toString() +
                                  product.id,
                              product:
                              productProvider.productList.data[index],
                              onTap: () {
                                print(productProvider.productList
                                    .data[index].defaultPhoto.imgPath);
                                final ProductDetailIntentHolder holder =
                                ProductDetailIntentHolder(
                                    product: productProvider
                                        .productList.data[index],
                                    heroTagImage: productProvider
                                        .hashCode
                                        .toString() +
                                        product.id +
                                        PsConst.HERO_TAG__IMAGE,
                                    heroTagTitle: productProvider
                                        .hashCode
                                        .toString() +
                                        product.id +
                                        PsConst.HERO_TAG__TITLE);
                                Navigator.pushNamed(
                                    context, RoutePaths.productDetail,
                                    arguments: holder);
                              },
                            );
                          }
                        }))
              ],
            )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _RecentProductHorizontalListWidget extends StatefulWidget {
  const _RecentProductHorizontalListWidget(
      {Key key,
        @required this.animationController,
        @required this.animation,
        @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __RecentProductHorizontalListWidgetState createState() =>
      __RecentProductHorizontalListWidgetState();
}

class __RecentProductHorizontalListWidgetState
    extends State<_RecentProductHorizontalListWidget> {
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

    return SliverToBoxAdapter(
      // fdfdf
        child: Consumer<RecentProductProvider>(builder: (BuildContext context,
            RecentProductProvider productProvider, Widget child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              child: (productProvider.productList.data != null &&
                  productProvider.productList.data.isNotEmpty)
                  ? Column(children: <Widget>[
                _MyHeaderWidget(
                  headerName:
                  Utils.getString(context, 'dashboard_recent_product'),
                  headerDescription:
                  Utils.getString(context, 'dashboard_recent_item_desc'),
                  viewAllClicked: () {
                    Navigator.pushNamed(context, RoutePaths.filterProductList,
                        arguments: ProductListIntentHolder(
                            appBarTitle: Utils.getString(
                                context, 'dashboard_recent_product'),
                            productParameterHolder: ProductParameterHolder()
                                .getRecentParameterHolder()));
                  },
                ),
                Container(
                    height: PsDimens.space340,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productProvider.productList.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (productProvider.productList.status ==
                              PsStatus.BLOCK_LOADING) {
                            return Shimmer.fromColors(
                                baseColor: PsColors.grey,
                                highlightColor: PsColors.white,
                                child: Row(children: const <Widget>[
                                  PsFrameUIForLoading(),
                                ]));
                          } else {
                            final Product product =
                            productProvider.productList.data[index];
                            return ProductHorizontalListItem(
                              coreTagKey:
                              productProvider.hashCode.toString() +
                                  product.id,
                              product:
                              productProvider.productList.data[index],
                              onTap: () {
                                print(productProvider.productList.data[index]
                                    .defaultPhoto.imgPath);

                                final ProductDetailIntentHolder holder =
                                ProductDetailIntentHolder(
                                    product: productProvider
                                        .productList.data[index],
                                    heroTagImage: productProvider.hashCode
                                        .toString() +
                                        product.id +
                                        PsConst.HERO_TAG__IMAGE,
                                    heroTagTitle: productProvider.hashCode
                                        .toString() +
                                        product.id +
                                        PsConst.HERO_TAG__TITLE);
                                Navigator.pushNamed(
                                    context, RoutePaths.productDetail,
                                    arguments: holder);
                              },
                            );
                          }
                        })),
                const PsAdMobBannerWidget(
                  admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                ),
              ])
                  : Container(),
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: widget.animation,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1.0 - widget.animation.value), 0.0),
                        child: child));
              });
        }));
  }
}

class _HomeBlogProductSliderListWidget extends StatelessWidget {
  const _HomeBlogProductSliderListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval((1 / count) * 1, 1.0,
            curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (blogProvider.blogList != null &&
                blogProvider.blogList.data.isNotEmpty)
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _MyHeaderWidget(
                  headerName:
                  Utils.getString(context, 'news__section__main__heading'),
                  headerDescription: Utils.getString(context, ''),
                  viewAllClicked: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.blogList,
                    );
                  },
                ),
                NewsBlog(
                  blogList: blogProvider.blogList.data,
                  onTap: (Blog blog) {
                    print(RoutePaths.blogDetail);
                    print(blog);
                    Navigator.pushNamed(context, RoutePaths.blogDetail,
                        arguments: blog);
                  },
                ),
              ],
            )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}

//class _HomeBlogProductSliderListWidget1 extends StatelessWidget {
//  const _HomeBlogProductSliderListWidget1({
//    Key key,
//    @required this.animationController,
//    @required this.animation,
//  }) : super(key: key);
//
//  final AnimationController animationController;
//  final Animation<double> animation;
//
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
//      child: Consumer<VideoProvider>(builder:
//          (BuildContext context, VideoProvider videoProvider, Widget child) {
//        return AnimatedBuilder(
//            animation: animationController,
//            child: (videoProvider.videoList != null &&
//                videoProvider.videoList.data.isNotEmpty)
//                ? Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                _MyHeaderWidget(
//                  headerName:
//                  Utils.getString(context, 'home__menu_drawer_blogsdfs '),
//                  headerDescription: Utils.getString(context, ''),
//                  viewAllClicked: () {
////                    Navigator.pushNamed(
////                      context,
////                      RoutePaths.videoList,
////                    );
//                  },
//                ),
//                Text('helo ere'),
//                VideoBlog(
//                  videoList: videoProvider.videoList.data,
//                  onTap: (Video video) {
//                    print(RoutePaths.videoDetail);
//                    print(video);
//                    Navigator.pushNamed(context, RoutePaths.videoDetail,
//                        arguments: video);
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
//  rowChips() {
//    return Container(
////        width: double.infinity,
//      padding: EdgeInsets.symmetric(horizontal: 10),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          chipForRow('title1',Color(0xFF79aa93)),
//          chipForRow('title1',Color(0xFF69a223)),
//          chipForRow('title1',Color(0xFF89a113)),
//        ],
//      ),
//    );
//  }
//  Widget chipForRow(String label,Color color) {
//    return Chip(
////      labelPadding: EdgeInsets.all(0.0),
//      padding: EdgeInsets.all(0.0),
//      avatar: CircleAvatar(
//        backgroundColor: Colors.green[900],
//        child: Text('AB'),
//      ),
//      label: Text(label,style: TextStyle(),
//
//      ),
//      backgroundColor: Colors.transparent,
//      shape: StadiumBorder(side: BorderSide()),
//
//    );
//  }
//}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key key,
        @required this.animationController,
        @required this.animation,
        @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (categoryProvider.categoryList.data != null &&
                categoryProvider.categoryList.data.isNotEmpty)
                ? Column(children: <Widget>[
              _MyHeaderWidget(
                headerName:
                Utils.getString(context, 'dashboard__categories'),
                headerDescription:
                Utils.getString(context, 'dashboard__category_desc'),
                viewAllClicked: () {
                  Navigator.pushNamed(context, RoutePaths.categoryList,
                      arguments: 'Categories');
                },
              ),
              // TODO:// category list
              Container(
                height: PsDimens.space140,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding:
                    const EdgeInsets.only(left: PsDimens.space16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categoryList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (categoryProvider.categoryList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: PsColors.grey,
                            highlightColor: PsColors.white,
                            child: Row(children: const <Widget>[
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        return CategoryHorizontalListItem(
                          category:
                          categoryProvider.categoryList.data[index],
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var catId = categoryProvider.categoryList.data[index].catId;
                              prefs.setString('categoryCatId', catId);
                              String titleName = categoryProvider.categoryList.data[index].catName;
                              prefs.setString('subCategoryForHome', titleName);
                            FocusScope.of(context)
                                .requestFocus(FocusNode());
                            print(categoryProvider.categoryList
                                .data[index].defaultPhoto.imgPath);
                            final ProductParameterHolder
                            productParameterHolder =      ProductParameterHolder()
                                .getLatestParameterHolder();
                            productParameterHolder.catId =
                                categoryProvider
                                    .categoryList.data[index].catId;
                            Navigator.pushNamed(
                                context, RoutePaths.subCategoryForHome,
                                arguments: categoryProvider
                                    .categoryList.data[index].catId,
//                                arguments: ProductListIntentHolder(
//                                  appBarTitle: categoryProvider
//                                      .categoryList.data[index].catName,
//                                  productParameterHolder:
//                                  productParameterHolder,
//                                )
                            );
                          },
                          // )
                        );
                      }
                    }),
              )
            ])
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _HomeItemListFromFollowersHorizontalListWidget extends StatelessWidget {
  const _HomeItemListFromFollowersHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<ItemListFromFollowersProvider>(
        builder: (BuildContext context,
            ItemListFromFollowersProvider itemListFromFollowersProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            child: (itemListFromFollowersProvider.psValueHolder.loginUserId !=
                '' &&
                itemListFromFollowersProvider
                    .itemListFromFollowersList.data !=
                    null &&
                itemListFromFollowersProvider
                    .itemListFromFollowersList.data.isNotEmpty)
                ? Column(
              children: <Widget>[
                _MyHeaderWidget(
                  headerName: Utils.getString(
                      context, 'dashboard__item_list_from_followers'),
                  headerDescription: Utils.getString(
                      context, 'dashboard_follow_item_desc'),
                  viewAllClicked: () {
                    Navigator.pushNamed(
                        context, RoutePaths.itemListFromFollower,
                        arguments: itemListFromFollowersProvider
                            .psValueHolder.loginUserId);
                  },
                ),
                Container(
                    height: PsDimens.space340,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: itemListFromFollowersProvider
                            .itemListFromFollowersList.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (itemListFromFollowersProvider
                              .itemListFromFollowersList.status ==
                              PsStatus.BLOCK_LOADING) {
                            return Shimmer.fromColors(
                                baseColor: PsColors.grey,
                                highlightColor: PsColors.white,
                                child: Row(children: const <Widget>[
                                  PsFrameUIForLoading(),
                                ]));
                          } else {
                            return ProductHorizontalListItem(
                              coreTagKey: itemListFromFollowersProvider
                                  .hashCode
                                  .toString() +
                                  itemListFromFollowersProvider
                                      .itemListFromFollowersList
                                      .data[index]
                                      .id,
                              product: itemListFromFollowersProvider
                                  .itemListFromFollowersList.data[index],
                              onTap: () {
                                print(itemListFromFollowersProvider
                                    .itemListFromFollowersList
                                    .data[index]
                                    .defaultPhoto
                                    .imgPath);
                                final Product product =
                                itemListFromFollowersProvider
                                    .itemListFromFollowersList
                                    .data
                                    .reversed
                                    .toList()[index];
                                final ProductDetailIntentHolder holder =
                                ProductDetailIntentHolder(
                                    product:
                                    itemListFromFollowersProvider
                                        .itemListFromFollowersList
                                        .data[index],
                                    heroTagImage:
                                    itemListFromFollowersProvider
                                        .hashCode
                                        .toString() +
                                        product.id +
                                        PsConst.HERO_TAG__IMAGE,
                                    heroTagTitle:
                                    itemListFromFollowersProvider
                                        .hashCode
                                        .toString() +
                                        product.id +
                                        PsConst.HERO_TAG__TITLE);
                                Navigator.pushNamed(
                                    context, RoutePaths.productDetail,
                                    arguments: holder);
                              },
                            );
                          }
                        }))
              ],
            )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    this.headerDescription,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final String headerDescription;
  final Function viewAllClicked;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  //   fit: FlexFit.loose,
                  child: Text(widget.headerName,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: PsColors.textPrimaryDarkColor)),
                ),
                Text(
                  Utils.getString(context, 'dashboard__view_all'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: PsColors.mainColor),
                ),
              ],
            ),
            if (widget.headerDescription == '')
              Container()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: PsDimens.space10),
                      child: Text(
                        widget.headerDescription,
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeaderWidget extends StatefulWidget {
  const _HomeHeaderWidget(
      {Key key,
        @required this.animationController,
        @required this.animation,
        @required this.psValueHolder,
        @required this.itemNameTextEditingController})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;
  final TextEditingController itemNameTextEditingController;

  @override
  __HomeHeaderWidgetState createState() => __HomeHeaderWidgetState();
}

class __HomeHeaderWidgetState extends State<_HomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<ItemLocationProvider>(
      builder: (BuildContext context, ItemLocationProvider itemLocationProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: Column(
              children: <Widget>[
                _MyHomeHeaderWidget(
                  userInputItemNameTextEditingController:
                  widget.itemNameTextEditingController,
                  selectedLocation: () {
                    Navigator.pushNamed(context, RoutePaths.itemLocationList);
                  },
                  locationName:
                  itemLocationProvider.psValueHolder.locactionName,
                  psValueHolder: widget.psValueHolder,
                )
              ],
            ),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }

}

class _MyHomeHeaderWidget extends StatefulWidget {
  const _MyHomeHeaderWidget(
      {Key key,
        @required this.userInputItemNameTextEditingController,
        @required this.selectedLocation,
        @required this.locationName,
        @required this.psValueHolder})
      : super(key: key);

  final Function selectedLocation;
  final String locationName;
  final TextEditingController userInputItemNameTextEditingController;
  final PsValueHolder psValueHolder;
  @override
  __MyHomeHeaderWidgetState createState() => __MyHomeHeaderWidgetState();
}

class __MyHomeHeaderWidgetState extends State<_MyHomeHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: PsDimens.space20,
            top: PsDimens.space20,
            right: PsDimens.space20,
            bottom: PsDimens.space4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  Utils.getString(context, 'app_name'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: PsColors.textPrimaryDarkColor),
                ),
              ),
              const SizedBox(width: PsDimens.space20),
              Text(
                Utils.getString(context, 'dashboard__your_location'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space20,
              right: PsDimens.space20,
              bottom: PsDimens.space4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Utils.getString(context, 'dashboard__connect_with_our'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: widget.selectedLocation,
                    child: Text(
                      widget.locationName,
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: PsColors.mainColor),
                    ),
                  ),
                  MySeparator(color: PsColors.grey),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space24, bottom: PsDimens.space10),
          // child: GestureDetector(
          child: PsTextFieldWidgetWithIcon(
            hintText: Utils.getString(context, 'home__bottom_app_bar_search'),
            textEditingController:
            widget.userInputItemNameTextEditingController,
            psValueHolder: widget.psValueHolder,
          ),
          // onTap: () {
          //   Navigator.pushNamed(
          //     context,
          //     RoutePaths.basketList,
          //   );
          // }),
        ),
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({this.height = 1, this.color});
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final double boxWidth = constraints.constrainWidth();
        const double dashWidth = 10.0;
        final double dashHeight = height;
        const int dashCount = 10; //(boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List<Widget>.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: PsDimens.space2),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}

class _HomeVideoBlogListWidget extends StatelessWidget {
  const _HomeVideoBlogListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval((1 / count) * 1, 1.0,
            curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (blogProvider.blogList != null &&
                blogProvider.blogList.data.isNotEmpty)
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                    Utils.getString(context, 'news__section__main__tab__heading3'),
                    headerDescription: Utils.getString(context, ''),
                    viewAllClicked: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.videoList,
                      );
                    },
                  ),
                       Container(
                         height: 200,
                       width: double.infinity,
                         child: FutureBuilder<List<VideoServices>>(
                             future: FetchVideoServices(http.Client()),
                             builder: (context, snapshot) {
                               if (snapshot.hasError) ;
                               return snapshot.hasData ?

                               ListView.builder(
                                   scrollDirection: Axis.horizontal,
                                   itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                                   itemBuilder: (BuildContext context,int index) {
                                     return Container(
                                       height: 220,
                                       width: 140,
                                       margin: EdgeInsets.only(left: 10),
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
                                                   color: Colors.green,
                                                   width: double.infinity,
                                                   height: 100,
                                                   child: CachedNetworkImage(
                                                     alignment: Alignment.topLeft,
                                                     placeholder: (context, url) => Image.asset(
                                                       'assets/images/placeholder_image.png',
                                                       width: double.infinity,
                                                       height: 80.0,
                                                       fit: BoxFit.fitWidth,
                                                     ),
                                                     imageUrl: '${PsConfig.ps_app_image_thumbs_url}${snapshot.data[index].imgPath}',
                                                     fit: BoxFit.cover,
                                                     errorWidget: (context, url, error) => Image.asset(
                                                       'assets/images/placeholder_image.png',
                                                       width: double.infinity,
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
                                     ); } ) : Center(child: CircularProgressIndicator()); } ),
                       )
              ],
            )
                : Container(),
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}