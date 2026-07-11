import 'package:equatable/equatable.dart';

class TeamModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String sport;
  final String logo;
  final String shortName;
  final String? country;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  const TeamModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.sport,
    required this.logo,
    required this.shortName,
    this.country,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    required this.version,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      sport: json['sport'] ?? '',
      logo: json['logo'] ?? '',
      shortName: json['shortName'] ?? '',
      country: json['country'],
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'slug': slug,
    'sport': sport,
    'logo': logo,
    'shortName': shortName,
    'country': country,
    'isActive': isActive,
    'sortOrder': sortOrder,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': version,
  };

  TeamModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? sport,
    String? logo,
    String? shortName,
    String? country,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      sport: sport ?? this.sport,
      logo: logo ?? this.logo,
      shortName: shortName ?? this.shortName,
      country: country ?? this.country,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
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
    logo,
    shortName,
    country,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
    version,
  ];
}