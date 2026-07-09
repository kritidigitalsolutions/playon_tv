import 'package:flutter/material.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class SeriesDetailPage extends StatefulWidget {
  const SeriesDetailPage({super.key, required this.id});
  final int id;

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  final seriesAllMatches = [
    {
      "image": AppImage.background,
      "seriesName": "Ghaziabad Premier League",
      "team1": "Raina Superkings",
      "team2": "Migsun Champions",
      "state": "UP",
      "logo": AppImage.logo,
    },
    {
      "image": AppImage.background,
      "seriesName": "Ghaziabad Premier League",
      "team1": "Raina Superkings",
      "team2": "Migsun Champions",
      "state": "UP",
      "logo": AppImage.logo,
    },
    {
      "image": AppImage.background,
      "seriesName": "Ghaziabad Premier League",
      "team1": "Raina Superkings",
      "team2": "Migsun Champions",
      "state": "UP",
      "logo": AppImage.logo,
    },
    {
      "image": AppImage.background,
      "seriesName": "Ghaziabad Premier League",
      "team1": "Raina Superkings",
      "team2": "Migsun Champions",
      "state": "UP",
      "logo": AppImage.logo,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BackgroundWithOneLight(
        child: Column(
          children: [
            // Custom AppBar
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    AppNavigation.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: AppColors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Series Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            // Body content
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),

                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 360,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,

                  childAspectRatio: 1.05,
                ),
                itemCount: seriesAllMatches.length,
                itemBuilder: (context, index) {
                  final match = seriesAllMatches[index];
                  return SeriesMatchCard(
                    match: match,
                    onTap: () {
                      AppNavigation.push(context, "seriesMatch/1");
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

class SeriesMatchCard extends StatefulWidget {
  final Map<String, String> match;
  final VoidCallback? onTap;

  const SeriesMatchCard({super.key, required this.match, this.onTap});

  @override
  State<SeriesMatchCard> createState() => _SeriesMatchCardState();
}

class _SeriesMatchCardState extends State<SeriesMatchCard> {
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
    final match = widget.match;
    final team1 = match['team1'] ?? '';
    final team2 = match['team2'] ?? '';
    final hasTeams = team1.isNotEmpty && team2.isNotEmpty;
    final state = match['state'] ?? '';
    final logo = match['logo'];

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with just the state badge overlaid on it.
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          match['image'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[850],
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 32,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.6, 1.0],
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.35),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (state.isNotEmpty)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                state,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Content footer — sized to its own content, so it
                  // can never overflow. The image above takes whatever
                  // space is left.
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              child: ClipOval(
                                child: logo != null
                                    ? Image.asset(
                                        logo,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.sports_cricket,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                      )
                                    : const Icon(
                                        Icons.sports_cricket,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                match['seriesName'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (hasTeams) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  team1,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'VS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  team2,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
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
