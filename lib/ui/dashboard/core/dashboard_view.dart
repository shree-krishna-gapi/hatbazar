import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/constant/ps_constants.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/constant/route_paths.dart';
import 'package:hatbazar/provider/chat/user_unread_message_provider.dart';
import 'package:hatbazar/provider/delete_task/delete_task_provider.dart';
import 'package:hatbazar/provider/user/user_provider.dart';
import 'package:hatbazar/repository/category_repository.dart';
import 'package:hatbazar/repository/delete_task_repository.dart';
import 'package:hatbazar/repository/product_repository.dart';
import 'package:hatbazar/repository/user_repository.dart';
import 'package:hatbazar/repository/user_unread_message_repository.dart';
import 'package:hatbazar/ui/category/list/category_list_view.dart';
import 'package:hatbazar/ui/chat/list/chat_list_view.dart';
import 'package:hatbazar/ui/common/dialog/chat_noti_dialog.dart';
import 'package:hatbazar/ui/contact/contact_us_view.dart';
import 'package:hatbazar/ui/common/dialog/confirm_dialog_view.dart';
import 'package:hatbazar/ui/common/dialog/noti_dialog.dart';
import 'package:hatbazar/ui/dashboard/home/home_dashboard_view.dart';
import 'package:hatbazar/ui/history/list/history_list_view.dart';
import 'package:hatbazar/ui/item/favourite/favourite_product_list_view.dart';
import 'package:hatbazar/ui/item/list_with_filter/product_list_with_filter_view.dart';
import 'package:hatbazar/ui/item/paid_ad/paid_ad_item_list_view.dart';
import 'package:hatbazar/ui/language/setting/language_setting_view.dart';
import 'package:hatbazar/ui/search/home_item_search_view.dart';
import 'package:hatbazar/ui/terms_and_conditions/terms_and_conditions_view.dart';
import 'package:hatbazar/ui/setting/setting_view.dart';
import 'package:hatbazar/ui/user/forgot_password/forgot_password_view.dart';
import 'package:hatbazar/ui/user/login/login_view.dart';
import 'package:hatbazar/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:hatbazar/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:hatbazar/ui/user/profile/profile_view.dart';
import 'package:hatbazar/ui/user/profile/profile_view1.dart';
import 'package:hatbazar/ui/user/register/register_view.dart';
import 'package:hatbazar/ui/user/verify/verify_email_view.dart';
import 'package:hatbazar/viewobject/common/ps_value_holder.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:hatbazar/viewobject/holder/product_parameter_holder.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:hatbazar/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:provider/single_child_widget.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:hatbazar/viewobject/product.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hatbazar/ui/item/entry/item_entry_container.dart';
//import 'test.dart';
//import 'package:hatbazar/gapi/newDrawer/news/news.dart';
import 'package:hatbazar/gapi/newDrawer/agriculturalVideo/agriculturalVideo.dart';
import 'package:share/share.dart';
import 'package:hatbazar/gapi/newDrawer/radio/radioStream.dart';
class DashboardView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AnimationController animationController;
  AnimationController animationControllerForFab;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Animation<double> animation;

  String appBarTitle = 'Home';
  int _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT; // 1005
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';
  UserProvider provider;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _navigateToChat(String sellerId, String buyerId, String senderName,
      String senderProflePhoto, String itemId, String action) {
    if (valueHolder.loginUserId == buyerId) {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
            chatFlag: PsConst.CHAT_FROM_SELLER,
            itemId: itemId,
            buyerUserId: buyerId,
            sellerUserId: sellerId,
          ));
    } else {
      Navigator.pushNamed(context, RoutePaths.chatView,
          arguments: ChatHistoryIntentHolder(
            chatFlag: PsConst.CHAT_FROM_BUYER,
            itemId: itemId,
            buyerUserId: buyerId,
            sellerUserId: sellerId,
          ));
    }
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);
    super.initState();

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(const IosNotificationSettings());
    }

    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      print('onResume: $message');
      Utils.takeDataFromNoti(context, message, valueHolder.loginUserId);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onResume: $message');
      Utils.takeDataFromNoti(context, message, valueHolder.loginUserId);
    }, onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      Utils.takeDataFromNoti(context, message, valueHolder.loginUserId);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerForFab.dispose();
    super.dispose();
  }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT: // 1005
        index = 0;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT: // 1005
        index = 1;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT: // 2006 REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT: // 2003 REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT
        if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
          index = 2;
        } else {
          index = 3;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT: //2002
        if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
          index = 2;
        } else {
          index = 3;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT: //2009
        if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
          index = 2;
        } else {
          index = 3;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT: //2004
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT: //2001
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT: //2010
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT: //2011
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT: //2008
        index = 3;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT: // 2007
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    final PsValueHolder psValueHolder =
    Provider.of<PsValueHolder>(context, listen: false);
    switch (param) {
      case 0:
        index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = ''; //Utils.getString(context, 'app_name');
        break;
      case 1:
        index = PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT;
        title = Utils.getString(context, 'dashboard__categories');
        break;
      case 2:
        index = PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
        title = (psValueHolder == null ||
            psValueHolder.userIdToVerify == null ||
            psValueHolder.userIdToVerify == '')
            ? Utils.getString(context, 'item_entry__listing_entry') //home__bottom_app_bar_login
            : Utils.getString(context, 'home__bottom_app_bar_verify_email');
        break;
      case 3:
        index = PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT;
        title =
            Utils.getString(context, 'home__bottom_app_bar_login'); //dashboard__bottom_navigation_message
        break;
      case 4:
        index = PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT;
        title = Utils.getString(context, 'dashboard__bottom_navigation_message'); //home__bottom_app_bar_search
        break;

      default:
        index = 0;
        title = ''; //Utils.getString(context, 'app_name');
        break;
    }
    return <dynamic>[title, index];
  }

  CategoryRepository categoryRepository;
  UserRepository userRepository;
  ProductRepository productRepository;
  PsValueHolder valueHolder;
  DeleteTaskRepository deleteTaskRepository;
  DeleteTaskProvider deleteTaskProvider;
  UserUnreadMessageProvider userUnreadMessageProvider;
  UserUnreadMessageRepository userUnreadMessageRepository;


  void handleResponse(response, {String appName}) {
    if (response == 0) {
      print("failed.");
    } else if (response == 1) {
      print("success");
    } else if (response == 2) {
      print("application isn't installed");
      if (appName != null) {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("${appName} isn't installed."),
          duration: new Duration(seconds: 4),
        ));
      }
    }
  }
  void shareApp() {


    final RenderBox box = context.findRenderObject();
    Share.share('www.hatbazar.com',
        subject: 'hatbazar subject',
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) &
        box.size);
  }

  @override
  Widget build(BuildContext context) {
    categoryRepository = Provider.of<CategoryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    productRepository = Provider.of<ProductRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);
    // final dynamic data = EasyLocalizationProvider.of(context).data;

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = ''; //Utils.getString(context, 'app_name');
      Utils.subscribeToTopic(valueHolder.notiSetting ?? true);
      isFirstTime = false;
    }

    Future<void> updateSelectedIndex(int index) async {
      setState(() {
        _currentIndex = index;
      });
    }

    dynamic callLogout(UserProvider provider,
        DeleteTaskProvider deleteTaskProvider, int index) async {
      Navigator.of(context).pop();
      updateSelectedIndex(index);
      provider.replaceLoginUserId('');
      provider.replaceLoginUserName('');
      await deleteTaskProvider.deleteTask();
      await FacebookLogin().logOut();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }

    Future<void> updateSelectedIndexWithAnimation(

        String title, int index) async {

      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }

        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'home__quit_dialog_description'),
                leftButtonText: Utils.getString(context, 'dialog__cancel'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () {
                  SystemNavigator.pop();
                });
          }) ??
          false;
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    UserUnreadMessageParameterHolder userUnreadMessageHolder;

    // return EasyLocalizationProvider(
    //   data: data,
    //   child:
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    return UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);
                  }),
              ChangeNotifierProvider<DeleteTaskProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    deleteTaskProvider = DeleteTaskProvider(
                        repo: deleteTaskRepository, psValueHolder: valueHolder);
                    return deleteTaskProvider;
                  }),
            ],
            child: Consumer<UserProvider>(
              builder:
                  (BuildContext context, UserProvider provider, Widget child) {
//                print(provider.psValueHolder.loginUserId);
                return ListView(padding: EdgeInsets.zero, children: <Widget>[
                  _DrawerHeaderWidget(),
                  ListTile(
                    title: Text(
                        Utils.getString(context, 'home__drawer_menu_home')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.store,
                      title: Utils.getString(context, 'home__drawer_menu_home'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation('', index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.category,
                      title: Utils.getString(
                          context, 'home__drawer_menu_category'),
                      index: PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.schedule,
                      title: Utils.getString(
                          context, 'home__drawer_menu_latest_product'),
                      index: PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.trending_up,
                      title: Utils.getString(
                          context, 'home__drawer_menu_popular_item'),
                      index:
                      PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  const Divider(
                    height: PsDimens.space1,
                  ),
//                  // gapi
//                  "home__drawer_menu_additional_national_news" : "रास्तिर्य समाचार",
//                  "home__drawer_menu_additional_agriculture_video" : "कृसी भिडियो",
//                  "home__drawer_menu_additional_about_us" : "हाम्रो बारेमा",
//                  "home__drawer_menu_additional_fm" : "एफ एम ",
//                  "home__drawer_menu_additional_guide_video" : "एप चलाउने तरिका",

                  ListTile(
                    title: Text(
                        Utils.getString(context, 'home__drawer_menu_additional_title')),
                  ),
//                  _DrawerMenuWidget(
//                      icon: Icons.chrome_reader_mode,
//                      title: Utils.getString(context, 'home__drawer_menu_additional_national_news'),
//                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
//                      onTap: (String title,int index) {
//                        Navigator.pop(context);
//
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => News()),
//                        );
////                        updateSelectedIndexWithAnimation(title, index);
//                      }),
                  _DrawerMenuWidget(
                      icon: Icons.ondemand_video,
                      title: Utils.getString(context, 'home__drawer_menu_additional_agriculture_video'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
//                      onTap: (String title, int index) {
//                        Navigator.pop(context);
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => AgriculturalVideo()),
//                        );
////                        updateSelectedIndexWithAnimation(title, index);
//                      }),

                      onTap: (String title, int index)async {
                        String url = 'https://www.youtube.com/channel/UCKVrP_Cw9jD8eBPoeZfOKlA/videos?view_as=subscriber';
                        if (await canLaunch(url)) {
                        await launch(url);
                        } else {
                        throw 'Could not launch $url';
                        }
                      Navigator.pop(context);
                      }),

//                  _DrawerMenuWidget(
//                      icon: Icons.live_help,
//                      title: Utils.getString(context, 'home__drawer_menu_additional_about_us'),
//                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
//                      onTap: (String title, int index) {
//                        Navigator.pop(context);
//                        updateSelectedIndexWithAnimation(title, index);
//                      }),
                  _DrawerMenuWidget(
                      icon: Icons.radio,
                      title: Utils.getString(context, 'home__drawer_menu_additional_fm'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RadioStream()),
                        );
//                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.videogame_asset,
                      title: Utils.getString(context, 'home__drawer_menu_additional_guide_video'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.share,
                      title: Utils.getString(context, 'home__drawer_menu_additional_app_share'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
//                        Navigator.pop(context);
//                        updateSelectedIndexWithAnimation(title, index);

                        shareApp();

                      }),
                  const Divider(
                    height: PsDimens.space1,
                  ),


                  //gapi
                  ListTile(
                    title: Text(Utils.getString(
                        context, 'home__menu_drawer_user_info')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.person,
                      title:
                      Utils.getString(context, 'home__menu_drawer_profile'),
                      index:
                      PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        title = (valueHolder == null ||
                            valueHolder.userIdToVerify == null ||
                            valueHolder.userIdToVerify == '')
                            ? Utils.getString(
                            context, 'home__menu_drawer_profile')
                            : Utils.getString(
                            context, 'home__bottom_app_bar_verify_email');
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.favorite_border,
                            title: Utils.getString(
                                context, 'home__menu_drawer_favourite'),
                            index:
                            PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                          icon: Icons.swap_horiz,
                          title: Utils.getString(
                              context, 'home__menu_drawer_paid_ad_transaction'),
                          index:
                          PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          },
                        ),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.book,
                            title: Utils.getString(
                                context, 'home__menu_drawer_user_history'),
                            index: PsConst
                                .REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT, //14
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.power_settings_new,
                            color: PsColors.mainColorWithWhite,
                          ),
                          title: Text(
                            Utils.getString(
                                context, 'home__menu_drawer_logout'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(context,
                                          'home__logout_dialog_description'),
                                      leftButtonText: Utils.getString(context,
                                          'home__logout_dialog_cancel_button'),
                                      rightButtonText: Utils.getString(context,
                                          'home__logout_dialog_ok_button'),
                                      onAgreeTap: () async {
                                        // setState(() {
                                        //   _currentIndex =
                                        //       PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
                                        // });
                                        callLogout(
                                            provider,
                                            deleteTaskProvider,
                                            PsConst
                                                .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                      });
                                });
                          },
                        ),
                      ),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  ListTile(
                    title:
                    Text(Utils.getString(context, 'home__menu_drawer_app')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.g_translate,
                      title: Utils.getString(
                          context, 'home__menu_drawer_language'),
                      index: PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation('', index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.contacts,
                      title: Utils.getString(
                          context, 'home__menu_drawer_contact_us'),
                      index: PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.settings,
                      title:
                      Utils.getString(context, 'home__menu_drawer_setting'),
                      index: PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.info_outline,
                      title: Utils.getString(
                          context, 'home__menu_drawer_terms_and_condition'),
                      index: PsConst
                          .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.star_border,
                      color: PsColors.mainColorWithWhite,
                    ),
                    title: Text(
                      Utils.getString(
                          context, 'home__menu_drawer_rate_this_app'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Utils.launchURL();
                    },
                  )
                ]);
              },
            ),
          ),
        ),
        // drawer
        appBar: AppBar(
          backgroundColor: (appBarTitle ==
              Utils.getString(context, 'home__verify_email') ||
              appBarTitle == Utils.getString(context, 'home_verify_phone'))
              ? PsColors.mainColor
              : PsColors.baseColor,
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.headline6.copyWith(
              fontWeight: FontWeight.bold,
              color: (appBarTitle ==
                  Utils.getString(context, 'home__verify_email') ||
                  appBarTitle ==
                      Utils.getString(context, 'home_verify_phone'))
                  ? PsColors.white
                  : PsColors.mainColorWithWhite,
            ),
          ),
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(
              color: (appBarTitle ==
                  Utils.getString(context, 'home__verify_email') ||
                  appBarTitle ==
                      Utils.getString(context, 'home_verify_phone'))
                  ? PsColors.white
                  : PsColors.mainColorWithWhite),
          textTheme: Theme.of(context).textTheme,
          brightness: Utils.getBrightnessForAppBar(context),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: (appBarTitle ==
                    Utils.getString(context, 'home__verify_email') ||
                    appBarTitle ==
                        Utils.getString(context, 'home_verify_phone'))
                    ? PsColors.white
                    : Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.notiList,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: _currentIndex ==
            PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
            _currentIndex ==
                PsConst
                    .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
            _currentIndex ==
                PsConst
                    .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT || //go to profile
            _currentIndex ==
                PsConst
                    .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
            _currentIndex ==
                PsConst
                    .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
            _currentIndex ==
                PsConst
                    .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Visibility(
          visible: true,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: getBottonNavigationIndex(_currentIndex),
            showUnselectedLabels: true,
            backgroundColor: PsColors.backgroundColor,
            selectedItemColor: PsColors.mainColor,
            elevation: 10,
            onTap: (int index) {
              final dynamic _returnValue =
              getIndexFromBottonNavigationIndex(index);

              updateSelectedIndexWithAnimation(
                  _returnValue[0], _returnValue[1]);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.store,
                  size: 20,
                ),
                title: Text(
                  Utils.getString(context, 'dashboard__home'),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                title: Text(
                  Utils.getString(
                      context, 'dashboard__bottom_navigation_catogory'),
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle,color: Colors.red.withOpacity(0.85),),
                  activeIcon: Icon(Icons.add_circle,color: Colors.red),
                  title: Text(
                    Utils.getString(
                        context, 'home__bottom_app_bar_add_or_remove'),
                  )),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text(
                  Utils.getString(context, 'home__bottom_app_bar_login'),
                ),
              ),
              BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Container(
                        width: PsDimens.space40,
                        margin: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.message,
                          ),
                        ),
                      ),
                      Positioned(
                        right: PsDimens.space4,
                        top: PsDimens.space1,
                        child: ChangeNotifierProvider<
                            UserUnreadMessageProvider>(
                            create: (BuildContext context) {
                              userUnreadMessageProvider =
                                  UserUnreadMessageProvider(
                                      repo: userUnreadMessageRepository);

                              if (valueHolder.loginUserId != null &&
                                  valueHolder.loginUserId != '') {
                                userUnreadMessageHolder =
                                    UserUnreadMessageParameterHolder(
                                        userId: valueHolder.loginUserId,
                                        deviceToken: valueHolder.deviceToken);
                                userUnreadMessageProvider
                                    .userUnreadMessageCount(
                                    userUnreadMessageHolder);
                              }
                              return userUnreadMessageProvider;
                            }, child: Consumer<UserUnreadMessageProvider>(
                            builder:
                                (BuildContext context,
                                UserUnreadMessageProvider
                                userUnreadMessageProvider,
                                Widget child) {
                              if (userUnreadMessageProvider != null &&
                                  userUnreadMessageProvider
                                      .userUnreadMessage !=
                                      null &&
                                  userUnreadMessageProvider
                                      .userUnreadMessage.data !=
                                      null) {
                                // print(userUnreadMessageProvider
                                //     .userUnreadMessage
                                //     .data
                                //     .buyerUnreadCount);
                                final int sellerCount = int.parse(
                                    userUnreadMessageProvider
                                        .userUnreadMessage
                                        .data
                                        .sellerUnreadCount);
                                final int buyerCount = int.parse(
                                    userUnreadMessageProvider
                                        .userUnreadMessage
                                        .data
                                        .buyerUnreadCount);
                                final int totalCount =
                                    sellerCount + buyerCount;
                                if (totalCount == 0) {
                                  return Container();
                                } else {
                                  return Container(
                                    width: PsDimens.space20,
                                    height: PsDimens.space20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: PsColors.mainColor,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        totalCount > 9
                                            ? '9+'
                                            : totalCount.toString(),
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(color: PsColors.white),
                                        maxLines: 1,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Container();
                              }
                            })),
                      ),
                    ],
                  ),
                  title: Text(
                    Utils.getString(
                        context, 'dashboard__bottom_navigation_message'),
                  )),

            ],
          ),
          // ],
          // ),
        )
            : null,
        floatingActionButton: _currentIndex ==
            PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
            _currentIndex ==
                PsConst
                    .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Container(
          height: 65.0,
          width: 65.0,
          child: FittedBox(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PsColors.mainColor.withOpacity(0.3),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Container()),
          ),
        )
            : null,
        body: Builder(
          builder: (BuildContext context) {
            if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT) {
              return CategoryListView();
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) { //REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
              //message
              // current show profile should to be show add product
              return ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    provider = UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);

                    return provider;
                  },
                  child: Consumer<UserProvider>(builder: (BuildContext context,
                      UserProvider provider, Widget child) {
                    if (provider == null ||
                        provider.psValueHolder.userIdToVerify == null ||
                        provider.psValueHolder.userIdToVerify == '') {
                      if (provider == null ||
                          provider.psValueHolder == null ||
                          provider.psValueHolder.loginUserId == null ||
                          provider.psValueHolder.loginUserId == '') {
                        return _CallLoginWidget(
                            currentIndex: _currentIndex,
                            animationController: animationController,
                            animation: animation,
                            updateCurrentIndex: (String title, int index) {
                              if (index != null) {
                                updateSelectedIndexWithAnimation(title, index);
                              }
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) {
                              if (index != null) {
                                updateSelectedIndexWithAnimation(title, index);
                              }
                              if (userId != null) {
                                _userId = userId;
                                provider.psValueHolder.loginUserId = userId;
                              }
                            });
                      } else {
                        // hello this is me now
                        return ItemEntryContainerView(
                            flag: PsConst.ADD_NEW_ITEM, item: Product()
                        );
                      }
                    } else {
                      return _CallVerifyEmailWidget(
                          animationController: animationController,
                          animation: animation,
                          currentIndex: _currentIndex,
                          userId: _userId,
                          updateCurrentIndex: (String title, int index) {
                            updateSelectedIndexWithAnimation(title, index);
                          },
                          updateUserCurrentIndex:
                              (String title, int index, String userId) async {
                            if (userId != null) {
                              _userId = userId;
                              provider.psValueHolder.loginUserId = userId;
                            }
                            setState(() {
                              appBarTitle = title;
                              _currentIndex = index;
                            });
                          });
                    }
                  }));
            }
            if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
              if (valueHolder.loginUserId != null &&
                  valueHolder.loginUserId != '') {
                return ChatListView(
                  animationController: animationController,
                );
              } else {
                return _CallLoginWidget(
                    currentIndex: _currentIndex,
                    animationController: animationController,
                    animation: animation,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) {
                      setState(() {
                        if (index != null) {
                          appBarTitle = title;
                          _currentIndex = index;
                        }
                      });
                      if (userId != null) {
                        _userId = userId;
                      }
                    });
              }
            }
            if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) { //REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT this is orginal
              //message REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT

                //TODO: index 3 profile hunu parne aile vaira xa search page
              return ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    provider = UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);

                    return provider;
                  },
                  child: Consumer<UserProvider>(builder: (BuildContext context,
                      UserProvider provider, Widget child) {
                    if (provider == null ||
                        provider.psValueHolder.userIdToVerify == null ||
                        provider.psValueHolder.userIdToVerify == '') {
                      if (provider == null ||
                          provider.psValueHolder == null ||
                          provider.psValueHolder.loginUserId == null ||
                          provider.psValueHolder.loginUserId == '') {
                        return _CallLoginWidget(
                            currentIndex: _currentIndex,
                            animationController: animationController,
                            animation: animation,
                            updateCurrentIndex: (String title, int index) {
                              if (index != null) {
                                updateSelectedIndexWithAnimation(title, index);
                              }
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) {
                              if (index != null) {
                                updateSelectedIndexWithAnimation(title, index);
                              }
                              if (userId != null) {
                                _userId = userId;
                                provider.psValueHolder.loginUserId = userId;
                              }
                            });
                      } else {
                        return ProfileView(
                          scaffoldKey: scaffoldKey,
                          animationController: animationController,
                          flag: _currentIndex,
                          callLogoutCallBack: (String userId) {
                            callLogout(provider, deleteTaskProvider,
                                PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                          },
                        );
                      }
                    } else {
                      return _CallVerifyEmailWidget(
                          animationController: animationController,
                          animation: animation,
                          currentIndex: _currentIndex,
                          userId: _userId,
                          updateCurrentIndex: (String title, int index) {
                            updateSelectedIndexWithAnimation(title, index);
                          },
                          updateUserCurrentIndex:
                              (String title, int index, String userId) async {
                            if (userId != null) {
                              _userId = userId;
                              provider.psValueHolder.loginUserId = userId;
                            }
                            setState(() {
                              appBarTitle = title;
                              _currentIndex = index;
                            });
                          });
                    }
                  }));
            } else if (

            _currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: PsColors.mainLightColor,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                    Widget>[
                  PhoneSignInView(
                      animationController: animationController,
                      goToLoginSelected: () {
                        animationController
                            .reverse()
                            .then<dynamic>((void data) {
                          if (!mounted) {
                            return;
                          }
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                          }
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                          }
                        });
                      },
                      phoneSignInSelected:
                          (String name, String phoneNo, String verifyId) {
                        phoneUserName = name;
                        phoneNumber = phoneNo;
                        phoneId = verifyId;
                        if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home_verify_phone'),
                              PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                        }
                        if (_currentIndex ==
                            PsConst
                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home_verify_phone'),
                              PsConst
                                  .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                        }
                      })
                ])
              ]);
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              return _CallVerifyPhoneWidget(
                  userName: phoneUserName,
                  phoneNumber: phoneNumber,
                  phoneId: phoneId,
                  animationController: animationController,
                  animation: animation,
                  currentIndex: _currentIndex,
                  updateCurrentIndex: (String title, int index) {
                    updateSelectedIndexWithAnimation(title, index);
                  },
                  updateUserCurrentIndex:
                      (String title, int index, String userId) async {
                    if (userId != null) {
                      _userId = userId;
                    }
                    setState(() {
                      appBarTitle = title;
                      _currentIndex = index;
                    });
                  });
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
              return ProfileView(
                scaffoldKey: scaffoldKey,
                animationController: animationController,
                flag: _currentIndex,
                userId: _userId,
                callLogoutCallBack: (String userId) {
                  callLogout(provider, deleteTaskProvider,
                      PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                },
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
              return CategoryListView();
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('1'),
                animationController: animationController,
                productParameterHolder:
                ProductParameterHolder().getLatestParameterHolder(),
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('2'),
                animationController: animationController,
                productParameterHolder:
                ProductParameterHolder().getRecentParameterHolder(),
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('3'),
                animationController: animationController,
                productParameterHolder:
                ProductParameterHolder().getPopularParameterHolder(),
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
              return ProductListWithFilterView(
                key: const Key('4'),
                animationController: animationController,
                productParameterHolder:
                ProductParameterHolder().getFeaturedParameterHolder(),
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: PsColors.mainLightColorWithBlack,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      ForgotPasswordView(
                        animationController: animationController,
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        },
                      )
                    ])
              ]);
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                _currentIndex == PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
              return Stack(children: <Widget>[
                Container(
                  color: PsColors.mainLightColorWithBlack,
                  width: double.infinity,
                  height: double.maxFinite,
                ),
                CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                    Widget>[
                  RegisterView(
                      animationController: animationController,
                      onRegisterSelected: (String userId) {
                        _userId = userId;
                        // widget.provider.psValueHolder.loginUserId = userId;
                        if (_currentIndex ==
                            PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home__verify_email'),
                              PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                        }
                        if (_currentIndex ==
                            PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'home__verify_email'),
                              PsConst
                                  .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                        }
                      },
                      goToLoginSelected: () {
                        animationController
                            .reverse()
                            .then<dynamic>((void data) {
                          if (!mounted) {
                            return;
                          }
                          if (_currentIndex ==
                              PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                          }
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_login'),
                                PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                          }
                        });
                      })
                ])
              ]);
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              return _CallVerifyEmailWidget(
                  animationController: animationController,
                  animation: animation,
                  currentIndex: _currentIndex,
                  userId: _userId,
                  updateCurrentIndex: (String title, int index) {
                    updateSelectedIndexWithAnimation(title, index);
                  },
                  updateUserCurrentIndex:
                      (String title, int index, String userId) async {
                    if (userId != null) {
                      _userId = userId;
                    }
                    setState(() {
                      appBarTitle = title;
                      _currentIndex = index;
                    });
                  });
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
              return _CallLoginWidget(
                  currentIndex: _currentIndex,
                  animationController: animationController,
                  animation: animation,
                  updateCurrentIndex: (String title, int index) {
                    updateSelectedIndexWithAnimation(title, index);
                  },
                  updateUserCurrentIndex:
                      (String title, int index, String userId) {
                    setState(() {
                      if (index != null) {
                        appBarTitle = title;
                        _currentIndex = index;
                      }
                    });
                    if (userId != null) {
                      _userId = userId;
                    }
                  });
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              return ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    final UserProvider provider = UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);

                    return provider;
                  },
                  child: Consumer<UserProvider>(builder: (BuildContext context,
                      UserProvider provider, Widget child) {
                    if (provider == null ||
                        provider.psValueHolder.userIdToVerify == null ||
                        provider.psValueHolder.userIdToVerify == '') {
                      if (provider == null ||
                          provider.psValueHolder == null ||
                          provider.psValueHolder.loginUserId == null ||
                          provider.psValueHolder.loginUserId == '') {
                        return Stack(
                          children: <Widget>[
                            Container(
                              color: PsColors.mainLightColorWithBlack,
                              width: double.infinity,
                              height: double.maxFinite,
                            ),
                            CustomScrollView(
                                scrollDirection: Axis.vertical,
                                slivers: <Widget>[
                                  LoginView(
                                    animationController: animationController,
                                    animation: animation,
                                    onGoogleSignInSelected: (String userId) {
                                      setState(() {
                                        _currentIndex = PsConst
                                            .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      });
                                      _userId = userId;
                                      provider.psValueHolder.loginUserId =
                                          userId;
                                    },
                                    onFbSignInSelected: (String userId) {
                                      setState(() {
                                        _currentIndex = PsConst
                                            .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      });
                                      _userId = userId;
                                      provider.psValueHolder.loginUserId =
                                          userId;
                                    },
                                    onPhoneSignInSelected: () {
                                      if (_currentIndex ==
                                          PsConst
                                              .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                context, 'home_phone_signin'),
                                            PsConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                      }
                                      if (_currentIndex ==
                                          PsConst
                                              .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                context, 'home_phone_signin'),
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                      }
                                      if (_currentIndex ==
                                          PsConst
                                              .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                context, 'home_phone_signin'),
                                            PsConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                      }
                                      if (_currentIndex ==
                                          PsConst
                                              .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                context, 'home_phone_signin'),
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                      }
                                    },
                                    onProfileSelected: (String userId) {
                                      setState(() {
                                        _currentIndex = PsConst
                                            .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        _userId = userId;
                                        provider.psValueHolder.loginUserId =
                                            userId;
                                      });
                                    },
                                    onForgotPasswordSelected: () {
                                      setState(() {
                                        _currentIndex = PsConst
                                            .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                        appBarTitle = Utils.getString(
                                            context, 'home__forgot_password');
                                      });
                                    },
                                    onSignInSelected: () {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(
                                              context, 'home__register'),
                                          PsConst
                                              .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                    },
                                  ),
                                ])
                          ],
                        );
                      } else {
                        return ProfileView(
                          scaffoldKey: scaffoldKey,
                          animationController: animationController,
                          flag: _currentIndex,
                          callLogoutCallBack: (String userId) {
                            callLogout(provider, deleteTaskProvider,
                                PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                          },
                        );
                      }
                    } else {
                      return _CallVerifyEmailWidget(
                          animationController: animationController,
                          animation: animation,
                          currentIndex: _currentIndex,
                          userId: _userId,
                          updateCurrentIndex: (String title, int index) {
                            updateSelectedIndexWithAnimation(title, index);
                          },
                          updateUserCurrentIndex:
                              (String title, int index, String userId) async {
                            if (userId != null) {
                              _userId = userId;
                              provider.psValueHolder.loginUserId = userId;
                            }
                            setState(() {
                              appBarTitle = title;
                              _currentIndex = index;
                            });
                          });
                    }
                  }));
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
              return FavouriteProductListView(

                  animationController: animationController);
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
              return PaidAdItemListView(
                  animationController: animationController);
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
              return HistoryListView(animationController: animationController);
            }
            // else if (_currentIndex ==
            //     PsConst.REQUEST_CODE__MENU_COLLECTION_FRAGMENT) {
            //   return CollectionHeaderListView(
            //       animationController: animationController);
            // }
            else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
              return LanguageSettingView(
                  animationController: animationController,
                  languageIsChanged: () {
                    // _currentIndex = PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT;
                    // appBarTitle = Utils.getString(
                    //     context, 'home__menu_drawer_language');

                    //updateSelectedIndexWithAnimation(
                    //  '', PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT);
                    // setState(() {});
                  });
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
              return ContactUsView(animationController: animationController);
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
              return Container(
                color: PsColors.coreBackgroundColor,
                height: double.infinity,
                child: SettingView(
                  animationController: animationController,
                ),
              );
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
              return TermsAndConditionsView(
                  animationController: animationController);
            } else if (_currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) {
              if (valueHolder.loginUserId != null &&
                  valueHolder.loginUserId != '') {
                return ChatListView(
                  animationController: animationController,
                );
              } else {
                return _CallLoginWidget(
                    currentIndex: _currentIndex,
                    animationController: animationController,
                    animation: animation,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) {
                      setState(() {
                        if (index != null) {
                          appBarTitle = title;
                          _currentIndex = index;
                        }
                      });
                      if (userId != null) {
                        _userId = userId;
                      }
                    });
              }
            } else {
              animationController.forward();
              return HomeDashboardViewWidget(
                  _scrollController,
                  animationController,
                  animationControllerForFab,
                  context, (String payload) {
                return showDialog<dynamic>(
                  context: context,
                  builder: (_) {
                    return NotiDialog(message: '$payload');
                  },
                );
              }, (String payload,
                  String sellerId,
                  String buyerId,
                  String senderName,
                  String senderProflePhoto,
                  String itemId,
                  String action) {
                return showDialog<dynamic>(
                  context: context,
                  builder: (_) {
                    return ChatNotiDialog(
                        description: '$payload',
                        leftButtonText:
                        Utils.getString(context, 'dialog__cancel'),
                        rightButtonText:
                        Utils.getString(context, 'chat_noti__open'),
                        onAgreeTap: () {
                          _navigateToChat(sellerId, buyerId, senderName,
                              senderProflePhoto, itemId, action);
                        });
                  },
                );
              });
            }
          },
        ),
      ),
      // ),
    );
  }
}

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
        @required this.animation,
        @required this.updateCurrentIndex,
        @required this.updateUserCurrentIndex,
        @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: PsColors.mainLightColorWithBlack,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
        this.phoneNumber,
        this.phoneId,
        @required this.updateCurrentIndex,
        @required this.updateUserCurrentIndex,
        @required this.animationController,
        @required this.animation,
        @required this.currentIndex});

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            }
//             else if (currentIndex ==
//                 PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
//               updateCurrentIndex(Utils.getString(context, 'home__register'),
//                   PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
//             } else if (currentIndex ==
//                 PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
//               updateCurrentIndex(Utils.getString(context, 'home__register'),
//                   PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
//             }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {@required this.updateCurrentIndex,
        @required this.updateUserCurrentIndex,
        @required this.animationController,
        @required this.animation,
        @required this.currentIndex,
        @required this.userId});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          userId: userId,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: PsColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/flutter_buy_and_sell_logo.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
          Text(
            Utils.getString(context, 'app_name'),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: PsColors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(color: PsColors.mainColor),
    );
  }
}
