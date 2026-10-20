import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:susadim/features/user_profile/models/user_profile_model.dart';

class UserProfileNotifier extends Notifier<UserProfileModel> {
  @override
  UserProfileModel build() {
    return const UserProfileModel(
      name: 'Mert Yılmaz',
      email: 'mert.yilmaz@example.com',
      weightKg: 78.5,
      heightCm: 182,
      age: 26,
      gender: 'Erkek',
      activityLevel: 'Aktif (Haftada 3-5 gün)',
    );
  }

  void updateProfile({
    String? name,
    double? weightKg,
    double? heightCm,
    int? age,
    String? activityLevel,
  }) {
    state = state.copyWith(
      name: name,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      activityLevel: activityLevel,
    );
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfileModel>(UserProfileNotifier.new);
