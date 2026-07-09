import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? mobile;
  final String fullName;
  final String? googleId;
  final String? facebookId;
  final String authProvider;
  final String email;
  final bool isProfileComplete;
  final bool onboardingCompleted;
  final List<String> favoriteSports;
  final String? fcmToken;
  final String? profilePic;
  final bool isDeleted;
  final String? deletedAt;
  final String deleteReason;
  final String accountStatus;
  final List<String> followedPlayers;
  final List<String> followedSeries;
  final bool adsDisabled;
  final String? adsExpiry;
  final String adFreePurchaseType;
  final String? referralCode;
  final String? referredBy;
  final int referralCount;
  final bool hasCompletedReferralReward;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  const UserModel({
    required this.id,
    this.mobile,
    required this.fullName,
    this.googleId,
    this.facebookId,
    required this.authProvider,
    required this.email,
    required this.isProfileComplete,
    required this.onboardingCompleted,
    required this.favoriteSports,
    this.fcmToken,
    this.profilePic,
    required this.isDeleted,
    this.deletedAt,
    required this.deleteReason,
    required this.accountStatus,
    required this.followedPlayers,
    required this.followedSeries,
    required this.adsDisabled,
    this.adsExpiry,
    required this.adFreePurchaseType,
    this.referralCode,
    this.referredBy,
    required this.referralCount,
    required this.hasCompletedReferralReward,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    required this.version,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      mobile: json['mobile'],
      fullName: json['fullName'] ?? '',
      googleId: json['googleId'],
      facebookId: json['facebookId'],
      authProvider: json['authProvider'] ?? '',
      email: json['email'] ?? '',
      isProfileComplete: json['isProfileComplete'] ?? false,
      onboardingCompleted: json['onboardingCompleted'] ?? false,
      favoriteSports: List<String>.from(json['favoriteSports'] ?? []),
      fcmToken: json['fcmToken'],
      profilePic: json['profilePic'],
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      deleteReason: json['deleteReason'] ?? '',
      accountStatus: json['accountStatus'] ?? '',
      followedPlayers: List<String>.from(json['followedPlayers'] ?? []),
      followedSeries: List<String>.from(json['followedSeries'] ?? []),
      adsDisabled: json['adsDisabled'] ?? false,
      adsExpiry: json['adsExpiry'],
      adFreePurchaseType: json['adFreePurchaseType'] ?? '',
      referralCode: json['referralCode'],
      referredBy: json['referredBy'],
      referralCount: json['referralCount'] ?? 0,
      hasCompletedReferralReward:
          json['hasCompletedReferralReward'] ?? false,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mobile': mobile,
      'fullName': fullName,
      'googleId': googleId,
      'facebookId': facebookId,
      'authProvider': authProvider,
      'email': email,
      'isProfileComplete': isProfileComplete,
      'onboardingCompleted': onboardingCompleted,
      'favoriteSports': favoriteSports,
      'fcmToken': fcmToken,
      'profilePic': profilePic,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
      'deleteReason': deleteReason,
      'accountStatus': accountStatus,
      'followedPlayers': followedPlayers,
      'followedSeries': followedSeries,
      'adsDisabled': adsDisabled,
      'adsExpiry': adsExpiry,
      'adFreePurchaseType': adFreePurchaseType,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'referralCount': referralCount,
      'hasCompletedReferralReward': hasCompletedReferralReward,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }

  UserModel copyWith({
    String? id,
    String? mobile,
    String? fullName,
    String? googleId,
    String? facebookId,
    String? authProvider,
    String? email,
    bool? isProfileComplete,
    bool? onboardingCompleted,
    List<String>? favoriteSports,
    String? fcmToken,
    String? profilePic,
    bool? isDeleted,
    String? deletedAt,
    String? deleteReason,
    String? accountStatus,
    List<String>? followedPlayers,
    List<String>? followedSeries,
    bool? adsDisabled,
    String? adsExpiry,
    String? adFreePurchaseType,
    String? referralCode,
    String? referredBy,
    int? referralCount,
    bool? hasCompletedReferralReward,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return UserModel(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      fullName: fullName ?? this.fullName,
      googleId: googleId ?? this.googleId,
      facebookId: facebookId ?? this.facebookId,
      authProvider: authProvider ?? this.authProvider,
      email: email ?? this.email,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      onboardingCompleted:
          onboardingCompleted ?? this.onboardingCompleted,
      favoriteSports: favoriteSports ?? this.favoriteSports,
      fcmToken: fcmToken ?? this.fcmToken,
      profilePic: profilePic ?? this.profilePic,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      deleteReason: deleteReason ?? this.deleteReason,
      accountStatus: accountStatus ?? this.accountStatus,
      followedPlayers: followedPlayers ?? this.followedPlayers,
      followedSeries: followedSeries ?? this.followedSeries,
      adsDisabled: adsDisabled ?? this.adsDisabled,
      adsExpiry: adsExpiry ?? this.adsExpiry,
      adFreePurchaseType:
          adFreePurchaseType ?? this.adFreePurchaseType,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      referralCount: referralCount ?? this.referralCount,
      hasCompletedReferralReward:
          hasCompletedReferralReward ??
              this.hasCompletedReferralReward,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        mobile,
        fullName,
        googleId,
        facebookId,
        authProvider,
        email,
        isProfileComplete,
        onboardingCompleted,
        favoriteSports,
        fcmToken,
        profilePic,
        isDeleted,
        deletedAt,
        deleteReason,
        accountStatus,
        followedPlayers,
        followedSeries,
        adsDisabled,
        adsExpiry,
        adFreePurchaseType,
        referralCode,
        referredBy,
        referralCount,
        hasCompletedReferralReward,
        lastLoginAt,
        createdAt,
        updatedAt,
        version,
      ];
}