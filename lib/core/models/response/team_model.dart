import 'package:equatable/equatable.dart';

class TeamModel extends Equatable {
  final String id;
  final String name;
  final String sport;
  final String logo;
  final String shortName;

  const TeamModel({
    required this.id,
    required this.name,
    required this.sport,
    required this.logo,
    required this.shortName,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    sport: json['sport'] ?? '',
    logo: json['logo'] ?? '',
    shortName: json['shortName'] ?? '',
  );

  Map<String, dynamic> toJson() => {};

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, sport, logo, shortName];
}
