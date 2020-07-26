import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/rating/rating_provider.dart';
import 'package:flutterbuyandsell/repository/rating_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/rating_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/viewobject/holder/rating_list_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingInputDialog extends StatefulWidget {
  const RatingInputDialog({
    Key key,
    // @required this.productprovider,
    @required this.itemUserId,
    @required this.psValueHolder,
    @required this.buyerUserId,
    @required this.sellerUserId,
    @required this.itemDetail,
  }) : super(key: key);

  // final ItemDetailProvider productprovider;
  final String itemUserId;
  final PsValueHolder psValueHolder;
  final String buyerUserId;
  final String sellerUserId;
  final Product itemDetail;
  @override
  _RatingInputDialogState createState() => _RatingInputDialogState();
}

class _RatingInputDialogState extends State<RatingInputDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double rating;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RatingRepository ratingRepo = Provider.of<RatingRepository>(context);

    final Widget _headerWidget = Container(
        height: PsDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: PsColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: PsDimens.space4),
            Icon(
              Icons.live_help,
              color: PsColors.white,
            ),
            const SizedBox(width: PsDimens.space4),
            Text(
              Utils.getString(context, 'rating_entry__user_rating_entry'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PsColors.white,
              ),
            ),
          ],
        ));
    return ChangeNotifierProvider<RatingProvider>(
        lazy: false,
        create: (BuildContext context) {
          final RatingProvider provider = RatingProvider(repo: ratingRepo);
          final RatingListHolder ratingListHolder =
              RatingListHolder(userId: widget.psValueHolder.loginUserId);
          provider.loadRatingList(
              ratingListHolder.toMap(), widget.psValueHolder.loginUserId);
          return provider;
        },
        child: Consumer<RatingProvider>(builder:
            (BuildContext context, RatingProvider provider, Widget child) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)), //this right here
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _headerWidget,
                  const SizedBox(
                    height: PsDimens.space16,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        Utils.getString(context, 'rating_entry__your_rating'),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(),
                      ),
                      if (rating == null)
                        SmoothStarRating(
                            allowHalfRating: false,
                            rating: 0.0,
                            starCount: 5,
                            size: PsDimens.space24,
                            color: PsColors.ratingColor,
                            onRated: (double rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0)
                      else
                        SmoothStarRating(
                            allowHalfRating: false,
                            rating: rating,
                            starCount: 5,
                            size: PsDimens.space24,
                            color: PsColors.ratingColor,
                            onRated: (double rating1) {
                              setState(() {
                                rating = rating1;
                              });
                            },
                            borderColor: PsColors.grey.withAlpha(100),
                            spacing: 0.0),
                      PsTextFieldWidget(
                          titleText:
                              Utils.getString(context, 'rating_entry__title'),
                          hintText:
                              Utils.getString(context, 'rating_entry__title'),
                          textEditingController: titleController),
                      PsTextFieldWidget(
                          height: PsDimens.space120,
                          titleText:
                              Utils.getString(context, 'rating_entry__message'),
                          hintText:
                              Utils.getString(context, 'rating_entry__message'),
                          textEditingController: descriptionController),
                      Divider(
                        color: PsColors.grey,
                        height: 0.5,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      _ButtonWidget(
                        descriptionController: descriptionController,
                        provider: provider,
                        itemUserId: widget.itemUserId,
                        titleController: titleController,
                        rating: rating,
                        psValueHolder: widget.psValueHolder,
                        buyerUserId: widget.buyerUserId,
                        sellerUserId: widget.sellerUserId,
                        itemDetail: widget.itemDetail,
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class _ButtonWidget extends StatelessWidget {
  const _ButtonWidget(
      {Key key,
      @required this.titleController,
      @required this.descriptionController,
      @required this.provider,
      // @required this.productProvider,
      @required this.itemUserId,
      @required this.rating,
      @required this.psValueHolder,
      @required this.buyerUserId,
      @required this.sellerUserId,
      @required this.itemDetail})
      : super(key: key);

  final TextEditingController titleController, descriptionController;
  final RatingProvider provider;
  // final ItemDetailProvider productProvider;
  final String itemUserId;
  final double rating;
  final PsValueHolder psValueHolder;
  final String buyerUserId;
  final String sellerUserId;
  final Product itemDetail;

  @override
  Widget build(BuildContext context) {
    RatingParameterHolder commentHeaderParameterHolder;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: false,
                colorData: PsColors.grey,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__cancel'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: PsDimens.space36,
              child: PSButtonWidget(
                hasShadow: true,
                width: double.infinity,
                titleText: Utils.getString(context, 'rating_entry__submit'),
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      rating != null &&
                      rating.toString() != '0.0') {
                    if (buyerUserId == psValueHolder.loginUserId) {
                      commentHeaderParameterHolder = RatingParameterHolder(
                        fromUserId: buyerUserId,
                        toUserId: sellerUserId,
                        title: titleController.text,
                        description: descriptionController.text,
                        rating: rating.toString(),
                      );
                    }
                    if (sellerUserId == psValueHolder.loginUserId) {
                      commentHeaderParameterHolder = RatingParameterHolder(
                        fromUserId: sellerUserId,
                        toUserId: buyerUserId,
                        title: titleController.text,
                        description: descriptionController.text,
                        rating: rating.toString(),
                      );
                    }

                    await provider
                        .postRating(commentHeaderParameterHolder.toMap());

                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: 'Rating Successed!!!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  } else {
                    print('There is no comment');

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message:
                                Utils.getString(context, 'rating_entry__error'),
                          );
                        });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
