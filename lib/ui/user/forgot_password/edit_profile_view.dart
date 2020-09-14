import 'dart:convert';
import 'dart:io';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/profileAddress.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/success_dialog.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/profile_update_view_holder.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  UserProvider userProvider;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool bindDataFirstTime = true;
  // String stateId;
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

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

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

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<UserProvider>(
            appBarTitle: Utils.getString(context, 'edit_profile__title') ?? '',
            initProvider: () {
              return UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
            },
            onProviderReady: (UserProvider provider) async {
              await provider.getUser(provider.psValueHolder.loginUserId);
              userProvider = provider;
            },
            builder:
                (BuildContext context, UserProvider provider, Widget child) {
              if (userProvider != null &&
                  userProvider.user != null &&
                  userProvider.user.data != null) {
                if (bindDataFirstTime) {
                  userNameController.text = userProvider.user.data.userName;
                  emailController.text = userProvider.user.data.userEmail;
                  phoneController.text = userProvider.user.data.userPhone;
                  aboutMeController.text = userProvider.user.data.userAboutMe;

                  bindDataFirstTime = false;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _ImageWidget(userProvider: userProvider),
                      _UserFirstCardWidget(
                        userNameController: userNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        aboutMeController: aboutMeController,
                        addressController: addressController,
                        cityController: cityController,
                        stateId: userProvider.user.data.stateId,
                        districtId: userProvider.user.data.districtId,
                        municipalityId: userProvider.user.data.municipalityId,
                        wardId: userProvider.user.data.wardId,
                        streetName: userProvider.user.data.streetName,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      _TwoButtonWidget(
                        userProvider: userProvider,
                        userNameController: userNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        aboutMeController: aboutMeController,
                        addressController: addressController,
                        cityController: cityController,
                      ),
                      const SizedBox(
                        height: PsDimens.space20,
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}

class _TwoButtonWidget extends StatelessWidget {
  const _TwoButtonWidget({
    @required this.userProvider,
    @required this.userNameController,
    @required this.emailController,
    @required this.phoneController,
    @required this.aboutMeController,
    @required this.addressController,
    @required this.cityController,
    @required this.stateId,
  });

  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;
  final TextEditingController addressController;
  final TextEditingController cityController;

  final UserProvider userProvider;
  final String stateId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12, right: PsDimens.space12),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'edit_profile__save'),
            onPressed: () async{

              SharedPreferences prefs = await SharedPreferences.getInstance();
              int sid = prefs.getInt('profileStateId');
              int did = prefs.getInt('profileDistrictId');
              int mid = prefs.getInt('profileMunicipalityId');
              int wid = prefs.getInt('profileWardId');
              String sn = prefs.getString('profileStreetName');
              if (userNameController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__name_error'),
                      );
                    });
              } else if (emailController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__email_error'),
                      );
                    });
              }else if (did == 0){
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'warning_dialog__input_district'),
                      );
                    });
              }else if (mid == 0){
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'warning_dialog__input_municipality'),
                      );
                    });
              }else if (wid == 0){
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'warning_dialog__input_ward'),
                      );
                    });
              } else if (sn == '' || sn == null){
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'warning_dialog__input_street'),
                      );
                    });
              } else {
                if (await Utils.checkInternetConnectivity()) {


                  final ProfileUpdateParameterHolder
                      profileUpdateParameterHolder =
                      ProfileUpdateParameterHolder(
                          userId: userProvider.user.data.userId,
                          userName: userNameController.text,
                          userEmail: emailController.text,
                          userPhone: phoneController.text,
                          userAboutMe: aboutMeController.text,
                          userAddress: addressController.text,
                          city: cityController.text,
                          deviceToken: userProvider.psValueHolder.deviceToken,
                          stateId: sid.toString(),
                          districtId: did.toString(),
                          municipalityId: mid.toString(),
                          wardId: wid.toString(),
                          streetName: sn,



                          // gapi works
                      );
                  // final ProgressDialog progressDialog = loadingDialog(context);
                  // progressDialog.show();
                  // usr2a42a4a986c1cb5ac3094c8161262e5d
                  PsProgressDialog.showDialog(context);
                  final PsResource<User> _apiStatus = await userProvider
                      .postProfileUpdate(profileUpdateParameterHolder.toMap());
                  if (_apiStatus.data != null) {
                    // progressDialog.dismiss();
                    PsProgressDialog.dismissDialog();
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext contet) {
                          return SuccessDialog(
                            message: Utils.getString(
                                context, 'edit_profile__success'),
                          );
                        });
                  } else {
                    // progressDialog.dismiss();
                    PsProgressDialog.dismissDialog();

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
            },
          ),
        ),
        const SizedBox(
          height: PsDimens.space12,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space20),
          child: PSButtonWidget(
            hasShadow: false,
            colorData: PsColors.mainColor,
            width: double.infinity,
            titleText:
                Utils.getString(context, 'edit_profile__password_change'),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutePaths.user_update_password,
              );
            },
          ),
        )
      ],
    );
  }
}

class _ImageWidget extends StatefulWidget {
  const _ImageWidget({this.userProvider});
  final UserProvider userProvider;

  @override
  __ImageWidgetState createState() => __ImageWidgetState();
}

File pickedImage;
List<Asset> images = <Asset>[];
Asset defaultAssetImage;

