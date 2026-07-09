import 'package:flutter/material.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/app_tab_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class Highlights extends StatefulWidget {
  const Highlights({super.key});

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
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
              child: Text("All Highlights", style: text24()),
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
              // Re-key the grid whenever the filter changes so old
              // FocusNodes (which no longer correspond to visible
              // cards) get torn down instead of stealing focus.
              child: GridView.builder(
                key: ValueKey(selectedFilter),
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
                  return HighLightCards(
                    // Only the very first card in the grid grabs
                    // initial remote focus.
                    autofocus: index == 0,
                    series: filteredSeries[index],
                    onTap: () {
                      AppNavigation.push(context, "/allHighlightsTornament/1");
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

class HighLightCards extends StatefulWidget {
  final Map<String, String> series;
  final VoidCallback? onTap;
  final bool autofocus;

  const HighLightCards({
    super.key,
    required this.series,
    this.onTap,
    this.autofocus = false,
  });

  @override
  State<HighLightCards> createState() => _HighLightCardsState();
}

class _HighLightCardsState extends State<HighLightCards> {
  // Kept locally (rather than inside TvFocusable) purely so this card
  // can drive its own border/glow highlight, which TvFocusable's
  // default background-tint highlight doesn't cover. TvFocusable still
  // owns all key handling (Select + D-pad traversal) via this node.
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final series = widget.series;
    final hasSport = (series['sport'] ?? '').isNotEmpty;
    final hasState = (series['state'] ?? '').isNotEmpty;

    return TvFocusable(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      borderRadius: BorderRadius.circular(14),
      // Let this widget's own border/glow be the highlight; skip
      // TvFocusable's flat background tint so it doesn't double up.
      focusBackgroundColor: Colors.transparent,
      onSelect: widget.onTap,
      child: _HighlightCardVisual(
        series: series,
        hasSport: hasSport,
        hasState: hasState,
        isFocused: _isFocused,
      ),
    );
  }
}

/// Pure visual presentation for a highlight card. Split out from
/// [HighLightCards] so [TvFocusable] owns all key handling while this
/// stays a simple build driven by the [isFocused] flag passed in.
class _HighlightCardVisual extends StatelessWidget {
  const _HighlightCardVisual({
    required this.series,
    required this.hasSport,
    required this.hasState,
    required this.isFocused,
  });

  final Map<String, String> series;
  final bool hasSport;
  final bool hasState;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isFocused ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.background.withAlpha(60),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFocused
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            width: isFocused ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isFocused
                  ? AppColors.primary.withOpacity(0.5)
                  : Colors.black.withOpacity(0.3),
              blurRadius: isFocused ? 22 : 8,
              spreadRadius: isFocused ? 2 : 0,
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
                    // Sport/state badge overlaid on the image's
                    // top-left corner instead of below.
                    if (hasSport || hasState)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Row(
                          children: [
                            if (hasSport) _Chip(text: series['sport']!),
                            if (hasSport && hasState) const SizedBox(width: 6),
                            if (hasState) _Chip(text: series['state']!),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Content section — only title + description now.
              // Sized to its own content, so it can never overflow;
              // the image above absorbs any extra or missing space.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      series['title'] ?? '',
                      style: text16(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
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
    );
  }
}

/// Small pill-shaped label used for sport/state tags. Slightly darker
/// background here since it now sits directly on top of the image
/// rather than on a dark content background.
class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: text12(fontWeight: FontWeight.w600)),
    );
  }
}
