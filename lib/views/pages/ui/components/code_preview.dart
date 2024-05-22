import 'package:flutter/cupertino.dart';

import '../../../../vaahextendflutter/app_theme.dart';
import '../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';

class CodePreview extends StatelessWidget {
  final List<String> code;

  const CodePreview({
    super.key,
    required this.code,
  });

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
