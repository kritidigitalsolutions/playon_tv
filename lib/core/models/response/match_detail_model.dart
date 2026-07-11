import 'package:equatable/equatable.dart';

class MatchDetailResponse extends Equatable {
  final bool success;
  final MatchModel match;

  const MatchDetailResponse({
    required this.success,
    required this.match,
  });

  factory MatchDetailResponse.fromJson(Map<String, dynamic> json) {
    return MatchDetailResponse(
      success: json['success'] ?? false,
      match: MatchModel.fromJson(json['match'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'match': match.toJson(),
    };
  }

  MatchDetailResponse copyWith({
    bool? success,
    MatchModel? match,
  }) {
    return MatchDetailResponse(
      success: success ?? this.success,
      match: match ?? this.match,
    );
  }

  @override
  List<Object?> get props => [success, match];
}

class MatchModel extends Equatable {
  final String id;
  final String title;
  final String sport;
  final String teamA;
  final String teamB;
  final String teamALogo;
  final String teamBLogo;
  final String tournament;
  final String venue;
  final DateTime? matchDate;
  final String status;
  final String thumbnail;
  final String banner;
  final String liveLogo;
  final bool showLiveLogo;
  final List<dynamic> scoreSources;
  final String seriesId;
  final String description;
  final bool isFeatured;
  final bool isTrending;
  final bool isPremium;
  final DateTime? liveStartedAt;
  final DateTime? liveEndedAt;
  final String highlightlyMatchId;
  final String highlightlySport;
  final dynamic highlightlyStatus;
  final dynamic highlightlyLastSync;
  final dynamic highlightlyData;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;
  final StreamModel stream;

  const MatchModel({
    required this.id,
    required this.title,
    required this.sport,
    required this.teamA,
    required this.teamB,
    required this.teamALogo,
    required this.teamBLogo,
    required this.tournament,
    required this.venue,
    required this.matchDate,
    required this.status,
    required this.thumbnail,
    required this.banner,
    required this.liveLogo,
    required this.showLiveLogo,
    required this.scoreSources,
    required this.seriesId,
    required this.description,
    required this.isFeatured,
    required this.isTrending,
    required this.isPremium,
    required this.liveStartedAt,
    required this.liveEndedAt,
    required this.highlightlyMatchId,
    required this.highlightlySport,
    this.highlightlyStatus,
    this.highlightlyLastSync,
    this.highlightlyData,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.stream,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      sport: json['sport'] ?? '',
      teamA: json['teamA'] ?? '',
      teamB: json['teamB'] ?? '',
      teamALogo: json['teamALogo'] ?? '',
      teamBLogo: json['teamBLogo'] ?? '',
      tournament: json['tournament'] ?? '',
      venue: json['venue'] ?? '',
      matchDate: json['matchDate'] != null
          ? DateTime.tryParse(json['matchDate'])
          : null,
      status: json['status'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      banner: json['banner'] ?? '',
      liveLogo: json['liveLogo'] ?? '',
      showLiveLogo: json['showLiveLogo'] ?? false,
      scoreSources: List<dynamic>.from(json['scoreSources'] ?? []),
      seriesId: json['seriesId'] ?? '',
      description: json['description'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isPremium: json['isPremium'] ?? false,
      liveStartedAt: json['liveStartedAt'] != null
          ? DateTime.tryParse(json['liveStartedAt'])
          : null,
      liveEndedAt: json['liveEndedAt'] != null
          ? DateTime.tryParse(json['liveEndedAt'])
          : null,
      highlightlyMatchId: json['highlightlyMatchId'] ?? '',
      highlightlySport: json['highlightlySport'] ?? '',
      highlightlyStatus: json['highlightlyStatus'],
      highlightlyLastSync: json['highlightlyLastSync'],
      highlightlyData: json['highlightlyData'],
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
      stream: StreamModel.fromJson(json['stream'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'sport': sport,
      'teamA': teamA,
      'teamB': teamB,
      'teamALogo': teamALogo,
      'teamBLogo': teamBLogo,
      'tournament': tournament,
      'venue': venue,
      'matchDate': matchDate?.toIso8601String(),
      'status': status,
      'thumbnail': thumbnail,
      'banner': banner,
      'liveLogo': liveLogo,
      'showLiveLogo': showLiveLogo,
      'scoreSources': scoreSources,
      'seriesId': seriesId,
      'description': description,
      'isFeatured': isFeatured,
      'isTrending': isTrending,
      'isPremium': isPremium,
      'liveStartedAt': liveStartedAt?.toIso8601String(),
      'liveEndedAt': liveEndedAt?.toIso8601String(),
      'highlightlyMatchId': highlightlyMatchId,
      'highlightlySport': highlightlySport,
      'highlightlyStatus': highlightlyStatus,
      'highlightlyLastSync': highlightlyLastSync,
      'highlightlyData': highlightlyData,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
      'stream': stream.toJson(),
    };
  }

  MatchModel copyWith({
    String? id,
    String? title,
    String? sport,
    String? teamA,
    String? teamB,
    String? teamALogo,
    String? teamBLogo,
    String? tournament,
    String? venue,
    DateTime? matchDate,
    String? status,
    String? thumbnail,
    String? banner,
    String? liveLogo,
    bool? showLiveLogo,
    List<dynamic>? scoreSources,
    String? seriesId,
    String? description,
    bool? isFeatured,
    bool? isTrending,
    bool? isPremium,
    DateTime? liveStartedAt,
    DateTime? liveEndedAt,
    String? highlightlyMatchId,
    String? highlightlySport,
    dynamic highlightlyStatus,
    dynamic highlightlyLastSync,
    dynamic highlightlyData,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    StreamModel? stream,
  }) {
    return MatchModel(
      id: id ?? this.id,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      teamALogo: teamALogo ?? this.teamALogo,
      teamBLogo: teamBLogo ?? this.teamBLogo,
      tournament: tournament ?? this.tournament,
      venue: venue ?? this.venue,
      matchDate: matchDate ?? this.matchDate,
      status: status ?? this.status,
      thumbnail: thumbnail ?? this.thumbnail,
      banner: banner ?? this.banner,
      liveLogo: liveLogo ?? this.liveLogo,
      showLiveLogo: showLiveLogo ?? this.showLiveLogo,
      scoreSources: scoreSources ?? this.scoreSources,
      seriesId: seriesId ?? this.seriesId,
      description: description ?? this.description,
      isFeatured: isFeatured ?? this.isFeatured,
      isTrending: isTrending ?? this.isTrending,
      isPremium: isPremium ?? this.isPremium,
      liveStartedAt: liveStartedAt ?? this.liveStartedAt,
      liveEndedAt: liveEndedAt ?? this.liveEndedAt,
      highlightlyMatchId: highlightlyMatchId ?? this.highlightlyMatchId,
      highlightlySport: highlightlySport ?? this.highlightlySport,
      highlightlyStatus: highlightlyStatus ?? this.highlightlyStatus,
      highlightlyLastSync: highlightlyLastSync ?? this.highlightlyLastSync,
      highlightlyData: highlightlyData ?? this.highlightlyData,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      stream: stream ?? this.stream,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        sport,
        teamA,
        teamB,
        teamALogo,
        teamBLogo,
        tournament,
        venue,
        matchDate,
        status,
        thumbnail,
        banner,
        liveLogo,
        showLiveLogo,
        scoreSources,
        seriesId,
        description,
        isFeatured,
        isTrending,
        isPremium,
        liveStartedAt,
        liveEndedAt,
        highlightlyMatchId,
        highlightlySport,
        highlightlyStatus,
        highlightlyLastSync,
        highlightlyData,
        createdBy,
        createdAt,
        updatedAt,
        version,
        stream,
      ];
}

class StreamModel extends Equatable {
  final String id;
  final String title;
  final String provider;
  final String streamUrl;
  final String backupUrl;
  final String streamType;
  final String quality;
  final String status;
  final int viewerCount;
  final String health;
  final bool isPremium;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;

  const StreamModel({
    required this.id,
    required this.title,
    required this.provider,
    required this.streamUrl,
    required this.backupUrl,
    required this.streamType,
    required this.quality,
    required this.status,
    required this.viewerCount,
    required this.health,
    required this.isPremium,
    required this.scheduledAt,
    required this.startedAt,
    required this.endedAt,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      provider: json['provider'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      backupUrl: json['backupUrl'] ?? '',
      streamType: json['streamType'] ?? '',
      quality: json['quality'] ?? '',
      status: json['status'] ?? '',
      viewerCount: json['viewerCount'] ?? 0,
      health: json['health'] ?? '',
      isPremium: json['isPremium'] ?? false,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.tryParse(json['scheduledAt'])
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'])
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.tryParse(json['endedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'provider': provider,
      'streamUrl': streamUrl,
      'backupUrl': backupUrl,
      'streamType': streamType,
      'quality': quality,
      'status': status,
      'viewerCount': viewerCount,
      'health': health,
      'isPremium': isPremium,
      'scheduledAt': scheduledAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
    };
  }

  StreamModel copyWith({
    String? id,
    String? title,
    String? provider,
    String? streamUrl,
    String? backupUrl,
    String? streamType,
    String? quality,
    String? status,
    int? viewerCount,
    String? health,
    bool? isPremium,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return StreamModel(
      id: id ?? this.id,
      title: title ?? this.title,
      provider: provider ?? this.provider,
      streamUrl: streamUrl ?? this.streamUrl,
      backupUrl: backupUrl ?? this.backupUrl,
      streamType: streamType ?? this.streamType,
      quality: quality ?? this.quality,
      status: status ?? this.status,
      viewerCount: viewerCount ?? this.viewerCount,
      health: health ?? this.health,
      isPremium: isPremium ?? this.isPremium,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        provider,
        streamUrl,
        backupUrl,
        streamType,
        quality,
        status,
        viewerCount,
        health,
        isPremium,
        scheduledAt,
        startedAt,
        endedAt,
      ];
}