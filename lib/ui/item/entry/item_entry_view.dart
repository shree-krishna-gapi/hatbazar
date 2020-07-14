import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hatbazar/api/common/ps_resource.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/constant/ps_constants.dart';
import 'package:hatbazar/constant/ps_dimens.dart';
import 'package:hatbazar/constant/route_paths.dart';
import 'package:hatbazar/provider/entry/item_entry_provider.dart';
import 'package:hatbazar/provider/gallery/gallery_provider.dart';
import 'package:hatbazar/repository/gallery_repository.dart';
import 'package:hatbazar/repository/product_repository.dart';
import 'package:hatbazar/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:hatbazar/ui/common/dialog/error_dialog.dart';
import 'package:hatbazar/ui/common/dialog/success_dialog.dart';
import 'package:hatbazar/ui/common/dialog/warning_dialog_view.dart';
import 'package:hatbazar/ui/common/ps_button_widget.dart';
import 'package:hatbazar/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:hatbazar/ui/common/ps_textfield_widget.dart';
import 'package:hatbazar/ui/common/ps_ui_widget.dart';
import 'package:hatbazar/utils/ps_progress_dialog.dart';
import 'package:hatbazar/utils/utils.dart';
import 'package:hatbazar/viewobject/category.dart';
import 'package:hatbazar/viewobject/common/ps_value_holder.dart';
import 'package:hatbazar/viewobject/condition_of_item.dart';
import 'package:hatbazar/viewobject/deal_option.dart';
import 'package:hatbazar/viewobject/default_photo.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:hatbazar/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:hatbazar/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:hatbazar/viewobject/item_currency.dart';
import 'package:hatbazar/viewobject/item_location.dart';
import 'package:hatbazar/viewobject/item_price_type.dart';
import 'package:hatbazar/viewobject/item_type.dart';
import 'package:hatbazar/viewobject/product.dart';
import 'package:hatbazar/viewobject/sub_category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ItemEntryView extends StatefulWidget {
  const ItemEntryView(
      {Key key, this.flag, this.item, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  final String flag;
  final Product item;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ProductRepository repo1;
  GalleryRepository galleryRepository;
  ItemEntryProvider _itemEntryProvider;
  GalleryProvider galleryProvider;
  PsValueHolder valueHolder;
  final TextEditingController userInputListingTitle = TextEditingController();
  final TextEditingController userInputBrand = TextEditingController();
  final TextEditingController userInputHighLightInformation =
      TextEditingController();
  final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputDealOptionText = TextEditingController();
  final TextEditingController userInputLattitude = TextEditingController();
  final TextEditingController userInputLongitude = TextEditingController();
  final TextEditingController userInputAddress = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();
  final MapController mapController = MapController();

  final TextEditingController categoryController = TextEditingController();
  final TextEditingController subCategoryController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController itemConditionController = TextEditingController();
  final TextEditingController priceTypeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dealOptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  LatLng latlng;
  final double zoom = 10;
  bool bindDataFirstTime = true;
  // New Images From Image Picker
  List<Asset> images = <Asset>[];
  Asset firstSelectedImageAsset;
  Asset secondSelectedImageAsset;
  Asset thirdSelectedImageAsset;
  Asset fouthSelectedImageAsset;
  Asset fifthSelectedImageAsset;

  Asset defaultAssetImage;

  // New Images Checking from Image Picker
  bool isSelectedFirstImagePath = false;
  bool isSelectedSecondImagePath = false;
  bool isSelectedThirdImagePath = false;
  bool isSelectedFouthImagePath = false;
  bool isSelectedFifthImagePath = false;

  // Existing Image Id
  String firstImageId = '';
  String secondImageId = '';
  String thirdImageId = '';
  String fourthImageId = '';
  String fiveImageId = '';

  String isShopCheckbox = '1';

  // ProgressDialog progressDialog;

  // File file;

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);

    // progressDialog = loadingDialog(
    //   context,
    // );

    Future<dynamic> uploadImage(String itemId) async {
      // if (!progressDialog.isShowing()) {
      //   progressDialog.show();
      // }
      bool _isFirstDone = isSelectedFirstImagePath;
      bool _isSecondDone = isSelectedSecondImagePath;
      bool _isThirdDone = isSelectedThirdImagePath;
      bool _isFouthDone = isSelectedFouthImagePath;
      bool _isFifthDone = isSelectedFifthImagePath;

      if (!PsProgressDialog.isShowing()) {
        PsProgressDialog.showDialog(context);
      }

      if (isSelectedFirstImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(itemId, firstImageId,
                await Utils.getImageFileFromAssets(firstSelectedImageAsset));
        if (_apiStatus.data != null) {
          isSelectedFirstImagePath = false;
          _isFirstDone = isSelectedFirstImagePath;
          print('1 image uploaded');
          if (isSelectedSecondImagePath ||
              isSelectedThirdImagePath ||
              isSelectedFouthImagePath ||
              isSelectedFifthImagePath) {
            await uploadImage(itemId);
          }
        }
      }
      if (isSelectedSecondImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(itemId, secondImageId,
                await Utils.getImageFileFromAssets(secondSelectedImageAsset));
        if (_apiStatus.data != null) {
          isSelectedSecondImagePath = false;
          _isSecondDone = isSelectedSecondImagePath;
          print('2 image uploaded');
          if (isSelectedThirdImagePath ||
              isSelectedFouthImagePath ||
              isSelectedFifthImagePath) {
            await uploadImage(itemId);
          }
        }
      }
      if (isSelectedThirdImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(itemId, thirdImageId,
                await Utils.getImageFileFromAssets(thirdSelectedImageAsset));
        if (_apiStatus.data != null) {
          isSelectedThirdImagePath = false;
          _isThirdDone = isSelectedThirdImagePath;
          print('3 image uploaded');
          if (isSelectedFouthImagePath || isSelectedFifthImagePath) {
            await uploadImage(itemId);
          }
        }
      }
      if (isSelectedFouthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(itemId, fourthImageId,
                await Utils.getImageFileFromAssets(fouthSelectedImageAsset));
        if (_apiStatus.data != null) {
          isSelectedFouthImagePath = false;
          _isFouthDone = isSelectedFouthImagePath;
          print('4 image uploaded');
          if (isSelectedFifthImagePath) {
            await uploadImage(itemId);
          }
        }
      }
      if (isSelectedFifthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(itemId, fiveImageId,
                await Utils.getImageFileFromAssets(fifthSelectedImageAsset));
        if (_apiStatus.data != null) {
          print('5 image uploaded');
          isSelectedFifthImagePath = false;
          _isFifthDone = isSelectedFifthImagePath;
        }
      }

      PsProgressDialog.dismissDialog();

      if (!(_isFirstDone ||
          _isSecondDone ||
          _isThirdDone ||
          _isFouthDone ||
          _isFifthDone)) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            });
      }

      return;
    }

    dynamic updateImages(List<Asset> resultList, int index) {
      if (index == -1) {
        firstSelectedImageAsset = defaultAssetImage;
        secondSelectedImageAsset = defaultAssetImage;
        thirdSelectedImageAsset = defaultAssetImage;
        fouthSelectedImageAsset = defaultAssetImage;
        fifthSelectedImageAsset = defaultAssetImage;
      }
      setState(() {
        images = resultList;

        if (resultList.isEmpty) {
          firstSelectedImageAsset = defaultAssetImage;
          isSelectedFirstImagePath = false;
          secondSelectedImageAsset = defaultAssetImage;
          isSelectedSecondImagePath = false;
          thirdSelectedImageAsset = defaultAssetImage;
          isSelectedThirdImagePath = false;
          fouthSelectedImageAsset = defaultAssetImage;
          isSelectedFouthImagePath = false;
          fifthSelectedImageAsset = defaultAssetImage;
          isSelectedFifthImagePath = false;
        }

        //for single select image
        if (index == 0 && resultList.isNotEmpty) {
          firstSelectedImageAsset = resultList[0];
          isSelectedFirstImagePath = true;
        }
        if (index == 1 && resultList.isNotEmpty) {
          secondSelectedImageAsset = resultList[0];
          isSelectedSecondImagePath = true;
        }
        if (index == 2 && resultList.isNotEmpty) {
          thirdSelectedImageAsset = resultList[0];
          isSelectedThirdImagePath = true;
        }
        if (index == 3 && resultList.isNotEmpty) {
          fouthSelectedImageAsset = resultList[0];
          isSelectedFouthImagePath = true;
        }
        if (index == 4 && resultList.isNotEmpty) {
          fifthSelectedImageAsset = resultList[0];
          isSelectedFifthImagePath = true;
        }
        //end single select image

        //for multi select
        if (index == -1 && resultList.length == 1) {
          firstSelectedImageAsset = resultList[0];
          isSelectedFirstImagePath = true;
        }
        if (index == -1 && resultList.length == 2) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
        }
        if (index == -1 && resultList.length == 3) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          thirdSelectedImageAsset = resultList[2];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
          isSelectedThirdImagePath = true;
        }
        if (index == -1 && resultList.length == 4) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          thirdSelectedImageAsset = resultList[2];
          fouthSelectedImageAsset = resultList[3];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
          isSelectedThirdImagePath = true;
          isSelectedFouthImagePath = true;
        }
        if (index == -1 && resultList.length == 5) {
          firstSelectedImageAsset = resultList[0];
          secondSelectedImageAsset = resultList[1];
          thirdSelectedImageAsset = resultList[2];
          fouthSelectedImageAsset = resultList[3];
          fifthSelectedImageAsset = resultList[4];
          isSelectedFirstImagePath = true;
          isSelectedSecondImagePath = true;
          isSelectedThirdImagePath = true;
          isSelectedFouthImagePath = true;
          isSelectedFifthImagePath = true;
        }
        //end multi select

        // if (index >= 0 && galleryProvider.selectedImageList.length > index) {
        //   galleryProvider.selectedImageList.removeAt(index);
        // }
      });
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    widget.animationController.forward();
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  latlng = LatLng(
                      double.parse(
                          _itemEntryProvider.psValueHolder.locationLat),
                      double.parse(
                          _itemEntryProvider.psValueHolder.locationLng));
                  if (_itemEntryProvider.itemLocationId != null ||
                      _itemEntryProvider.itemLocationId != '')
                    _itemEntryProvider.itemLocationId =
                        _itemEntryProvider.psValueHolder.locationId;
                  if (userInputLattitude.text.isEmpty)
                    userInputLattitude.text =
                        _itemEntryProvider.psValueHolder.locationLat;
                  if (userInputLongitude.text.isEmpty)
                    userInputLongitude.text =
                        _itemEntryProvider.psValueHolder.locationLng;
                  _itemEntryProvider.getItemFromDB(widget.item.id);

                  return _itemEntryProvider;
                }),
            ChangeNotifierProvider<GalleryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(repo: galleryRepository);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    galleryProvider.loadImageList(
                        widget.item.defaultPhoto.imgParentId,
                        PsConst.ITEM_TYPE);

                    // firstImageId = galleryProvider.galleryList.data[0].imgId;
                    // secondImageId = galleryProvider.galleryList.data[1].imgId;
                    // thirdImageId = galleryProvider.galleryList.data[2].imgId;
                    // fourthImageId = galleryProvider.galleryList.data[3].imgId;
                    // fiveImageId = galleryProvider.galleryList.data[4].imgId;

                    // Utils.psPrint(firstImageId);
                    // Utils.psPrint(secondImageId);
                    // Utils.psPrint(thirdImageId);
                    // Utils.psPrint(fourthImageId);
                    // Utils.psPrint(fiveImageId);
                  }
                  return galleryProvider;
                }),
          ],
          child: SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10),
                        child: Text(
                            Utils.getString(
                                context, 'item_entry__listing_today'),
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10),
                        child: Row(
                          children: <Widget>[
                            Text(
                                Utils.getString(context,
                                    'item_entry__choose_photo_showcase'),
                                style: Theme.of(context).textTheme.bodyText2),
                            Text(' *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: PsColors.mainColor))
                          ],
                        ),
                      ),
                      //  _largeSpacingWidget,
                      Consumer<GalleryProvider>(builder: (BuildContext context,
                          GalleryProvider provider, Widget child) {
                        if (provider != null &&
                            provider.galleryList.data.isNotEmpty) {
                          for (int imageId = 0;
                              imageId < provider.galleryList.data.length;
                              imageId++) {
                            if (imageId == 0) {
                              firstImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 1) {
                              secondImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 2) {
                              thirdImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 3) {
                              fourthImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 4) {
                              fiveImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                          }
                        }

                        return ImageUploadHorizontalList(
                          flag: widget.flag,
                          images: images,
                          selectedImageList: galleryProvider.selectedImageList,
                          updateImages: updateImages,
                          firstImagePath: firstSelectedImageAsset,
                          secondImagePath: secondSelectedImageAsset,
                          thirdImagePath: thirdSelectedImageAsset,
                          fouthImagePath: fouthSelectedImageAsset,
                          fifthImagePath: fifthSelectedImageAsset,
                        );
                      }),

                      Consumer<ItemEntryProvider>(builder:
                          (BuildContext context, ItemEntryProvider provider,
                              Widget child) {
                        if (provider != null &&
                            provider.item != null &&
                            provider.item.data != null) {
                          if (bindDataFirstTime) {
                            userInputListingTitle.text =
                                provider.item.data.title;
                            userInputBrand.text = provider.item.data.brand;
                            userInputHighLightInformation.text =
                                provider.item.data.highlightInformation;
                            userInputDescription.text =
                                provider.item.data.description;
                            userInputDealOptionText.text =
                                provider.item.data.dealOptionRemark;
                            userInputLattitude.text = provider.item.data.lat;
                            userInputLongitude.text = provider.item.data.lng;
                            userInputAddress.text = provider.item.data.address;
                            userInputPrice.text = provider.item.data.price;
                            categoryController.text =
                                provider.item.data.category.catName;
                            subCategoryController.text =
                                provider.item.data.subCategory.name;
                            typeController.text =
                                provider.item.data.itemType.name;
                            itemConditionController.text =
                                provider.item.data.conditionOfItem.name;
                            priceTypeController.text =
                                provider.item.data.itemPriceType.name;
                            priceController.text =
                                provider.item.data.itemCurrency.currencySymbol;
                            dealOptionController.text =
                                provider.item.data.dealOption.name;
                            locationController.text =
                                provider.item.data.itemLocation.name;

                            provider.categoryId =
                                provider.item.data.category.catId;
                            provider.subCategoryId =
                                provider.item.data.subCategory.id;
                            provider.itemTypeId =
                                provider.item.data.itemType.id;
                            provider.itemConditionId =
                                provider.item.data.conditionOfItem.id;
                            provider.itemCurrencyId =
                                provider.item.data.itemCurrency.id;
                            provider.itemDealOptionId =
                                provider.item.data.dealOption.id;
                            provider.itemLocationId =
                                provider.item.data.itemLocation.id;
                            provider.itemPriceTypeId =
                                provider.item.data.itemPriceType.id;
                            bindDataFirstTime = false;

                            if (provider.item.data.businessMode == '1') {
                              Utils.psPrint('Check On is shop');
                              provider.isCheckBoxSelect = true;
                              _BusinessModeCheckbox();
                            } else {
                              provider.isCheckBoxSelect = false;
                              Utils.psPrint('Check Off is shop');
                              //  updateCheckBox(context, provider);
                              _BusinessModeCheckbox();
                            }
                          }
                        }
                        return AllControllerTextWidget(
                            userInputListingTitle: userInputListingTitle,
                            categoryController: categoryController,
                            subCategoryController: subCategoryController,
                            typeController: typeController,
                            itemConditionController: itemConditionController,
                            userInputBrand: userInputBrand,
                            priceTypeController: priceTypeController,
                            priceController: priceController,
                            userInputHighLightInformation:
                                userInputHighLightInformation,
                            userInputDescription: userInputDescription,
                            dealOptionController: dealOptionController,
                            userInputDealOptionText: userInputDealOptionText,
                            locationController: locationController,
                            userInputLattitude: userInputLattitude,
                            userInputLongitude: userInputLongitude,
                            userInputAddress: userInputAddress,
                            userInputPrice: userInputPrice,
                            mapController: mapController,
                            zoom: zoom,
                            flag: widget.flag,
                            item: widget.item,
                            provider: provider,
                            latlng: latlng,
                            uploadImage: (String itemId) {
                              if (isSelectedFirstImagePath ||
                                  isSelectedSecondImagePath ||
                                  isSelectedThirdImagePath ||
                                  isSelectedFouthImagePath ||
                                  isSelectedFifthImagePath) {
                                uploadImage(itemId);
                              }
                            },
                            isSelectedFirstImagePath: isSelectedFirstImagePath,
                            isSelectedSecondImagePath:
                                isSelectedSecondImagePath,
                            isSelectedThirdImagePath: isSelectedThirdImagePath,
                            isSelectedFouthImagePath: isSelectedFouthImagePath,
                            isSelectedFifthImagePath: isSelectedFifthImagePath,
                            firstImageId: firstImageId,
                            // galleryProvider.galleryList.data[0].imgId,
                            secondImageId: secondImageId,
                            // galleryProvider.galleryList.data[1].imgId,
                            thirdImageId: thirdImageId,
                            // galleryProvider.galleryList.data[2].imgId,
                            fourthImageId: fourthImageId,
                            // galleryProvider.galleryList.data[3].imgId,
                            fiveImageId: fiveImageId
                            // galleryProvider.galleryList.data[4].imgId,
                            );
                      })
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  return child;
                }),
          )),
    );
  }
}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget(
      {Key key,
      this.userInputListingTitle,
      this.categoryController,
      this.subCategoryController,
      this.typeController,
      this.itemConditionController,
      this.userInputBrand,
      this.priceTypeController,
      this.priceController,
      this.userInputHighLightInformation,
      this.userInputDescription,
      this.dealOptionController,
      this.userInputDealOptionText,
      this.locationController,
      this.userInputLattitude,
      this.userInputLongitude,
      this.userInputAddress,
      this.userInputPrice,
      this.mapController,
      this.provider,
      this.latlng,
      this.zoom,
      this.flag,
      this.item,
      this.uploadImage,
      this.isSelectedFirstImagePath,
      this.isSelectedSecondImagePath,
      this.isSelectedThirdImagePath,
      this.isSelectedFouthImagePath,
      this.isSelectedFifthImagePath,
      this.firstImageId,
      this.secondImageId,
      this.thirdImageId,
      this.fourthImageId,
      this.fiveImageId})
      : super(key: key);

  final TextEditingController userInputListingTitle;
  final TextEditingController categoryController;
  final TextEditingController subCategoryController;
  final TextEditingController typeController;
  final TextEditingController itemConditionController;
  final TextEditingController userInputBrand;
  final TextEditingController priceTypeController;
  final TextEditingController priceController;
  final TextEditingController userInputHighLightInformation;
  final TextEditingController userInputDescription;
  final TextEditingController dealOptionController;
  final TextEditingController userInputDealOptionText;
  final TextEditingController locationController;
  final TextEditingController userInputLattitude;
  final TextEditingController userInputLongitude;
  final TextEditingController userInputAddress;
  final TextEditingController userInputPrice;
  final MapController mapController;
  final ItemEntryProvider provider;
  final double zoom;
  final String flag;
  final Product item;
  final LatLng latlng;
  final Function uploadImage;
  final bool isSelectedFirstImagePath;
  final bool isSelectedSecondImagePath;
  final bool isSelectedThirdImagePath;
  final bool isSelectedFouthImagePath;
  final bool isSelectedFifthImagePath;
  final String firstImageId;
  final String secondImageId;
  final String thirdImageId;
  final String fourthImageId;
  final String fiveImageId;
  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  LatLng _latlng;

  @override
  Widget build(BuildContext context) {
    _latlng ??= widget.latlng;
    ((widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text ==
                    widget.provider.psValueHolder.locactionName) ||
            (widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text.isEmpty))
        ? widget.locationController.text =
            widget.provider.psValueHolder.locactionName
        : Container();
    if (widget.provider.item.data != null && widget.flag == PsConst.EDIT_ITEM) {
      _latlng = LatLng(double.parse(widget.provider.item.data.lat),
          double.parse(widget.provider.item.data.lng));
    }

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__submit'),
          onPressed: () async {
            if (!widget.isSelectedFirstImagePath &&
                !widget.isSelectedSecondImagePath &&
                !widget.isSelectedThirdImagePath &&
                !widget.isSelectedFouthImagePath &&
                !widget.isSelectedFifthImagePath &&
                widget.firstImageId == '' &&
                widget.secondImageId == '' &&
                widget.thirdImageId == '' &&
                widget.fourthImageId == '' &&
                widget.fiveImageId == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_image'),
                    );
                  });
            } else if (widget.userInputListingTitle.text == null ||
                widget.userInputListingTitle.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry__need_listing_title'),
                    );
                  });
            } else if (widget.categoryController.text == null ||
                widget.categoryController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_category'),
                    );
                  });
            } else if (widget.subCategoryController.text == null ||
                widget.subCategoryController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_subcategory'),
                    );
                  });
            } else if (widget.typeController.text == null ||
                widget.typeController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(context, 'item_entry_need_type'),
                    );
                  });
            } else if (widget.itemConditionController.text == null ||
                widget.itemConditionController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_item_condition'),
                    );
                  });
            } else if (widget.priceController.text == null ||
                widget.priceController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_currency_symbol'),
                    );
                  });
            } else if (widget.userInputPrice.text == null ||
                widget.userInputPrice.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message:
                          Utils.getString(context, 'item_entry_need_price'),
                    );
                  });
            } else if (widget.userInputDescription.text == null ||
                widget.userInputDescription.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_description'),
                    );
                  });
            } else if (widget.dealOptionController.text == null ||
                widget.dealOptionController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                      message: Utils.getString(
                          context, 'item_entry_need_deal_option'),
                    );
                  });
            } else {
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                //add new
                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                        catId: widget.provider.categoryId,
                        subCatId: widget.provider.subCategoryId,
                        itemTypeId: widget.provider.itemTypeId,
                        conditionOfItemId: widget.provider.itemConditionId,
                        itemPriceTypeId: widget.provider.itemPriceTypeId,
                        itemCurrencyId: widget.provider.itemCurrencyId,
                        price: widget.userInputPrice.text,
                        dealOptionId: widget.provider.itemDealOptionId,
                        itemLocationId: widget.provider.itemLocationId,
                        businessMode: widget.provider.checkOrNotShop,
                        isSoldOut: '', //must be ''
                        title: widget.userInputListingTitle.text,
                        brand: widget.userInputBrand.text,
                        highlightInfomation:
                            widget.userInputHighLightInformation.text,
                        description: widget.userInputDescription.text,
                        dealOptionRemark: widget.userInputDealOptionText.text,
                        latitude: widget.userInputLattitude.text,
                        longitude: widget.userInputLongitude.text,
                        address: widget.userInputAddress.text,
                        id: '', //must be ''
                        addedUserId: widget.provider.psValueHolder.loginUserId);

                final PsResource<Product> itemData = await widget.provider
                    .postItemEntry(itemEntryParameterHolder.toMap());

                if (itemData.data != null) {
                  if (widget.isSelectedFirstImagePath ||
                      widget.isSelectedSecondImagePath ||
                      widget.isSelectedThirdImagePath ||
                      widget.isSelectedFouthImagePath ||
                      widget.isSelectedFifthImagePath) {
                    widget.uploadImage(itemData.data.id);
                  }
                }
              } else {
                // edit item

                final ItemEntryParameterHolder itemEntryParameterHolder =
                    ItemEntryParameterHolder(
                        catId: widget.provider.categoryId,
                        subCatId: widget.provider.subCategoryId,
                        itemTypeId: widget.provider.itemTypeId,
                        conditionOfItemId: widget.provider.itemConditionId,
                        itemPriceTypeId: widget.provider.itemPriceTypeId,
                        itemCurrencyId: widget.provider.itemCurrencyId,
                        price: widget.userInputPrice.text,
                        dealOptionId: widget.provider.itemDealOptionId,
                        itemLocationId: widget.provider.itemLocationId,
                        businessMode: widget.provider.checkOrNotShop,
                        isSoldOut: widget.item.isSoldOut,
                        title: widget.userInputListingTitle.text,
                        brand: widget.userInputBrand.text,
                        highlightInfomation:
                            widget.userInputHighLightInformation.text,
                        description: widget.userInputDescription.text,
                        dealOptionRemark: widget.userInputDealOptionText.text,
                        latitude: widget.userInputLattitude.text,
                        longitude: widget.userInputLongitude.text,
                        address: widget.userInputAddress.text,
                        id: widget.item.id,
                        addedUserId: widget.provider.psValueHolder.loginUserId);

                final PsResource<Product> itemData = await widget.provider
                    .postItemEntry(itemEntryParameterHolder.toMap());

                if (itemData.data != null) {
                  Fluttertoast.showToast(
                      msg: 'Item Uploaded',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white);

                  if (widget.isSelectedFirstImagePath ||
                      widget.isSelectedSecondImagePath ||
                      widget.isSelectedThirdImagePath ||
                      widget.isSelectedFouthImagePath ||
                      widget.isSelectedFifthImagePath) {
                    widget.uploadImage(itemData.data.id);
                  }
                }
              }
            }
          },
        ));

    return Column(children: <Widget>[
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__listing_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__entry_title'),
        textEditingController: widget.userInputListingTitle,
        isStar: true,
      ),
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__category'),
        textEditingController: widget.categoryController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

          final dynamic categoryResult =
              await Navigator.pushNamed(context, RoutePaths.searchCategory);

          if (categoryResult != null && categoryResult is Category) {
            provider.categoryId = categoryResult.catId;
            widget.categoryController.text = categoryResult.catName;
            provider.subCategoryId = '';

            setState(() {
              widget.categoryController.text = categoryResult.catName;
              widget.subCategoryController.text = '';
            });
          }
        },
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__subCategory'),
          textEditingController: widget.subCategoryController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);
            if (provider.categoryId != '') {
              final dynamic subCategoryResult = await Navigator.pushNamed(
                  context, RoutePaths.searchSubCategory,
                  arguments: provider.categoryId);
              if (subCategoryResult != null &&
                  subCategoryResult is SubCategory) {
                provider.subCategoryId = subCategoryResult.id;

                widget.subCategoryController.text = subCategoryResult.name;
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'home_search__choose_category_first'),
                    );
                  });
              const ErrorDialog(message: 'Choose Category first');
            }
          }),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__type'),
          textEditingController: widget.typeController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemTypeResult =
                await Navigator.pushNamed(context, RoutePaths.itemType);

            if (itemTypeResult != null && itemTypeResult is ItemType) {
              provider.itemTypeId = itemTypeResult.id;

              setState(() {
                widget.typeController.text = itemTypeResult.name;
              });
            }
          }),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__item_condition'),
          textEditingController: widget.itemConditionController,
          isStar: true,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemConditionResult =
                await Navigator.pushNamed(context, RoutePaths.itemCondition);

            if (itemConditionResult != null &&
                itemConditionResult is ConditionOfItem) {
              provider.itemConditionId = itemConditionResult.id;

              setState(() {
                widget.itemConditionController.text = itemConditionResult.name;
              });
            }
          }),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__brand'),
        textAboutMe: false,
        textEditingController: widget.userInputBrand,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PriceDropDownControllerWidget(
            currencySymbolController: widget.priceController,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: PsDimens.space44,
              margin: const EdgeInsets.only(
                  top: PsDimens.space32,
                  right: PsDimens.space12,
                  bottom: PsDimens.space12),
              decoration: BoxDecoration(
                color: Utils.isLightMode(context)
                    ? Colors.white60
                    : Colors.black54,
                borderRadius: BorderRadius.circular(PsDimens.space4),
                border: Border.all(
                    color: Utils.isLightMode(context)
                        ? Colors.grey[200]
                        : Colors.black87),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                maxLines: null,
                controller: widget.userInputPrice,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: PsDimens.space12,
                    bottom: PsDimens.space8,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__price_type'),
          textEditingController: widget.priceTypeController,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemPriceTypeResult =
                await Navigator.pushNamed(context, RoutePaths.itemPriceType);

            if (itemPriceTypeResult != null &&
                itemPriceTypeResult is ItemPriceType) {
              provider.itemPriceTypeId = itemPriceTypeResult.id;
              // provider.subCategoryId = '';

              setState(() {
                widget.priceTypeController.text = itemPriceTypeResult.name;
                // provider.selectedSubCategoryName = '';
              });
            }
          }),

      Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space12),
            child: Text(Utils.getString(context, 'item_entry__shop_setting'),
                style: Theme.of(context).textTheme.bodyText2),
          ),
          BusinessModeCheckbox(
            provider: widget.provider,
            onCheckBoxClick: () {
              setState(() {
                updateCheckBox(context, widget.provider);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: PsDimens.space40),
            child: Text(
                Utils.getString(context, 'item_entry__show_more_than_one'),
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: PsColors.mainColor)),
          ),
        ],
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__highlight_info'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__highlight_info'),
        textAboutMe: true,
        textEditingController: widget.userInputHighLightInformation,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space120,
        hintText: Utils.getString(context, 'item_entry__description'),
        textAboutMe: true,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
      Column(
        children: <Widget>[
          PsDropdownBaseWithControllerWidget(
              title: Utils.getString(context, 'item_entry__deal_option'),
              textEditingController: widget.dealOptionController,
              isStar: true,
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemDealOptionResult = await Navigator.pushNamed(
                    context, RoutePaths.itemDealOption);

                if (itemDealOptionResult != null &&
                    itemDealOptionResult is DealOption) {
                  provider.itemDealOptionId = itemDealOptionResult.id;

                  setState(() {
                    widget.dealOptionController.text =
                        itemDealOptionResult.name;
                  });
                }
              }),
          Container(
            width: double.infinity,
            height: PsDimens.space44,
            margin: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
                bottom: PsDimens.space12),
            decoration: BoxDecoration(
              color:
                  Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(
                  color: Utils.isLightMode(context)
                      ? Colors.grey[200]
                      : Colors.black87),
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              maxLines: null,
              controller: widget.userInputDealOptionText,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: PsDimens.space12,
                  bottom: PsDimens.space8,
                ),
                border: InputBorder.none,
                hintText: Utils.getString(context, 'item_entry__remark'),
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: PsColors.textPrimaryLightColor),
              ),
            ),
          )
        ],
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__address'),
        textAboutMe: false,
        height: PsDimens.space160,
        textEditingController: widget.userInputAddress,
        hintText: Utils.getString(context, 'item_entry__address'),
      ),
      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__location'),
          // selectedText: provider.selectedItemLocation == ''
          //     ? provider.psValueHolder.locactionName
          //     : provider.selectedItemLocation,

          textEditingController:
              // locationController.text == ''
              // ?
              // provider.psValueHolder.locactionName
              // :
              widget.locationController,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemLocationResult =
                await Navigator.pushNamed(context, RoutePaths.itemLocation);

            if (itemLocationResult != null &&
                itemLocationResult is ItemLocation) {
              provider.itemLocationId = itemLocationResult.id;
              setState(() {
                widget.locationController.text = itemLocationResult.name;
                _latlng = LatLng(double.parse(itemLocationResult.lat),
                    double.parse(itemLocationResult.lng));

                widget.mapController.move(_latlng, widget.zoom);

                widget.userInputLattitude.text = itemLocationResult.lat;
                widget.userInputLongitude.text = itemLocationResult.lng;

                // tappedPoints = <LatLng>[];
                // tappedPoints.add(latlng);
              });
            }
          }),

      Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          height: 250,
          child: FlutterMap(
            mapController: widget.mapController,
            options: MapOptions(
                center: widget
                    .latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                zoom: widget.zoom, //10.0,
                onTap: (LatLng latLngr) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _handleTap(_latlng, widget.mapController);
                }),
            layers: <LayerOptions>[
              TileLayerOptions(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayerOptions(markers: <Marker>[
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _latlng,
                  builder: (BuildContext ctx) => Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on,
                        color: PsColors.mainColor,
                      ),
                      iconSize: 45,
                      onPressed: () {},
                    ),
                  ),
                )
              ])
            ],
          ),
        ),
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__latitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLattitude,
      ),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__longitude'),
        textAboutMe: false,
        textEditingController: widget.userInputLongitude,
      ),

      _uploadItemWidget
    ]);
  }

  dynamic _handleTap(LatLng latLng, MapController mapController) async {
    final dynamic result = await Navigator.pushNamed(context, RoutePaths.mapPin,
        arguments: MapPinIntentHolder(
            flag: PsConst.PIN_MAP,
            mapLat: _latlng.latitude.toString(),
            mapLng: _latlng.longitude.toString()));
    if (result != null && result is MapPinCallBackHolder) {
      setState(() {
        _latlng = result.latLng;
        mapController.move(_latlng, widget.zoom);
        widget.userInputAddress.text = result.address;
        // tappedPoints = <LatLng>[];
        // tappedPoints.add(latlng);
      });
      widget.userInputLattitude.text = result.latLng.latitude.toString();
      widget.userInputLongitude.text = result.latLng.longitude.toString();
    }
  }
}

