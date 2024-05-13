import 'dart:io';
import 'package:nexoft/exports.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nexoft/generic_components/approve_bottom_sheet.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UpsertUserForm extends StatelessWidget {
  const UpsertUserForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.deleteStatus == Status.success) {
          Navigator.pop(context);
          context.read<HomeCubit>().deleteStatusChanged(Status.showPopUp);
        }
        if (state.createStatus == Status.success && state.isUpdate == false) {
          showModalBottomSheet(
            elevation: 0,
            context: context,
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            builder: (modalBottomSheetContext) {
              return ApproveBottomSheet(text: AppLocalizations.of(context)!.userAdded);
            },
          );
        }
        if (state.updateStatus == Status.success) {
          showModalBottomSheet(
            elevation: 0,
            context: context,
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            builder: (modalBottomSheetContext) {
              context.read<HomeCubit>().updateStatusChanged(Status.idle);
              return ApproveBottomSheet(text: AppLocalizations.of(context)!.changesApplied);
            },
          );
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (prev, curr) =>
            prev.isUpdate != curr.isUpdate || prev.isUserEditable != curr.isUserEditable || prev.createStatus != curr.createStatus,
        builder: (context, state) {
          var isUpdate = state.isUpdate;
          var isEditable = state.isUserEditable;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: CommonDecorations.commonUpsertUserPageDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CancelEditDoneButtons(),
                const SizedBox(height: 25),
                _UserPhoto(),
                _AddChangePhotoButton(),
                const SizedBox(height: 24),
                _FirstName(),
                if ((isUpdate && isEditable) || (!isUpdate && !isEditable)) const SizedBox(height: 20),
                _LastName(),
                if ((isUpdate && isEditable) || (!isUpdate && !isEditable)) const SizedBox(height: 20),
                _PhoneNumber(),
                if ((isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable)) _DeleteButton(),
                const Spacer(),
              ],
            ),
          );
        },
      ),
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
          prev.isUserEditable != curr.isUserEditable ||
          prev.createStatus != curr.createStatus ||
          prev.editedSelectedUser != curr.editedSelectedUser,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        var isValid = state.isValid;
        var isEditable = state.isUserEditable;
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
                AppLocalizations.of(context)!.newContact,
                style: CommonStyles.bodyLargeBlack(),
              ),
            if (isUpdate)
              TextButton(
                onPressed: isEditable
                    ? state.selectedUser != state.editedSelectedUser
                        ? () {
                            context.read<HomeCubit>().isUserEditableStatusChanged(false);
                            context.read<HomeCubit>().updateUserRequested();
                          }
                        : null
                    : () => context.read<HomeCubit>().isUserEditableStatusChanged(true),
                child: Text(
                  isEditable ? AppLocalizations.of(context)!.done : AppLocalizations.of(context)!.edit,
                  style: isEditable && state.selectedUser == state.editedSelectedUser ? CommonStyles.bodyLargeGrey() : CommonStyles.bodyLargeBlue(),
                ),
              )
            else
              state.createStatus == Status.inProgress
                  ? const CustomCircularProgressIndicator()
                  : TextButton(
                      onPressed: state.createStatus == Status.success
                          ? () {
                              context.read<HomeCubit>().createStatusChanged(Status.idle);
                              context.read<HomeCubit>().isUpdateStatusChanged(true);
                              context.read<HomeCubit>().isUserEditableStatusChanged(true);
                            }
                          : isValid
                              ? () {
                                  context.read<HomeCubit>().createUserRequested();
                                }
                              : null,
                      child: Text(
                        state.createStatus == Status.success ? AppLocalizations.of(context)!.edit : AppLocalizations.of(context)!.done,
                        style: isValid ? CommonStyles.bodyLargeBlue() : CommonStyles.bodyLargeGrey(),
                      ),
                    ),
          ],
        );
      },
    );
  }
}

class _UserPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = ScreenUtil.getScreenSize();

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.selectedUser != curr.selectedUser || prev.image != curr.image,
      builder: (context, state) {
        if (state.isUpdate) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width * 0.45),
              child: state.selectedUser.profileImageUrl != null && state.selectedUser.profileImageUrl!.isNotEmpty
                  ? Image.network(
                      state.selectedUser.profileImageUrl!,
                      height: size.width * 0.45,
                      width: size.width * 0.45,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/png/profile_picture.png',
                      height: size.width * 0.45,
                      width: size.width * 0.45,
                      fit: BoxFit.cover,
                    ),
            ),
          );
        }
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size.width * 0.45),
            child: state.image != null && state.image!.path.isNotEmpty
                ? Image.file(
                    File(state.image!.path),
                    height: size.width * 0.45,
                    width: size.width * 0.45,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/png/profile_picture.png',
                    height: size.width * 0.45,
                    width: size.width * 0.45,
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }
}

class _AddChangePhotoButton extends StatefulWidget {
  @override
  State<_AddChangePhotoButton> createState() => _AddChangePhotoButtonState();
}

