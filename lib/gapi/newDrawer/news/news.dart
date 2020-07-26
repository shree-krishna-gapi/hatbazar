import 'package:flutter/material.dart';
import 'tabs/tabOne.dart';
import 'tabs/tabThree.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 6,
          // This is the number of tabs.
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
//                  backgroundColor: Colors.purple,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color:PsColors.mainColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    elevation: 4,
                    pinned: true,
                    floating: false,
                    forceElevated: innerBoxIsScrolled,
                    title: Text(
                Utils.getString(context, 'news__section__main__heading'),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold,color: PsColors.mainColor)),
                    titleSpacing: 0.0,
                    bottom: PreferredSize(preferredSize: Size.fromHeight(40.0),
                        child: Container(
                          height: 50,
                          child: TabBar(
                            indicatorColor: PsColors.mainColor,
                            isScrollable: true,
                            tabs: <Widget>[
                              Text('${Utils.getString(context, 'news__section__main__tab__heading1')}',
                              style: TextStyle(fontWeight: FontWeight.bold,color: PsColors.mainColor),
                              ),Text('${Utils.getString(context, 'news__section__main__tab__heading2')}',style: TextStyle(
                                  fontWeight: FontWeight.bold,color: PsColors.mainColor
                              )),Text('${Utils.getString(context, 'news__section__main__tab__heading3')}',style: TextStyle(
                                  fontWeight: FontWeight.bold,color: PsColors.mainColor
                              )),
                              Text('${Utils.getString(context, 'news__section__main__tab__heading3')}',style: TextStyle(
                                  fontWeight: FontWeight.bold,color: PsColors.mainColor
                              )),
                              Text('${Utils.getString(context, 'news__section__main__tab__heading3')}',style: TextStyle(
                                  fontWeight: FontWeight.bold,color: PsColors.mainColor
                              )),
                              Text('${Utils.getString(context, 'news__section__main__tab__heading3')}',style: TextStyle(
                                  fontWeight: FontWeight.bold,color: PsColors.mainColor
                              )),
                            ],
                          ),
                        )),
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[

                  TabOne(),

                  Container(
                    color: Colors.pink[800],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Empty',style: TextStyle(color: Colors.white, fontSize: 24,

                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black87,
                                offset: Offset(2.0, 4.0),
                              ),
                            ],letterSpacing: 3
                        ),),
                      ],
                    ),
                  ),

                  TabThree(),
                  Container(),
                  Container(),
                  Container(),

                ],
              )
          )
      ),
    );
  }
}


class TopTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
            flex: 4,
            child: Text('',
            )
        ),
        Expanded(
          flex: 1,
          child:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(right:15.0),
//                child: Icon(Icons.center_focus_strong),
//              )
            ],
          ), ),
      ],
    );
  }
}
