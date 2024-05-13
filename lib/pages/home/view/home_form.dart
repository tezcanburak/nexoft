import 'package:image_picker/image_picker.dart';
import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';
import 'package:nexoft/generic_components/approve_bottom_sheet.dart';
import 'package:nexoft/pages/upsert_user/view/upsert_user_page.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.fetchStatus == Status.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('There is an error!'),
              ),
            );
        } else if (state.fetchStatus == Status.missingInfo) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('There is an error!'),
              ),
            );
        }
        if (state.deleteStatus == Status.showPopUp) {
          context.read<HomeCubit>().deleteStatusChanged(Status.idle);
          showModalBottomSheet(
            elevation: 0,
            context: context,
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            builder: (modalBottomSheetContext) {
              return ApproveBottomSheet(text: AppLocalizations.of(context)!.accountDeleted);
            },
          );
        }
      },

      /// Whole Home Body
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ContactsAndAddButton(),
            const SizedBox(height: 15),
            _SearchBarWidget(),
            Expanded(
              child: _UserList(),
            )
          ],
        ),
      ),
    );
  }
}

class _ContactsAndAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.contacts,
          style: CommonStyles.titleLargeBlack(),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            context.read<HomeCubit>().isUpdateStatusChanged(false);
            context.read<HomeCubit>().createStatusChanged(Status.idle);
            context.read<HomeCubit>().setImage(XFile(''));
            context.read<HomeCubit>().selectedUserChanged(const User.empty());

            /// This (false) is for if user use back button in the phone, and then go to another person.
            context.read<HomeCubit>().isUserEditableStatusChanged(false);
            Navigator.push(context, _animatedRoute());
          },
          child: SvgPicture.asset('assets/svg/blue_plus_icon.svg'),
        ),
      ],
    );
  }
}

class _SearchBarWidget extends StatefulWidget {
  @override
  State<_SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<_SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  bool isSearchStarted = false;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: CommonDecorations.whiteColorBorder12(),
      child: TextField(
        onChanged: (value) {
          cubit.filterUserListRequested(value.trim());
          setState(() {
            if (value == '') {
              isSearchStarted = false;
              return;
            }
            isSearchStarted = true;
          });
        },
        cursorColor: ColorConstants.black,
        style: CommonStyles.bodyLargeBlack(),
        controller: _searchController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintStyle: CommonStyles.bodyLargeGrey(),
          hintText: AppLocalizations.of(context)!.search,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          prefixIconConstraints: const BoxConstraints(maxHeight: 21),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 15),
            child: SvgPicture.asset(
              'assets/svg/search_icon.svg',
              color: _searchController.text.trim().isNotEmpty ? ColorConstants.black : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final _scrollController = ScrollController();

  void _scrollListener(BuildContext context) {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<HomeCubit>().getUsersList();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _scrollListener(context);
    });
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.filteredUserList != curr.filteredUserList || prev.fetchStatus != curr.fetchStatus || prev.userList != curr.userList,
      builder: (context, state) {
        if (state.filteredUserList.isNotEmpty || state.fetchStatus == Status.inProgress) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.filteredUserList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, contactIndex) {
                      var user = state.filteredUserList[contactIndex];
                      return InkWell(
                        onTap: () {
                          context.read<HomeCubit>().isUpdateStatusChanged(true);
                          context.read<HomeCubit>().setImage(XFile(''));

                          /// This (false) is for if user use back button in the phone, and then pick another person.
                          context.read<HomeCubit>().isUserEditableStatusChanged(false);
                          context.read<HomeCubit>().selectedUserChanged(user);
                          Navigator.push(context, _animatedRoute());
                        },
                        child: Container(
                          decoration: CommonDecorations.whiteColorBorder12(),
                          child: Row(
                            children: [
                              /// Left Padding
                              const SizedBox(width: 20),
                              _EachContactPhoto(user: user),

                              /// Padding Between Contact Photo & Texts
                              const SizedBox(width: 10),
                              _EachNameAndPhoneNumberTexts(user: user),

                              /// Right Padding
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                      );
                    },

                    /// Padding between each contact
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                  ),
                  if (state.fetchStatus == Status.inProgress) const CustomCircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
        return _ThereIsNoContactView();
      },
    );
  }
}

class _EachContactPhoto extends StatelessWidget {
  const _EachContactPhoto({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
          ? Image.network(
              user.profileImageUrl!,
              height: 34,
              width: 34,
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/png/profile_picture.png',
              height: 34,
              width: 34,
              fit: BoxFit.cover,
            ),
    );
  }
}

class _EachNameAndPhoneNumberTexts extends StatelessWidget {
  const _EachNameAndPhoneNumberTexts({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Padding
        const SizedBox(height: 13),
        Text.rich(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: CommonStyles.bodyLargeBlack(),
          TextSpan(
            text: user.firstName ?? '',
            children: [
              const TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: user.lastName ?? '',
              ),
            ],
          ),
        ),
        Text(
          user.phoneNumber ?? '',
          style: CommonStyles.bodyLargeGrey(),
        ),

        /// Bottom Padding
        const SizedBox(height: 13),
      ],
    );
  }
}

class _ThereIsNoContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/png/profile_picture.png',
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.noContacts,
          textAlign: TextAlign.center,
          style: CommonStyles.titleLargeBlack(),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.addContactsText,
          textAlign: TextAlign.center,
          style: CommonStyles.bodyLargeBlack(),
        ),
        TextButton(
          onPressed: () {
            context.read<HomeCubit>().isUpdateStatusChanged(false);
            context.read<HomeCubit>().createStatusChanged(Status.idle);
            context.read<HomeCubit>().setImage(XFile(''));
            context.read<HomeCubit>().selectedUserChanged(const User.empty());

            /// This (false) is for if user use back button in the phone, and then go to another person.
            context.read<HomeCubit>().isUserEditableStatusChanged(false);
            Navigator.push(context, _animatedRoute());
          },
          child: Text(
            AppLocalizations.of(context)!.createContact,
            textAlign: TextAlign.center,
            style: CommonStyles.bodyLargeBlue(),
          ),
        ),
      ],
    );
  }
}

Route _animatedRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 1000),
    pageBuilder: (context, animation, secondaryAnimation) => const UpsertUserPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
