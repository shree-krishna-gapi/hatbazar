import 'dart:async';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:hatbazar/constant/router.dart' as router;
import 'package:hatbazar/gapi/newDrawer/radio/radioStream.dart';
import 'package:hatbazar/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hatbazar/config/ps_theme_data.dart';
import 'package:hatbazar/provider/common/ps_theme_provider.dart';
import 'package:hatbazar/provider/ps_provider_dependencies.dart';
import 'package:hatbazar/repository/ps_theme_repository.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'config/ps_colors.dart';
import 'config/ps_config.dart';
import 'db/common/ps_shared_preferences.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    _fcm.requestNotificationPermissions(const IosNotificationSettings());
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('getLoadVideo', true); // gapi
  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', null);
    await prefs.setString('codeL', null);
  }
  Admob.initialize(Utils.getAdAppId());

  //check is apple signin is available
  await Utils.checkAppleSignInAvailable();

  runApp(EasyLocalization(
      path: 'assets/langs',
      supportedLocales: getSupportedLanguages(),
      child: PSApp()));
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in PsConfig.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;
  @override
  void initState() {
    super.initState();
  }

  Future<ThemeData> getSharePerference(
      EasyLocalization provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    // init Color
    PsColors.loadColor(context);
    print('*** ${Utils.convertColorToString(PsColors.mainColor)}');
    return MultiProvider(
        providers: <SingleChildWidget>[
          ...providers,
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Hat Bazar',
                theme: theme,
                initialRoute: '/',
                onGenerateRoute: router.generateRoute,
                localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  EasyLocalization.of(context).delegate,
                ],
                supportedLocales: EasyLocalization.of(context).supportedLocales,
                locale: EasyLocalization.of(context).locale,
              );
            }));
  }
}