class ImageUploadHorizontalList extends StatefulWidget {
  const ImageUploadHorizontalList(
      {@required this.flag,
      @required this.images,
      @required this.selectedImageList,
      @required this.updateImages,
      @required this.firstImagePath,
      @required this.secondImagePath,
      @required this.thirdImagePath,
      @required this.fouthImagePath,
      @required this.fifthImagePath});
  final String flag;
  final List<Asset> images;
  final List<DefaultPhoto> selectedImageList;
  final Function updateImages;
  final Asset firstImagePath;
  final Asset secondImagePath;
  final Asset thirdImagePath;
  final Asset fouthImagePath;
  final Asset fifthImagePath;
  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  Future<void> loadPickMultiImage() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: widget.images,
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

    widget.updateImages(resultList, -1);
  }

  Future<void> loadSingleImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        // selectedAssets: null, //widget.images,
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

    widget.updateImages(resultList, index);
  }

  @override
  Widget build(BuildContext context) {
    Asset defaultAssetImage;
    DefaultPhoto defaultUrlImage;

    return Container(
      height: PsDimens.space120,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                ItemEntryImageWidget(
                  index: 0,
                  images: (widget.firstImagePath != null)
                      ? widget.firstImagePath
                      : defaultAssetImage,
                  selectedImage: (widget.selectedImageList.isNotEmpty &&
                          widget.firstImagePath == null)
                      ? widget.selectedImageList[0]
                      : null,
                  // (widget.firstImagePath != null) ? null : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (widget.flag == PsConst.ADD_NEW_ITEM) {
                      loadPickMultiImage();
                    } else {
                      loadSingleImage(0);
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 1,
                  images: (widget.secondImagePath != null)
                      ? widget.secondImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.secondImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 1 &&
                              widget.secondImagePath == null)
                          ? widget.selectedImageList[1]
                          : null,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (widget.flag == PsConst.ADD_NEW_ITEM) {
                      loadPickMultiImage();
                    } else {
                      loadSingleImage(1);
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 2,
                  images: (widget.thirdImagePath != null)
                      ? widget.thirdImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.thirdImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 2 &&
                              widget.thirdImagePath == null)
                          ? widget.selectedImageList[2]
                          : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (widget.flag == PsConst.ADD_NEW_ITEM) {
                      loadPickMultiImage();
                    } else {
                      loadSingleImage(2);
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 3,
                  images: (widget.fouthImagePath != null)
                      ? widget.fouthImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.fouthImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 3 &&
                              widget.fouthImagePath == null)
                          ? widget.selectedImageList[3]
                          : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (widget.flag == PsConst.ADD_NEW_ITEM) {
                      loadPickMultiImage();
                    } else {
                      loadSingleImage(3);
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 4,
                  images: (widget.fifthImagePath != null)
                      ? widget.fifthImagePath
                      : defaultAssetImage,
                  selectedImage: //widget.fifthImagePath != null ||
                      //     widget.selectedImageList.length - 1 >= 4)
                      // ? widget.selectedImageList[4]
                      // : defaultUrlImage,
                      (widget.selectedImageList.length > 4 &&
                              widget.fifthImagePath == null)
                          ? widget.selectedImageList[4]
                          : null,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (widget.flag == PsConst.ADD_NEW_ITEM) {
                      loadPickMultiImage();
                    } else {
                      loadSingleImage(4);
                    }
                  },
                ),
              ],
            );
          }),
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget({
    Key key,
    @required this.index,
    @required this.images,
    @required this.selectedImage,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final int index;
  final Asset images;
  final DefaultPhoto selectedImage;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.selectedImage != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap,
          child: PsNetworkImageWithUrl(
            photoKey: '',
            width: 100,
            height: 100,
            imagePath: widget.selectedImage.imgPath,
          ),
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: AssetThumb(
              asset: asset,
              width: 100,
              height: 100,
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
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

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget({
    Key key,
    // @required this.onTap,
    this.currencySymbolController,
  }) : super(key: key);

  final TextEditingController currencySymbolController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space12,
              left: PsDimens.space12),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: PsColors.mainColor))
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
                Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemCurrencySymbolResult = await Navigator.pushNamed(
                context, RoutePaths.itemCurrencySymbol);

            if (itemCurrencySymbolResult != null &&
                itemCurrencySymbolResult is ItemCurrency) {
              provider.itemCurrencyId = itemCurrencySymbolResult.id;

              currencySymbolController.text =
                  itemCurrencySymbolResult.currencySymbol;
            }
          },
          child: Container(
            width: PsDimens.space140,
            height: PsDimens.space44,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color:
                  Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(
                  color: Utils.isLightMode(context)
                      ? Colors.grey[200]
                      : Colors.black87),
            ),
            child: Container(
              margin: const EdgeInsets.all(PsDimens.space12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    child: Ink(
                      color: PsColors.backgroundColor,
                      child: Text(
                        currencySymbolController.text == ''
                            ? Utils.getString(context, 'home_search__not_set')
                            : currencySymbolController.text,
                        style: currencySymbolController.text == ''
                            ? Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.grey[600])
                            : Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BusinessModeCheckbox extends StatefulWidget {
  const BusinessModeCheckbox(
      {@required this.provider, @required this.onCheckBoxClick});

  // final String checkOrNot;
  final ItemEntryProvider provider;
  final Function onCheckBoxClick;

  @override
  _BusinessModeCheckbox createState() => _BusinessModeCheckbox();
}

class _BusinessModeCheckbox extends State<BusinessModeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            activeColor: PsColors.mainColor,
            value: widget.provider.isCheckBoxSelect,
            onChanged: (bool value) {
              widget.onCheckBoxClick();
            },
          ),
        ),
        Expanded(
          child: InkWell(
            child: Text(Utils.getString(context, 'item_entry__is_shop'),
                style: Theme.of(context).textTheme.bodyText1.copyWith(color: PsColors.mainColor)),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, ItemEntryProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
    provider.checkOrNotShop = '0';
  } else {
    provider.isCheckBoxSelect = true;
    provider.checkOrNotShop = '1';
    // Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 2);
  }
}
