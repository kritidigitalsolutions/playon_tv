import 'package:equatable/equatable.dart';

class ChannelStreamResponse extends Equatable {
  final bool success;
  final String message;
  final StreamData stream;
  final Channel channel;

  const ChannelStreamResponse({
    required this.success,
    required this.message,
    required this.stream,
    required this.channel,
  });

  factory ChannelStreamResponse.fromJson(Map<String, dynamic> json) {
    return ChannelStreamResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      stream: StreamData.fromJson(json['stream'] ?? {}),
      channel: Channel.fromJson(json['channel'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'stream': stream.toJson(),
      'channel': channel.toJson(),
    };
  }

  ChannelStreamResponse copyWith({
    bool? success,
    String? message,
    StreamData? stream,
    Channel? channel,
  }) {
    return ChannelStreamResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      stream: stream ?? this.stream,
      channel: channel ?? this.channel,
    );
  }

  @override
  List<Object?> get props => [
        success,
        message,
        stream,
        channel,
      ];
}

class StreamData extends Equatable {
  final String streamUrl;
  final String backupUrl;
  final String rtmpUrl;
  final String srtUrl;
  final String streamType;

  const StreamData({
    required this.streamUrl,
    required this.backupUrl,
    required this.rtmpUrl,
    required this.srtUrl,
    required this.streamType,
  });

  factory StreamData.fromJson(Map<String, dynamic> json) {
    return StreamData(
      streamUrl: json['streamUrl'] ?? '',
      backupUrl: json['backupUrl'] ?? '',
      rtmpUrl: json['rtmpUrl'] ?? '',
      srtUrl: json['srtUrl'] ?? '',
      streamType: json['streamType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'streamUrl': streamUrl,
      'backupUrl': backupUrl,
      'rtmpUrl': rtmpUrl,
      'srtUrl': srtUrl,
      'streamType': streamType,
    };
  }

  StreamData copyWith({
    String? streamUrl,
    String? backupUrl,
    String? rtmpUrl,
    String? srtUrl,
    String? streamType,
  }) {
    return StreamData(
      streamUrl: streamUrl ?? this.streamUrl,
      backupUrl: backupUrl ?? this.backupUrl,
      rtmpUrl: rtmpUrl ?? this.rtmpUrl,
      srtUrl: srtUrl ?? this.srtUrl,
      streamType: streamType ?? this.streamType,
    );
  }

  @override
  List<Object?> get props => [
        streamUrl,
        backupUrl,
        rtmpUrl,
        srtUrl,
        streamType,
      ];
}

class Channel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String category;
  final String description;
  final String streamUrl;
  final String backupUrl;
  final String rtmpUrl;
  final String srtUrl;
  final String streamType;
  final String quality;
  final String thumbnail;
  final String logo;
  final String status;
  final int viewerCount;
  final bool featured;
  final dynamic createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;
  final int channelNumber;
  final bool isPremium;
  final bool showLiveLogo;
  final String liveLogo;

  const Channel({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.description,
    required this.streamUrl,
    required this.backupUrl,
    required this.rtmpUrl,
    required this.srtUrl,
    required this.streamType,
    required this.quality,
    required this.thumbnail,
    required this.logo,
    required this.status,
    required this.viewerCount,
    required this.featured,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.channelNumber,
    required this.isPremium,
    required this.showLiveLogo,
    required this.liveLogo,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
      backupUrl: json['backupUrl'] ?? '',
      rtmpUrl: json['rtmpUrl'] ?? '',
      srtUrl: json['srtUrl'] ?? '',
      streamType: json['streamType'] ?? '',
      quality: json['quality'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      logo: json['logo'] ?? '',
      status: json['status'] ?? '',
      viewerCount: json['viewerCount'] ?? 0,
      featured: json['featured'] ?? false,
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
      channelNumber: json['channelNumber'] ?? 0,
      isPremium: json['isPremium'] ?? false,
      showLiveLogo: json['showLiveLogo'] ?? false,
      liveLogo: json['liveLogo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'category': category,
      'description': description,
      'streamUrl': streamUrl,
      'backupUrl': backupUrl,
      'rtmpUrl': rtmpUrl,
      'srtUrl': srtUrl,
      'streamType': streamType,
      'quality': quality,
      'thumbnail': thumbnail,
      'logo': logo,
      'status': status,
      'viewerCount': viewerCount,
      'featured': featured,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
      'channelNumber': channelNumber,
      'isPremium': isPremium,
      'showLiveLogo': showLiveLogo,
      'liveLogo': liveLogo,
    };
  }

  Channel copyWith({
    String? id,
    String? name,
    String? slug,
    String? category,
    String? description,
    String? streamUrl,
    String? backupUrl,
    String? rtmpUrl,
    String? srtUrl,
    String? streamType,
    String? quality,
    String? thumbnail,
    String? logo,
    String? status,
    int? viewerCount,
    bool? featured,
    dynamic createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    int? channelNumber,
    bool? isPremium,
    bool? showLiveLogo,
    String? liveLogo,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      description: description ?? this.description,
      streamUrl: streamUrl ?? this.streamUrl,
      backupUrl: backupUrl ?? this.backupUrl,
      rtmpUrl: rtmpUrl ?? this.rtmpUrl,
      srtUrl: srtUrl ?? this.srtUrl,
      streamType: streamType ?? this.streamType,
      quality: quality ?? this.quality,
      thumbnail: thumbnail ?? this.thumbnail,
      logo: logo ?? this.logo,
      status: status ?? this.status,
      viewerCount: viewerCount ?? this.viewerCount,
      featured: featured ?? this.featured,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      channelNumber: channelNumber ?? this.channelNumber,
      isPremium: isPremium ?? this.isPremium,
      showLiveLogo: showLiveLogo ?? this.showLiveLogo,
      liveLogo: liveLogo ?? this.liveLogo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        category,
        description,
        streamUrl,
        backupUrl,
        rtmpUrl,
        srtUrl,
        streamType,
        quality,
        thumbnail,
        logo,
        status,
        viewerCount,
        featured,
        createdBy,
        createdAt,
        updatedAt,
        version,
        channelNumber,
        isPremium,
        showLiveLogo,
        liveLogo,
      ];
}