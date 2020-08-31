import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
class GettingThisTileView extends StatefulWidget {
  const GettingThisTileView({
    Key key,
    @required this.detailOptionId,
    @required this.address,
    @required this.stateId,
    @required this.districtId,
    @required this.municipalityId,
    @required this.wardId,
    @required this.streetName,
  }) : super(key: key);

  final String detailOptionId;
  final String address;
  final String stateId;
  final String districtId;
  final String municipalityId;
  final String wardId;
  final String streetName;
  @override
  _GettingThisTileViewState createState() => _GettingThisTileViewState();
}

class _GettingThisTileViewState extends State<GettingThisTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'getting_this_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileIconWidget = Icon(
      MaterialCommunityIcons.lightbulb_on_outline,
      color: PsColors.mainColor,
    );
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
        leading: _expansionTileIconWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        SimpleLineIcons.location_pin,
                        size: PsDimens.space20,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: PsDimens.space40,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.detailOptionId == '1'
                                  ? Utils.getString(
                                      context, 'getting_this_tile__meet_up')
                                  : Utils.getString(context,
                                      'getting_this_tile__mailing_on_delivery'),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            // const SizedBox(
                            //   height: PsDimens.space8,
                            // ),
                            Row(
                              children: [
                                Container(width: 55,child: widget.stateId == null || widget.stateId == '' ? Text('') :FutureBuilder(
                                    builder: (context, snapshot) {
                                      var stateData = json.decode(snapshot.data.toString());
                                      return Container(
                                        height: 38,
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 14),
                                          shrinkWrap: true,
                                          itemCount: stateData == null ? 0 : stateData.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return stateData[index]['stateId'].toString() == widget.stateId ? Text('${stateData[index]['stateName']},',):Container(height: 0,);
                                          },
                                        ),
                                      );
                                    },
                                    future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/state.json")
                                ),),Expanded(child:  widget.districtId == null || widget.districtId == '' ? Text('') :
                                FutureBuilder(
                                    builder: (context, snapshot) {
                                      var stateData = json.decode(snapshot.data.toString());
                                      return Container(
                                        height: 38,
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: 14),
                                          itemCount: stateData == null ? 0 : stateData.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return stateData[index]['districtId'].toString() == widget.districtId ? Text('${stateData[index]['districtName']}'):Text('');
                                          },
                                        ),
                                      );
                                    },
                                    future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/district.json")
                                ),)
                              ],
                            ),
                           
                            Row(
                              children: [
                                Container(width: 80,child: widget.wardId == null || widget.wardId == '' ? Text('') :FutureBuilder(
                                    builder: (context, snapshot) {
                                      var stateData = json.decode(snapshot.data.toString());
                                      return ListView.builder(
                                        padding: EdgeInsets.only(bottom: 3.5),
                                        shrinkWrap: true,
                                        itemCount: stateData == null ? 0 : stateData.length,
                                        itemBuilder: (BuildContext context, int index){
                                          return stateData[index]['wardId'].toString() == widget.wardId ? Padding(
                                            padding: const EdgeInsets.only(bottom:4.0),
                                            child: Text('${stateData[index]['wardName']},',),
                                          ):Container() ;
                                        },
                                      );
                                    },
                                    future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/ward.json")
                                ),),
                                Expanded(child: widget.municipalityId == null || widget.municipalityId == '' ? Text('') :FutureBuilder(
                                    builder: (context, snapshot) {
                                      var stateData = json.decode(snapshot.data.toString());
                                      return Container(
                                        // color: Colors.greenAccent,
                                        child: ListView.builder(
                                            padding: EdgeInsets.only(bottom: 3.5),
                                          shrinkWrap: true,
                                          itemCount: stateData == null ? 0 : stateData.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return stateData[index]['municipalityId'].toString() == widget.municipalityId ? Text('${stateData[index]['municipalityName']}',):Container() ;
                                          },
                                        ),
                                      );
                                    },
                                    future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/municipality${widget.stateId}.json")
                                ),),
                              ],
                            ),

                            Row(
                              children: [
                                Text(
                                  widget.address != '' ? widget.address : '',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
//                                stateId != '' ? Text('$stateId',style: Theme.of(context).textTheme.bodyText1,) :
//                                Text(''),
                              ],
                            ),
                            widget.streetName == null || widget.streetName == '' ? Text(''):Padding(
                              padding: const EdgeInsets.only(top:4.0),
                              child: Text('${widget.streetName}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
