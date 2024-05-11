import 'dart:io';
import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nexoft/pages/upsert_user/image/selected_image.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UpsertUserForm extends StatefulWidget {
  const UpsertUserForm({super.key});

  @override
  State<UpsertUserForm> createState() => _UpsertUserFormState();
}

class _UpsertUserFormState extends State<UpsertUserForm> {
  SelectedImage selectedImage = SelectedImage();

  void pickSingleImage() async {
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
    if (storageStatus.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.pickedImage.path;
      }
    }
  }

  void takePhoto() async {
    var storageStatus = await Permission.camera.status;
    if (!storageStatus.isGranted) {
      await Permission.camera.request();
    }
    if (storageStatus.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        selectedImage.pickedImage.path;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = ScreenUtil.getScreenSize();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var user = state.selectedUser;
        var isUpdate = state.isUpdate;
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
                child: selectedImage.pickedImage.path.isNotEmpty
                    ? Image.file(
                        File(selectedImage.pickedImage.path),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
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
                                InkWell(
                                  onTap: takePhoto,
                                  child: Container(
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
                                ),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: pickSingleImage,
                                  child: Container(
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
                                ),
                                const SizedBox(height: 15),
                                InkWell(
                                  onTap: () => Navigator.pop(modalBottomSheetContext),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: CommonDecorations.pageColorBorder10(),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style: CommonStyles.titleLargeBlue(),
                                      ),
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

              /*       if (isUpdate) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    user.firstName ?? '',
                    style: CommonStyles.bodyLargeBlack(),
                  ),
                ),
                _divider(30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    user.lastName ?? '',
                    style: CommonStyles.bodyLargeBlack(),
                  ),
                ),
                _divider(30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    user.phoneNumber ?? '',
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
              ] else ...[
                _FirstName(),
                const SizedBox(height: 20),
                _LastName(),
                const SizedBox(height: 20),
                _PhoneNumber(),
              ],
                Divider _divider(double height) {
                  return Divider(
                    height: height,
                    thickness: 1,
                    color: ColorConstants.grey,
                  );
                }
              */
              _FirstName(),
              if (!isUpdate) const SizedBox(height: 20),
              _LastName(),
              if (!isUpdate) const SizedBox(height: 20),
              _PhoneNumber(),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}

class _FirstName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.firstName != curr.firstName || prev.isUpdate != curr.isUpdate || prev.selectedUser != curr.selectedUser,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        return Container(
          decoration: isUpdate ? null : CommonDecorations.pageColorBorder15(),
          child: TextFormField(
            textAlign: TextAlign.left,
            enabled: isUpdate ? false : true,
            cursorColor: ColorConstants.blue,
            keyboardType: TextInputType.text,
            style: CommonStyles.bodyLargeBlack(),
            validator: (value) => state.firstName.errorMessage,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: isUpdate ? TextEditingController(text: state.selectedUser.firstName) : null,
            onChanged: (firstName) => context.read<HomeCubit>().firstNameChanged(firstName.trim()),
            decoration:
                isUpdate ? CommonDecorations.textFormFieldUnderlineDecoration('firstName') : CommonDecorations.textFormFieldDecoration('firstName'),
          ),
        );
      },
    );
  }
}

class _LastName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.lastName != curr.lastName || prev.isUpdate != curr.isUpdate || prev.selectedUser != curr.selectedUser,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        return Container(
          decoration: isUpdate ? null : CommonDecorations.pageColorBorder15(),
          child: TextFormField(
            enabled: isUpdate ? false : true,
            controller: isUpdate ? TextEditingController(text: state.selectedUser.lastName) : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => state.lastName.errorMessage,
            onChanged: (lastName) => context.read<HomeCubit>().lastNameChanged(lastName.trim()),
            keyboardType: TextInputType.text,
            style: CommonStyles.bodyLargeBlack(),
            decoration:
                isUpdate ? CommonDecorations.textFormFieldUnderlineDecoration('lastName') : CommonDecorations.textFormFieldDecoration('lastName'),
            textAlign: TextAlign.left,
            cursorColor: ColorConstants.blue,
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class _PhoneNumber extends StatelessWidget {
  var maskFormatter = MaskTextInputFormatter(mask: '+## ### ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.eager);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.phoneNumber != curr.phoneNumber || prev.isUpdate != curr.isUpdate || prev.selectedUser != curr.selectedUser,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        return Container(
          decoration: isUpdate ? null : CommonDecorations.pageColorBorder15(),
          child: TextFormField(
            textAlign: TextAlign.left,
            cursorColor: ColorConstants.blue,
            enabled: isUpdate ? false : true,
            keyboardType: TextInputType.phone,
            style: CommonStyles.bodyLargeBlack(),
            controller: isUpdate ? TextEditingController(text: state.selectedUser.phoneNumber) : null,
            onChanged: (phoneNumber) => context.read<HomeCubit>().phoneNumberChanged(phoneNumber),
            decoration: isUpdate
                ? CommonDecorations.textFormFieldUnderlineDecoration('phoneNumber')
                : CommonDecorations.textFormFieldDecoration('phoneNumber'),
          ),
        );
      },
    );
  }
}

class _CancelEditDoneButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.isValid != curr.isValid ||
          prev.isUpdate != curr.isUpdate ||
          prev.selectedUser != curr.selectedUser ||
          prev.isEditable != curr.isEditable,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        var isValid = state.isValid;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: CommonStyles.bodySmallBlue(),
              ),
            ),
            if (isUpdate == false)
              Text(
                'newContact',
                style: CommonStyles.bodyLargeBlack(),
              ),
            if (isUpdate)
              TextButton(
                onPressed: () {},
                child: Text(
                  isUpdate ? AppLocalizations.of(context)!.edit : AppLocalizations.of(context)!.done,
                  style: CommonStyles.bodyLargeBlue(),
                ),
              )
            else
              TextButton(
                onPressed: isValid ? () => context.read<HomeCubit>().createUserRequested() : null,
                child: Text(
                  AppLocalizations.of(context)!.done,
                  style: isValid ? CommonStyles.bodyLargeBlue() : CommonStyles.bodyLargeGrey(),
                ),
              ),
          ],
        );
      },
    );
  }
}