class _AddChangePhotoButtonState extends State<_AddChangePhotoButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        return Row(
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
                            onTap: () async {
                              var storageStatus = await Permission.camera.status;
                              if (!storageStatus.isGranted) {
                                await Permission.camera.request();
                              }
                              if (storageStatus.isGranted) {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                                if (image != null) {
                                  if (!mounted) return;
                                  context.read<HomeCubit>().setImage(image);
                                  if (isUpdate) {
                                    context.read<HomeCubit>().addOrUpdateUserPhoto();
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: CommonDecorations.pageColorBorder10WithShadow(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.camera,
                                    style: CommonStyles.titleLargeBlack(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () async {
                              var storageStatus = await Permission.storage.status;
                              if (!storageStatus.isGranted) {
                                await Permission.storage.request();
                              }
                              if (storageStatus.isGranted) {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  if (!mounted) return;
                                  context.read<HomeCubit>().setImage(image);
                                  if (isUpdate) {
                                    context.read<HomeCubit>().addOrUpdateUserPhoto();
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: CommonDecorations.pageColorBorder10WithShadow(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.gallery,
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
                              decoration: CommonDecorations.pageColorBorder10WithShadow(),
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
                (isUpdate && state.selectedUser.profileImageUrl == null) ||
                        (!isUpdate &&
                            ((state.createStatus == Status.idle && state.image == null) ||
                                (state.createStatus == Status.success && state.selectedUser.profileImageUrl == null)))
                    ? AppLocalizations.of(context)!.addPhoto
                    : AppLocalizations.of(context)!.changePhoto,
                softWrap: true,
                style: CommonStyles.bodyLargeBlack(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FirstName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) =>
          prev.firstName != curr.firstName ||
          prev.isUpdate != curr.isUpdate ||
          prev.selectedUser != curr.selectedUser ||
          prev.isUserEditable != curr.isUserEditable ||
          prev.editedSelectedUser != curr.editedSelectedUser,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        var isEditable = state.isUserEditable;
        return Container(
          decoration: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable)
              ? null
              : CommonDecorations.pageColorBorder15(),
          child: TextFormField(
            initialValue: (isUpdate) || (!isUpdate && state.createStatus == Status.success) ? state.selectedUser.firstName : '',
            textAlign: TextAlign.left,
            cursorColor: ColorConstants.blue,
            keyboardType: TextInputType.text,
            style: CommonStyles.bodyLargeBlack(),
            enabled: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable) ? false : true,
            validator: (value) => state.firstName.errorMessage,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (firstName) => context.read<HomeCubit>().firstNameChanged(firstName.trim()),
            decoration: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable)
                ? CommonDecorations.textFormFieldUnderlineDecoration(AppLocalizations.of(context)!.firstName)
                : CommonDecorations.textFormFieldDecoration(AppLocalizations.of(context)!.firstName),
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
      buildWhen: (prev, curr) =>
          prev.lastName != curr.lastName ||
          prev.isUpdate != curr.isUpdate ||
          prev.selectedUser != curr.selectedUser ||
          prev.isUserEditable != curr.isUserEditable ||
          prev.editedSelectedUser != curr.editedSelectedUser,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        var isEditable = state.isUserEditable;
        return Container(
          decoration: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable)
              ? null
              : CommonDecorations.pageColorBorder15(),
          child: TextFormField(
            initialValue: (isUpdate) || (!isUpdate && state.createStatus == Status.success) ? state.selectedUser.lastName : '',
            textAlign: TextAlign.left,
            cursorColor: ColorConstants.blue,
            keyboardType: TextInputType.text,
            enabled: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable) ? false : true,
            validator: (value) => state.lastName.errorMessage,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (lastName) => context.read<HomeCubit>().lastNameChanged(lastName.trim()),
            style: CommonStyles.bodyLargeBlack(),
            decoration: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable)
                ? CommonDecorations.textFormFieldUnderlineDecoration(AppLocalizations.of(context)!.lastName)
                : CommonDecorations.textFormFieldDecoration(AppLocalizations.of(context)!.lastName),
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
      buildWhen: (prev, curr) =>
          prev.phoneNumber != curr.phoneNumber ||
          prev.isUpdate != curr.isUpdate ||
          prev.selectedUser != curr.selectedUser ||
          prev.isUserEditable != curr.isUserEditable ||
          prev.editedSelectedUser != curr.editedSelectedUser,
      builder: (context, state) {
        var isUpdate = state.isUpdate;
        var isEditable = state.isUserEditable;
        return Container(
          decoration: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable)
              ? null
              : CommonDecorations.pageColorBorder15(),
          child: TextFormField(
            initialValue: (isUpdate) || (!isUpdate && state.createStatus == Status.success) ? state.selectedUser.phoneNumber : '',
            textAlign: TextAlign.left,
            cursorColor: ColorConstants.blue,
            enabled: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable) ? false : true,
            validator: (value) => state.phoneNumber.errorMessage,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            style: CommonStyles.bodyLargeBlack(),
            onChanged: (phoneNumber) => context.read<HomeCubit>().phoneNumberChanged(phoneNumber),
            decoration: (isUpdate && !isEditable) || (!isUpdate && state.createStatus == Status.success && !isEditable)
                ? CommonDecorations.textFormFieldUnderlineDecoration(AppLocalizations.of(context)!.phoneNumber)
                : CommonDecorations.textFormFieldDecoration(AppLocalizations.of(context)!.phoneNumber),
          ),
        );
      },
    );
  }
}

class _DeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var user = state.selectedUser;
        return Row(
          children: [
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  elevation: 0,
                  context: context,
                  barrierColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  builder: (modalBottomSheetContext) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      decoration: CommonDecorations.commonUpsertUserPageDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.deleteAccount,
                              style: CommonStyles.titleLargeRed(),
                            ),
                          ),
                          const SizedBox(height: 25),
                          InkWell(
                            onTap: () {
                              Navigator.pop(modalBottomSheetContext);
                              context.read<HomeCubit>().deleteUserRequested(user);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: CommonDecorations.pageColorBorder10WithShadow(),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.yes,
                                  style: CommonStyles.titleLargeBlack(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () => Navigator.pop(modalBottomSheetContext),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: CommonDecorations.pageColorBorder10WithShadow(),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.no,
                                  style: CommonStyles.titleLargeBlack(),
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
                AppLocalizations.of(context)!.deleteContact,
                style: CommonStyles.bodyLargeRed(),
              ),
            ),
          ],
        );
      },
    );
  }
}
