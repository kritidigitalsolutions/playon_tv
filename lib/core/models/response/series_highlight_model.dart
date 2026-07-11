import 'package:equatable/equatable.dart';

class SeriesHighlightModel extends Equatable {
  final String id;
  final String title;
  final String sport;
  final String banner;
  final String tournamentLogo;
  final String status;

  const SeriesHighlightModel({
    required this.id,
    required this.title,
    required this.sport,
    required this.banner,
    required this.tournamentLogo,
    required this.status,
  });

  factory SeriesHighlightModel.fromJson(Map<String, dynamic> json) => SeriesHighlightModel(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    sport: json['sport'] ?? '',
    banner: json['banner'] ?? '',
    tournamentLogo: json['tournamentLogo'] ?? '',
    status: json['status'] ?? '',
  );

  Map<String, dynamic> toJson() => {};

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, sport, banner, tournamentLogo, status];
}
