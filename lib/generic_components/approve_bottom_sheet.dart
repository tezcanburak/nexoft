import 'package:nexoft/exports.dart';

class ApproveBottomSheet extends StatelessWidget {
  const ApproveBottomSheet({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: CommonDecorations.commonUpsertUserPageDecoration(),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/green_success_icon.svg',
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 15),
          Text(
            text,
            style: CommonStyles.bodyLargeGreen(),
          )
        ],
      ),
    );
  }
}
