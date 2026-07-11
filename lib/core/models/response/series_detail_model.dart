import 'package:equatable/equatable.dart';

class SeriesDetailsResponse extends Equatable {
  final bool success;
  final SeriesDetailModel series;
  final List<MatchModel> matches;

  const SeriesDetailsResponse({
    required this.success,
    required this.series,
    required this.matches,
  });

  factory SeriesDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SeriesDetailsResponse(
      success: json["success"] ?? false,
      series: SeriesDetailModel.fromJson(json["series"]),
      matches: (json["matches"] as List<dynamic>)
          .map((e) => MatchModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "series": series.toJson(),
        "matches": matches.map((e) => e.toJson()).toList(),
      };

  SeriesDetailsResponse copyWith({
    bool? success,
    SeriesDetailModel? series,
    List<MatchModel>? matches,
  }) {
    return SeriesDetailsResponse(
      success: success ?? this.success,
      series: series ?? this.series,
      matches: matches ?? this.matches,
    );
  }

  @override
  List<Object?> get props => [success, series, matches];
}

class SeriesDetailModel extends Equatable {
  final String id;
  final String title;
  final String sport;
  final String slug;
  final String banner;
  final String tournamentLogo;
  final String description;
  final List<Team> teams;
  final String tourCountry;
  final String startDate;
  final String endDate;
  final String status;
  final bool isFeatured;
  final bool isTrending;
  final bool isHomeScreen;
  final bool isPremium;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  const SeriesDetailModel({
    required this.id,
    required this.title,
    required this.sport,
    required this.slug,
    required this.banner,
    required this.tournamentLogo,
    required this.description,
    required this.teams,
    required this.tourCountry,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isFeatured,
    required this.isTrending,
    required this.isHomeScreen,
    required this.isPremium,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SeriesDetailModel.fromJson(Map<String, dynamic> json) {
    return SeriesDetailModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      sport: json["sport"] ?? "",
      slug: json["slug"] ?? "",
      banner: json["banner"] ?? "",
      tournamentLogo: json["tournamentLogo"] ?? "",
      description: json["description"] ?? "",
      teams: (json["teams"] as List<dynamic>)
          .map((e) => Team.fromJson(e))
          .toList(),
      tourCountry: json["tourCountry"] ?? "",
      startDate: json["startDate"] ?? "",
      endDate: json["endDate"] ?? "",
      status: json["status"] ?? "",
      isFeatured: json["isFeatured"] ?? false,
      isTrending: json["isTrending"] ?? false,
      isHomeScreen: json["isHomeScreen"] ?? false,
      isPremium: json["isPremium"] ?? false,
      createdBy: json["createdBy"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "sport": sport,
        "slug": slug,
        "banner": banner,
        "tournamentLogo": tournamentLogo,
        "description": description,
        "teams": teams.map((e) => e.toJson()).toList(),
        "tourCountry": tourCountry,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "isFeatured": isFeatured,
        "isTrending": isTrending,
        "isHomeScreen": isHomeScreen,
        "isPremium": isPremium,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  SeriesDetailModel copyWith({
    String? id,
    String? title,
    String? sport,
    String? slug,
    String? banner,
    String? tournamentLogo,
    String? description,
    List<Team>? teams,
    String? tourCountry,
    String? startDate,
    String? endDate,
    String? status,
    bool? isFeatured,
    bool? isTrending,
    bool? isHomeScreen,
    bool? isPremium,
    String? createdBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return SeriesDetailModel(
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
      ];
}

class MatchModel extends Equatable {
  final String id;
  final String title;
  final String sport;
  final String teamA;
  final String teamB;
  final String teamALogo;
  final String teamBLogo;
  final String venue;
  final String matchDate;
  final String status;
  final String thumbnail;
  final String banner;
  final String description;
  final bool isFeatured;
  final bool isTrending;
  final bool isPremium;

  const MatchModel({
    required this.id,
    required this.title,
    required this.sport,
    required this.teamA,
    required this.teamB,
    required this.teamALogo,
    required this.teamBLogo,
    required this.venue,
    required this.matchDate,
    required this.status,
    required this.thumbnail,
    required this.banner,
    required this.description,
    required this.isFeatured,
    required this.isTrending,
    required this.isPremium,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      sport: json["sport"] ?? "",
      teamA: json["teamA"] ?? "",
      teamB: json["teamB"] ?? "",
      teamALogo: json["teamALogo"] ?? "",
      teamBLogo: json["teamBLogo"] ?? "",
      venue: json["venue"] ?? "",
      matchDate: json["matchDate"] ?? "",
      status: json["status"] ?? "",
      thumbnail: json["thumbnail"] ?? "",
      banner: json["banner"] ?? "",
      description: json["description"] ?? "",
      isFeatured: json["isFeatured"] ?? false,
      isTrending: json["isTrending"] ?? false,
      isPremium: json["isPremium"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "sport": sport,
        "teamA": teamA,
        "teamB": teamB,
        "teamALogo": teamALogo,
        "teamBLogo": teamBLogo,
        "venue": venue,
        "matchDate": matchDate,
        "status": status,
        "thumbnail": thumbnail,
        "banner": banner,
        "description": description,
        "isFeatured": isFeatured,
        "isTrending": isTrending,
        "isPremium": isPremium,
      };

  MatchModel copyWith({
    String? id,
    String? title,
    String? sport,
    String? teamA,
    String? teamB,
    String? teamALogo,
    String? teamBLogo,
    String? venue,
    String? matchDate,
    String? status,
    String? thumbnail,
    String? banner,
    String? description,
    bool? isFeatured,
    bool? isTrending,
    bool? isPremium,
  }) {
    return MatchModel(
      id: id ?? this.id,
      title: title ?? this.title,
      sport: sport ?? this.sport,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      teamALogo: teamALogo ?? this.teamALogo,
      teamBLogo: teamBLogo ?? this.teamBLogo,
      venue: venue ?? this.venue,
      matchDate: matchDate ?? this.matchDate,
      status: status ?? this.status,
      thumbnail: thumbnail ?? this.thumbnail,
      banner: banner ?? this.banner,
      description: description ?? this.description,
      isFeatured: isFeatured ?? this.isFeatured,
      isTrending: isTrending ?? this.isTrending,
      isPremium: isPremium ?? this.isPremium,
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
        venue,
        matchDate,
        status,
        thumbnail,
        banner,
        description,
        isFeatured,
        isTrending,
        isPremium,
      ];
}

class Team extends Equatable {
  final String id;
  final String name;
  final String sport;
  final String logo;
  final String shortName;
  final String country;

  const Team({
    required this.id,
    required this.name,
    required this.sport,
    required this.logo,
    required this.shortName,
    required this.country,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      sport: json["sport"] ?? "",
      logo: json["logo"] ?? "",
      shortName: json["shortName"] ?? "",
      country: json["country"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "sport": sport,
        "logo": logo,
        "shortName": shortName,
        "country": country,
      };

  Team copyWith({
    String? id,
    String? name,
    String? sport,
    String? logo,
    String? shortName,
    String? country,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      logo: logo ?? this.logo,
      shortName: shortName ?? this.shortName,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [id, name, sport, logo, shortName, country];
}