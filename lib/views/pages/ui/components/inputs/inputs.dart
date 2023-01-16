import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';
import 'package:team/vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';
import 'package:team/views/pages/ui/components/inputs/defaults.dart';
import 'package:team/views/pages/ui/components/inputs/icons.dart';
import 'package:team/views/pages/ui/components/inputs/sizes.dart';
import 'package:team/views/pages/ui/components/section_title_selector.dart';

class AppInputs extends StatefulWidget {
  const AppInputs({Key? key}) : super(key: key);

  @override
  State<AppInputs> createState() => _AppInputsState();
}

class _AppInputsState extends State<AppInputs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ContainerWithRoundedBorder(
      width: double.infinity,
      color: AppTheme.colors['white']!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Text Inputs', style: TextStyles.semiBold7),
          verticalMargin24,
          tabOptions(),
          Divider(color: AppTheme.colors['primary']!.shade200),
          verticalMargin24,
          const DefaultTextInputs(),
          verticalMargin24,
          const InputSizes(),
          verticalMargin24,
          const InputIcons(),
          verticalMargin24,
        ],
      ),
    );
  }

  Widget tabOptions() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        sectionTitleSelector(
          title: 'Preview',
          condition: _selectedIndex == 0,
          callback: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        ),
        verticalMargin12,
        horizontalMargin12,
        sectionTitleSelector(
          title: 'Code',
          condition: _selectedIndex == 1,
          callback: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        ),
      ],
    );
  }
}
