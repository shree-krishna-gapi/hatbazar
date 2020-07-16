import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/constant/ps_constants.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/constant/route_paths.dart';
import 'package:hatbazar/provider/about_us/about_us_provider.dart';
import 'package:hatbazar/provider/history/history_provider.dart';
import 'package:hatbazar/provider/product/favourite_item_provider.dart';
import 'package:hatbazar/provider/product/mark_sold_out_item_provider.dart';
import 'package:hatbazar/provider/product/product_provider.dart';
import 'package:hatbazar/provider/product/touch_count_provider.dart';
import 'package:hatbazar/provider/user/user_provider.dart';
import 'package:hatbazar/repository/about_us_repository.dart';
import 'package:hatbazar/repository/history_repsitory.dart';
import 'package:hatbazar/repository/product_repository.dart';
import 'package:hatbazar/repository/user_repository.dart';
import 'package:hatbazar/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:hatbazar/ui/common/dialog/confirm_dialog_view.dart';
import 'package:hatbazar/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:hatbazar/ui/common/ps_button_widget.dart';
import 'package:hatbazar/ui/common/ps_expansion_tile.dart';
import 'package:hatbazar/ui/common/ps_hero.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';
import 'package:hatbazar/ui/item/detail/views/getting_this_tile_view.dart';
import 'package:hatbazar/ui/item/detail/views/location_tile_view.dart';
import 'package:hatbazar/ui/item/detail/views/safety_tips_tile_view.dart';
import 'package:hatbazar/ui/item/detail/views/seller_info_tile_view.dart';
import 'package:hatbazar/ui/item/detail/views/static_tile_view.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/api_status.dart';
import 'package:hatbazar/viewobject/common/ps_value_holder.dart';
import 'package:hatbazar/viewobject/holder/favourite_parameter_holder.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:hatbazar/viewobject/holder/mark_sold_out_item_parameter_holder.dart';
import 'package:hatbazar/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:hatbazar/viewobject/holder/user_delete_item_parameter_holder.dart';
import 'package:hatbazar/viewobject/holder/user_report_item_parameter_holder.dart';
import 'package:hatbazar/viewobject/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView(
      {@required this.product,
        @required this.heroTagImage,
        @required this.heroTagTitle});

  final Product product;
  final String heroTagImage;
  final String heroTagTitle;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductRepository productRepo;
  HistoryRepository historyRepo;
  HistoryProvider historyProvider;
  TouchCountProvider touchCountProvider;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  AboutUsRepository aboutUsRepo;
  AboutUsProvider aboutUsProvider;
  MarkSoldOutItemProvider markSoldOutItemProvider;
  MarkSoldOutItemParameterHolder markSoldOutItemHolder;
  UserProvider userProvider;
  UserRepository userRepo;
  bool isReadyToShowAppBarIcons = false;
  bool isAddedToHistory = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    // print('Detail ***Tag*** ${widget.heroTagImage}');
    psValueHolder = Provider.of<PsValueHolder>(context);
    productRepo = Provider.of<ProductRepository>(context);
    historyRepo = Provider.of<HistoryRepository>(context);
    aboutUsRepo = Provider.of<AboutUsRepository>(context);
    userRepo = Provider.of<UserRepository>(context);
    markSoldOutItemHolder =
        MarkSoldOutItemParameterHolder().markSoldOutItemHolder();
    markSoldOutItemHolder.itemId = widget.product.id;

    return PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
              ChangeNotifierProvider<ItemDetailProvider>(
                lazy: false,
                create: (BuildContext context) {
                  final ItemDetailProvider itemDetailProvider = ItemDetailProvider(
                      repo: productRepo, psValueHolder: psValueHolder);

                  final String loginUserId = Utils.checkUserLoginId(psValueHolder);
                  itemDetailProvider.loadProduct(widget.product.id, loginUserId);

                  return itemDetailProvider;
                },
              ),
              ChangeNotifierProvider<HistoryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  historyProvider = HistoryProvider(repo: historyRepo);
                  return historyProvider;
                },
              ),
              ChangeNotifierProvider<AboutUsProvider>(
                lazy: false,
                create: (BuildContext context) {
                  aboutUsProvider = AboutUsProvider(
                      repo: aboutUsRepo, psValueHolder: psValueHolder);
                  aboutUsProvider.loadAboutUsList();
                  return aboutUsProvider;
                },
              ),
              ChangeNotifierProvider<MarkSoldOutItemProvider>(
                lazy: false,
                create: (BuildContext context) {
                  markSoldOutItemProvider =
                      MarkSoldOutItemProvider(repo: productRepo);

                  return markSoldOutItemProvider;
                },
              ),
              ChangeNotifierProvider<UserProvider>(
                lazy: false,
                create: (BuildContext context) {
                  userProvider =
                      UserProvider(repo: userRepo, psValueHolder: psValueHolder);
                  return userProvider;
                },
              ),
              ChangeNotifierProvider<TouchCountProvider>(
                lazy: false,
                create: (BuildContext context) {
                  touchCountProvider = TouchCountProvider(
                      repo: productRepo, psValueHolder: psValueHolder);
                  final String loginUserId = Utils.checkUserLoginId(psValueHolder);

                  final TouchCountParameterHolder touchCountParameterHolder =
                  TouchCountParameterHolder(
                      itemId: widget.product.id, userId: loginUserId);
                  touchCountProvider
                      .postTouchCount(touchCountParameterHolder.toMap());
                  return touchCountProvider;
                },
              )
            ],
            child: Consumer<ItemDetailProvider>(
              builder: (BuildContext context, ItemDetailProvider provider,
                  Widget child) {
                if (provider.itemDetail != null &&
                    provider.itemDetail.data != null &&
                    markSoldOutItemProvider != null &&
                    userProvider != null) {
                  if (!isAddedToHistory) {
                    ///
                    /// Add to History
                    ///
                    historyProvider.addHistoryList(provider.itemDetail.data);
                    isAddedToHistory = true;
                  }
                  return Consumer<MarkSoldOutItemProvider>(builder:
                      (BuildContext context,
                      MarkSoldOutItemProvider markSoldOutItemProvider,
                      Widget child) {
                    return Stack(
                      children: <Widget>[
                        CustomScrollView(slivers: <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: true,
                            brightness: Utils.getBrightnessForAppBar(context),
                            expandedHeight: PsDimens.space300,
                            iconTheme: Theme.of(context)
                                .iconTheme
                                .copyWith(color: PsColors.mainColorWithWhite),
                            leading: PsBackButtonWithCircleBgWidget(
                                isReadyToShow: isReadyToShowAppBarIcons),
                            floating: false,
                            pinned: false,
                            stretch: true,
                            actions: <Widget>[
                              Visibility(
                                visible: isReadyToShowAppBarIcons,
                                child: _PopUpMenuWidget(
                                    userProvider: userProvider,
                                    itemId: provider.itemDetail.data.id,
                                    reportedUserId: psValueHolder.loginUserId,
                                    itemTitle: provider.itemDetail.data.title,
                                    itemImage: provider
                                        .itemDetail.data.defaultPhoto.imgPath),
                              ),
                            ],
                            backgroundColor: PsColors.mainColorWithBlack,
                            //   flexibleSpace: FlexibleSpaceBar(
                            //     background: Container(
                            //       color: PsColors.backgroundColor,
                            //       child: PsNetworkImage(
                            //         photoKey: widget.heroTagImage, //'latest${widget.product.defaultPhoto.imgId}',
                            //         defaultPhoto: widget.product.defaultPhoto,
                            //         width: double.infinity,
                            //         height: double.infinity,
                            //         onTap: () {
                            //           Navigator.pushNamed(context, RoutePaths.galleryGrid, arguments: widget.product);
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                color: PsColors.backgroundColor,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: <Widget>[
                                    PsNetworkImage(
                                      photoKey: widget.heroTagImage,
                                      defaultPhoto: widget.product.defaultPhoto,
                                      width: double.infinity,
                                      height: double.infinity,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePaths.galleryGrid,
                                            arguments: widget.product);
                                      },
                                    ),
                                    if (provider.itemDetail.data.addedUserId ==
                                        provider.psValueHolder.loginUserId)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: PsDimens.space12,
                                            right: PsDimens.space12),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            if (provider.itemDetail.data
                                                .paidStatus ==
                                                PsConst.ADSPROGRESS)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        PsDimens.space4),
                                                    color:
                                                    PsColors.paidAdsColor),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_progress'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                      color:
                                                      PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                .paidStatus ==
                                                PsConst.ADSFINISHED &&
                                                provider.itemDetail.data
                                                    .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        PsDimens.space4),
                                                    color: PsColors.black),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_completed'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                      color:
                                                      PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                  .paidStatus ==
                                                  PsConst.ADSNOTYETSTART)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                      color: Colors.yellow),
                                                  padding: const EdgeInsets.all(
                                                      PsDimens.space12),
                                                  child: Text(
                                                    Utils.getString(context,
                                                        'paid__ads_is_not_yet_start'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                        color:
                                                        PsColors.white),
                                                  ),
                                                )
                                              else
                                                Container(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>[
                                                if (provider.itemDetail.data
                                                    .isSoldOut ==
                                                    '1')
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            PsDimens
                                                                .space4),
                                                        color:
                                                        PsColors.mainColor),
                                                    padding:
                                                    const EdgeInsets.all(
                                                        PsDimens.space12),
                                                    child: Text(
                                                      Utils.getString(context,
                                                          'item_detail__sold'),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                          color: PsColors
                                                              .white),
                                                    ),
                                                  )
                                                else
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog<dynamic>(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) {
                                                            return ConfirmDialogView(
                                                                description: Utils
                                                                    .getString(
                                                                    context,
                                                                    'item_detail__sold_out_item'),
                                                                leftButtonText:
                                                                Utils.getString(
                                                                    context,
                                                                    'item_detail__sold_out_dialog_cancel_button'),
                                                                rightButtonText:
                                                                Utils.getString(
                                                                    context,
                                                                    'item_detail__sold_out_dialog_ok_button'),
                                                                onAgreeTap:
                                                                    () async {
                                                                  await markSoldOutItemProvider.loadmarkSoldOutItem(
                                                                      psValueHolder
                                                                          .loginUserId,
                                                                      markSoldOutItemHolder);
                                                                  if (markSoldOutItemProvider
                                                                      .markSoldOutItem !=
                                                                      null &&
                                                                      markSoldOutItemProvider
                                                                          .markSoldOutItem
                                                                          .data !=
                                                                          null) {
                                                                    setState(
                                                                            () {
                                                                          provider.itemDetail.data.isSoldOut = markSoldOutItemProvider
                                                                              .markSoldOutItem
                                                                              .data
                                                                              .isSoldOut;
                                                                        });
                                                                  }
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                });
                                                          });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              PsDimens
                                                                  .space4),
                                                          color: PsColors
                                                              .mainColor),
                                                      padding:
                                                      const EdgeInsets.all(
                                                          PsDimens.space12),
                                                      child: Text(
                                                        Utils.getString(context,
                                                            'item_detail__mark_sold'),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2
                                                            .copyWith(
                                                            color: PsColors
                                                                .white),
                                                      ),
                                                    ),
                                                  ),
                                                InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            PsDimens
                                                                .space4),
                                                        color: Colors.black45),
                                                    padding:
                                                    const EdgeInsets.all(
                                                        PsDimens.space12),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .end,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(
                                                          Ionicons.md_images,
                                                          color: PsColors.white,
                                                        ),
                                                        const SizedBox(
                                                            width: PsDimens
                                                                .space12),
                                                        Text(
                                                          '${widget.product.photoCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                          style: Theme.of(
                                                              context)
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                              color: PsColors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        RoutePaths.galleryGrid,
                                                        arguments:
                                                        widget.product);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            PsDimens.space8),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: <Widget>[
                                            if (provider.itemDetail.data
                                                .paidStatus ==
                                                PsConst.ADSPROGRESS)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        PsDimens.space4),
                                                    color:
                                                    PsColors.paidAdsColor),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_progress'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                      color:
                                                      PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                .paidStatus ==
                                                PsConst.ADSFINISHED &&
                                                provider.itemDetail.data
                                                    .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        PsDimens.space4),
                                                    color: PsColors.black),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_completed'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                      color:
                                                      PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                  .paidStatus ==
                                                  PsConst.ADSNOTYETSTART)
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          PsDimens.space4),
                                                      color: Colors.yellow),
                                                  padding: const EdgeInsets.all(
                                                      PsDimens.space12),
                                                  child: Text(
                                                    Utils.getString(context,
                                                        'paid__ads_is_not_yet_start'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                        color:
                                                        PsColors.white),
                                                  ),
                                                )
                                              else
                                                Container(),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        PsDimens.space4),
                                                    color: Colors.black45),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(
                                                      Ionicons.md_images,
                                                      color: PsColors.white,
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                        PsDimens.space12),
                                                    Text(
                                                      '${widget.product.photoCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                          color: PsColors
                                                              .white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    RoutePaths.galleryGrid,
                                                    arguments: widget.product);
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(<Widget>[
                              Container(
                                color: PsColors.baseColor,
                                child: Column(children: <Widget>[
                                  _HeaderBoxWidget(
                                      itemDetail: provider,
                                      product: widget.product,
                                      heroTagTitle: widget.heroTagTitle,
                                      pro: provider
                                  ),
                                  // shift in another line
//                                  SellerInfoTileView(
//                                    itemDetail: provider,
//                                  ),
                                  if (provider.itemDetail.data.isOwner ==
                                      PsConst.ONE &&
                                      provider.itemDetail.data.paidStatus ==
                                          PsConst.ADSNOTAVAILABLE)
                                    PromoteTileView(
                                        animationController:
                                        animationController,
                                        product: provider.itemDetail.data,
                                        provider: provider)
                                  else
                                    Container(),
                                  SafetyTipsTileView(
                                      animationController: animationController),
                                  LocationTileView(item: widget.product),
                                  GettingThisTileView(
                                      detailOptionId:
                                      provider.itemDetail.data.dealOptionId,
                                      address:
                                      provider.itemDetail.data.address),
                                  StatisticTileView(
                                    provider,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space80,
                                  ),
                                ]),
                              )
                            ]),
                          )
                        ]),
                        if (widget.product.addedUserId != null &&
                            widget.product.addedUserId ==
                                psValueHolder.loginUserId)
                          _EditAndDeleteButtonWidget(
                            provider: provider,
                          )
                        else
                          _CallAndChatButtonWidget(
                            provider: provider,
                            favouriteItemRepo: productRepo,
                            psValueHolder: psValueHolder,
                          )
                      ],
                    );
                  });
                } else {
                  return Container();
                }
              },
            )));
  }
}

