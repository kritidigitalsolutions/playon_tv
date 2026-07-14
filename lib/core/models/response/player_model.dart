import 'package:equatable/equatable.dart';

class PlayerResponse extends Equatable {
  final bool success;
  final int count;
  final List<PlayerModel> players;

  const PlayerResponse({
    required this.success,
    required this.count,
    required this.players,
  });

  factory PlayerResponse.fromJson(Map<String, dynamic> json) {
    return PlayerResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      players: (json['players'] as List<dynamic>? ?? [])
          .map((e) => PlayerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'players': players.map((e) => e.toJson()).toList(),
    };
  }

  PlayerResponse copyWith({
    bool? success,
    int? count,
    List<PlayerModel>? players,
  }) {
    return PlayerResponse(
      success: success ?? this.success,
      count: count ?? this.count,
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [success, count, players];
}

class PlayerModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String sport;
  final String team;
  final String position;
  final String country;
  final String image;
  final String bio;
  final bool featured;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.sport,
    required this.team,
    required this.position,
    required this.country,
    required this.image,
    required this.bio,
    required this.featured,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      sport: json['sport'] ?? '',
      team: json['team'] ?? '',
      position: json['position'] ?? '',
      country: json['country'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
      featured: json['featured'] ?? false,
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'sport': sport,
      'team': team,
      'position': position,
      'country': country,
      'image': image,
      'bio': bio,
      'featured': featured,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  PlayerModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? sport,
    String? team,
    String? position,
    String? country,
    String? image,
    String? bio,
    bool? featured,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      sport: sport ?? this.sport,
      team: team ?? this.team,
      position: position ?? this.position,
      country: country ?? this.country,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      featured: featured ?? this.featured,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    sport,
    team,
    position,
    country,
    image,
    bio,
    featured,
    status,
    createdAt,
    updatedAt,
    version,
  ];
}
