import 'package:airnote/services/locator.dart';
import 'package:airnote/services/promotion-code.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PromotionCodeViewModel extends BaseViewModel {
  final PromotionCodeService _promotionCodeService = locator<PromotionCodeService>();
  final SnackBarService _snackBarService = locator<SnackBarService>();

  Future<bool> redeemCode(String code) async {
    setStatus(ViewStatus.LOADING);
    bool success = false;
    try {
      await _promotionCodeService.setupClient();
      await _promotionCodeService.redeemCode(code);
      success = true;
      _snackBarService.showSnackBar(icon: Icon(Icons.card_membership), text: "Successfully redeemed the promotion code");
    } on DioError catch(_) {
      success = false;
      _snackBarService.showSnackBar(icon: Icon(Icons.error), text: "There was an issue, please try again");
    }
    setStatus(ViewStatus.READY);
    return success;
  }
}