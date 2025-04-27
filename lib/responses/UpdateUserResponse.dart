import 'package:my_app/models/User.dart';

class UpdateUserResponse {
  // final bool status;
  final User user;
  // final String token;

  UpdateUserResponse({
    // required this.status,
    required this.user,
    // required this.token,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      user: User.fromJson(json['data']),
    );
  }
}
