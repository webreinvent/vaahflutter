import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';

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
