import 'package:flutter/foundation.dart';
import '../models/user_profile_model.dart';

class UserProfileController {
  static final UserProfileController _instance = UserProfileController._internal();
  factory UserProfileController() => _instance;

  UserProfileController._internal() {
    _initDefaults();
  }

  final ValueNotifier<UserProfileModel> profile = ValueNotifier<UserProfileModel>(
    const UserProfileModel(
      name: 'Mert Yılmaz',
      email: 'mert.yilmaz@susadim.com',
      profileimage: '',
      level: 12,
      coins: 450,
      weightKg: 78.5,
      heightCm: 182,
    ),
  );

  void _initDefaults() {}

  void updateProfile({String? name, double? weight, double? height}) {
    profile.value = profile.value.copyWith(
      name: name,
      weightKg: weight,
      heightCm: height,
    );
  }

  void addCoins(int amount) {
    profile.value = profile.value.copyWith(
      coins: profile.value.coins + amount,
    );
  }

  void dispose() {
    profile.dispose();
  }
}
