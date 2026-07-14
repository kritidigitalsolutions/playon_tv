import 'package:equatable/equatable.dart';

class ChannelResponse extends Equatable {
  final bool success;
  final int count;
  final List<ChannelModel> channels;

  const ChannelResponse({
    required this.success,
    required this.count,
    required this.channels,
  });

  factory ChannelResponse.fromJson(Map<String, dynamic> json) {
    return ChannelResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      channels: (json['channels'] as List<dynamic>? ?? [])
          .map((e) => ChannelModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'channels': channels.map((e) => e.toJson()).toList(),
    };
  }

  ChannelResponse copyWith({
    bool? success,
    int? count,
    List<ChannelModel>? channels,
  }) {
    return ChannelResponse(
      success: success ?? this.success,
      count: count ?? this.count,
      channels: channels ?? this.channels,
    );
  }

  @override
  List<Object?> get props => [success, count, channels];
}

class ChannelModel extends Equatable {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final bool isPremium;
  final int channelNumber;
  final String liveLogo;
  final bool showLiveLogo;

  const ChannelModel({
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
    required this.v,
    required this.isPremium,
    required this.channelNumber,
    required this.liveLogo,
    required this.showLiveLogo,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
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
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      isPremium: json['isPremium'] ?? false,
      channelNumber: json['channelNumber'] ?? 0,
      liveLogo: json['liveLogo'] ?? '',
      showLiveLogo: json['showLiveLogo'] ?? false,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'isPremium': isPremium,
      'channelNumber': channelNumber,
      'liveLogo': liveLogo,
      'showLiveLogo': showLiveLogo,
    };
  }

  ChannelModel copyWith({
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
    int? v,
    bool? isPremium,
    int? channelNumber,
    String? liveLogo,
    bool? showLiveLogo,
  }) {
    return ChannelModel(
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
      v: v ?? this.v,
      isPremium: isPremium ?? this.isPremium,
      channelNumber: channelNumber ?? this.channelNumber,
      liveLogo: liveLogo ?? this.liveLogo,
      showLiveLogo: showLiveLogo ?? this.showLiveLogo,
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
    v,
    isPremium,
    channelNumber,
    liveLogo,
    showLiveLogo,
  ];
}
