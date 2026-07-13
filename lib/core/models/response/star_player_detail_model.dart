import 'package:equatable/equatable.dart';

class StarPlayerDetailResponse extends Equatable {
  final bool success;
  final StarPlayerDetailModel highlight;

  const StarPlayerDetailResponse({
    required this.success,
    required this.highlight,
  });

  factory StarPlayerDetailResponse.fromJson(Map<String, dynamic> json) {
    return StarPlayerDetailResponse(
      success: json['success'] ?? false,
      highlight: StarPlayerDetailModel.fromJson(json['highlight']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'highlight': highlight.toJson(),
    };
  }

  StarPlayerDetailResponse copyWith({
    bool? success,
    StarPlayerDetailModel? highlight,
  }) {
    return StarPlayerDetailResponse(
      success: success ?? this.success,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  List<Object?> get props => [success, highlight];
}

class StarPlayerDetailModel extends Equatable {
  final String id;
  final SportModel sport;
  final PlayerModel player;
  final String playerName;
  final String team;
  final String title;
  final String thumbnail;
  final String videoUrl;
  final String type;
  final String duration;
  final bool isFeatured;
  final bool isPremium;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> sources;
  final String liveLogo;
  final bool showLiveLogo;

  const StarPlayerDetailModel({
    required this.id,
    required this.sport,
    required this.player,
    required this.playerName,
    required this.team,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.type,
    required this.duration,
    required this.isFeatured,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
    required this.sources,
    required this.liveLogo,
    required this.showLiveLogo,
  });

  factory StarPlayerDetailModel.fromJson(Map<String, dynamic> json) {
    return StarPlayerDetailModel(
      id: json['_id'] ?? '',
      sport: SportModel.fromJson(json['sportId'] ?? {}),
      player: PlayerModel.fromJson(json['playerId'] ?? {}),
      playerName: json['playerName'] ?? '',
      team: json['team'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      type: json['type'] ?? '',
      duration: json['duration'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      isPremium: json['isPremium'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      sources: json['sources'] ?? [],
      liveLogo: json['liveLogo'] ?? '',
      showLiveLogo: json['showLiveLogo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sportId': sport.toJson(),
      'playerId': player.toJson(),
      'playerName': playerName,
      'team': team,
      'title': title,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'type': type,
      'duration': duration,
      'isFeatured': isFeatured,
      'isPremium': isPremium,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'sources': sources,
      'liveLogo': liveLogo,
      'showLiveLogo': showLiveLogo,
    };
  }

  StarPlayerDetailModel copyWith({
    String? id,
    SportModel? sport,
    PlayerModel? player,
    String? playerName,
    String? team,
    String? title,
    String? thumbnail,
    String? videoUrl,
    String? type,
    String? duration,
    bool? isFeatured,
    bool? isPremium,
    String? createdAt,
    String? updatedAt,
    List<dynamic>? sources,
    String? liveLogo,
    bool? showLiveLogo,
  }) {
    return StarPlayerDetailModel(
      id: id ?? this.id,
      sport: sport ?? this.sport,
      player: player ?? this.player,
      playerName: playerName ?? this.playerName,
      team: team ?? this.team,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      videoUrl: videoUrl ?? this.videoUrl,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      isFeatured: isFeatured ?? this.isFeatured,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sources: sources ?? this.sources,
      liveLogo: liveLogo ?? this.liveLogo,
      showLiveLogo: showLiveLogo ?? this.showLiveLogo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sport,
        player,
        playerName,
        team,
        title,
        thumbnail,
        videoUrl,
        type,
        duration,
        isFeatured,
        isPremium,
        createdAt,
        updatedAt,
        sources,
        liveLogo,
        showLiveLogo,
      ];
}

class SportModel extends Equatable {
  final String id;
  final String name;
  final String slug;

  const SportModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory SportModel.fromJson(Map<String, dynamic> json) {
    return SportModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
    };
  }

  SportModel copyWith({
    String? id,
    String? name,
    String? slug,
  }) {
    return SportModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
    );
  }

  @override
  List<Object?> get props => [id, name, slug];
}

class PlayerModel extends Equatable {
  final String id;
  final String name;
  final String team;
  final String country;
  final String image;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.team,
    required this.country,
    required this.image,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      team: json['team'] ?? '',
      country: json['country'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'team': team,
      'country': country,
      'image': image,
    };
  }

  PlayerModel copyWith({
    String? id,
    String? name,
    String? team,
    String? country,
    String? image,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      team: team ?? this.team,
      country: country ?? this.country,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        team,
        country,
        image,
      ];
}