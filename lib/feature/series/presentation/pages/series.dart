import 'package:flutter/material.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class Series extends StatefulWidget {
  const Series({super.key});

  @override
  State<Series> createState() => _SeriesState();
}

class _SeriesState extends State<Series> {
  int selectedIndex = 0;
  String selectedFilter = 'HOME';

  final List<String> tabs = const [
    "HOME",
    "CRICKET",
    "FOOTBALL",
    "HOCKEY",
    "KHOKHO",
    "KABADDI",
  ];

  final List<Map<String, String>> series = [
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "CRICKET",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "CRICKET",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "CRICKET",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "FOOTBALL",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "HOCKEY",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "CRICKET",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "FOOTBALL",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
    {
      "image": AppImage.background,
      "title": "Ghaziabad Premier League 2026",
      "sport": "HOCKEY",
      "state": "UP",
      "description": "Ghaziabad Premier League",
    },
  ];

  List<Map<String, String>> get filteredSeries {
    if (selectedFilter == 'HOME') {
      return series;
    }
    return series.where((item) => item['sport'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BackgroundWithOneLight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("All Series", style: text24()),
            ),
            Center(
              child: AppTabBar(
                tabs: tabs,
                selectedIndex: selectedIndex,
                onChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                    selectedFilter = tabs[index];
                  });
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of cards per row
                  crossAxisSpacing: 12, // Horizontal spacing between cards
                  mainAxisSpacing: 12, // Vertical spacing between cards
                  childAspectRatio:
                      1, // Width to height ratio (adjust as needed)
                ),
                itemCount: filteredSeries.length,
                itemBuilder: (context, index) {
                  return SeriesCard(
                    series: filteredSeries[index],
                    onTap: () {
                      AppNavigation.push(context, "/seriesDetail/12");
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeriesCard extends StatefulWidget {
  final Map<String, String> series;
  final VoidCallback? onTap;

  const SeriesCard({super.key, required this.series, this.onTap});

  @override
  State<SeriesCard> createState() => _SeriesCardState();
}

class _SeriesCardState extends State<SeriesCard> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final series = widget.series;

    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isFocused ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: AppColors.background.withAlpha(60),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isFocused
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.3),
                width: _isFocused ? 3 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isFocused
                      ? AppColors.primary.withOpacity(0.5)
                      : Colors.black.withOpacity(0.3),
                  blurRadius: _isFocused ? 22 : 8,
                  spreadRadius: _isFocused ? 2 : 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image - flexes to fill whatever space is left over
                  // after the content section below takes what it needs.
                  // (Previously this was Expanded(flex: 6) alongside a
                  // flex: 4 content section, which forced the text into
                  // a fixed share of the height and overflowed on
                  // smaller cards.)
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          series['image'] ?? '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[850],
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 36,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        // subtle bottom scrim so the image edge blends
                        // into the content section below
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 40,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.35),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content section — NOT wrapped in Expanded. It only
                  // takes the height its text actually needs, so it can
                  // never overflow; the image above absorbs any extra
                  // or missing space instead.
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          series['title'] ?? '',
                          style: text16(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Sport and State as pill chips
                        Row(
                          children: [
                            if ((series['sport'] ?? '').isNotEmpty)
                              _Chip(text: series['sport']!),
                            if ((series['state'] ?? '').isNotEmpty) ...[
                              const SizedBox(width: 8),
                              _Chip(text: series['state']!),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Description
                        Text(
                          series['description'] ?? '',
                          style: text12(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small pill-shaped label used for sport/state tags.
class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: text12(fontWeight: FontWeight.w600)),
    );
  }
}
