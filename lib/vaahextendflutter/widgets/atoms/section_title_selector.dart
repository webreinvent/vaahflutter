import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../helpers/styles.dart';

Widget sectionTitleSelector({
  required String title,
  bool condition = false,
  required Function()? callback,
}) {
  return InkWell(
    onTap: callback,
    child: Text(
      title,
      style: condition
          ? TextStyles.semiBold6?.copyWith(
              color: AppTheme.colors['primary'],
            )
          : TextStyles.regular5,
    ),
  );
}
