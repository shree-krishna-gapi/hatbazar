import 'package:hatbazar/api/common/ps_status.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/provider/item_location/item_location_provider.dart';
import 'package:hatbazar/repository/item_location_repository.dart';
import 'package:hatbazar/ui/common/base/ps_widget_with_appbar.dart';
import 'package:hatbazar/ui/common/ps_frame_loading_widget.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'item_entry_location_list_view_item.dart';

class ItemEntryLocationView extends StatefulWidget {
  // const ItemEntryLocationView({@required this.categoryId});

  @override
  State<StatefulWidget> createState() {
    return ItemEntryLocationViewState();
  }
}

class ItemEntryLocationViewState extends State<ItemEntryLocationView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemLocationProvider _itemLocationProvider;
  AnimationController animationController;
  Animation<double> animation;
  PsValueHolder valueHolder;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemLocationProvider.nextItemLocationList();
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

  ItemLocationRepository repo1;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
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

    repo1 = Provider.of<ItemLocationRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemLocationProvider>(
          appBarTitle: Utils.getString(context, 'item_entry__location') ?? '',
          initProvider: () {
            return ItemLocationProvider(
                repo: repo1, psValueHolder: valueHolder);
          },
          onProviderReady: (ItemLocationProvider provider) {
            provider.loadItemLocationList();
            _itemLocationProvider = provider;
          },
          builder: (BuildContext context, ItemLocationProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.itemLocationList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemLocationList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.white,
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
                        final int count = provider.itemLocationList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemEntryLocationListViewItem(
                              itemLocation:
                                  provider.itemLocationList.data[index],
                              onTap: () {
                                Navigator.pop(context,
                                    provider.itemLocationList.data[index]);
                                print(
                                    provider.itemLocationList.data[index].name);
                                // if (index == 0) {
                                //   Navigator.pushNamed(
                                //     context,
                                //     RoutePaths.searchCategory,
                                //   );
                                // }
                              },
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemLocationList();
                },
              )),
              PSProgressIndicator(provider.itemLocationList.status)
            ]);
          }),
    );
  }
}
