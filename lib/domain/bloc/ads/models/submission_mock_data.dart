// TODO(api): Replace mock submissions with real backend API call
import 'package:solofy_vendor_app/domain/bloc/ads/models/interest_round.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user_mock.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission_status.dart';

final List<Submission> initialMockSubmissions = [
  // 1. Pending Approval (Screenshot 1)
  const Submission(
    id: 'sub_1',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 0,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 0,
    status: SubmissionStatus.pendingApproval,
    category: 'Property',
    plan: 'Featured',
    contactNumber: '8606449640',
  ),

  // 2. Active with 0 interested (Screenshot 2)
  const Submission(
    id: 'sub_2',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 200,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 0,
    status: SubmissionStatus.active,
    category: 'Property',
    plan: 'Regular',
    contactNumber: '8606449640',
  ),

  // 3. Active with 20 interested (Screenshot 5)
  const Submission(
    id: 'sub_3',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 200,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 20,
    status: SubmissionStatus.active,
    category: 'Property',
    plan: 'Regular',
    contactNumber: '8606449640',
  ),

  // 4. Expiring Soon
  const Submission(
    id: 'sub_4',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 200,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s.',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 20,
    status: SubmissionStatus.expiringSoon,
    category: 'Property',
    plan: 'Urgent',
    contactNumber: '8606449640',
  ),

  // 5. Expired (Screenshot 2 in latest prompt)
  const Submission(
    id: 'sub_5',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 200,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 20,
    status: SubmissionStatus.expired,
    category: 'Property',
    plan: 'Regular',
    contactNumber: '8606449640',
  ),

  // 6. Stopped (Figma Screenshot 3)
  Submission(
    id: 'sub_stopped',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 200,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 0,
    status: SubmissionStatus.stopped,
    category: 'Property',
    plan: 'Regular',
    contactNumber: '8606449640',
    stoppedAt: DateTime(2025, 7, 26, 16, 0),
    stoppedAtFormatted: '26 Jul 2025 | 04:00 PM',
  ),

  // 7. Rejected (Figma Screenshot 4)
  const Submission(
    id: 'sub_rejected',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 0,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 0,
    status: SubmissionStatus.rejected,
    category: 'Property',
    plan: 'Regular',
    contactNumber: '8606449640',
    rejectionReason:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s.',
  ),

  // 8. Re-Posted Active (Figma Screenshots 1 + 2)
  Submission(
    id: 'sub_reposted',
    adRef: '0123456789',
    title: 'Property For Rent',
    postedAt: '22 Jul 2025',
    viewCount: 200,
    description:
        'Lorem Ipsum Is Simply Dummy Text Of The Printing And Typesetting Industry. Lorem Ipsum Has Been The Industry\'s Standard Dummy Text Ever Since The 1500s, When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type When An Unknown Printer Took A Galley Of Type And Scrambled It To Make A Type Specimen Book. Scrambled It To Make A Type',
    locationLabel: 'Pincode, Palazhi , Calicut',
    interestedCount: 20,
    status: SubmissionStatus.active,
    category: 'Property',
    plan: 'Regular',
    contactNumber: '8606449640',
    rePostedAt: DateTime(2025, 7, 30, 16, 0),
    rePostedAtFormatted: '30 Jul 2025 | 04:00 PM',
    rounds: [
      InterestRound(
        number: 1,
        contacts: List.from(initialMockInterestedUsers.take(10)),
      ),
      InterestRound(
        number: 2,
        contacts: List.from(initialMockInterestedUsers.skip(10).take(10)),
      ),
    ],
  ),
];

class SubmissionStore {
  SubmissionStore._();
  static final SubmissionStore instance = SubmissionStore._();

  List<Submission> _submissions = List.from(initialMockSubmissions);

  List<Submission> get submissions => List.unmodifiable(_submissions);

  void deleteSubmission(String id) {
    _submissions = _submissions.where((s) => s.id != id).toList();
  }

  void reset() {
    _submissions = List.from(initialMockSubmissions);
  }
}

List<Submission> get mockSubmissions => SubmissionStore.instance.submissions;
