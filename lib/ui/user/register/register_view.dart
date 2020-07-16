import 'package:flutter/widgets.dart';
import 'package:hatbazar/api/common/ps_resource.dart';

import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/config/ps_config.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/constant/route_paths.dart';
import 'package:hatbazar/provider/user/user_provider.dart';
import 'package:hatbazar/repository/user_repository.dart';
import 'package:hatbazar/ui/common/dialog/error_dialog.dart';
import 'package:hatbazar/ui/common/dialog/warning_dialog_view.dart';
import 'package:hatbazar/ui/common/ps_button_widget.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/common/ps_value_holder.dart';
import 'package:hatbazar/viewobject/holder/user_register_parameter_holder.dart';
import 'package:hatbazar/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:hatbazar/gapi/fadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class RegisterView extends StatefulWidget {
  const RegisterView(
      {Key key,
        this.animationController,
        this.onRegisterSelected,
        this.goToLoginSelected})
      : super(key: key);
  final AnimationController animationController;
  final Function onRegisterSelected, goToLoginSelected;
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  UserRepository repo1;
  PsValueHolder valueHolder;
  TextEditingController streetController;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;

  getToken() {
    _firebaseMessaging.getToken().then((token) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('***********************************************************');
      print(token);
      print('***********************************************************');

    });
  }
  @override
  void initState() {
    getToken();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void dispose() {
    animationController.dispose();
    // nameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
          UserProvider(repo: repo1, psValueHolder: valueHolder);

          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
              streetController = TextEditingController(
                  text: provider.psValueHolder.userStreetToVerify);
          nameController = TextEditingController(
              text: provider.psValueHolder.userNameToVerify);
          emailController = TextEditingController(
              text: provider.psValueHolder.userEmailToVerify);
          passwordController = TextEditingController(
              text: provider.psValueHolder.userPasswordToVerify);

          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _TextFieldWidget(
                            streetName: streetController,
                            nameText: nameController,
                            emailText: emailController,
                            passwordText: passwordController,
                          ),
                          const SizedBox(
                            height: PsDimens.space8,
                          ),
                          _TermsAndConCheckbox(
                            provider: provider,
                            streetTextEditingController: streetController,
                            nameTextEditingController: nameController,
                            emailTextEditingController: emailController,
                            passwordTextEditingController: passwordController,
                          ),
                          const SizedBox(
                            height: PsDimens.space8,
                          ),
                          _SignInButtonWidget(
                            provider: provider,
                            streetTextEditingController: streetController,
                            nameTextEditingController: nameController,
                            emailTextEditingController: emailController,
                            passwordTextEditingController: passwordController,
                            onRegisterSelected: widget.onRegisterSelected,
                          ),
                          const SizedBox(
                            height: PsDimens.space16,
                          ),
                          _TextWidget(
                            goToLoginSelected: widget.goToLoginSelected,
                          ),
                          const SizedBox(
                            height: PsDimens.space64,
                          ),
                        ],
                      ),
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                            opacity: animation,
                            child: Transform(
                                transform: Matrix4.translationValues(
                                    0.0, 100 * (1.0 - animation.value), 0.0),
                                child: child));
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox({
    @required this.provider,
    @required this.streetTextEditingController,
    @required this.nameTextEditingController,
    @required this.emailTextEditingController,
    @required this.passwordTextEditingController,
  });

  final UserProvider provider;
  final TextEditingController
      streetTextEditingController,
      nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;
  @override
  __TermsAndConCheckboxState createState() => __TermsAndConCheckboxState();
}

class __TermsAndConCheckboxState extends State<_TermsAndConCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: PsDimens.space20,
        ),
        Checkbox(
          activeColor: PsColors.mainColor,
          value: widget.provider.isCheckBoxSelect,
          onChanged: (bool value) {
            setState(() {
              updateCheckBox(
                  widget.provider.isCheckBoxSelect,
                  context,
                  widget.provider,
                  widget.streetTextEditingController,
                  widget.nameTextEditingController,
                  widget.emailTextEditingController,
                  widget.passwordTextEditingController);
            });
          },
        ),
        Expanded(
          child: InkWell(
            child: Text(
              Utils.getString(context, 'login__agree_privacy'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              setState(() {
                updateCheckBox(
                    widget.provider.isCheckBoxSelect,
                    context,
                    widget.provider,
                    widget.streetTextEditingController,
                    widget.nameTextEditingController,
                    widget.emailTextEditingController,
                    widget.passwordTextEditingController);
              });
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(
    bool isCheckBoxSelect,
    BuildContext context,
    UserProvider provider,
    TextEditingController streetTextEditingController,
    TextEditingController nameTextEditingController,
    TextEditingController emailTextEditingController,
    TextEditingController passwordTextEditingController) {
  if (isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;
    //it is for holder
    provider.psValueHolder.userStreetToVerify = streetTextEditingController.text;
    provider.psValueHolder.userNameToVerify = nameTextEditingController.text;
    provider.psValueHolder.userEmailToVerify = emailTextEditingController.text;
    provider.psValueHolder.userPasswordToVerify =
        passwordTextEditingController.text;
    Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Ink(
          color: PsColors.backgroundColor,
          child: Text(
            Utils.getString(context, 'register__login'),
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: PsColors.mainColor),
          ),
        ),
      ),
      onTap: () {
        if (widget.goToLoginSelected != null) {
          widget.goToLoginSelected();
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.login_container,
          );
        }
      },
    );
  }
}