class _PopUpMenuWidget extends StatelessWidget {
  const _PopUpMenuWidget(
      {@required this.userProvider,
        @required this.itemId,
        @required this.reportedUserId,
        @required this.itemTitle,
        @required this.itemImage});
  final UserProvider userProvider;
  final String itemId;
  final String reportedUserId;
  final String itemTitle;
  final String itemImage;

  Future<PsResource<ApiStatus>> _reportItem(
      String itemId, String reportedUserId, UserProvider userProvider) async {
    final UserReportItemParameterHolder userReportItemParameterHolder =
    UserReportItemParameterHolder(
        itemId: itemId, reportedUserId: reportedUserId);

    final PsResource<ApiStatus> _apiStatus = await userProvider
        .userReportItem(userReportItemParameterHolder.toMap());
    return _apiStatus;
  }

  Future<void> _onSelect(String value) async {
    switch (value) {
      case 'PsStatus.SUCCESS':
        {
          Fluttertoast.showToast(
              msg: 'User Reported This item',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white);
        }
        break;
      case '2':
      //Share.share('http://www.panacea-soft.com');

        final HttpClientRequest request = await HttpClient()
            .getUrl(Uri.parse(PsConfig.ps_app_image_url + itemImage));
        final HttpClientResponse response = await request.close();
        final Uint8List bytes =
        await consolidateHttpClientResponseBytes(response);
        await Share.file(itemTitle, itemTitle + '.jpg', bytes, 'image/jpg',
            text: itemTitle);
        break;
      default:
        print('English');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String status;
    _reportItem(itemId, reportedUserId, userProvider);
    _reportItem(itemId, reportedUserId, userProvider)
        .then((PsResource<ApiStatus> onValue) {
      status = onValue.status.toString();
    });
    return PopupMenuButton<String>(
      onSelected: _onSelect,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: status,
            child: Text(
              Utils.getString(context, 'item_detail__report_item'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          PopupMenuItem<String>(
            value: '2',
            child: Text(Utils.getString(context, 'item_detail__share'),
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ];
      },
      elevation: 4,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget(
      {Key key,
        @required this.itemDetail,
        @required this.product,
        @required this.heroTagTitle,
        @required this.pro
      })
      : super(key: key);

  final ItemDetailProvider itemDetail;
  final Product product;
  final String heroTagTitle;
  final ItemDetailProvider pro;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.product != null &&
        widget.itemDetail != null &&
        widget.itemDetail.itemDetail != null &&
        widget.itemDetail.itemDetail.data != null) {
      return Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
          const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(PsDimens.space16),
              child: PsHero(
                tag: widget.heroTagTitle,
                child: Text(widget.itemDetail.itemDetail.data.title,
                    style: Theme.of(context).textTheme.headline5),
              ),
            ),
            _IconsAndTwoTitleTextWidget(
                icon: Icons.schedule,
                title: '${widget.itemDetail.itemDetail.data.addedDateStr}',
                color: PsColors.grey,
                itemProvider: widget.itemDetail),
            if (widget.itemDetail.itemDetail.data.itemPriceType.name != '')
              _IconsAndTowTitleWithColumnTextWidget(
                  icon: AntDesign.tago,
                  title:
                  '${widget.itemDetail.itemDetail.data.itemCurrency.currencySymbol} ${widget.itemDetail.itemDetail.data.price}',
                  subTitle:
                  '(${widget.itemDetail.itemDetail.data.itemPriceType.name})',
                  color: PsColors.mainColor)
            else
              _IconsAndTitleTextWidget(
                  icon: AntDesign.tago,
                  title:
                  '${widget.itemDetail.itemDetail.data.itemCurrency.currencySymbol} ${widget.itemDetail.itemDetail.data.price}',
                  color: PsColors.mainColor),
            // here display
            SellerInfoTileView(
              itemDetail: widget.pro,
            ),
            _IconsAndTitleTextWidget(
                icon: SimpleLineIcons.drawer,
                title: widget.itemDetail.itemDetail.data.conditionOfItem.name,
                color: null),

            _IconsAndTitleTextWidget2(
//                icon: MaterialCommunityIcons.view_dashboard_outline,
                icon: Icons.category,
                title:
                '${widget.itemDetail.itemDetail.data.category.catName}',
                subTitle : '${widget.itemDetail.itemDetail.data.subCategory.name}',
                color: null),
//            _IconsAndTitleTextWidget(
//                icon: MaterialCommunityIcons.arrow_left_right_bold_outline,
//                title: '${widget.itemDetail.itemDetail.data.itemType.name}',
//                color: null),
            // gapi
            _IconsAndTitleTextWidget1(
                icon: MaterialCommunityIcons.arrow_left_right_bold_outline,
                title: '${widget.itemDetail.itemDetail.data.itemType.name}',
                subTitle: '${widget.itemDetail.itemDetail.data.highlightInformation}',
//                subTitle: '${widget.itemDetail.itemDetail.data.description}',
                color: null),

            _IconsAndTitleTextWidget(
                icon: Octicons.archive,
                title: widget.itemDetail.itemDetail.data.businessMode == '0'
                    ? Utils.getString(context, 'item_detail__item_cannot_order')
                    : Utils.getString(context, 'item_detail__item_can_order'),
                color: null),
            _IconsAndTitleTextWidget(
                icon: Octicons.info,
                title: widget.itemDetail.itemDetail.data.description,
                color: null),

            _IconsAndTitleTextWidget(
                icon: Icons.favorite_border,
                title:
                '${widget.itemDetail.itemDetail.data.favouriteCount} ${Utils.getString(context, 'item_detail__like_count')}',
                color: PsColors.mainColor),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
class _IconsAndTitleTextWidget1 extends StatelessWidget {
  const _IconsAndTitleTextWidget1({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.color,
    @required this.subTitle,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('$subTitle',style: Theme.of(context).textTheme.bodyText1,),
                SizedBox(height:10),
                Text(
                  title,
                  style: color == null
                      ? Theme.of(context).textTheme.bodyText1
                      : Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.blue), //gapi color: color
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _IconsAndTitleTextWidget extends StatelessWidget {
  const _IconsAndTitleTextWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Expanded(
            child: Text(
              title,
              style: color == null
                  ? Theme.of(context).textTheme.bodyText1
                  : Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.blue), //gapi color: color
            ),
          ),
        ],
      ),
    );
  }
}
class _IconsAndTitleTextWidget2 extends StatelessWidget {
  const _IconsAndTitleTextWidget2({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.subTitle,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: color == null
                      ? Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w600)
                      : Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.blue), //gapi color: color
                ),
                Text(
                  subTitle,
                  style: color == null
                      ? Theme.of(context).textTheme.bodyText1
                      : Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.blue), //gapi color: color
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _IconsAndTwoTitleTextWidget extends StatelessWidget {
  const _IconsAndTwoTitleTextWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.itemProvider,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final ItemDetailProvider itemProvider;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Text(
            title,
            style: color == null
                ? Theme.of(context).textTheme.bodyText1
                : Theme.of(context).textTheme.bodyText1.copyWith(color: color),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.userDetail,
                  // arguments: itemProvider.itemDetail.data.addedUserId
                  arguments: UserIntentHolder(
                      userId: itemProvider.itemDetail.data.addedUserId,
                      userName: itemProvider.itemDetail.data.user.userName));
            },
            child: Text(
              '${itemProvider.itemDetail.data.user.userName}',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: PsColors.mainColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallAndChatButtonWidget extends StatefulWidget {
  const _CallAndChatButtonWidget({
    Key key,
    @required this.provider,
    @required this.favouriteItemRepo,
    @required this.psValueHolder,
  }) : super(key: key);

  final ItemDetailProvider provider;
  final ProductRepository favouriteItemRepo;
  final PsValueHolder psValueHolder;

  @override
  __CallAndChatButtonWidgetState createState() =>
      __CallAndChatButtonWidgetState();
}

class __CallAndChatButtonWidgetState extends State<_CallAndChatButtonWidget> {
  FavouriteItemProvider favouriteProvider;
  Widget icon;
  @override
  Widget build(BuildContext context) {
    if (widget.provider != null &&
        widget.provider.itemDetail != null &&
        widget.provider.itemDetail.data != null) {
      return ChangeNotifierProvider<FavouriteItemProvider>(
          lazy: false,
          create: (BuildContext context) {
            favouriteProvider = FavouriteItemProvider(
                repo: widget.favouriteItemRepo,
                psValueHolder: widget.psValueHolder);
            // provider.loadFavouriteList('prd9a3bfa2b7ab0f0693e84d834e73224bb');
            return favouriteProvider;
          },
          child: Consumer<FavouriteItemProvider>(builder: (BuildContext context,
              FavouriteItemProvider provider, Widget child) {
            return Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: PsDimens.space72,
                child: Container(
                  decoration: BoxDecoration(
                    color: PsColors.backgroundColor,
                    border: Border.all(color: PsColors.backgroundColor),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(PsDimens.space12),
                        topRight: Radius.circular(PsDimens.space12)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: PsColors.backgroundColor,
                        blurRadius:
                        10.0, // has the effect of softening the shadow
                        spreadRadius:
                        0, // has the effect of extending the shadow
                        offset: const Offset(
                          0.0, // horizontal, move right 10
                          0.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(PsDimens.space16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        PSButtonWithIconWidget(
                          hasShadow: false,
                          colorData: PsColors.black.withOpacity(0.1),
                          icon: widget.provider.itemDetail.data.isFavourited !=
                              null
                              ? widget.provider.itemDetail.data.isFavourited ==
                              '0'
                              ? Icons.favorite_border
                              : Icons.favorite
                              : null,
                          iconColor: PsColors.mainColor,
                          width: 60,
                          titleText: '',
                          onPressed: () async {
                            if (await Utils.checkInternetConnectivity()) {
                              Utils.navigateOnUserVerificationView(
                                  widget.provider, context, () async {
                                if (widget.provider.itemDetail.data
                                    .isFavourited ==
                                    '0') {
                                  setState(() {
                                    widget.provider.itemDetail.data
                                        .isFavourited = '1';
                                  });
                                } else {
                                  setState(() {
                                    widget.provider.itemDetail.data
                                        .isFavourited = '0';
                                  });
                                }

                                final FavouriteParameterHolder
                                favouriteParameterHolder =
                                FavouriteParameterHolder(
                                    itemId:
                                    widget.provider.itemDetail.data.id,
                                    userId:
                                    widget.psValueHolder.loginUserId);

                                final PsResource<Product> _apiStatus =
                                await favouriteProvider.postFavourite(
                                    favouriteParameterHolder.toMap());

                                if (_apiStatus.data != null) {
                                  if (_apiStatus.status == PsStatus.SUCCESS) {
                                    await widget.provider.loadItemForFav(
                                        widget.provider.itemDetail.data.id,
                                        widget.psValueHolder.loginUserId);
                                  }
                                  if (widget.provider != null &&
                                      widget.provider.itemDetail != null &&
                                      widget.provider.itemDetail.data != null &&
                                      widget.provider.itemDetail.data
                                          .isFavourited ==
                                          '0') {
                                    icon = Icon(Icons.favorite,
                                        color: PsColors.mainColor);
                                  } else {
                                    icon = Icon(Icons.favorite_border,
                                        color: PsColors.mainColor);
                                  }
                                } else {
                                  print('There is no comment');
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        if (widget.provider.itemDetail.data.user.userPhone !=
                            null &&
                            widget.provider.itemDetail.data.user.userPhone !=
                                '')
                          PSButtonWithIconWidget(
                            hasShadow: true,
                            icon: Icons.call,
                            width: 100,
                            titleText:
                            Utils.getString(context, 'item_detail__call'),
                            onPressed: () async {
                              if (await canLaunch(
                                  'tel://${widget.provider.itemDetail.data.user.userPhone}')) {
                                await launch(
                                    'tel://${widget.provider.itemDetail.data.user.userPhone}');
                              } else {
                                throw 'Could not Call Phone';
                              }
                            },
                          )
                        else
                          Container(),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        Expanded(
                          child:
                          // RaisedButton(
                          //   child: Text(
                          //     Utils.getString(context, 'item_detail__chat'),
                          //     overflow: TextOverflow.ellipsis,
                          //     maxLines: 1,
                          //     textAlign: TextAlign.center,
                          //     softWrap: false,
                          //   ),
                          //   color: PsColors.mainColor,
                          //   shape: const BeveledRectangleBorder(
                          //       borderRadius: BorderRadius.all(
                          //     Radius.circular(PsDimens.space8),
                          //   )),
                          //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                          //   onPressed: () {
                          PSButtonWithIconWidget(
                            hasShadow: true,
                            icon: Icons.chat,
                            width: double.infinity,
                            titleText:
                            Utils.getString(context, 'item_detail__chat'),
                            onPressed: () async {
                              if (await Utils.checkInternetConnectivity()) {
                                Utils.navigateOnUserVerificationView(
                                    widget.provider, context, () async {
                                  Navigator.pushNamed(
                                      context, RoutePaths.chatView,
                                      arguments: ChatHistoryIntentHolder(
                                        chatFlag: PsConst.CHAT_FROM_SELLER,
                                        itemId:
                                        widget.provider.itemDetail.data.id,
                                        buyerUserId:
                                        widget.psValueHolder.loginUserId,
                                        sellerUserId: widget.provider.itemDetail
                                            .data.addedUserId,
                                      ));
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }));
    } else {
      return Container();
    }
  }
}

class _EditAndDeleteButtonWidget extends StatelessWidget {
  const _EditAndDeleteButtonWidget({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final ItemDetailProvider provider;
  @override
  Widget build(BuildContext context) {
    if (provider != null &&
        provider.itemDetail != null &&
        provider.itemDetail.data != null) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: PsDimens.space12),
            SizedBox(
              width: double.infinity,
              height: PsDimens.space72,
              child: Container(
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  border: Border.all(color: PsColors.backgroundColor),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(PsDimens.space12),
                      topRight: Radius.circular(PsDimens.space12)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: PsColors.backgroundColor,
                      blurRadius:
                      10.0, // has the effect of softening the shadow
                      spreadRadius: 0, // has the effect of extending the shadow
                      offset: const Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:
                        // RaisedButton(
                        //   child: Text(
                        //     Utils.getString(context, 'item_detail__delete'),
                        //     overflow: TextOverflow.ellipsis,
                        //     maxLines: 1,
                        //     softWrap: false,
                        //   ),
                        //   color: PsColors.grey,
                        //   shape: const BeveledRectangleBorder(
                        //       borderRadius: BorderRadius.all(
                        //     Radius.circular(PsDimens.space8),
                        //   )),
                        //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                        //   onPressed: () async {
                        PSButtonWithIconWidget(
                          hasShadow: true,
                          width: double.infinity,
                          icon: Icons.delete,
                          colorData: PsColors.grey,
                          titleText:
                          Utils.getString(context, 'item_detail__delete'),
                          onPressed: () async {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(
                                          context, 'item_detail__delete_desc'),
                                      leftButtonText: Utils.getString(
                                          context, 'dialog__cancel'),
                                      rightButtonText: Utils.getString(
                                          context, 'dialog__ok'),
                                      onAgreeTap: () async {
                                        final UserDeleteItemParameterHolder
                                        userDeleteItemParameterHolder =
                                        UserDeleteItemParameterHolder(
                                          itemId: provider.itemDetail.data.id,
                                        );

                                        final PsResource<ApiStatus> _apiStatus =
                                        await provider.userDeleteItem(
                                            userDeleteItemParameterHolder
                                                .toMap());
                                        if (_apiStatus.data.status ==
                                            'success') {
                                          Fluttertoast.showToast(
                                              msg: 'Item Deleated',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blueGrey,
                                              textColor: Colors.white);
                                          // Navigator.pop(context, true);
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RoutePaths.home,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Item is not Deleated',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blueGrey,
                                              textColor: Colors.white);
                                        }
                                      });
                                });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: PsDimens.space10,
                      ),
                      Expanded(
                        child:
                        //  RaisedButton(
                        //   child: Text(
                        //     Utils.getString(context, 'item_detail__edit'),
                        //     overflow: TextOverflow.ellipsis,
                        //     maxLines: 1,
                        //     textAlign: TextAlign.center,
                        //     softWrap: false,
                        //   ),
                        //   color: PsColors.mainColor,
                        //   shape: const BeveledRectangleBorder(
                        //       borderRadius: BorderRadius.all(
                        //     Radius.circular(PsDimens.space8),
                        //   )),
                        //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                        //   onPressed: () async {
                        PSButtonWithIconWidget(
                          hasShadow: true,
                          width: double.infinity,
                          icon: Icons.edit,
                          titleText:
                          Utils.getString(context, 'item_detail__edit'),
                          onPressed: () async {
                            Navigator.pushNamed(context, RoutePaths.itemEntry,
                                arguments: ItemEntryIntentHolder(
                                    flag: PsConst.EDIT_ITEM,
                                    item: provider.itemDetail.data));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _IconsAndTowTitleWithColumnTextWidget extends StatelessWidget {
  const _IconsAndTowTitleWithColumnTextWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.subTitle,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: color == null
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: color),
              ),
              SizedBox(width: 12,),
              Text(
                subTitle,
                style: color == null
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: color),
              )
              // )
            ],
          )
        ],
      ),
    );
  }
}

class PromoteTileView extends StatefulWidget {
  const PromoteTileView(
      {Key key,
        @required this.animationController,
        @required this.product,
        @required this.provider})
      : super(key: key);

  final AnimationController animationController;
  final Product product;
  final ItemDetailProvider provider;

  @override
  _PromoteTileViewState createState() => _PromoteTileViewState();
}

class _PromoteTileViewState extends State<PromoteTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'item_detail__promote_your_item'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingIconWidget =
    Icon(Ionicons.ios_megaphone, color: PsColors.mainColor);

    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        leading: _expansionTileLeadingIconWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(
                height: PsDimens.space1,
                color: Theme.of(context).iconTheme.color,
              ),
              Padding(
                padding: const EdgeInsets.all(PsDimens.space12),
                child: Text(
                    Utils.getString(context, 'item_detail__promote_sub_title')),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space12,
                    right: PsDimens.space12,
                    bottom: PsDimens.space12),
                child: Text(Utils.getString(
                    context, 'item_detail__promote_description')),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: PsDimens.space12),
                    child: SizedBox(
                        width: PsDimens.space180,
                        child: PSButtonWithIconWidget(
                            hasShadow: false,
                            width: double.infinity,
                            icon: Ionicons.ios_megaphone,
                            titleText:
                            Utils.getString(context, 'item_detail__promte'),
                            onPressed: () async {
                              final dynamic returnData =
                              await Navigator.pushNamed(
                                  context, RoutePaths.itemPromote,
                                  arguments: widget.product);
                              if (returnData) {
                                final String loginUserId =
                                Utils.checkUserLoginId(
                                    widget.provider.psValueHolder);
                                widget.provider.loadProduct(
                                    widget.product.id, loginUserId);
                              }
                            })),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: PsDimens.space18, bottom: PsDimens.space8),
                    child: Image.asset(
                      'assets/images/baseline_promotion_color_74.png',
                      width: PsDimens.space80,
                      height: PsDimens.space80,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
