import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'dart:async';

import 'package:flutter_radio/flutter_radio.dart';
import 'dart:convert';
import 'package:flutterbuyandsell/gapi/fadeAnimation.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RadioStream extends StatefulWidget {
  @override
  _RadioStreamState createState() => _RadioStreamState();
}

class _RadioStreamState extends State<RadioStream> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    audioStart();
//    playingStatus();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    print('isPlay-> $isP');
  }
  bool radioPlay = false;
  int indexPlay = 99;
  bool connected;
  @override
  Widget build(BuildContext context) {
    DateTime backPressTime;
    Future<bool> _onWillPop() async {
//      DateTime currentTime = DateTime.now();
//      //Statement 1 Or statement2
//      bool backButton = backPressTime == null ||
//          currentTime.difference(backPressTime) > Duration(seconds: 3);
//      if (backButton) {
//        backPressTime = currentTime;
//      }
      Navigator.of(context).pop();
      await FlutterRadio.stop();
    }
//    userRepo = Provider.of<UserRepository>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color:PsColors.mainColor),
                onPressed: _onWillPop

            ),
            title: FadeAnimation(
              0.2, Text(
                Utils.getString(context, 'home__drawer_menu_additional_fm'),
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold,color: PsColors.mainColor)),
            ),
          ),
          body: OfflineBuilder(
    connectivityBuilder: (
    BuildContext context,
    ConnectivityResult connectivity,
    Widget child,
    ) {
    connected = connectivity != ConnectivityResult.none;
    if(connected == false) {
      Fluttertoast.showToast(
        msg: Utils.getString(context, 'Network Connection Failled!'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
//        timeInSecForIosWeb: 1,
        backgroundColor: PsColors.mainColor,
        textColor: Colors.white,
        fontSize: 16.0,

      );
    }
      return Container(
        color: Colors.black.withOpacity(0.05),
        height: double.infinity,
        child: FutureBuilder(
            builder: (context, snapshot) {
              var radioData = json.decode(snapshot.data.toString());
              return FadeAnimation( 0.2,
                 Container(

                    color: Colors.black.withOpacity(0.0),
                    padding: EdgeInsets.only(top: 0),
                    margin: EdgeInsets.only(top: 0),
                    height: 500,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: radioData == null ? 0 : radioData.length,
                      itemBuilder: (BuildContext context, int index){
                        return FadeAnimation(
                          0.3, Material(
                          color: Colors.white.withOpacity(0.8),
                          child: indexPlay == index ? InkWell(
                            splashColor: Colors.green,
                            child: Container(
                              decoration: BoxDecoration(
                                color: indexPlay == index ? Color(0xFFE5F6D2): Colors.white.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(-0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: Image.asset(radioData[index]['logo']),
                                  ),
                                    flex: 2,
                                  ),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${radioData[index]['name']}'),
                                      SizedBox(height: 7,),
                                      Text(radioData[index]['channel'],style: TextStyle(color: Colors.grey.withOpacity(0.8),
                                          fontSize: 13),)
                                    ],
                                  ),
                                    flex: 3,
                                  ),
                                  Expanded(child: Align(child:
                                  radioPlay ? Icon(Icons.pause,size: 30, color: Colors.green[600].withOpacity(0.9),):
                                  Icon(Icons.play_arrow,size: 30, color: Colors.green[600].withOpacity(0.9),)
                                    ,),flex: 1,)
                                ],
                              ),
                            ),
                            onTap: () {

                              setState(() {
                                indexPlay = index;
                                radioPlay =! radioPlay;
                              });
                              if (radioPlay == true) {
                                FlutterRadio.playOrPause(url: radioData[index]['url']);
                              } else {
//                              FlutterRadio.pause(url: radioData[index]['url']);
                                FlutterRadio.stop();
                              }
                            },

                          ):
                          InkWell(
                            splashColor: Colors.green,
                            child: Container(
                              decoration: BoxDecoration(
                                color: indexPlay == index ? Color(0xFFE5F6D2): Colors.white.withOpacity(0.9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(-0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: Image.asset(radioData[index]['logo']),
                                  ),
                                    flex: 2,
                                  ),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('${radioData[index]['name']}'),
                                      SizedBox(height: 7,),
                                      Text(radioData[index]['channel'],style: TextStyle(color: Colors.grey.withOpacity(0.9),
                                          fontSize: 13),)
                                    ],
                                  ),

                                    flex: 3,
                                  ),
                                  Expanded(child: Align(child:
                                  Icon(Icons.play_arrow,size: 30, color: Colors.green[600].withOpacity(0.9),)
                                    ,),flex: 1,)
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                indexPlay = index;
                                radioPlay = true;
                              });
                              if (radioPlay == true) {
                                FlutterRadio.playOrPause(url: radioData[index]['url']);
                              } else {
//                              FlutterRadio.pause(url: radioData[index]['url']);
                                FlutterRadio.stop();
                              }

                            },
                          ),
                        ),
                        );
                      },
                    )
                ),
              );
            },
            future:  DefaultAssetBundle.of(context).loadString("assets/gapi/radio/${Utils.getString(context, 'current__language')}/radio.json")

        ),

      ); },child: Text(''),)
      ),
    );
  }
}



