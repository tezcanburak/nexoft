import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UpsertUserForm extends StatefulWidget {
  const UpsertUserForm({
    super.key,
    required this.isUpdate,
    this.user,
  });

  final bool isUpdate;
  final User? user;

  @override
  State<UpsertUserForm> createState() => _UpsertUserFormState();
}

class _UpsertUserFormState extends State<UpsertUserForm> {
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
          CircleAvatar(
            radius: size.width * 0.225,
            backgroundColor: Colors.transparent,
            child: Image.asset(
              'assets/png/profile_picture.png',
              fit: BoxFit.cover,
            ),
          ),

          /// This row is used to prevent the clickable area from stretching to the entire width.
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: ColorConstants.pageColor,
                    barrierColor: Colors.transparent,
                    elevation: 0,
                    context: context,
                    builder: (modalBottomSheetContext) {
                      return Container(
                        padding: const EdgeInsets.all(30),
                        decoration: CommonDecorations.commonUpsertUserPageDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: CommonDecorations.pageColorBorder10(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'camera',
                                    style: CommonStyles.titleLargeBlack(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: CommonDecorations.pageColorBorder10(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'gallery',
                                    style: CommonStyles.titleLargeBlack(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: CommonDecorations.pageColorBorder10(),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.cancel,
                                  style: CommonStyles.titleLargeBlue(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
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
              'Alice',
              style: CommonStyles.bodyLargeBlack(),
            ),
          ),
          _divider(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Wellington',
              style: CommonStyles.bodyLargeBlack(),
            ),
          ),
          _divider(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              '+1234567890',
              style: CommonStyles.bodyLargeBlack(),
            ),
          ),
          const SizedBox(height: 11),
          _divider(8),
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
          _FirstName(),
          const SizedBox(height: 20),
          _LastName(),
          const SizedBox(height: 20),
          _PhoneNumber(),
          const Spacer(),
        ],
      ),
    );
  }

  Divider _divider(double height) {
    return Divider(
      height: height,
      thickness: 1,
      color: ColorConstants.grey,
    );
  }
}

class _FirstName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CommonDecorations.pageColorBorder15(),
      child: BlocBuilder<HomeCubit, HomeState>(
        //  buildWhen: (prev, curr) => prev.otherName != curr.otherName,
        builder: (context, state) {
          return TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //  validator: (value) => state.otherName.errorMessage,
            //  onChanged: (name) => context.read<InformationCubit>().otherNameChanged(name),
            keyboardType: TextInputType.text,
            style: CommonStyles.bodyLargeBlack(),
            decoration: CommonDecorations.textFormFieldDecoration('firstName'),
            textAlign: TextAlign.left,
            cursorColor: ColorConstants.blue,
          );
        },
      ),
    );
  }
}

class _LastName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CommonDecorations.pageColorBorder15(),
      child: BlocBuilder<HomeCubit, HomeState>(
        // buildWhen: (prev, curr) => prev.surName != curr.surName,
        builder: (context, state) {
          return TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            //  validator: (value) => state.surName.errorMessage,
            //  onChanged: (surname) => context.read<InformationCubit>().surnameChanged(surname),
            keyboardType: TextInputType.text,
            style: CommonStyles.bodyLargeBlack(),
            decoration: CommonDecorations.textFormFieldDecoration('lastName'),
            textAlign: TextAlign.left,
            cursorColor: ColorConstants.blue,
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _PhoneNumber extends StatelessWidget {
  var maskFormatter = MaskTextInputFormatter(mask: '### ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.eager);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CommonDecorations.pageColorBorder15(),
      child: TextFormField(
        inputFormatters: [maskFormatter],
        //  onChanged: (phoneNumber) => context.read<InformationCubit>().phoneNumberChanged(phoneNumber),
        keyboardType: TextInputType.phone,
        style: CommonStyles.bodyLargeBlack(),

        decoration: CommonDecorations.textFormFieldDecoration('phoneNumber'),
        textAlign: TextAlign.left,
        cursorColor: ColorConstants.blue,
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
