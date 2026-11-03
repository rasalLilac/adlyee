import 'package:equatable/equatable.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/owner_mark.dart';

class InterestedUser extends Equatable {
  const InterestedUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
    this.onWhatsApp = true,
    this.canCall = true,
    this.mark,
  });

  final String id;
  final String name;
  final String phone;
  final String avatarUrl;
  final bool onWhatsApp;
  final bool canCall;
  final OwnerMark? mark;

  InterestedUser copyWith({
    String? id,
    String? name,
    String? phone,
    String? avatarUrl,
    bool? onWhatsApp,
    bool? canCall,
    OwnerMark? Function()? mark,
  }) {
    return InterestedUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      onWhatsApp: onWhatsApp ?? this.onWhatsApp,
      canCall: canCall ?? this.canCall,
      mark: mark != null ? mark() : this.mark,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, avatarUrl, onWhatsApp, canCall, mark];
}
