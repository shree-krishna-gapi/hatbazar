import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/provider/gallery/gallery_provider.dart';
import 'package:flutterbuyandsell/repository/gallery_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar_no_app_bar_title.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/default_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({
    Key key,
    @required this.selectedDefaultImage,
    // @required this.index,
    this.onImageTap,
  }) : super(key: key);

  // final List<DefaultPhoto> image;
  final DefaultPhoto selectedDefaultImage;
  final Function onImageTap;

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository galleryRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBarNoAppBarTitle<GalleryProvider>(
      appBarTitle: Utils.getString(context, 'gallery__title') ?? '',
      initProvider: () {
        return GalleryProvider(repo: galleryRepo);
      },
      onProviderReady: (GalleryProvider provider) {
        provider.loadImageList(
            widget.selectedDefaultImage.imgParentId, PsConst.ITEM_TYPE);
      },
      builder: (BuildContext context, GalleryProvider provider, Widget child) {
        if (provider.galleryList != null &&
            provider.galleryList.data != null &&
            provider.galleryList.data.isNotEmpty) {
          int selectedIndex = 0;
          for (int i = 0; i < provider.galleryList.data.length; i++) {
            if (widget.selectedDefaultImage.imgId ==
                provider.galleryList.data[i].imgId) {
              selectedIndex = i;
              break;
            }
          }

          return PhotoViewGallery.builder(
            itemCount: provider.galleryList.data.length,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions.customChild(
                child: PsNetworkImageWithUrl(
                  photoKey: '',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  imagePath: provider.galleryList.data[index].imgPath,
                  onTap: widget.onImageTap,
                  boxfit: BoxFit.contain,
                ),
                childSize: MediaQuery.of(context).size,
              );
            },
            pageController: PageController(initialPage: selectedIndex),
            scrollPhysics: const BouncingScrollPhysics(),
            loadingBuilder: (BuildContext context, ImageChunkEvent event) =>
                const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
