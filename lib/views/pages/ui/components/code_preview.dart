import 'package:flutter/cupertino.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';
import 'package:team/vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';

class CodePreview extends StatelessWidget {
  final List<String> code;

  const CodePreview({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerWithRoundedBorder(
      width: double.infinity,
      color: AppTheme.colors['black']!.withOpacity(0.8),
      padding: allPadding12,
      borderRadius: 6,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in code)
              Text(
                line,
                style: TextStyles.regular2?.copyWith(color: AppTheme.colors['white']),
              ),
          ],
        ),
      ),
    );
  }
}
