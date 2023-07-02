import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/wall_rio.dart';
import '../theme/theme_data.dart';
import '../widgets/sliver_app_bar_widget.dart';
import '../widgets/trending_wall_grid_widget.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<WallRio>(context, listen: false).resetToDefault();
          return true;
        },
        child: SafeArea(
          child: CustomScrollView(controller: scrollController, slivers: [
            const SliverAppBarWidget(
                showLogo: false,
                showSearchBtn: false,
                centeredTitle: true,
                showBackBtn: true,
                clearSearchedData: true,
                text: "Search it..."),
            _buildSearchBarUI(),
            _buildChipsUI(),
            const TrendingWallGridWidget(isShuffled: true, isActionGrid: true)
          ]),
        ),
      ),
    );
  }

  Consumer<WallRio> _buildChipsUI() {
    final ScrollController scrollController = ScrollController();
    return Consumer<WallRio>(builder: (context, provider, _) {
      return SliverToBoxAdapter(
          child: SizedBox(
              height: 80,
              child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 20),
                    ...provider.tag.selectedTags
                        .map((tag) => Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: FilterChip(
                                label: Text(tag),
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                selected: provider.getTagIsSelected(tag),
                                onSelected: (value) {
                                  cancelSearchBar(context);
                                  provider.onSelectedTag(tag);
                                })))
                        .toList(),
                    ...provider.tag.unSelectedTags
                        .map((tag) => Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: FilterChip(
                                label: Text(tag),
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.5)),
                                selected: provider.getTagIsSelected(tag),
                                onSelected: (_) {
                                  cancelSearchBar(context);
                                  provider.onSelectedTag(tag);
                                  scrollController.animateTo(0,
                                      curve: Curves.easeInOut,
                                      duration:
                                          const Duration(milliseconds: 500));
                                })))
                        .toList()
                  ])));
    });
  }

  Widget _buildSearchBarUI() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<WallRio>(builder: (context, provider, _) {
          return TextFormField(
            controller: textEditingController,
            cursorColor: Theme.of(context).primaryColorLight,
            cursorWidth: 3,
            cursorRadius: const Radius.circular(10),
            onTap: () {
              provider.clearSelectedTags();
              scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            onChanged: (query) => provider.onSearchTap(query),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).primaryColorLight.withOpacity(0.05),
              hintText: 'Search...',
              hintStyle: const TextStyle(fontSize: 14),
              suffixIcon: IconButton(
                  onPressed: textEditingController.text.isNotEmpty
                      ? () {
                          provider.resetToDefault();
                          cancelSearchBar(context);
                        }
                      : null,
                  icon: Icon(textEditingController.text.isNotEmpty
                      ? Icons.cancel
                      : Icons.search_rounded)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              hoverColor: blackColor.withOpacity(0.05),
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          );
        }),
      ),
    );
  }

  void cancelSearchBar(BuildContext context) {
    textEditingController.clear();
    FocusScope.of(context).unfocus();
  }
}