class _TextFieldWidget extends StatefulWidget {
  const _TextFieldWidget({
    @required this.nameText,
    @required this.emailText,
    @required this.passwordText,
    @required this.streetName,
  });

  final TextEditingController streetName, nameText, emailText, passwordText;
  @override
  __TextFieldWidgetState createState() => __TextFieldWidgetState();
}

class __TextFieldWidgetState extends State<_TextFieldWidget> {
  // gapi
  int stateIndex;
  String stateText;
  int stateId = 0;

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
  // gapi
  double districtDialogHeight = 400.0;
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
                                    0.1, ListView.builder(
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
                                          int oldId = prefs.get('stateId');
                                          stateId = currentId;
                                          if(oldId != currentId) {
                                            districtId = 0;
                                            municipalityId = 0;
                                            wardId = 0;
                                            prefs.setInt('districtId',districtId);
                                            prefs.setInt('municipalityId',municipalityId);
                                            prefs.setInt('wardId',wardId);
                                            setState(() {
                                              districtText = null;
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }
                                          prefs.setInt('stateId',currentId);
                                          setState(() {
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
                                          int oldId = prefs.get('stateId');
                                          stateId = currentId;
                                          if(oldId != currentId) {
                                            districtId = 0;
                                            municipalityId = 0;
                                            wardId = 0;
                                            prefs.setInt('districtId',districtId);
                                            prefs.setInt('municipalityId',municipalityId);
                                            prefs.setInt('wardId',wardId);
                                            setState(() {
                                              districtText = null;
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }

                                          prefs.setInt('stateId',currentId);
                                          setState(() {
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
                                    0.1, ListView.builder(
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
                                          int oldId = prefs.get('districtId');
                                          if(oldId != currentId) {
                                            municipalityId = 0;
                                            wardId = 0;
                                            prefs.setInt('municipalityId',municipalityId);
                                            prefs.setInt('wardId',wardId);
                                            setState(() {
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }
                                          districtId = currentId;
                                          prefs.setInt('districtId',currentId);
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
                                          int oldId = prefs.get('districtId');
                                          if(oldId != currentId) {
                                            municipalityId = 0;
                                            wardId = 0;
                                            prefs.setInt('municipalityId',municipalityId);
                                            prefs.setInt('wardId',wardId);
                                            setState(() {
                                              municipalityText = null;
                                              wardText = null;
                                            });
                                          }
                                          districtId = currentId;
                                          prefs.setInt('districtId',currentId);
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
                                    0.1, ListView.builder(
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
                                          int oldId = prefs.get('municipalityId');
                                          int currentId = showData[index]['municipalityId'];
                                          if(oldId != currentId) {
                                            wardId = 0;
                                            prefs.setInt('wardId',wardId);
                                            setState(() {
                                              wardText = null;
                                            });
                                          }
//                                          wardId = currentId;
                                          wardTotal = showData[index]['wardTotal'];
                                          prefs.setInt('municipalityId',currentId);
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
                                          int oldId = prefs.get('municipalityId');
                                          int currentId = showData[index]['municipalityId'];
                                          if(oldId != currentId) {
                                            wardId = 0;
                                            prefs.setInt('wardId',wardId);
                                            setState(() {
                                              wardText = null;
                                            });
                                          }

//                                          wardId = currentId;
                                          wardTotal = showData[index]['wardTotal'];
                                          prefs.setInt('municipalityId',currentId);

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
                                    0.1, ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: showData == null ? 0 : showData.length,
                                    itemBuilder: (BuildContext context, int index) {
//                        indexDistrict
                                      return index == wardIndex ? InkWell(
                                        child: index < wardTotal ? Container(
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
                                          prefs.setInt('wardId',wardId);
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
                                          prefs.setInt('wardId',wardId);
                                          Navigator.of(context).pop();
                                        },
                                        child: index < wardTotal ? Container(
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
  @override
  void initState() {
    // TODO: implement initState
    this.resetId();
    super.initState();
  }
  resetId()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('stateId',0);
    prefs.setInt('districtId',0);
    prefs.setInt('municipalityId',0);
    prefs.setInt('wardId',0);
  }
//  TextEditingController streetName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetWidget = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);

    const Widget _dividerWidget = Divider(
      height: PsDimens.space1,
    );
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: Column(
        children: <Widget>[
          //                                gapi
          // state
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
//                    color: Colors.amber,
                    margin: _marginEdgeInsetWidget,
                    child: stateText == null ? TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
                      onTap: _stateDialog,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Utils.getString(context, 'label__state'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.textPrimaryLightColor),
                          icon: Icon(Icons.album,
                              color: Theme.of(context).iconTheme.color)),
                    ):TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
                      onTap: _stateDialog,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: stateText,
                          hintStyle: Theme.of(context).textTheme.button.copyWith(),
                          icon: Icon(Icons.album,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  )
              ),
              InkWell(
                onTap: _stateDialog,
                child: Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: stateText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                ),
              )
            ],
          ),
          Divider(height: 1.0,),
          // district
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    margin: _marginEdgeInsetWidget,
                    child: districtText == null ? TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
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
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Utils.getString(context, 'label__district'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.textPrimaryLightColor),
                          icon: Icon(Icons.explore,
                              color: Theme.of(context).iconTheme.color)),
                    ):TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
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
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: districtText,
                          hintStyle: Theme.of(context).textTheme.button.copyWith(),
                          icon: Icon(Icons.explore,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  )
              ),
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
                child: Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: districtText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                ),
              )
            ],
          ),
          Divider(height: 1.0,),
          // municipality
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
//                    color: Colors.amber,
                    margin: _marginEdgeInsetWidget,
                    child: municipalityText == null ? TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
                      onTap: () {
                        if(districtId != 0) {
                          _municipalityDialog();
                        }
                        else {
                          Fluttertoast.showToast(
                            msg: Utils.getString(context, 'warning__choose__district'),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: PsColors.mainColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Utils.getString(context, 'label__municipality'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.textPrimaryLightColor),
                          icon: Icon(Icons.adjust,
                              color: Theme.of(context).iconTheme.color)),
                    ):TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
                      onTap: _municipalityDialog,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: municipalityText,
                          hintStyle: Theme.of(context).textTheme.button.copyWith(),
                          icon: Icon(Icons.adjust,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  )
              ),
              InkWell(
                onTap: _municipalityDialog,
                child: Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: municipalityText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                ),
              )
            ],
          ),
          Divider(height: 1.0,),
          // ward
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
//                    color: Colors.amber,
                    margin: _marginEdgeInsetWidget,
                    child: wardText == null || wardText=='' ? TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
                      onTap: () {
                        if(municipalityId != 0) {
                          _wardDialog();
                        }
                        else {
                          Fluttertoast.showToast(
                            msg: Utils.getString(context, 'warning__choose__municipality'),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: PsColors.mainColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Utils.getString(context, 'label__ward'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.textPrimaryLightColor),
                          icon: Icon(Icons.brightness_1,
                              color: Theme.of(context).iconTheme.color)),
                    ):TextField(
                      style: Theme.of(context).textTheme.button.copyWith(),
                      readOnly: true,
                      onTap: _wardDialog,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: wardText,
                          hintStyle: Theme.of(context).textTheme.button.copyWith(),
                          icon: Icon(Icons.brightness_1,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  )
              ),
              InkWell(
                onTap: _wardDialog,
                child: Padding(
                  padding: const EdgeInsets.only(right:20),
                  child: wardText == null ? Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryLightColor.withOpacity(0.75) ):
                  Icon(Icons.arrow_drop_down,color: PsColors.textPrimaryDarkColorForLight.withOpacity(0.75)),
                ),
              )
            ],
          ),
          Divider(height: 1.0,),
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.streetName,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'label__street'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.location_on,
                      color: Theme.of(context).iconTheme.color)),

            ),
          ),
          Divider(height: 1.0,),
