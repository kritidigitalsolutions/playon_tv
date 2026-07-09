import 'package:equatable/equatable.dart';

class TvLoginResponse extends Equatable{
  final bool success;
  final String message;
  final String token;
  final TvUser user;

  const TvLoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory TvLoginResponse.fromJson(Map<String, dynamic> json) {
    return TvLoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: TvUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'user': user.toJson(),
    };
  }

  TvLoginResponse copyWith({
    bool? success,
    String? message,
    String? token,
    TvUser? user,
  }) {
    return TvLoginResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [success, message, token, user];
}

class TvUser extends Equatable{
  final String id;
  final String fullName;
  final String? mobile;
  final String email;
  final String profilePic;

  const TvUser({
    required this.id,
    required this.fullName,
    this.mobile,
    required this.email,
    required this.profilePic,
  });

  factory TvUser.fromJson(Map<String, dynamic> json) {
    return TvUser(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      mobile: json['mobile'],
      email: json['email'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'mobile': mobile,
      'email': email,
      'profilePic': profilePic,
    };
  }

  TvUser copyWith({
    String? id,
    String? fullName,
    String? mobile,
    String? email,
    String? profilePic,
  }) {
    return TvUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [id, fullName, mobile, email, profilePic];
}