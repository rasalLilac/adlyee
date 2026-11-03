import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solofy_vendor_app/application/bloc/interested_contacts_cubit/interested_contacts_cubit.dart';
import 'package:solofy_vendor_app/application/bloc/interested_contacts_cubit/interested_contacts_state.dart';
import 'package:solofy_vendor_app/application/core/route/app_route.dart';
import 'package:solofy_vendor_app/application/core/theme/colors.dart';
import 'package:solofy_vendor_app/application/core/theme/scale.dart';
import 'package:solofy_vendor_app/application/core/utils/string_file.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/interested_user.dart';
import 'package:solofy_vendor_app/domain/bloc/ads/models/submission.dart';
import 'package:solofy_vendor_app/presentation/widgets/ad_status_chip.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_header_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_page_scaffold.dart';
import 'package:solofy_vendor_app/presentation/widgets/app_search_bar.dart';
import 'package:solofy_vendor_app/presentation/widgets/interested_contact_row.dart';

class InterestedContactsScreen extends StatefulWidget {
  const InterestedContactsScreen({
    super.key,
    required this.ad,
    this.roundNumber,
  });

  final Submission ad;
  final int? roundNumber;

  static const routeName = 'interested-contacts';

  @override
  State<InterestedContactsScreen> createState() => _InterestedContactsScreenState();
}

class _InterestedContactsScreenState extends State<InterestedContactsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InterestedUser>? _resolveInitialContacts() {
    if (widget.roundNumber != null && widget.ad.rounds.isNotEmpty) {
      final round = widget.ad.rounds.firstWhere(
        (r) => r.number == widget.roundNumber,
        orElse: () => widget.ad.rounds.first,
      );
      return round.contacts;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    final initialContacts = _resolveInitialContacts();

    return BlocProvider(
      create: (_) => InterestedContactsCubit(initialContacts: initialContacts),
      child: AppPageScaffold(
        scrollable: false,
        child: Builder(
          builder: (context) {
                final cubit = context.read<InterestedContactsCubit>();

                return Column(
                  children: [
                    // Pinned Header Section
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.s, 12.s, 16.s, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppHeaderBar(
                            title: StringFile.interestedContacts,
                            onBack: () => AppRoute.pop(),
                          ),
                          SizedBox(height: 16.s),

                          // Row: Ad Ref left + StatusChip right (shows ad's real status)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text.rich(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    text: 'Ad Ref : ',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.s,
                                      fontWeight: FontWeight.w400,
                                      color: ColorResources.grey,
                                      height: 1.2,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.ad.adRef,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.s,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.textColor,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.s),
                              StatusChip(status: widget.ad.status),
                            ],
                          ),
                          SizedBox(height: 14.s),

                          // Full-width Search Bar (no filter icon, subtle border)
                          AppSearchBar(
                            controller: _searchController,
                            borderColor: ColorResources.borderColor,
                            onChanged: (query) => cubit.updateQuery(query),
                          ),
                          SizedBox(height: 14.s),

                          // Interested Count Row
                          BlocBuilder<InterestedContactsCubit, InterestedContactsState>(
                            buildWhen: (prev, curr) => prev.contacts.length != curr.contacts.length,
                            builder: (context, state) {
                              final totalCount = initialContacts != null
                                  ? initialContacts.length
                                  : (widget.ad.interestedCount > 0
                                      ? widget.ad.interestedCount
                                      : state.contacts.length);
                              return Text.rich(
                                TextSpan(
                                  text: StringFile.interestedPrefix,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.s,
                                    fontWeight: FontWeight.w400,
                                    color: ColorResources.grey,
                                    height: 1.2,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '$totalCount',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.s,
                                        fontWeight: FontWeight.w700,
                                        color: ColorResources.textColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 12.s),
                        ],
                      ),
                    ),

                    // Scrollable List of Contacts
                    Expanded(
                      child: BlocBuilder<InterestedContactsCubit, InterestedContactsState>(
                        builder: (context, state) {
                          final contacts = state.filtered;

                          if (contacts.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.s),
                                child: Text(
                                  StringFile.noContactsFound,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.s,
                                    fontWeight: FontWeight.w400,
                                    color: ColorResources.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              16.s,
                              0,
                              16.s,
                              16.s + bottomSafe,
                            ),
                            itemCount: contacts.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8.s),
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return InterestedContactRow(
                                key: ValueKey(contact.id),
                                user: contact,
                                onMarkChanged: (mark) {
                                  cubit.setMark(contact.id, mark);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
    );
  }
}
