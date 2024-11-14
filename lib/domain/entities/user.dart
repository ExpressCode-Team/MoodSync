import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    int? id,
    String? name,
    String? email,
  }) = _User;

  // Untuk mendukung JSON serialization
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
