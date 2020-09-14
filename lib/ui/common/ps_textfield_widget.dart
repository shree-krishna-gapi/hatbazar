import 'dart:convert';

import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PsTextFieldWidget extends StatelessWidget {
  const PsTextFieldWidget(
      {this.textEditingController,
      this.titleText = '',
      this.hintText,
      this.textAboutMe = false,
      this.height = PsDimens.space44,
      this.showTitle = true,
      this.keyboardType = TextInputType.text,
      this.isStar = false});

  final TextEditingController textEditingController;
  final String titleText;
  final String hintText;
  final double height;
  final bool textAboutMe;
  final TextInputType keyboardType;
  final bool showTitle;

  final bool isStar;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(titleText, style: Theme.of(context).textTheme.bodyText2);

    return Column(
      children: <Widget>[
        if (showTitle)
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space12,
                top: PsDimens.space12,
                right: PsDimens.space12),
            child: Row(
              children: <Widget>[
                if (isStar)
                  Row(
                    children: <Widget>[
                      Text(titleText,
                          style: Theme.of(context).textTheme.bodyText2),
                      Text(' *',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: PsColors.mainColor))
                    ],
                  )
                else
                  _productTextWidget
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
            width: double.infinity,
            height: height,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: TextField(
                keyboardType: keyboardType,
                maxLines: null,
                controller: textEditingController,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: textAboutMe
                    ? InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space12,
                          bottom: PsDimens.space8,
                          top: PsDimens.space10,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      )
                    : InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space12,
                          bottom: PsDimens.space8,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ))),
      ],
    );
  }
}
class StateEditWidget extends StatefulWidget {
  StateEditWidget({this.id});
  final String id;
  @override
  _StateEditWidgetState createState() => _StateEditWidgetState();
}

class _StateEditWidgetState extends State<StateEditWidget> {

  @override
  Widget build(BuildContext context) {
    return    FutureBuilder(
        builder: (context, snapshot) {
          var stateData = json.decode(snapshot.data.toString());
          return Container(
            width: double.infinity,
            height: PsDimens.space44,
            margin: const EdgeInsets.all(PsDimens.space12),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: stateData == null ? 0 : stateData.length,
              itemBuilder: (BuildContext context, int index){
                return stateData[index]['stateId'].toString() == widget.id ? Center(child: Text('${stateData[index]['stateName']}',)):Container(height: 0,);
                // return stateData[index]['stateId'].toString() == widget.id ? TextField(
                //   style: Theme.of(context).textTheme.button.copyWith(),
                //   readOnly: true,
                //   // onTap: _stateDialog,
                //   decoration: InputDecoration(
                //       border: InputBorder.none,
                //       hintText: stateData[index]['stateName'],
                //       hintStyle: Theme.of(context).textTheme.button.copyWith(),
                //     )
                //
                //   ,
                // ):Container(height: 0,);
              },
            ),
          );
        },
        future:  DefaultAssetBundle.of(context).loadString("assets/gapi/${Utils.getString(context, 'current__language')}/state.json")
    );
  }
}
