import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';
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

class _SearchBarWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<HomeCubit>();
    return Container(
      decoration: CommonDecorations.whiteColorBorder12(),
      child: TextField(
        onChanged: (value) => cubit.filterUserListRequested(value.trim()),
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
          suffixIcon: IconButton(
            onPressed: () {
              _searchController.clear();
              cubit.filterUserListRequested(_searchController.text.trim());
            },
            icon: Icon(
              Icons.clear,
              color: ColorConstants.black.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.filteredUserList != curr.filteredUserList || prev.fetchStatus != curr.fetchStatus,
      builder: (context, state) {
        if (state.fetchStatus == Status.inProgress) {
          return const CustomCircularProgressIndicator();
        } else {
          if (state.filteredUserList.isNotEmpty) {
            return ListView.separated(
              itemCount: state.filteredUserList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (context, contactIndex) {
                var user = state.filteredUserList[contactIndex];
                return InkWell(
                  onTap: () {
                    context.read<HomeCubit>().isUpdateStatusChanged(true);

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
            );
          }
          return _ThereIsNoContactView();
        }
      },
    );
  }
}

class _EachContactPhoto extends StatelessWidget {
  const _EachContactPhoto({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 17,
      backgroundColor: Colors.transparent,
      child: user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
          ? Image.network(
              user.profileImageUrl!,
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/png/profile_picture.png',
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
