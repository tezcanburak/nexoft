import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';

class UpsertUserForm extends StatelessWidget {
  const UpsertUserForm({
    super.key,
    required this.isUpdate,
    this.user,
  });

  final bool isUpdate;
  final User? user;

  @override
  Widget build(BuildContext context) {
    var size = ScreenUtil.getScreenSize();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: CommonDecorations.commonUpsertUserPageDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CancelEditDoneButtons(),
          Container(
            width: size.width * 0.45,
            height: size.width * 0.45,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/png/profile_picture.png'),
              ),
            ),
          ),

          /// This row is used to prevent the clickable area from stretching to the entire width.
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.changePhoto,
                  softWrap: true,
                  style: CommonStyles.bodyLargeBlack(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Deneme',
              style: CommonStyles.bodyLargeBlack(),
            ),
          ),
          Divider(
            height: 30,
            thickness: 1,
            color: ColorConstants.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Deneme',
              style: CommonStyles.bodyLargeBlack(),
            ),
          ),
          Divider(
            height: 30,
            thickness: 1,
            color: ColorConstants.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Deneme',
              style: CommonStyles.bodyLargeBlack(),
            ),
          ),
          const SizedBox(height: 11),
          Divider(
            height: 8,
            thickness: 1,
            color: ColorConstants.grey,
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.deleteAccount,
                  style: CommonStyles.redDeleteAccountTextStyle(),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _CancelEditDoneButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: CommonStyles.bodySmallBlue(),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.edit,
                style: CommonStyles.bodyLargeBlue(),
              ),
            ),
          ],
        );
      },
    );
  }
}
