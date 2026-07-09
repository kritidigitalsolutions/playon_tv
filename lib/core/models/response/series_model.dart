import 'package:equatable/equatable.dart';

class SeriesModel extends Equatable {
  final String id;
  final String title;
  final String sport;
  final String banner;
  final String tournamentLogo;
  final String status;

  const SeriesModel({
    required this.id,
    required this.title,
    required this.sport,
    required this.banner,
    required this.tournamentLogo,
    required this.status,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) => SeriesModel(
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
