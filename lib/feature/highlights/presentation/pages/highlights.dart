import 'package:flutter/material.dart';

import 'package:playon/feature/highlights/presentation/widgets/highlight_view.dart';


class Highlights extends StatefulWidget {
  const Highlights({super.key});

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
  @override
  Widget build(BuildContext context) {
    return const HighlightsView();
  }
}

