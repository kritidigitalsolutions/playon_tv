import 'package:equatable/equatable.dart';
import 'package:playon/core/models/response/team_model.dart';
import 'series_match_model.dart';

class SeriesModel extends Equatable {
  final String id;
  final String title;
  final String sport;
  final String slug;
  final String banner;
  final String tournamentLogo;
  final String description;
  final List<TeamModel> teams;
  final String? tourCountry;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final bool isFeatured;
  final bool isTrending;
  final bool isHomeScreen;
  final bool isPremium;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final List<SeriesMatchModel>? matches; // ✅ Updated to SeriesMatchModel
  final int totalMatches;
  final DateTime? matchScheduledDate;
  final String? matchStatus;
  final String? teamA;
  final String? teamB;
  final List<dynamic>? teamAPlayers;
  final List<dynamic>? teamBPlayers;

  const SeriesModel({
    required this.id,
    required this.title,
    required this.sport,
    required this.slug,
    required this.banner,
    required this.tournamentLogo,
    required this.description,
    required this.teams,
    this.tourCountry,
    this.startDate,
    this.endDate,
    required this.status,
    required this.isFeatured,
    required this.isTrending,
    required this.isHomeScreen,
    required this.isPremium,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.matches,
    required this.totalMatches,
    this.matchScheduledDate,
    this.matchStatus,
    this.teamA,
    this.teamB,
    this.teamAPlayers,
    this.teamBPlayers,
  });

  factory SeriesModel.fromJson(Map<String, dynamic> json) {
    return SeriesModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      sport: json['sport'] ?? '',
      slug: json['slug'] ?? '',
      banner: json['banner'] ?? '',
      tournamentLogo: json['tournamentLogo'] ?? '',
      description: json['description'] ?? '',
      teams: (json['teams'] as List? ?? [])
          .map((e) => TeamModel.fromJson(e))
          .toList(),
      tourCountry: json['tourCountry'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      status: json['status'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isHomeScreen: json['isHomeScreen'] ?? false,
      isPremium: json['isPremium'] ?? false,
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      version: json['__v'] ?? 0,
      matches: json['matches'] != null
          ? (json['matches'] as List)
              .map((e) => SeriesMatchModel.fromJson(e)) // ✅ Updated to SeriesMatchModel
              .toList()
          : null,
      totalMatches: json['totalMatches'] ?? 0,
      matchScheduledDate: json['matchScheduledDate'] != null
          ? DateTime.parse(json['matchScheduledDate'])
          : null,
      matchStatus: json['matchStatus'],
      teamA: json['teamA'],
      teamB: json['teamB'],
      teamAPlayers: json['teamAPlayers'],
      teamBPlayers: json['teamBPlayers'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'sport': sport,
    'slug': slug,
    'banner': banner,
    'tournamentLogo': tournamentLogo,
    'description': description,
    'teams': teams.map((e) => e.toJson()).toList(),
    'tourCountry': tourCountry,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'status': status,
    'isFeatured': isFeatured,
    'isTrending': isTrending,
    'isHomeScreen': isHomeScreen,
    'isPremium': isPremium,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': version,
    'matches': matches?.map((e) => e.toJson()).toList(),
    'totalMatches': totalMatches,
    'matchScheduledDate': matchScheduledDate?.toIso8601String(),
    'matchStatus': matchStatus,
    'teamA': teamA,
    'teamB': teamB,
    'teamAPlayers': teamAPlayers,
    'teamBPlayers': teamBPlayers,
  };

  SeriesModel copyWith({
    String? id,
    String? title,
    String? sport,
    String? slug,
    String? banner,
    String? tournamentLogo,
    String? description,
    List<TeamModel>? teams,
    String? tourCountry,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    bool? isFeatured,
    bool? isTrending,
    bool? isHomeScreen,
    bool? isPremium,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    List<SeriesMatchModel>? matches, // ✅ Updated to SeriesMatchModel
    int? totalMatches,
    DateTime? matchScheduledDate,
    String? matchStatus,
    String? teamA,
    String? teamB,
    List<dynamic>? teamAPlayers,
    List<dynamic>? teamBPlayers,
  }) {
    return SeriesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      slug: slug ?? this.slug,
      banner: banner ?? this.banner,
      tournamentLogo: tournamentLogo ?? this.tournamentLogo,
      description: description ?? this.description,
      teams: teams ?? this.teams,
      tourCountry: tourCountry ?? this.tourCountry,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      isTrending: isTrending ?? this.isTrending,
      isHomeScreen: isHomeScreen ?? this.isHomeScreen,
      isPremium: isPremium ?? this.isPremium,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      matches: matches ?? this.matches,
      totalMatches: totalMatches ?? this.totalMatches,
      matchScheduledDate: matchScheduledDate ?? this.matchScheduledDate,
      matchStatus: matchStatus ?? this.matchStatus,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      teamAPlayers: teamAPlayers ?? this.teamAPlayers,
      teamBPlayers: teamBPlayers ?? this.teamBPlayers,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    sport,
    slug,
    banner,
    tournamentLogo,
    description,
    teams,
    tourCountry,
    startDate,
    endDate,
    status,
    isFeatured,
    isTrending,
    isHomeScreen,
    isPremium,
    createdBy,
    createdAt,
    updatedAt,
    version,
    matches,
    totalMatches,
    matchScheduledDate,
    matchStatus,
    teamA,
    teamB,
    teamAPlayers,
    teamBPlayers,
  ];
}