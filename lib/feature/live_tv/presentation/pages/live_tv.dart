import 'package:flutter/material.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_button.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_text_field.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class LiveTv extends StatefulWidget {
  const LiveTv({super.key});

  @override
  State<LiveTv> createState() => _LiveTvState();
}

class _LiveTvState extends State<LiveTv> {
  late final TextEditingController _searchController;
  int selectedIndex = 0;
  final List images = [
    {"id": 1, "images": AppImage.background},
    {"id": 2, "images": AppImage.background},
    {"id": 3, "images": AppImage.background},
    {"id": 4, "images": AppImage.background},
  ];
  final List<String> tabs = const [
    "ALL",
    "ENTERTAINMENT",
    "MOVIES",
    "MUSIC",
    "NEWS",
    "SPORTS",
    "VAKTI",
  ];

  final List channels = [
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "SPORTS"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "ENTERTAINMENT"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "MOVIES"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "SPORTS"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "SPORTS"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "SPORTS"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "ENTERTAINMENT"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "MOVIES"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "SPORTS"},
    {"image": AppImage.logo, "name": "DD SPORTS", "type": "SPORTS"},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChannel(BuildContext context) {
    AppNavigation.push(context, "liveChannelDetail/12");
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = tabs[selectedIndex];
    final filteredChannels = selectedTab == "ALL"
        ? channels
        : channels.where((c) => c['type'] == selectedTab).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: SafeArea(
          child: Column(
            children: [
              // Fixed header row (title + search) — sits outside any
              // scrollable, so it never moves.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Text("Live TV Channels", style: text24()),
                    SizedBox(width: 20),
                    Expanded(
                      child: AppTextField(
                        controller: _searchController,
                        // This is the screen's single autofocus target —
                        // the grid below no longer also claims it.
                        autofocus: true,
                        hintText: "Search Channel",
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 14, right: 10),
                          child: Icon(
                            Icons.search,
                            size: 22,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Category tabs — also fixed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppTabBar(
                  tabs: tabs,
                  selectedIndex: selectedIndex,
                  onChanged: (value) {
                    setState(() => selectedIndex = value);
                  },
                ),
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 16),

              // Everything below this point scrolls.
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.55,
                        child: FocusTraversalGroup(
                          policy: ReadingOrderTraversalPolicy(),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return TvFocusable(
                                autofocus:
                                    index ==
                                    0, // first banner is the page's landing focus
                                borderRadius: BorderRadius.circular(20),
                                onSelect: () {
                                  AppNavigation.push(
                                    context,
                                    "/trending/${images[index]['id']}",
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.85,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        images[index]["images"]!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (filteredChannels.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              "No channels in this category",
                              style: text17(
                                color: AppColors.white.withAlpha(150),
                              ),
                            ),
                          ),
                        )
                      else
                        FocusTraversalGroup(
                          policy: ReadingOrderTraversalPolicy(),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredChannels.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.7,
                                ),
                            itemBuilder: (context, index) {
                              final channel = filteredChannels[index];

                              return TvFocusable(
                                borderRadius: BorderRadius.circular(10),
                                onSelect: () => _openChannel(context),
                                child: AnimatedBox(
                                  padding: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  color: AppColors.background.withAlpha(60),
                                  border: Border.all(color: AppColors.primary),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.white
                                                  .withOpacity(0.08),
                                              border: Border.all(
                                                color: AppColors.white
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: Image.asset(
                                                  channel['image'],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  channel['name'],
                                                  style: text17(
                                                    color: AppColors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  channel['type'],
                                                  style: text14(
                                                    color: AppColors.white
                                                        .withAlpha(150),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      IgnorePointer(
                                        child: AppButton(
                                          title: "Watch",
                                          height: 36,
                                          radius: 20,
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
