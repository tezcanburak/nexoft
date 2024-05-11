import 'upsert_user_form.dart';
import 'package:nexoft/exports.dart';
import 'package:nexoft/model/user.dart';

class UpsertUserPage extends StatelessWidget {
  const UpsertUserPage({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const UpsertUserPage(),
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
