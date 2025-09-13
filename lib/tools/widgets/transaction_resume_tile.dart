import 'package:flutter/widgets.dart';

class TransactionResumeTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const TransactionResumeTile({
    required this.title,
    required this.value,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
