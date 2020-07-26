import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';

import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/subcategory/sub_category_provider.dart';
import 'package:flutterbuyandsell/repository/sub_category_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/subcategory/item/sub_category_search_list_item1.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
//import 'package:flutterbuyandsell/test.dart';
class SubCategoryForHome extends StatefulWidget {
  const SubCategoryForHome({@required this.categoryId,this.appBarTitle});

  final String categoryId;
  final String appBarTitle;
  @override
  State<StatefulWidget> createState() {
    return _SubCategoryForHomeState();
  }
}

class _SubCategoryForHomeState extends State<SubCategoryForHome>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SubCategoryProvider _subCategoryProvider;
  // final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    this.getTitle();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _subCategoryProvider.nextSubCategoryList(widget.categoryId);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }
  String appBarName='';
  getTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String title = prefs.getString('subCategoryForHome');
    setState(() {
      appBarName = title;
    });
  }
  SubCategoryRepository repo1;

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

    repo1 = Provider.of<SubCategoryRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<SubCategoryProvider>(
          appBarTitle: Utils.getString(
              context, '$appBarName') ??
              '',
          initProvider: () {
            return SubCategoryProvider(
              repo: repo1,
            );
          },
          onProviderReady: (SubCategoryProvider provider) {
            provider.loadSubCategoryList(widget.categoryId);
            _subCategoryProvider = provider;
          },
          builder: (BuildContext context, SubCategoryProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                    child: OrientationBuilder(

                        builder: (context, orientation)
                    {
                      return GridView.count(
                        crossAxisCount: orientation == Orientation.portrait ? 3 : 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,

                        children: List.generate(provider.subCategoryList.data.length, (index) {
                          if (provider.subCategoryList.status ==
                              PsStatus.BLOCK_LOADING) {
                            return Shimmer.fromColors(
                                baseColor: PsColors.grey,
                                highlightColor: PsColors.white,
                                child: Column(children: const <Widget>[
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                  PsFrameUIForLoading(),
                                ]));
                          } else {
                            final int count = provider.subCategoryList.data.length;
                            animationController.forward();
                            return FadeTransition(
                                opacity: animation,
                                child: SubCategorySearchListItem1(
                                  animationController: animationController,
                                  animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  subCategory: provider.subCategoryList.data[index],
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String subCatId = provider.subCategoryList.data[index].id;
                                    prefs.setString('subCatId', subCatId);
                                    final ProductParameterHolder
                                    productParameterHolder =      ProductParameterHolder()
                                        .getLatestParameterHolder();
                                    print(provider.subCategoryList.data[index]
                                        .defaultPhoto.imgPath);

                                    //Navigator.pop(context, provider.subCategoryList.data[index]);
                                    String catId = prefs.getString('categoryCatId');
                                    final Map<String, String> dataHolder = <String, String>{};
                                    dataHolder[PsConst.CATEGORY_ID] = catId;
                                    dataHolder[PsConst.SUB_CATEGORY_ID] = subCatId;
                                    Navigator.pushNamed(
                                        context, RoutePaths.filterProductList,
                                        arguments: ProductListIntentHolder(
                                          appBarTitle: provider.subCategoryList.data[index].name,
                                          productParameterHolder: productParameterHolder,
                                        )
                                    );

//                                    Navigator.of(context, rootNavigator: true)
//                                        .pop(provider.subCategoryList.data[index]);

                                    // if (index == 0) {

                                    // }
                                  },
                                ),
                            );
                          }
                        }),
                      );

                    }),
                    onRefresh: () {
                      return provider.resetSubCategoryList(widget.categoryId);
                    },
                  )),

              PSProgressIndicator(provider.subCategoryList.status)
            ]);
          }),
    );
  }
}


class Single_prod extends StatelessWidget {
  final item_pic;
  final icon_name;
  Single_prod({this.item_pic,this.icon_name});
  @override
  Widget build(BuildContext context) {
    return Card(

//        tag: item_pic,
      child: Material(
        child: InkWell(customBorder: Border.all(width:2.0,color: Colors.black),
            child: GridTile(
              footer: Container(
                color: Colors.black54,
                child: ListTile(leading: Text(icon_name,style: TextStyle(fontSize: 12.0,color: Colors.white,),),),
                height: 40.0,
              ),
              child: Image.asset(item_pic,fit: BoxFit.fitWidth,),
            ),


        ),textStyle: TextStyle(color: Colors.white),
      ),

    );
  }













}

