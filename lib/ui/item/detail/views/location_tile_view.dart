import 'package:flutter_icons/flutter_icons.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_constants.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/constant/route_paths.dart';
import 'package:hatbazar/ui/common/ps_expansion_tile.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:hatbazar/viewobject/product.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
class LocationTileView extends StatefulWidget {
  const LocationTileView({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Product item;

  @override
  _LocationTileViewState createState() => _LocationTileViewState();
}

class _LocationTileViewState extends State<LocationTileView> {
//  LatLng _center ;

  String adtionalDistance ='';
  @override
  void initState() {
    // TODO: implement initState
    this._getCurrentLocation();
    super.initState();
  }
  _getCurrentLocation() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double currentLatitude = position.latitude;
    double currentLongitude = position.longitude;
    double calculateDistance(lat1, lon1, lat2, lon2){
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p)/2 +
          c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p))/2;
      return 12742 * asin(sqrt(a));
    }

    List<dynamic> data = [
      {
        "lat": widget.item.lat,
        "lng": widget.item.lng
      },{
        "lat": currentLatitude,
        "lng": currentLongitude
      }
    ];
    double totalDistance = 0;
    for(var i = 0; i < data.length-1; i++){
      totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"], data[i+1]["lat"], data[i+1]["lng"]);
    }
    print('total is $totalDistance');
    setState(() {
      adtionalDistance = totalDistance.toString();
    });
  }
  @override
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'location_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingWidget = Icon(
      SimpleLineIcons.location_pin,
      color: PsColors.mainColor,
    );
    // if (productDetail != null && productDetail.description != null) {
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
        leading: _expansionTileLeadingWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              InkWell(
                child: Ink(
                  child: Padding(
                    padding: const EdgeInsets.all(PsDimens.space16),
                    child: Text(
                      Utils.getString(
                              context, 'location_tile__view_on_map_button')
                          .toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: PsColors.mainColor),
                    ),
                  ),
                ),
                onTap: () async {
                  await Navigator.pushNamed(context, RoutePaths.mapPin,
                      arguments: MapPinIntentHolder(
                          flag: PsConst.VIEW_MAP,
                          mapLat: widget.item.lat,
                          mapLng: widget.item.lng));
                },
              ),
              adtionalDistance == '' ? Text('') :Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Row(
                  children: <Widget>[
                    Text(
                      Utils.getString(
                          context, 'Additional Distance')
                          .toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 13),
                    ),
                    Text(
                      Utils.getString(
                          context, ' ${adtionalDistance} Km')
                          .toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // } else {
    //   return const Card();
    // }
  }
}