//                                gapi
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.nameText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__user_name'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.people,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.emailText,
              style: Theme.of(context).textTheme.button.copyWith(),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__email'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.passwordText,
              obscureText: true,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__password'),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: PsColors.textPrimaryLightColor),
                  icon: Icon(Icons.lock,
                      color: Theme.of(context).iconTheme.color)),
              // keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        Container(
          width: 90,
          height: 90,
          child: Image.asset(
            'assets/images/flutter_buy_and_sell_logo.png',
          ),
        ),
        const SizedBox(
          height: PsDimens.space8,
        ),
        Text(
          Utils.getString(context, 'app_name'),
          style: Theme.of(context).textTheme.headline6.copyWith(
            fontWeight: FontWeight.bold,
            color: PsColors.mainColor,
          ),
        ),
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _SignInButtonWidget extends StatefulWidget {
  const _SignInButtonWidget(
      {@required this.provider,
        @required this.streetTextEditingController,
        @required this.nameTextEditingController,
        @required this.emailTextEditingController,
        @required this.passwordTextEditingController,
        this.onRegisterSelected});
  final UserProvider provider;
  final Function onRegisterSelected;
  final TextEditingController
  streetTextEditingController,
  nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;


  @override
  __SignInButtonWidgetState createState() => __SignInButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
        );
      });
}

