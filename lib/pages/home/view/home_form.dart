import 'package:nexoft/exports.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';
import 'package:nexoft/pages/upsert_user/view/upsert_user_page.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.contacts,
                style: CommonStyles.titleLargeBlack(),
              ),
              const Spacer(),
              SvgPicture.asset('assets/svg/blue_plus_icon.svg'),
            ],
          ),
          const SizedBox(height: 15),
          _SearchBarWidget(),
          Expanded(
            child: _UserList(),
          )
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ListView.separated(
          itemCount: 10,
          //state.userList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.push(context, _updateRoute()),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorConstants.white,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      height: 34,
                      width: 34,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 13),
                        Text(
                          'Alice Wellington',
                          style: CommonStyles.bodyLargeBlack(),
                        ),
                        Text(
                          '+1234567890',
                          style: CommonStyles.bodyLargeGrey(),
                        ),
                        const SizedBox(height: 13),
                      ],
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 20),
        );
      },
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 1000),
    pageBuilder: (context, animation, secondaryAnimation) => const UpsertUserPage(isUpdate: false),
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

Route _updateRoute() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 1000),
    pageBuilder: (context, animation, secondaryAnimation) => const UpsertUserPage(isUpdate: true),
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

class _SearchBarWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextField(
        // onChanged: (value) => searchBloc.add(FilterUserListRequested(value.trim())),

        cursorColor: ColorConstants.black,
        style: TextStyle(
          color: ColorConstants.black,
        ),
        controller: _searchController,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: TextStyle(
            color: ColorConstants.black.withOpacity(0.4),
          ),
          hintText: 'search',
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              //     _searchController.clear();
              //     searchBloc.add(FilterUserListRequested(_searchController.text.trim()));
            },
            icon: Icon(
              Icons.clear,
              color: ColorConstants.black.withOpacity(0.4),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
