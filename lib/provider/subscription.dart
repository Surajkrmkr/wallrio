import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../log.dart';

class SubscriptionProvider with ChangeNotifier {
  bool isLoading = false;
  bool subscriptionLoading = false;
  bool isSupported = false;
  String activeSubscription = "";
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];

  late StreamSubscription subscription;

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  final String testID = 'com.wallrio.test';

  User? _user;

  User get user => _user!;

  set setProducts(List<ProductDetails> productList) {
    products = productList;
    notifyListeners();
  }

  set setPurchases(List<PurchaseDetails> purchasesList) {
    purchases = purchasesList;
    notifyListeners();
  }

  set setSubscription(bool val) {
    subscriptionLoading = val;
    notifyListeners();
  }

  set setSubscriptionLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  set setIsLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  set setSignedInUser(User user) {
    _user = user;
  }

  SubscriptionProvider() {
    checkSupportForIAP();
  }

  Future<void> checkSupportForIAP() async {
    isSupported = await inAppPurchase.isAvailable();
    if (isSupported) {
      subscription = inAppPurchase.purchaseStream.listen((data) {
        logger.i(data.first.purchaseID);
        logger.i(data.first.productID);
        logger.i(data.first.status);
        logger.i(data.first.error);
      });
    }
  }

  Future<void> getUserProducts() async {
    setSubscription = true;
    final Set<String> ids = {testID};
    try {
      final ProductDetailsResponse response =
          await inAppPurchase.queryProductDetails(ids);
      setProducts = response.productDetails;
    } catch (error) {
      logger.e(error);
    } finally {
      setSubscription = false;
    }
  }

  void buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam, autoConsume: false);
  }
}
