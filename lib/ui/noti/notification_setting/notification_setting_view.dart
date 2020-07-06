import 'package:flutter/services.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_constants.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/db/common/ps_shared_preferences.dart';
import 'package:hatbazar/provider/common/notification_provider.dart';
import 'package:hatbazar/repository/Common/notification_repository.dart';
import 'package:hatbazar/ui/common/base/ps_widget_with_appbar.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/common/ps_value_holder.dart';
import 'package:hatbazar/viewobject/holder/noti_register_holder.dart';
import 'package:hatbazar/viewobject/holder/noti_unregister_holder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NotificationSettingView extends StatefulWidget {
  @override
  _NotificationSettingViewState createState() =>
      _NotificationSettingViewState();
}

NotificationRepository notiRepository;
NotificationProvider notiProvider;
PsValueHolder _psValueHolder;
final FirebaseMessaging _fcm = FirebaseMessaging();

class _NotificationSettingViewState extends State<NotificationSettingView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    notiRepository = Provider.of<NotificationRepository>(context);
    _psValueHolder = Provider.of<PsValueHolder>(context);
    // final Widget _appbarWidget = AppBar(
    //   elevation: 0,
    //   automaticallyImplyLeading: true,
    //   title: Text(
    //     Utils.getString(context,'noti_setting__toolbar_name'),
    //     style: Theme.of(context).textTheme.headline6.copyWith(),
    //   ),
    // );
    print(
        '............................Build UI Again ...........................');

    return PsWidgetWithAppBar<NotificationProvider>(
        appBarTitle:
            Utils.getString(context, 'noti_setting__toolbar_name') ?? '',
        initProvider: () {
          return NotificationProvider(
              repo: notiRepository, psValueHolder: _psValueHolder);
        },
        onProviderReady: (NotificationProvider provider) {
          notiProvider = provider;
        },
        builder: (BuildContext context, NotificationProvider provider,
            Widget child) {
          return _NotificationSettingWidget(notiProvider: provider);
        });
  }
}

class _NotificationSettingWidget extends StatefulWidget {
  const _NotificationSettingWidget({this.notiProvider});
  final NotificationProvider notiProvider;
  @override
  __NotificationSettingWidgetState createState() =>
      __NotificationSettingWidgetState();
}

class __NotificationSettingWidgetState
    extends State<_NotificationSettingWidget> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    if (notiProvider.psValueHolder.notiSetting != null) {
      isSwitched = notiProvider.psValueHolder.notiSetting;
    }
    final Widget _switchButtonwidget = Switch(
        value: isSwitched,
        onChanged: (bool value) {
          setState(() {
            isSwitched = value;
            notiProvider.psValueHolder.notiSetting = value;
            notiProvider.replaceNotiSetting(value);
          });

          if (isSwitched == true) {
            _fcm.subscribeToTopic('broadcast');
            if (notiProvider.psValueHolder.deviceToken != null &&
                notiProvider.psValueHolder.deviceToken != '') {
              final String loginUserId =
                  Utils.checkUserLoginId(notiProvider.psValueHolder);

              final NotiRegisterParameterHolder notiRegisterParameterHolder =
                  NotiRegisterParameterHolder(
                      platformName: PsConst.PLATFORM,
                      deviceId: notiProvider.psValueHolder.deviceToken,
                      loginUserId: loginUserId);
              notiProvider
                  .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
            }
          } else {
            _fcm.unsubscribeFromTopic('broadcast');
            if (notiProvider.psValueHolder.deviceToken != null &&
                notiProvider.psValueHolder.deviceToken != '') {
              final String loginUserId =
                  Utils.checkUserLoginId(notiProvider.psValueHolder);
              final NotiUnRegisterParameterHolder
                  notiUnRegisterParameterHolder = NotiUnRegisterParameterHolder(
                      platformName: PsConst.PLATFORM,
                      deviceId: notiProvider.psValueHolder.deviceToken,
                      userId: loginUserId);
              notiProvider.rawUnRegisterNotiToken(
                  notiUnRegisterParameterHolder.toMap());
            }
          }
        },
        activeTrackColor: PsColors.mainColor,
        activeColor: PsColors.mainColor);

    final Widget _notiSettingTextWidget = Text(
      Utils.getString(context, 'noti_setting__onof'),
      style: Theme.of(context).textTheme.subtitle1,
    );

    final Widget _messageTextWidget = Row(
      children: <Widget>[
        Icon(
          FontAwesome.bullhorn,
          size: PsDimens.space16,
        ),
        const SizedBox(
          width: PsDimens.space16,
        ),
        Text(
          Utils.getString(context, 'noti__latest_message'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              top: PsDimens.space8,
              bottom: PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _notiSettingTextWidget,
              _switchButtonwidget,
            ],
          ),
        ),
        const Divider(
          height: PsDimens.space1,
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space20,
              bottom: PsDimens.space20,
              left: PsDimens.space8),
          child: _messageTextWidget,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
              top: PsDimens.space8,
              bottom: PsDimens.space20,
              left: PsDimens.space44,
              right: PsDimens.space16),
          child: Text(
            PsSharedPreferences.instance.getNotiMessage() ?? '-',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        const Divider(
          height: PsDimens.space1,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
              top: PsDimens.space20,
              left: PsDimens.space16,
              right: PsDimens.space16),
          child: Text(
            'Token Id',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: notiProvider.psValueHolder.deviceToken));
            Fluttertoast.showToast(
                msg: 'Token copied.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: PsColors.mainColor,
                textColor: PsColors.white);
          },
          child: Padding(
            padding: const EdgeInsets.only(
                top: PsDimens.space16,
                bottom: PsDimens.space20,
                left: PsDimens.space16,
                right: PsDimens.space16),
            child: Text(
              '${notiProvider.psValueHolder.deviceToken}',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        const Divider(
          height: PsDimens.space1,
        ),
      ],
    );
  }
}