class __SignInButtonWidgetState extends State<_SignInButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'register__register'),
        onPressed: () async {

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          int shareStateId = prefs.getInt('stateId');
          int shareDistrictId = prefs.getInt('districtId');
          int shareMunicipalityId = prefs.getInt('municipalityId');
          int shareWardId = prefs.getInt('wardId');
          if (widget.provider.isCheckBoxSelect) {
            //
            if(shareStateId == 0) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_state'));
            } else
            if(shareDistrictId == 0) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_district'));
            } else
            if(shareMunicipalityId == 0) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_municipality'));
            } else
            if(shareWardId == 0) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_ward'));
            }else
            if (widget.streetTextEditingController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_street')); }
            else if (widget.nameTextEditingController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_name'));
            } else if (widget.emailTextEditingController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_email'));
            } else if (widget.passwordTextEditingController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_password'));
            } else {
              if (await Utils.checkInternetConnectivity()) {
                print('here the register');
                final UserRegisterParameterHolder userRegisterParameterHolder =
                UserRegisterParameterHolder(
//                  pOne: '',
                  userId: '',
                  userName: widget.nameTextEditingController.text,
                  userEmail: widget.emailTextEditingController.text,
                  userPassword: widget.passwordTextEditingController.text,
                  userPhone: '',
                  deviceToken: widget.provider.psValueHolder.deviceToken,
                  stateId: shareStateId,
                  districtId: shareDistrictId,
                  municipalityId: shareMunicipalityId,
                  wardId: shareWardId,
                  streetName:  widget.streetTextEditingController.text
                );

                final PsResource<User> _apiStatus = await widget.provider
                    .postUserRegister(userRegisterParameterHolder.toMap());

                if (_apiStatus.data != null) {
                  final User user = _apiStatus.data;

                  //verify
                  await widget.provider.replaceVerifyUserData(
                      _apiStatus.data.userId,
                      _apiStatus.data.userName,
                      _apiStatus.data.userEmail,
                      widget.passwordTextEditingController.text);

                  widget.provider.psValueHolder.userIdToVerify = user.userId;
                  widget.provider.psValueHolder.userNameToVerify =
                      user.userName;
                  widget.provider.psValueHolder.userEmailToVerify =
                      user.userEmail;
                  widget.provider.psValueHolder.userPasswordToVerify =
                      user.userPassword;

                  //
                  if (widget.onRegisterSelected != null) {
                    await widget.onRegisterSelected(_apiStatus.data.userId);
                  } else {
                    final dynamic returnData = await Navigator.pushNamed(
                        context, RoutePaths.user_verify_email_container,
                        arguments: _apiStatus.data.userId);

                    if (returnData != null && returnData is User) {
                      final User user = returnData;
                      if (Provider != null && Provider.of != null) {
                        widget.provider.psValueHolder =
                            Provider.of<PsValueHolder>(context, listen: false);
                      }
                      widget.provider.psValueHolder.loginUserId = user.userId;
                      widget.provider.psValueHolder.userIdToVerify = '';
                      widget.provider.psValueHolder.userNameToVerify = '';
                      widget.provider.psValueHolder.userEmailToVerify = '';
                      widget.provider.psValueHolder.userPasswordToVerify = '';
//                      print(user.userId);
                      Navigator.of(context).pop();
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: _apiStatus.message,
                        );
                      });
                }
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'error_dialog__no_internet'),
                      );
                    });
              }
            }
            //
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(
                        context, 'login__warning_agree_privacy'),
                  );
                });
          }
        },
      ),
    );
  }
}
