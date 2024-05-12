import 'upsert_user_form.dart';
import 'package:nexoft/exports.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: const UpsertUserForm(),
    );
  }
}