class __ImageWidgetState extends State<_ImageWidget> {
  Future<bool> requestGalleryPermission() async {
    // final Map<Permission, PermissionStatus> permissionss =
    //     await PermissionHandler()
    //         .requestPermissions(<Permission>[Permission.photos]);
    // if (permissionss != null &&
    //     permissionss.isNotEmpty &&
    //     permissionss[Permission.photos] == PermissionStatus.granted) {
    final Permission _photos = Permission.photos;
    final PermissionStatus permissionss = await _photos.request();

    if (permissionss != null && permissionss == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _pickImage() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    images = resultList;
    setState(() {});

    if (images.isNotEmpty) {
      PsProgressDialog.dismissDialog();
      final PsResource<User> _apiStatus = await widget.userProvider
          .postImageUpload(widget.userProvider.psValueHolder.loginUserId,
              PsConst.PLATFORM, await Utils.getImageFileFromAssets(images[0]));
      if (_apiStatus.data != null) {
        setState(() {
          widget.userProvider.user.data = _apiStatus.data;
        });
      }
      PsProgressDialog.dismissDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget =
        widget.userProvider.user.data.userProfilePhoto != null
            ? PsNetworkImageWithUrl(
                photoKey: '',
                imagePath: widget.userProvider.user.data.userProfilePhoto,
                width: double.infinity,
                height: PsDimens.space200,
                boxfit: BoxFit.cover,
                onTap: () {},
              )
            : InkWell(
                onTap: () {},
                child: Ink(
                    child:
                        AssetThumb(asset: images[0], width: 100, height: 160)),
              );

    final Widget _editWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: PsDimens.space2),
        iconSize: PsDimens.space24,
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          if (await Utils.checkInternetConnectivity()) {
            // requestGalleryPermission().then((bool status) async {
            //   if (status) {
            await _pickImage();
            // }
            // });
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message:
                        Utils.getString(context, 'error_dialog__no_internet'),
                  );
                });
          }
        },
      ),
      width: PsDimens.space32,
      height: PsDimens.space32,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PsColors.mainColor),
        color: PsColors.backgroundColor,
        borderRadius: BorderRadius.circular(PsDimens.space28),
      ),
    );

    final Widget _imageInCenterWidget = Positioned(
        top: 110,
        child: Stack(
          children: <Widget>[
            Container(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: ProfileImageWidget(
                    images:
                        (images != null && images != null && images.isNotEmpty)
                            ? images[0]
                            : defaultAssetImage,
                    selectedImage: (widget.userProvider.user.data
                                .userProfilePhoto.isNotEmpty &&
                            images.isEmpty)
                        ? widget.userProvider.user.data.userProfilePhoto
                        : null,
                    onTap: () {
                      _pickImage();
                    },
                  ),
                )),
            Positioned(
              top: 1,
              right: 1,
              child: _editWidget,
            ),
          ],
        ));

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
            width: double.infinity,
            height: PsDimens.space160,
            child: _imageWidget),
        Container(
          color: PsColors.white.withAlpha(100),
          width: double.infinity,
          height: PsDimens.space160,
        ),
        Container(
          // color: Colors.white38,
          width: double.infinity,
          height: PsDimens.space220,
        ),
        _imageInCenterWidget,
      ],
    );
  }
}

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({
    Key key,
    @required this.images,
    @required this.selectedImage,
    this.onTap,
  }) : super(key: key);

  final Function onTap;

  final Asset images;
  final String selectedImage;
  @override
  State<StatefulWidget> createState() {
    return ProfileImageWidgetState();
  }
}

class ProfileImageWidgetState extends State<ProfileImageWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedImage != null) {
      return InkWell(
        onTap: widget.onTap,
        child: PsNetworkCircleImage(
          photoKey: '',
          width: double.infinity,
          height: PsDimens.space200,
          imagePath: widget.selectedImage,
          boxfit: BoxFit.cover,
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images;
        return InkWell(
          onTap: widget.onTap,
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
          // ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10000.0),
          child: InkWell(
            onTap: widget.onTap,
            child: Image.asset(
              'assets/images/default_image.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
  }
}

class _UserFirstCardWidget extends StatelessWidget {
  const _UserFirstCardWidget(
      {@required this.userNameController,
      @required this.emailController,
      @required this.phoneController,
      @required this.aboutMeController,
      @required this.addressController,
      @required this.cityController,this.stateId,this.districtId,this.municipalityId,this.wardId,this.streetName});
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final String stateId,districtId,municipalityId,wardId,streetName;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      padding:
          const EdgeInsets.only(left: PsDimens.space8, right: PsDimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: PsDimens.space16,
          ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__user_name'),
              hintText: Utils.getString(context, 'edit_profile__user_name'),
              textAboutMe: false,
              textEditingController: userNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__email'),
              hintText: Utils.getString(context, 'edit_profile__email'),
              keyboardType: TextInputType.emailAddress,
              textAboutMe: false,
              textEditingController: emailController),
          // Text('$stateId'),

          Container(
            child: ProfileAddress(stateId: int.parse(stateId),districtId:int.parse(districtId),municipalityId:int.parse(municipalityId),
                wardId:int.parse(wardId),streetName:streetName),
          ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__phone'),
              textAboutMe: false,
              keyboardType: TextInputType.phone,
              hintText: Utils.getString(context, 'edit_profile__phone'),
              textEditingController: phoneController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__about_me'),
              height: PsDimens.space120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              hintText: Utils.getString(context, 'edit_profile__about_me'),
              textEditingController: aboutMeController),
          const SizedBox(
            height: PsDimens.space12,
          )
        ],
      ),
    );
  }
}
