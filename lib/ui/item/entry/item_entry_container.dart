import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/viewobject/product.dart';

import 'item_entry_view.dart';

class ItemEntryContainerView extends StatefulWidget {
  const ItemEntryContainerView({
    @required this.flag,
    @required this.item,
  });
  final String flag;
  final Product item;
  @override
  ItemEntryContainerViewState createState() => ItemEntryContainerViewState();
}

class ItemEntryContainerViewState extends State<ItemEntryContainerView>
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
          title: Text(
            Utils.getString(context, 'item_entry__listing_entry'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.mainColorWithWhite),
          ),
          elevation: 0,
        ),
        body: ItemEntryView(
          animationController: animationController,
          flag: widget.flag,
          item: widget.item,
        ),
      ),
    );
  }
}
