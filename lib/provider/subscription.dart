import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:wallrio/provider/auth.dart';

import '../log.dart';
import '../ui/widgets/toast_widget.dart';

class SubscriptionProvider with ChangeNotifier {
  bool isLoading = false;
  bool isSupported = false;
  String activeSubscriptionId = "";

  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];

  late StreamSubscription subscription;

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  final String testID = 'com.wallrio.test';

  final successPurchasedStream = StreamController<bool>();

  set setProducts(List<ProductDetails> productList) {
    products = productList;
    notifyListeners();
  }

  set setPurchases(List<PurchaseDetails> purchasesList) {
    purchases = purchasesList;
    notifyListeners();
  }

  set setActiveSubscriptionId(String purchaseId) {
    activeSubscriptionId = purchaseId;
    notifyListeners();
  }

  set setIsLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  Future<void> checkSupportForIAP() async {
    isSupported = await inAppPurchase.isAvailable();
    if (isSupported) {
      subscription = inAppPurchase.purchaseStream.listen((data) {
        switch (data.first.status) {
          case PurchaseStatus.canceled:
            ToastWidget.showToast('Purchase Cancelled');
            break;
          case PurchaseStatus.error:
            ToastWidget.showToast('Something went wrong');
            break;
          case PurchaseStatus.pending:
            ToastWidget.showToast(
                'Your purchase is currently pending. Please check back in sometime');
            break;
          case PurchaseStatus.purchased:
            ToastWidget.showToast('Purchased successfully');
            _verifyPurchase(data.first);
            break;
          default:
        }
      });
    }
  }

  Future<void> getUserProducts() async {
    setIsLoading = true;
    final Set<String> ids = {testID};
    try {
      final ProductDetailsResponse response =
          await inAppPurchase.queryProductDetails(ids);
      setProducts = response.productDetails;
    } catch (error) {
      logger.e(error);
    } finally {
      setIsLoading = false;
    }
  }

  void buyProduct(ProductDetails prod) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
      await inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam, autoConsume: true);
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    setIsLoading = true;
    try {
      await inAppPurchase.completePurchase(purchase);
      final CollectionReference purchases =
          FirebaseFirestore.instance.collection('purchases');
      await purchases.add({
        "productID": purchase.productID,
        "purchaseID": purchase.purchaseID,
        "pendingCompletePurchase": purchase.pendingCompletePurchase,
        "transactionDate": purchase.transactionDate,
        'email': AuthProvider().user.email,
        'purchaseStartDate': DateTime.now().toUtc(),
        'purchaseEndDate':
            DateTime.now().add(const Duration(days: 30)).toUtc(), // TODO
      });
      setActiveSubscriptionId = purchase.productID;
      successPurchasedStream.sink.add(true);
    } catch (error) {
      logger.e(error);
    } finally {
      setIsLoading = false;
    }
  }

  Future<void> checkPastPurchases({required String email}) async {
    try {
      final CollectionReference purchases =
          FirebaseFirestore.instance.collection('purchases');
      final QuerySnapshot<Object?> querySnapshot = await purchases.get();
      final now = DateTime.now();
      for (var element in querySnapshot.docs) {
        if (element["email"] == email) {
          final purchaseStartDate =
              DateTime.parse(element["purchaseStartDate"].toDate().toString());
          final purchaseEndDate =
              DateTime.parse(element["purchaseEndDate"].toDate().toString());
          final bool isPurchaseActive =
              purchaseStartDate.isBefore(now) && purchaseEndDate.isAfter(now);
          if (isPurchaseActive) setActiveSubscriptionId = element["productID"];
        }
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  void clearData() => setActiveSubscriptionId = "";
}
