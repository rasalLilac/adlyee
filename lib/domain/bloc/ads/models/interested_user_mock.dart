import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/owner_mark.dart';

// TODO(api): Replace mock interested users with backend API call
final List<InterestedUser> initialMockInterestedUsers = [
  const InterestedUser(
    id: 'user_1',
    name: 'Wade Warren',
    phone: '+91 8606449640',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
    onWhatsApp: true,
    canCall: true,
    mark: OwnerMark.definitelySuitable,
  ),
  const InterestedUser(
    id: 'user_2',
    name: 'Cameron Williamson',
    phone: '+91 8978675634',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    onWhatsApp: true,
    canCall: true,
    mark: OwnerMark.definitelySuitable,
  ),
  const InterestedUser(
    id: 'user_3',
    name: 'Jenny Wilson',
    phone: '+91 8606449640',
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
    onWhatsApp: true,
    canCall: true,
    mark: OwnerMark.tentativelySuitable,
  ),
  const InterestedUser(
    id: 'user_4',
    name: 'Guy Hawkins',
    phone: '+91 9876543255',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    onWhatsApp: false,
    canCall: true,
    mark: OwnerMark.tentativelySuitable,
  ),
  const InterestedUser(
    id: 'user_5',
    name: 'Wade Warren',
    phone: '+91 8606449640',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
    onWhatsApp: false,
    canCall: true,
    mark: OwnerMark.notSuitable,
  ),
  const InterestedUser(
    id: 'user_6',
    name: 'Cameron Williamson',
    phone: '+91 8978675634',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    onWhatsApp: false,
    canCall: true,
    mark: OwnerMark.notSuitable,
  ),
  const InterestedUser(
    id: 'user_7',
    name: 'Jenny Wilson',
    phone: '+91 8606449640',
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
    onWhatsApp: false,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_8',
    name: 'Guy Hawkins',
    phone: '+91 9876543255',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    onWhatsApp: true,
    canCall: false,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_9',
    name: 'Wade Warren',
    phone: '+91 8606449640',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
    onWhatsApp: true,
    canCall: false,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_10',
    name: 'Cameron Williamson',
    phone: '+91 8978675634',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    onWhatsApp: true,
    canCall: false,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_11',
    name: 'Brooklyn Simmons',
    phone: '+91 9845123456',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    onWhatsApp: true,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_12',
    name: 'Leslie Alexander',
    phone: '+91 9123456789',
    avatarUrl: 'https://i.pravatar.cc/150?img=2',
    onWhatsApp: true,
    canCall: false,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_13',
    name: 'Ronald Richards',
    phone: '+91 9876501234',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    onWhatsApp: false,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_14',
    name: 'Kristin Watson',
    phone: '+91 9988776655',
    avatarUrl: 'https://i.pravatar.cc/150?img=4',
    onWhatsApp: true,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_15',
    name: 'Eleanor Pena',
    phone: '+91 9811223344',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    onWhatsApp: false,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_16',
    name: 'Cody Fisher',
    phone: '+91 9722334455',
    avatarUrl: 'https://i.pravatar.cc/150?img=6',
    onWhatsApp: true,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_17',
    name: 'Robert Fox',
    phone: '+91 9633445566',
    avatarUrl: 'https://i.pravatar.cc/150?img=7',
    onWhatsApp: true,
    canCall: false,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_18',
    name: 'Esther Howard',
    phone: '+91 9544556677',
    avatarUrl: 'https://i.pravatar.cc/150?img=10',
    onWhatsApp: true,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_19',
    name: 'Jerome Bell',
    phone: '+91 9455667788',
    avatarUrl: 'https://i.pravatar.cc/150?img=13',
    onWhatsApp: false,
    canCall: true,
    mark: null,
  ),
  const InterestedUser(
    id: 'user_20',
    name: 'Darrell Steward',
    phone: '+91 9366778899',
    avatarUrl: 'https://i.pravatar.cc/150?img=14',
    onWhatsApp: true,
    canCall: true,
    mark: null,
  ),
];

// In-memory store so changes to marks reflect across screens in real-time
class InterestedContactsStore {
  InterestedContactsStore._();
  static final InterestedContactsStore instance = InterestedContactsStore._();

  List<InterestedUser> _contacts = List.from(initialMockInterestedUsers);

  List<InterestedUser> get contacts => List.unmodifiable(_contacts);

  void setMark(String userId, OwnerMark? mark) {
    _contacts = _contacts.map((u) {
      if (u.id == userId) {
        return u.copyWith(mark: () => mark);
      }
      return u;
    }).toList();
  }

  void reset() {
    _contacts = List.from(initialMockInterestedUsers);
  }
}

// Backwards-compatibility alias
List<InterestedUser> get mockInterestedUsers => InterestedContactsStore.instance.contacts;
