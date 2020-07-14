//import 'package:flutter_icons/flutter_icons.dart';
//import 'package:hatbazar/api/common/ps_resource.dart';
//import 'package:hatbazar/api/common/ps_status.dart';
//import 'package:hatbazar/config/ps_colors.dart';
//import 'package:hatbazar/constant/ps_constants.dart';
//import 'package:hatbazar/constant/ps_dimens.dart';
//import 'package:hatbazar/constant/route_paths.dart';
//import 'package:hatbazar/provider/product/added_item_provider.dart';
//import 'package:hatbazar/provider/product/paid_id_item_provider.dart';
//import 'package:hatbazar/provider/user/user_provider.dart';
//import 'package:hatbazar/repository/paid_ad_item_repository.dart';
//import 'package:hatbazar/repository/product_repository.dart';
//import 'package:hatbazar/repository/user_repository.dart';
//import 'package:hatbazar/ui/common/dialog/confirm_dialog_view.dart';
//import 'package:hatbazar/ui/common/ps_frame_loading_widget.dart';
//import 'package:hatbazar/ui/common/ps_ui_widget.dart';
//import 'package:hatbazar/ui/item/item/product_horizontal_list_item.dart';
//import 'package:hatbazar/ui/item/paid_ad/paid_ad_item_horizontal_list_item.dart';
//import 'package:hatbazar/utils/utils.dart';
//import 'package:hatbazar/viewobject/api_status.dart';
//import 'package:hatbazar/viewobject/common/ps_value_holder.dart';
//import 'package:flutter/material.dart';
//import 'package:hatbazar/viewobject/holder/delete_user_holder.dart';
//import 'package:hatbazar/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
//import 'package:hatbazar/viewobject/holder/product_parameter_holder.dart';
//import 'package:hatbazar/viewobject/product.dart';
//import 'package:hatbazar/viewobject/user.dart';
//import 'package:provider/provider.dart';
//import 'package:shimmer/shimmer.dart';
//
//class ProfileView1 extends StatefulWidget {
//  const ProfileView1(
//      {Key key,
//        this.animationController,
//        @required this.flag,
//        this.userId,
//        @required this.scaffoldKey,
//        @required this.callLogoutCallBack})
//      : super(key: key);
//  final AnimationController animationController;
//  final GlobalKey<ScaffoldState> scaffoldKey;
//  final int flag;
//  final String userId;
//  final Function callLogoutCallBack;
//  @override
//  _ProfilePage1State createState() => _ProfilePage1State();
//}
//
//class _ProfilePage1State extends State<ProfileView1>
//    with SingleTickerProviderStateMixin {
//  UserRepository userRepository;
//
//  @override
//  Widget build(BuildContext context) {
//    widget.animationController.forward();
//    return SingleChildScrollView(
//        child: Text('hello mot'));
//  }
//}
//
//class _PaidAdWidget extends StatefulWidget {
//  const _PaidAdWidget(
//      {Key key,
//        @required this.animationController,
//        this.userId,
//        this.animation})
//      : super(key: key);
//
//  final AnimationController animationController;
//  final String userId;
//  final Animation<double> animation;
//
//  @override
//  __PaidAdWidgetState createState() => __PaidAdWidgetState();
//}
//
//class __PaidAdWidgetState extends State<_PaidAdWidget> {
//  PaidAdItemRepository paidAdItemRepository;
//  PsValueHolder psValueHolder;
//  ProductParameterHolder parameterHolder;
//
//  @override
//  Widget build(BuildContext context) {
//    paidAdItemRepository = Provider.of<PaidAdItemRepository>(context);
//    psValueHolder = Provider.of<PsValueHolder>(context);
//
//    return SliverToBoxAdapter(
//        child: ChangeNotifierProvider<PaidAdItemProvider>(
//            lazy: false,
//            create: (BuildContext context) {
//              final PaidAdItemProvider provider = PaidAdItemProvider(
//                  repo: paidAdItemRepository, psValueHolder: psValueHolder);
//              if (provider.psValueHolder.loginUserId == null ||
//                  provider.psValueHolder.loginUserId == '') {
//                provider.loadPaidAdItemList(widget.userId);
//              } else {
//                provider.loadPaidAdItemList(provider.psValueHolder.loginUserId);
//              }
//
//              return provider;
//            },
//            child: Consumer<PaidAdItemProvider>(builder: (BuildContext context,
//                PaidAdItemProvider productProvider, Widget child) {
//              return AnimatedBuilder(
//                  animation: widget.animationController,
//                  child: (productProvider.paidAdItemList.data != null &&
//                      productProvider.paidAdItemList.data.isNotEmpty)
//                      ? Column(children: <Widget>[
//                    _HeaderWidget(
//                      headerName:
//                      Utils.getString(context, 'profile__paid_ad'),
//                      viewAllClicked: () {
//                        Navigator.pushNamed(
//                          context,
//                          RoutePaths.paidAdItemList,
//                        );
//                      },
//                    ),
//                    Container(
//                        height: 400,
//                        width: MediaQuery.of(context).size.width,
//                        child: ListView.builder(
//                            scrollDirection: Axis.horizontal,
//                            itemCount: productProvider
//                                .paidAdItemList.data.length,
//                            itemBuilder:
//                                (BuildContext context, int index) {
//                              if (productProvider.paidAdItemList.status ==
//                                  PsStatus.BLOCK_LOADING) {
//                                return Shimmer.fromColors(
//                                    baseColor: Colors.grey[300],
//                                    highlightColor: Colors.white,
//                                    child: Row(children: const <Widget>[
//                                      PsFrameUIForLoading(),
//                                    ]));
//                              } else {
//                                return PaidAdItemHorizontalListItem(
//                                  paidAdItem: productProvider
//                                      .paidAdItemList.data[index],
//                                  onTap: () {
//                                    // final Product product = provider.historyList.data.reversed.toList()[index];
//                                    final ProductDetailIntentHolder
//                                    holder =
//                                    ProductDetailIntentHolder(
//                                        product: productProvider
//                                            .paidAdItemList
//                                            .data[index]
//                                            .item,
//                                        heroTagImage: productProvider
//                                            .hashCode
//                                            .toString() +
//                                            productProvider
//                                                .paidAdItemList
//                                                .data[index]
//                                                .item
//                                                .id +
//                                            PsConst.HERO_TAG__IMAGE,
//                                        heroTagTitle: productProvider
//                                            .hashCode
//                                            .toString() +
//                                            productProvider
//                                                .paidAdItemList
//                                                .data[index]
//                                                .item
//                                                .id +
//                                            PsConst.HERO_TAG__TITLE);
//                                    Navigator.pushNamed(
//                                        context, RoutePaths.productDetail,
//                                        arguments: holder
//                                      // productProvider
//                                      //     .paidAdItemList.data[index].item
//                                    );
//                                  },
//                                );
//                              }
//                            }))
//                  ])
//                      : Container(),
//                  builder: (BuildContext context, Widget child) {
//                    return FadeTransition(
//                        opacity: widget.animation,
//                        child: Transform(
//                            transform: Matrix4.translationValues(
//                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
//                            child: child));
//                  });
//            })));
//  }
//}
//
//class _UserUploadDatWidget extends StatefulWidget {
//  const _UserUploadDatWidget(
//      {Key key,
//        @required this.animationController,
//        this.userId,
//        this.animation})
//      : super(key: key);
//
//  final AnimationController animationController;
//  final String userId;
//  final Animation<double> animation;
//
//  @override
//  __UserUploadDatWidgetState createState() => __UserUploadDatWidgetState();
//}
//
//class __UserUploadDatWidgetState extends State<_UserUploadDatWidget> {
//  ProductRepository productRepository;
//
//  PsValueHolder psValueHolder;
//
//  @override
//  Widget build(BuildContext context) {
//    productRepository = Provider.of<ProductRepository>(context);
//    psValueHolder = Provider.of<PsValueHolder>(context);
//
//    return SliverToBoxAdapter(
//        child: ChangeNotifierProvider<AddedItemProvider>(
//            lazy: false,
//            create: (BuildContext context) {
//              final AddedItemProvider provider = AddedItemProvider(
//                  repo: productRepository, psValueHolder: psValueHolder);
//              if (provider.psValueHolder.loginUserId == null ||
//                  provider.psValueHolder.loginUserId == '') {
//                provider.addedUserParameterHolder.addedUserId = widget.userId;
//                provider.loadItemList(
//                    widget.userId, provider.addedUserParameterHolder);
//              } else {
//                provider.addedUserParameterHolder.addedUserId =
//                    provider.psValueHolder.loginUserId;
//                provider.loadItemList(provider.psValueHolder.loginUserId,
//                    provider.addedUserParameterHolder);
//              }
//
//              return provider;
//            },
//            child: Consumer<AddedItemProvider>(builder: (BuildContext context,
//                AddedItemProvider productProvider, Widget child) {
//              return AnimatedBuilder(
//                  animation: widget.animationController,
//                  child: (productProvider.itemList.data != null &&
//                      productProvider.itemList.data.isNotEmpty)
//                      ? Column(children: <Widget>[
//                    _HeaderWidget(
//                      headerName:
//                      Utils.getString(context, 'profile__listing'),
//                      viewAllClicked: () {
//                        Navigator.pushNamed(
//                            context, RoutePaths.userItemList,
//                            arguments: productProvider
//                                .psValueHolder.loginUserId);
//                      },
//                    ),
//                    Container(
//                        height: PsDimens.space340,
//                        width: MediaQuery.of(context).size.width,
//                        child: ListView.builder(
//                            scrollDirection: Axis.horizontal,
//                            itemCount:
//                            productProvider.itemList.data.length,
//                            itemBuilder:
//                                (BuildContext context, int index) {
//                              if (productProvider.itemList.status ==
//                                  PsStatus.BLOCK_LOADING) {
//                                return Shimmer.fromColors(
//                                    baseColor: Colors.grey[300],
//                                    highlightColor: Colors.white,
//                                    child: Row(children: const <Widget>[
//                                      PsFrameUIForLoading(),
//                                    ]));
//                              } else {
//                                return ProductHorizontalListItem(
//                                  product: productProvider
//                                      .itemList.data[index],
//                                  coreTagKey: productProvider.hashCode
//                                      .toString() +
//                                      productProvider
//                                          .itemList.data[index].id,
//                                  onTap: () {
//                                    print(productProvider
//                                        .itemList
//                                        .data[index]
//                                        .defaultPhoto
//                                        .imgPath);
//                                    final Product product =
//                                    productProvider
//                                        .itemList.data.reversed
//                                        .toList()[index];
//                                    final ProductDetailIntentHolder
//                                    holder =
//                                    ProductDetailIntentHolder(
//                                        product: productProvider
//                                            .itemList.data[index],
//                                        heroTagImage: productProvider
//                                            .hashCode
//                                            .toString() +
//                                            product.id +
//                                            PsConst.HERO_TAG__IMAGE,
//                                        heroTagTitle: productProvider
//                                            .hashCode
//                                            .toString() +
//                                            product.id +
//                                            PsConst.HERO_TAG__TITLE);
//                                    Navigator.pushNamed(
//                                        context, RoutePaths.productDetail,
//                                        arguments: holder);
//                                  },
//                                );
//                              }
//                            }))
//                  ])
//                      : Container(),
//                  builder: (BuildContext context, Widget child) {
//                    return FadeTransition(
//                        opacity: widget.animation,
//                        child: Transform(
//                            transform: Matrix4.translationValues(
//                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
//                            child: child));
//                  });
//            })));
//  }
//}
//
//class _ProfileDetailWidget extends StatefulWidget {
//  const _ProfileDetailWidget(
//      {Key key,
//        this.animationController,
//        this.animation,
//        @required this.userId,
//        @required this.callLogoutCallBack})
//      : super(key: key);
//
//  final AnimationController animationController;
//  final Animation<double> animation;
//  final String userId;
//  final Function callLogoutCallBack;
//
//  @override
//  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
//}
//
//class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
//  UserRepository userRepository;
//  PsValueHolder psValueHolder;
//  UserProvider provider;
//
//  @override
//  Widget build(BuildContext context) {
//    const Widget _dividerWidget = Divider(
//      height: 1,
//    );
//
//    userRepository = Provider.of<UserRepository>(context);
//
//    psValueHolder = Provider.of<PsValueHolder>(context);
//    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);
//
//    return SliverToBoxAdapter(
//      child: ChangeNotifierProvider<UserProvider>(
//          lazy: false,
//          create: (BuildContext context) {
//            if (provider.psValueHolder.loginUserId == null ||
//                provider.psValueHolder.loginUserId == '') {
//              provider.userParameterHolder.id = widget.userId;
//              provider.getUser(widget.userId);
//              // provider.getMyUserData(provider.userParameterHolder.toMap());
//            } else {
//              provider.userParameterHolder.id =
//                  provider.psValueHolder.loginUserId;
//              provider.getUser(provider.psValueHolder.loginUserId);
//              // provider.getMyUserData(provider.userParameterHolder.toMap());
//            }
//
//            return provider;
//          },
//          child: Consumer<UserProvider>(builder:
//              (BuildContext context, UserProvider provider, Widget child) {
//            if (provider.user != null &&
//                provider.user.data != null &&
//                provider.user.data != null) {
//              return AnimatedBuilder(
//                  animation: widget.animationController,
//                  child: Container(
//                    color: PsColors.backgroundColor,
//                    child: Column(
//                      children: <Widget>[
//                        _ImageAndTextWidget(userProvider: provider),
//                        _dividerWidget,
//                        _EditAndHistoryRowWidget(userProvider: provider),
//                        _dividerWidget,
//                        _FavAndSettingWidget(),
//                        _dividerWidget,
//                        _JoinDateWidget(userProvider: provider),
//                        _VerifiedWidget(
//                          data: provider.user.data,
//                        ),
//                        _DeactivateAccWidget(
//                          userProvider: provider,
//                          callLogoutCallBack: widget.callLogoutCallBack,
//                        ),
//                        _dividerWidget,
//                      ],
//                    ),
//                  ),
//                  builder: (BuildContext context, Widget child) {
//                    return FadeTransition(
//                        opacity: widget.animation,
//                        child: Transform(
//                            transform: Matrix4.translationValues(
//                                0.0, 100 * (1.0 - widget.animation.value), 0.0),
//                            child: child));
//                  });
//            } else {
//              return Container();
//            }
//          })),
//    );
//  }
//}
//
//class _VerifiedWidget extends StatelessWidget {
//  const _VerifiedWidget({
//    Key key,
//    @required this.data,
//  }) : super(key: key);
//
//  final User data;
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: const EdgeInsets.only(
//          left: PsDimens.space16,
//          right: PsDimens.space16,
//          top: PsDimens.space8),
//      child: Row(
//        children: <Widget>[
//          Text(
//            Utils.getString(context, 'seller_info_tile__verified'),
//            style: Theme.of(context).textTheme.bodyText1,
//          ),
//          if (data.facebookVerify == '1')
//            const Padding(
//              padding: EdgeInsets.only(
//                  left: PsDimens.space4, right: PsDimens.space4),
//              child: Icon(
//                FontAwesome.facebook_official,
//              ),
//            )
//          else
//            Container(),
//          if (data.googleVerify == '1')
//            const Padding(
//              padding: EdgeInsets.only(
//                  left: PsDimens.space4, right: PsDimens.space4),
//              child: Icon(
//                FontAwesome.google,
//              ),
//            )
//          else
//            Container(),
//          if (data.phoneVerify == '1')
//            const Padding(
//              padding: EdgeInsets.only(
//                  left: PsDimens.space4, right: PsDimens.space4),
//              child: Icon(
//                FontAwesome.phone,
//              ),
//            )
//          else
//            Container(),
//          if (data.emailVerify == '1')
//            const Padding(
//              padding: EdgeInsets.only(
//                  left: PsDimens.space4, right: PsDimens.space4),
//              child: Icon(
//                MaterialCommunityIcons.email,
//              ),
//            )
//          else
//            Container(),
//        ],
//      ),
//    );
//  }
//}
//
//class _JoinDateWidget extends StatelessWidget {
//  const _JoinDateWidget({this.userProvider});
//  final UserProvider userProvider;
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//        padding: const EdgeInsets.only(
//          left: PsDimens.space16,
//          right: PsDimens.space16,
//          top: PsDimens.space16,
//        ),
//        child: Align(
//            alignment: Alignment.center,
//            child: Row(
//              children: <Widget>[
//                Text(Utils.getString(context, 'profile__join_on'),
//                    textAlign: TextAlign.start,
//                    style: Theme.of(context).textTheme.bodyText1),
//                const SizedBox(
//                  width: PsDimens.space2,
//                ),
//                Text(
//                  userProvider.user.data.addedDate,
//                  textAlign: TextAlign.start,
//                  style: Theme.of(context).textTheme.bodyText1,
//                ),
//              ],
//            )));
//  }
//}
//
//class _DeactivateAccWidget extends StatelessWidget {
//  const _DeactivateAccWidget(
//      {@required this.userProvider, @required this.callLogoutCallBack});
//  final UserProvider userProvider;
//  final Function callLogoutCallBack;
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//        padding: const EdgeInsets.only(
//            left: PsDimens.space16,
//            right: PsDimens.space16,
//            top: PsDimens.space8,
//            bottom: PsDimens.space16),
//        child: InkWell(
//          child: Container(
//            child: Ink(
//              color: PsColors.backgroundColor,
//              child: Align(
//                alignment: Alignment.centerLeft,
//                child: Text(
//                  Utils.getString(context, 'profile__deactivate_acc'),
//                  textAlign: TextAlign.start,
//                  style: Theme.of(context).textTheme.subtitle2.copyWith(
//                      fontWeight: FontWeight.normal, color: PsColors.mainColor),
//                ),
//              ),
//            ),
//          ),
//          onTap: () {
//            showDialog<dynamic>(
//                context: context,
//                builder: (BuildContext context) {
//                  return ConfirmDialogView(
//                      description: Utils.getString(
//                          context, 'profile__deactivate_confirm_text'),
//                      leftButtonText:
//                      Utils.getString(context, 'dialog__cancel'),
//                      rightButtonText: Utils.getString(context, 'dialog__ok'),
//                      onAgreeTap: () async {
//                        final DeleteUserHolder deleteUserHolder =
//                        DeleteUserHolder(
//                            userId: userProvider.psValueHolder.loginUserId);
//                        final PsResource<ApiStatus> _apiStatus =
//                        await userProvider
//                            .postDeleteUser(deleteUserHolder.toMap());
//                        if (_apiStatus.data != null) {
//                          if (callLogoutCallBack != null) {
//                            callLogoutCallBack(
//                                userProvider.psValueHolder.loginUserId);
//                          }
//                        }
//                      });
//                });
//          },
//        ));
//  }
//}
//
//class _FavAndSettingWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    const Widget _sizedBoxWidget = SizedBox(
//      width: PsDimens.space4,
//    );
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        Expanded(
//            flex: 2,
//            child: MaterialButton(
//              height: 50,
//              minWidth: double.infinity,
//              onPressed: () {
//                Navigator.pushNamed(
//                  context,
//                  RoutePaths.favouriteProductList,
//                );
//              },
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Icon(
//                    Icons.favorite,
//                    color: Theme.of(context).iconTheme.color,
//                  ),
//                  _sizedBoxWidget,
//                  Text(
//                    Utils.getString(context, 'profile__favourite'),
//                    textAlign: TextAlign.start,
//                    softWrap: false,
//                    style: Theme.of(context)
//                        .textTheme
//                        .bodyText2
//                        .copyWith(fontWeight: FontWeight.bold),
//                  ),
//                ],
//              ),
//            )),
//        Container(
//          color: Theme.of(context).dividerColor,
//          width: PsDimens.space1,
//          height: PsDimens.space48,
//        ),
//        Expanded(
//            flex: 2,
//            child: MaterialButton(
//              height: 50,
//              minWidth: double.infinity,
//              onPressed: () {
//                Navigator.pushNamed(
//                  context,
//                  RoutePaths.setting,
//                );
//              },
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Icon(Icons.settings,
//                      color: Theme.of(context).iconTheme.color),
//                  _sizedBoxWidget,
//                  Text(
//                    Utils.getString(context, 'profile__setting'),
//                    softWrap: false,
//                    textAlign: TextAlign.start,
//                    style: Theme.of(context)
//                        .textTheme
//                        .bodyText2
//                        .copyWith(fontWeight: FontWeight.bold),
//                  ),
//                ],
//              ),
//            ))
//      ],
//    );
//  }
//}
//
//class _EditAndHistoryRowWidget extends StatelessWidget {
//  const _EditAndHistoryRowWidget({@required this.userProvider});
//  final UserProvider userProvider;
//  @override
//  Widget build(BuildContext context) {
//    final Widget _verticalLineWidget = Container(
//      color: Theme.of(context).dividerColor,
//      width: PsDimens.space1,
//      height: PsDimens.space48,
//    );
//    return Row(
//      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      children: <Widget>[
//        _EditAndHistoryTextWidget(
//          userProvider: userProvider,
//          checkText: 0,
//        ),
//        _verticalLineWidget,
//        _EditAndHistoryTextWidget(
//          userProvider: userProvider,
//          checkText: 1,
//        ),
//        _verticalLineWidget,
//        _EditAndHistoryTextWidget(
//          userProvider: userProvider,
//          checkText: 2,
//        )
//      ],
//    );
//  }
//}
//
//class _EditAndHistoryTextWidget extends StatelessWidget {
//  const _EditAndHistoryTextWidget({
//    Key key,
//    @required this.userProvider,
//    @required this.checkText,
//  }) : super(key: key);
//
//  final UserProvider userProvider;
//  final int checkText;
//
//  @override
//  Widget build(BuildContext context) {
//    if (checkText == 0) {
//      return MaterialButton(
//        child: Text(
//          Utils.getString(context, 'profile__edit'),
//          softWrap: false,
//          style: Theme.of(context)
//              .textTheme
//              .bodyText2
//              .copyWith(fontWeight: FontWeight.bold),
//        ),
//        height: 50,
//        minWidth: 100,
//        onPressed: () async {
//          final dynamic returnData = await Navigator.pushNamed(
//            context,
//            RoutePaths.editProfile,
//          );
//          if (returnData != null && returnData is bool) {
//            userProvider.getUser(userProvider.psValueHolder.loginUserId);
//          }
//        },
//      );
//    } else {
//      return Expanded(
//          child: MaterialButton(
//              height: 50,
//              minWidth: double.infinity,
//              onPressed: () async {
//                if (checkText == 1) {
//                  Navigator.pushNamed(
//                    context,
//                    RoutePaths.followerUserList,
//                  );
//                } else if (checkText == 2) {
//                  Navigator.pushNamed(
//                    context,
//                    RoutePaths.followingUserList,
//                  );
//                }
//              },
//              child: checkText == 1
//                  ? Text(
//                Utils.getString(context, 'profile__follower') +
//                    '( ${userProvider.user.data.followerCount} )',
//                style: Theme.of(context)
//                    .textTheme
//                    .bodyText2
//                    .copyWith(fontWeight: FontWeight.bold),
//              )
//                  : Text(
//                Utils.getString(context, 'profile__following') +
//                    '( ${userProvider.user.data.followingCount} )',
//                style: Theme.of(context)
//                    .textTheme
//                    .bodyText2
//                    .copyWith(fontWeight: FontWeight.bold),
//              )));
//    }
//  }
//}
//
//class _HeaderWidget extends StatelessWidget {
//  const _HeaderWidget({
//    Key key,
//    @required this.headerName,
//    @required this.viewAllClicked,
//  }) : super(key: key);
//
//  final String headerName;
//  final Function viewAllClicked;
//  @override
//  Widget build(BuildContext context) {
//    return InkWell(
//      onTap: viewAllClicked,
//      child: Padding(
//        padding: const EdgeInsets.only(
//            top: PsDimens.space20,
//            left: PsDimens.space16,
//            right: PsDimens.space16,
//            bottom: PsDimens.space16),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          crossAxisAlignment: CrossAxisAlignment.end,
//          children: <Widget>[
//            Text(headerName,
//                textAlign: TextAlign.start,
//                style: Theme.of(context).textTheme.subtitle1),
//            InkWell(
//              child: Text(
//                Utils.getString(context, 'profile__view_all'),
//                textAlign: TextAlign.start,
//                style: Theme.of(context)
//                    .textTheme
//                    .caption
//                    .copyWith(color: PsColors.mainColor),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class _ImageAndTextWidget extends StatelessWidget {
//  const _ImageAndTextWidget({this.userProvider});
//  final UserProvider userProvider;
//  @override
//  Widget build(BuildContext context) {
//    final Widget _imageWidget = Padding(
//      padding: const EdgeInsets.only(left: PsDimens.space16),
//      child: PsNetworkCircleImage(
//        photoKey: '',
//        imagePath: userProvider.user.data.userProfilePhoto,
//        width: PsDimens.space80,
//        height: PsDimens.space80,
//        boxfit: BoxFit.cover,
//        onTap: () {},
//      ),
//    );
//    const Widget _spacingWidget = SizedBox(
//      height: PsDimens.space4,
//    );
//    return Container(
//      width: double.infinity,
//      margin: const EdgeInsets.only(
//          top: PsDimens.space16, bottom: PsDimens.space16),
//      child: Row(
//        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          _imageWidget,
//          Expanded(
//            child: Padding(
//              padding: const EdgeInsets.only(
//                  left: PsDimens.space12,
//                  top: PsDimens.space8,
//                  right: PsDimens.space12),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisSize: MainAxisSize.max,
//                children: <Widget>[
//                  Text(
//                    userProvider.user.data.userName,
//                    textAlign: TextAlign.start,
//                    style: Theme.of(context).textTheme.headline6,
//                    maxLines: 1,
//                  ),
//                  _spacingWidget,
//                  Text(
//                    userProvider.user.data.userPhone != ''
//                        ? userProvider.user.data.userPhone
//                        : Utils.getString(context, 'profile__phone_no'),
//                    style: Theme.of(context)
//                        .textTheme
//                        .bodyText2
//                        .copyWith(color: PsColors.textPrimaryLightColor),
//                    maxLines: 1,
//                  ),
//                  _spacingWidget,
//                  Text(
//                    userProvider.user.data.userAboutMe != ''
//                        ? userProvider.user.data.userAboutMe
//                        : Utils.getString(context, 'profile__about_me'),
//                    style: Theme.of(context)
//                        .textTheme
//                        .caption
//                        .copyWith(color: PsColors.textPrimaryLightColor),
//                    maxLines: 1,
//                    overflow: TextOverflow.ellipsis,
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
