import 'package:flutter/cupertino.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/ui/item/list_with_filter/product_list_with_filter_view.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:hatbazar/gapi/service/sub_category.dart';
class ProductListWithFilterContainerView extends StatefulWidget {
  const ProductListWithFilterContainerView(
      {@required this.productParameterHolder, @required this.appBarTitle});
  final ProductParameterHolder productParameterHolder;
  final String appBarTitle;
  @override
  _ProductListWithFilterContainerViewState createState() =>
      _ProductListWithFilterContainerViewState();
}

class _ProductListWithFilterContainerViewState
    extends State<ProductListWithFilterContainerView>
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
print(widget.productParameterHolder.runtimeType);
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
            widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(color: PsColors.mainColorWithWhite),
          ),
          elevation: 1,
        ),
        body:Container( child: FutureBuilder<List<OfflineFeeYear>>(
          future: FetchOffline(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) ;
            if(snapshot.hasData) {
              print('------------------------');
              print(snapshot.data.length);
              return snapshot.data.length> 0 ?ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {

                    return
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15,8,10,0),
                            child: Text('${snapshot.data[index].name}'),
                          ),
                        ],
                      );
                  }
              ):Text('Empty');
            }
            else {
              return Center(child: CircularProgressIndicator());
            }

          },
        ),),
      ),
    );
  }

}


