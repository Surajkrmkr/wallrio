import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../provider/dark_theme.dart';
import '../../provider/subscription.dart';
import '../theme/theme_data.dart';
import 'shimmer_widget.dart';

class PlusSubscription extends StatefulWidget {
  const PlusSubscription({super.key});

  @override
  State<PlusSubscription> createState() => _PlusSubscriptionState();
}

class _PlusSubscriptionState extends State<PlusSubscription> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<SubscriptionProvider>(context, listen: false)
          .getUserProducts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          _headerUI(),
          _featureUI(),
          _productList(),
          _buildQueryUI(),
          _buildBuyBtnUI(),
          _buildRestoreBtn()
        ],
      ),
    );
  }

  Widget _buildRestoreBtn() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child:
            TextButton(onPressed: () {}, child: const Text("Restore Purchase")),
      );

  Padding _buildBuyBtnUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 25),
      child: InkWell(
        child: Ink(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFFFE376), Color(0xFFF7B540)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text("Buy now for",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                    )),
          ),
        ),
      ),
    );
  }

  Padding _buildQueryUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Please contact us for any payment related queries.",
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
          Text("teamshadowsupp@gmail.com",
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _productList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
      child: Ink(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFFFE376), Color(0xFFF7B540)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(20)),
        child: Consumer<SubscriptionProvider>(builder: (context, provider, _) {
          return provider.isLoading
              ? const ShimmerWidget(height: 24, width: double.infinity)
              : Theme(
                  data: WallRioThemeData.getLightThemeData(
                      isDarkTheme: false, context: context),
                  child: Column(
                    children: provider.products
                        .map((product) => _buildSubscriptonTile(
                            product: product,
                            activeSubscription: provider.activeSubscription))
                        .toList(),
                  ),
                );
        }),
      ),
    );
  }

  Widget _featureUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
      child: Column(
        children: [
          _buildPlusFeature(context: context, feature: "Ad-free experience."),
          _buildPlusFeature(
              context: context, feature: "Unlock Plus collections."),
          _buildPlusFeature(
              context: context, feature: "Maximum Quality Upto 8k.")
        ],
      ),
    );
  }

  Container _headerUI() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: Theme.of(context).navigationBarTheme.indicatorColor,
      ),
      child: Column(
        children: [
          Image.asset("assets/app_icon/icon-foreground.png", height: 90),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<DarkThemeProvider>(builder: (context, provider, _) {
                return GradientText(
                  " WallRio ",
                  style: Theme.of(context).textTheme.displayLarge,
                  colors: gradientColorMap[provider.gradType]!,
                );
              }),
              Text(
                "Plus",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(width: 12),
              _buildPlusIcon(size: 24)
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  RadioListTile<String> _buildSubscriptonTile(
      {required ProductDetails product, required String activeSubscription}) {
    return RadioListTile(
      value: product.id,
      groupValue: activeSubscription,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      onChanged: (val) =>
          Provider.of<SubscriptionProvider>(context, listen: false)
              .buyProduct(product),
      title: Row(
        children: [
          Expanded(child: Text(product.title)),
          Text(product.price),
        ],
      ),
      isThreeLine: true,
      subtitle: Text(
        product.description,
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).primaryColorDark),
      ),
    );
  }

  Row _buildPlusFeature(
      {required BuildContext context, required String feature}) {
    return Row(
      children: [
        _buildPlusIcon(size: 16),
        const SizedBox(width: 10),
        Text(
          feature,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Padding _buildPlusIcon({required double size}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Image.asset("assets/plus_icon.png", height: size),
    );
  }
}