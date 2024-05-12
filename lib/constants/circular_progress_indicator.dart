import 'package:nexoft/exports.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: CircularProgressIndicator(
          color: ColorConstants.blue,
          backgroundColor: ColorConstants.grey,
        ),
      ),
    );
  }
}
