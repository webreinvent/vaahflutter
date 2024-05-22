import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../vaahextendflutter/app_theme.dart';
import '../../../../../vaahextendflutter/helpers/alerts.dart';
import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/enums.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/input_text.dart';
import '../code_preview.dart';
import '../commons.dart';

class InputIconsPreview extends StatelessWidget {
  const InputIconsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Icons', style: heading),
        verticalMargin16,
        const InputText(
          size: InputSize.small,
          label: 'Small',
          prefixIcon: FontAwesomeIcons.user,
        ),
        verticalMargin8,
        const InputText(
          size: InputSize.medium,
          label: 'Medium',
          prefixIcon: FontAwesomeIcons.user,
        ),
        verticalMargin8,
        const InputText(
          size: InputSize.large,
          label: 'Large',
          prefixIcon: FontAwesomeIcons.user,
        ),
        verticalMargin8,
        const InputText(
          label: 'Search',
          suffixIcon: FontAwesomeIcons.magnifyingGlass,
        ),
        verticalMargin8,
        InputText(
          label: 'Search',
          prefixOnTap: () {
            Alerts.showSuccessToast!(content: 'Prefix icon onTap');
          },
          suffixOnTap: () {
            Alerts.showErrorToast!(content: 'Suffix icon onTap');
          },
          prefixIcon: FontAwesomeIcons.user,
          prefixIconColor: AppTheme.colors['primary'],
          suffixIcon: FontAwesomeIcons.magnifyingGlass,
          suffixIconColor: AppTheme.colors['primary'],
        ),
      ],
    );
  }
}

class InputIconsCode extends StatelessWidget {
  const InputIconsCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Small', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "const InputText(",
            "    size: InputSize.small,",
            "    label: 'Small',",
            "    prefixIcon: FontAwesomeIcons.user,",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Medium', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "const InputText(",
            "    size: InputSize.medium,",
            "    label: 'Medium',",
            "    prefixIcon: FontAwesomeIcons.user,",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Large', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "const InputText(",
            "    size: InputSize.large,",
            "    label: 'Large',",
            "    prefixIcon: FontAwesomeIcons.user,",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Suffix icon', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "const InputText(",
            "    label: 'Search',",
            "    suffixIcon: FontAwesomeIcons.magnifyingGlass,",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Icon On Tap', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "const InputText(",
            "    label: 'Search',",
            "    prefixOnTap: () {",
            "        Alerts.showSuccessToast!(content: 'Prefix icon onTap');",
            "    },",
            "    suffixOnTap: () {",
            "        Alerts.showErrorToast!(content: 'Suffix icon onTap');",
            "    },",
            "    prefixIcon: FontAwesomeIcons.user,",
            "    prefixIconColor: AppTheme.colors['primary'],",
            "    suffixIcon: FontAwesomeIcons.magnifyingGlass,",
            "    suffixIconColor: AppTheme.colors['primary'],",
            "),",
          ],
        ),
      ],
    );
  }
}
