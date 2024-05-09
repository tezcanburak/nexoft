import 'upsert_user_form.dart';
import 'package:nexoft/exports.dart';

class UpsertUserPage extends StatelessWidget {
  const UpsertUserPage({super.key, required this.isUpdate});

  final bool isUpdate;

  static Route route(bool isUpdate) {
    return MaterialPageRoute(
      builder: (_) => UpsertUserPage(isUpdate: isUpdate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: const UpsertUserForm(),
    );
  }
}
