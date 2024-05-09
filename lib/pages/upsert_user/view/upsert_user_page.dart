import 'upsert_user_form.dart';
import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';

class UpsertUserPage extends StatelessWidget {
  const UpsertUserPage({
    super.key,
    required this.isUpdate,
    this.user,
  });

  final bool isUpdate;
  final User? user;

  static Route route(bool isUpdate, User? user) {
    return MaterialPageRoute(
      builder: (_) => UpsertUserPage(
        isUpdate: isUpdate,
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: UpsertUserForm(isUpdate: isUpdate, user: user),
    );
  }
}
