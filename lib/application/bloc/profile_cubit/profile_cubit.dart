import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solofy_vendor_app/application/bloc/profile_cubit/user_profile.dart';

class ProfileCubit extends Cubit<UserProfile> {
  ProfileCubit({UserProfile? initialProfile})
      : super(
          initialProfile ??
              const UserProfile(
                name: 'Cameron Williamson',
                userId: '654321',
                phone: '8606449640',
                email: 'cameron@gmail.com',
                avatarUrl: null,
              ),
        ) {
    _instance = this;
  }

  static ProfileCubit? _instance;
  static ProfileCubit get instance => _instance ??= ProfileCubit();
  static set instance(ProfileCubit cubit) => _instance = cubit;

  void updateProfile({
    String? name,
    String? phone,
    String? email,
    String? avatarUrl,
  }) {
    emit(
      state.copyWith(
        name: name,
        phone: phone,
        email: email,
        avatarUrl: avatarUrl,
      ),
    );
  }
}

