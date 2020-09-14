import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/ps_colors.dart';
import 'gapi/fadeAnimation.dart';


class ProfileAddress extends StatefulWidget {
  const ProfileAddress({this.stateId,this.districtId,this.municipalityId,this.wardId,this.streetName
  });

  final int stateId,districtId,municipalityId,wardId;
  final String streetName;
  @override
  _ProfileAddressState createState() => _ProfileAddressState();
}

class _ProfileAddressState extends State<ProfileAddress> {

  int stateIndex;
  String stateText;
  int stateId;

  int districtIndex;
  String districtText;
  int districtId = 0;

  int municipalityIndex;
  String municipalityText;
  int municipalityId = 0;

  int wardIndex;
  String wardText;
  int wardId = 0;
  int wardTotal;
  double districtDialogHeight = 400.0;
  final TextEditingController streetNameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    this.defaultSet();
    super.initState();
  }
  defaultSet()async {
    setState(() {
      stateId = widget.stateId;
      districtId = widget.districtId;
      municipalityId = widget.municipalityId;
      wardId = widget.wardId;
    });
    streetNameController.text = widget.streetName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('profileStateId',widget.stateId);
    prefs.setInt('profileDistrictId',widget.districtId);
    prefs.setInt('profileMunicipalityId',widget.municipalityId);
    prefs.setInt('profileWardId',widget.wardId);
    prefs.setString('profileStreetName',widget.streetName);
  }
  double height = PsDimens.space44;
  double paddingLeft = 10.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(Utils.getString(context, 'label__state'), style: Theme.of(context).textTheme.bodyText2),
        ),
        InkWell(
          onTap: _stateDialog,
          child: Container(
            width: double.infinity,
            height: height,
            padding: EdgeInsets.only(left: paddingLeft),
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: stateText == null ? FutureBuilder(
                        builder: (context, snapshot) {
                          var stateData = json.decode(snapshot.data.toString());
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: stateData == null ? 0 : stateData.length,
                            itemBuilder: (BuildContext context, int index){
                              return stateData[index]['stateId'] == stateId ? Text('${stateData[index]['stateName']}',):Container(height: 0,);
                            },
                          );
                        },
                        future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/state.json")
                    ):TextField(
                        style: Theme.of(context).textTheme.button.copyWith(),
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: stateText,
                            hintStyle: Theme.of(context).textTheme.button.copyWith(),
                            ),
                      ),

                ),
                Padding(
                  padding: const EdgeInsets.only(right:10),
                  child: stateText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(Utils.getString(context, 'label__district'), style: Theme.of(context).textTheme.bodyText2),
        ),
        // district
        InkWell(
          onTap: () {
            if(stateId != 0) {
              _districtDialog();
            }
            else {
              Fluttertoast.showToast(
                msg: Utils.getString(context, 'warning__choose__state'),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: PsColors.mainColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          },

          child: Container(
            width: double.infinity,
            height: height,
            padding: EdgeInsets.only(left: paddingLeft),
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                      child: districtText == null ? FutureBuilder(
                          builder: (context, snapshot) {
                            var stateData = json.decode(snapshot.data.toString());
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: stateData == null ? 0 : stateData.length,
                              itemBuilder: (BuildContext context, int index){
                                return stateData[index]['districtId'] == districtId ? Text('${stateData[index]['districtName']}',):Container(height: 0,);
                              },
                            );
                          },
                          future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/district.json")
                      ):TextField(
                        style: Theme.of(context).textTheme.button.copyWith(),
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: districtText,
                            hintStyle: Theme.of(context).textTheme.button.copyWith(),
                            ),
                      ),

                ),
                Padding(
                  padding: const EdgeInsets.only(right:10),
                  child: districtText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(Utils.getString(context, 'label__municipality'), style: Theme.of(context).textTheme.bodyText2),
        ),
        // municipality
        InkWell(
          onTap: _municipalityDialog,
          child: Container(
            width: double.infinity,
            height: height,
            padding: EdgeInsets.only(left: paddingLeft),
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                      child: municipalityText == null ? FutureBuilder(
                          builder: (context, snapshot) {
                            var stateData = json.decode(snapshot.data.toString());
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: stateData == null ? 0 : stateData.length,
                              itemBuilder: (BuildContext context, int index){
                                return stateData[index]['municipalityId'] == municipalityId ? Text('${stateData[index]['municipalityName']}',):Container(height: 0,);
                              },
                            );
                          },
                          future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/municipality${widget.stateId}.json")
                      ):TextField(
                        style: Theme.of(context).textTheme.button.copyWith(),
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: municipalityText,
                            hintStyle: Theme.of(context).textTheme.button.copyWith(),
                            ),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:10),
                  child: municipalityText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                )
              ],
            ),
          ),

        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(Utils.getString(context, 'label__ward'), style: Theme.of(context).textTheme.bodyText2),
        ),
        // ward
        InkWell(
          onTap: _wardDialog,
          child: Container(
            width: double.infinity,
            height: height,
            padding: EdgeInsets.only(left: paddingLeft),
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: Row(
              children: <Widget>[
                Expanded(

                      child: wardText == null ? FutureBuilder(
                          builder: (context, snapshot) {
                            var stateData = json.decode(snapshot.data.toString());
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: stateData == null ? 0 : stateData.length,
                              itemBuilder: (BuildContext context, int index){
                                return stateData[index]['wardId'] == wardId ? Text('${stateData[index]['wardName']}',):Container(height: 0,);
                              },
                            );
                          },
                          future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/ward.json")
                      ):TextField(
                        style: Theme.of(context).textTheme.button.copyWith(),
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: wardText,
                            hintStyle: Theme.of(context).textTheme.button.copyWith(),
                            ),
                      ),

                ),
                Padding(
                  padding: const EdgeInsets.only(right:10),
                  child: wardText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(Utils.getString(context, 'label__street'), style: Theme.of(context).textTheme.bodyText2),
        ),
        Container(
          width: double.infinity,
          height: height,
          padding: EdgeInsets.only(left: paddingLeft),
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius: BorderRadius.circular(PsDimens.space4),
            border: Border.all(color: PsColors.mainDividerColor),
          ),
          child: TextField(
            style: Theme.of(context).textTheme.bodyText2,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Utils.getString(context, 'Street Name'),
                hintStyle: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: PsColors.textPrimaryLightColor)

            ),
            onChanged: (v)async {
              print(v);

              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('profileStreetName',v);
            },
controller: streetNameController,
          ),
        ),
      ],
    );
  }


  _stateDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                  height: districtDialogHeight,
                  width: double.infinity,
                  child: Container(
                      height: districtDialogHeight,
                      width: double.infinity,
                      child:Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 60,
                                width: double.infinity,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: PsColors.mainColor,
                                ),

                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: PsDimens.space4,
                                    ),
                                    Icon(
                                      Icons.album,size: 16,
                                      color: PsColors.white,
                                    ),
                                    const SizedBox(
                                      width: PsDimens.space6,
                                    ),
                                    Text(Utils.getString(context, 'choose__state'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: PsColors.white)),
                                  ],
                                )),
                            Expanded(
                              child: FutureBuilder(builder: (context,snapshot) {
                                var showData = json.decode(snapshot.data.toString());
                                return Container(
//                          height: disctictDialogHeight, // Change as per your requirement
                                  width: 300.0, // Change as per your requirement
                                  child: FadeAnimation(
                                    0.2, ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: showData == null ? 0 : showData.length,
                                    itemBuilder: (BuildContext context, int index) {
//                        indexDistrict
                                      return index == stateIndex ? InkWell(
                                        child: Container(
                                          color: PsColors.mainColor,
                                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text('${showData[index]['stateName']}',style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                        onTap: () async {
                                          stateIndex=index;
                                         int currentId = showData[index]['stateId'];
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int oldId = prefs.getInt('profileStateId');

                                          if(oldId != currentId) {
                                            districtId = 0;
                                            municipalityId = 0;

                                            prefs.setInt('profileDistrictId',districtId);
                                            prefs.setInt('profileMunicipalityId',municipalityId);
                                            prefs.setInt('profileWardId',0);
                                            setState(() {
                                              wardId = 0;
                                              districtText = null;
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }
                                          prefs.setInt('profileStateId',currentId);
                                          setState(() {
                                            stateId = currentId;
                                            stateText = showData[index]['stateName'];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ):
                                      InkWell(
                                        onTap: () async {
                                          stateIndex=index;
                                          int currentId = showData[index]['stateId'];
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int oldId = prefs.get('profileStateId');

                                          if(oldId != currentId) {
                                            districtId = 0;
                                            municipalityId = 0;

                                            prefs.setInt('profileDistrictId',districtId);
                                            prefs.setInt('profileMunicipalityId',municipalityId);
                                            prefs.setInt('profileWardId',0);
                                            setState(() {
                                              wardId = 0;
                                              districtText = null;
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }

                                          prefs.setInt('profileStateId',currentId);
                                          setState(() {
                                            stateId = currentId;
                                            stateText = showData[index]['stateName'];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
//                                  color: Colors.cyan,
                                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 7.5),
                                            child: Text('${showData[index]['stateName']}'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ),
                                );
                              },future:
                              DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/state.json")


                                ,),
                            ),
                          ],
                        ),
                      )
                  )
              ));});
  }
  _districtDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),

              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),

              content: Container(
                  height: districtDialogHeight,
                  width: double.infinity,
                  child: Container(
                      height: districtDialogHeight,
                      width: double.infinity,
                      child:Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 60,
                                width: double.infinity,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: PsColors.mainColor,
                                ),

                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: PsDimens.space4,
                                    ),
                                    Icon(
                                      Icons.album,size: 16,
                                      color: PsColors.white,
                                    ),
                                    const SizedBox(
                                      width: PsDimens.space6,
                                    ),
                                    Text(Utils.getString(context, 'choose__district'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: PsColors.white)),
                                  ],
                                )),
                            Expanded(
                              child: FutureBuilder(builder: (context,snapshot) {
                                var showData = json.decode(snapshot.data.toString());
                                return Container(
//                          height: disctictDialogHeight, // Change as per your requirement
                                  width: 300.0, // Change as per your requirement
                                  child: FadeAnimation(
                                    0.2, ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: showData == null ? 0 : showData.length,
                                    itemBuilder: (BuildContext context, int index) {
//                                      print('you choose state id-> $stateId && ${showData[index]['stateId']}');
                                      return index == districtIndex ? InkWell(
                                        child: showData[index]['stateId'] == stateId ? Container(
                                          color: PsColors.mainColor,
                                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text('${showData[index]['districtName']}',
                                                style: TextStyle(color: Colors.white)),
                                          ),
                                        ):  Container(height: 0,),
                                        onTap: ()async {
                                          districtIndex=index;
                                          int currentId = showData[index]['districtId'];
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int oldId = prefs.get('profileDistrictId');
                                          if(oldId != currentId) {
                                            municipalityId = 0;

                                            prefs.setInt('profileMmunicipalityId',municipalityId);
                                            prefs.setInt('profileWardId',0);
                                            setState(() {
                                              wardId = 0;
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }
                                          districtId = currentId;
                                          prefs.setInt('profileDistrictId',currentId);
                                          setState(() {
                                            districtText = showData[index]['districtName'];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ):
                                      InkWell(
                                        onTap: ()async {
                                          districtIndex=index;
                                          int currentId = showData[index]['districtId'];
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int oldId = prefs.get('profileDistrictId');
                                          if(oldId != currentId) {
                                            municipalityId = 0;

                                            prefs.setInt('profileMunicipalityId',municipalityId);
                                            prefs.setInt('profileWardId',0);
                                            setState(() {
                                              wardId = 0;
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }
                                          districtId = currentId;
                                          prefs.setInt('profileDistrictId',currentId);
                                          setState(() {
                                            districtText = showData[index]['districtName'];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: showData[index]['stateId'] == stateId ? Container(
//                                  color: Colors.cyan,
                                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 7.5),
                                            child: Text('${showData[index]['districtName']}',
                                                style: TextStyle(color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75))),
                                          ),
                                        ): Container(height: 0,),
                                      );
                                    },
                                  ),
                                  ),
                                );
                              },future: DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/district.json"),),
                            ),
                          ],
                        ),
                      )
                  )
              ));});
  }
  _municipalityDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                  height: districtDialogHeight,
                  width: double.infinity,
                  child: Container(
                      height: districtDialogHeight,
                      width: double.infinity,
                      child:Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 60,
                                width: double.infinity,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: PsColors.mainColor,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: PsDimens.space4,
                                    ),
                                    Icon(
                                      Icons.album,size: 16,
                                      color: PsColors.white,
                                    ),
                                    const SizedBox(
                                      width: PsDimens.space6,
                                    ),
                                    Text(Utils.getString(context, 'choose__municipality'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: PsColors.white)),
                                  ],
                                )),
                            Expanded(
                              child: FutureBuilder(builder: (context,snapshot) {
                                var showData = json.decode(snapshot.data.toString());
                                return Container(
                                  width: 300.0, // Change as per your requirement
                                  child: FadeAnimation(
                                    0.3, ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: showData == null ? 0 : showData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return
                                        showData[index]['districtId'] == districtId ?
                                        index == municipalityIndex ? InkWell(
                                          child: Container(
                                            color: PsColors.mainColor,
                                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: Text('${showData[index]['municipalityName']}',style: TextStyle(color: Colors.white),),
                                            ),
                                          ),
                                          onTap: () async{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            int oldId = prefs.get('profileMunicipalityId');
                                            int currentId = showData[index]['municipalityId'];
                                            if(oldId != currentId) {

                                              prefs.setInt('profileWardId',0);
                                              setState(() {
                                                wardId = 0;
                                                wardText = null;
                                              });
                                            }
                                            wardTotal = showData[index]['wardTotal'];
                                            prefs.setInt('profileMunicipalityId',currentId);
                                            municipalityIndex=index;
                                            setState(() {
                                              municipalityText = showData[index]['municipalityName'];
                                            });
                                            municipalityId = currentId;
                                            Navigator.of(context).pop();
                                          },
                                        ):
                                        InkWell(
                                          onTap: ()async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            int oldId = prefs.get('profileMunicipalityId');
                                            int currentId = showData[index]['municipalityId'];
                                            if(oldId != currentId) {

                                              prefs.setInt('profileWardId',0);
                                              setState(() {
                                                wardId = 0;
                                                wardText = null;
                                              });
                                            }
                                            wardTotal = showData[index]['wardTotal'];
                                            prefs.setInt('profileMunicipalityId',currentId);

                                            municipalityIndex=index;
                                            setState(() {
                                              municipalityText = showData[index]['municipalityName'];
                                            });
                                            municipalityId = currentId;
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
//                                  color: Colors.cyan,
                                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 7.5),
                                              child: Text('${showData[index]['municipalityName']}'),
                                            ),
                                          ),
                                        )
                                            : Container();
                                    },
                                  ),
                                  ),
                                );
                              },future:
                              DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/municipality$stateId.json"),),
                            ),
                          ],
                        ),
                      )
                  )
              ));});
  }
  _wardDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                  height: districtDialogHeight,
                  width: double.infinity,
                  child: Container(
                      height: districtDialogHeight,
                      width: double.infinity,
                      child:Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: 60,
                                width: double.infinity,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: PsColors.mainColor,
                                ),

                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      width: PsDimens.space4,
                                    ),
                                    Icon(
                                      Icons.album,size: 16,
                                      color: PsColors.white,
                                    ),
                                    const SizedBox(
                                      width: PsDimens.space6,
                                    ),
                                    Text(Utils.getString(context, 'choose_ward'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(color: PsColors.white)),
                                  ],
                                )),
                            Expanded(
                              child: FutureBuilder(builder: (context,snapshot) {
                                var showData = json.decode(snapshot.data.toString());
                                return Container(
                                  width: 300.0, // Change as per your requirement
                                  child: FadeAnimation(
                                    0.2, ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: showData == null ? 0 : showData.length,
                                    itemBuilder: (BuildContext context, int index) {
//                        indexDistrict
                                      return index == wardIndex ? InkWell(
                                        child: index <  10? Container( //wardTotal
                                          color: PsColors.mainColor,
                                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text('${showData[index]['wardName']}',style: TextStyle(color: Colors.white),),
                                          ),
                                        ): Container(),
                                        onTap: ()async {
                                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                                          setState(() {
                                            wardText = showData[index]['wardName'];
                                          });
                                          wardId = showData[index]['wardId'];
                                          prefs.setInt('profileWardId',wardId);
                                          Navigator.of(context).pop();
                                        },
                                      ):
                                      InkWell(
                                        onTap: () async{
                                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                                          wardIndex=index;
                                          setState(() {
                                            wardText = showData[index]['wardName'];
                                          });
                                          wardId = showData[index]['wardId'];
                                          prefs.setInt('profileWardId',wardId);
                                          Navigator.of(context).pop();
                                        },
                                        child: index < 10 ? Container( //wardTotal
//                                  color: Colors.cyan,
                                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 7.5),
                                            child: Text('${showData[index]['wardName']}'),
                                          ),
                                        ):Container(),
                                      );
                                    },
                                  ),
                                  ),
                                );
                              },future: DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/ward.json"),),
                            ),
                          ],
                        ),
                      )
                  )
              ));});
  }
}
