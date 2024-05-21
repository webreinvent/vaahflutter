import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../vaahextendflutter/app_theme.dart';
import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/buttons.dart';
import '../code_preview.dart';
import '../commons.dart';

class ButtonIconLabelPreview extends StatelessWidget {
  const ButtonIconLabelPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Label and Icon Buttons', style: heading),
        verticalMargin16,
        Wrap(
          spacing: defaultPadding / 2,
          children: [
            ButtonElevatedWithIcon(
              onPressed: () {},
              text: "Icon Button",
              leading: const Icon(FontAwesomeIcons.user),
            ),
            ButtonOutlinedWithIcon(
              onPressed: () {},
              text: "Icon Button",
              iconData: FontAwesomeIcons.user,
            ),
            ButtonTextWithIcon(
              onPressed: () {},
              text: "Icon Button",
              leading: const Icon(FontAwesomeIcons.user),
            ),
            ButtonOutlinedWithIcon(
              onPressed: () {},
              borderColor: AppTheme.colors['info'],
              text: "Border Color",
              iconData: FontAwesomeIcons.user,
            ),
          ],
        ),
      ],
    );
  }
}

class ButtonIconLabelCode extends StatelessWidget {
  const ButtonIconLabelCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Elevated Button With Icon', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevatedWithIcon(',
            '    onPressed: () {},',
            '    text: "Icon Button",',
            '    iconData: FontAwesomeIcons.user,',
            '),',
          ],
        ),
        verticalMargin8,
        Text('Outlined Button With Icon', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonOutlinedWithIcon(',
            '    onPressed: () {},',
            '    text: "Icon Button",',
            '    iconData: FontAwesomeIcons.user,',
            '),',
          ],
        ),
        verticalMargin8,
        Text('Text Button With Icon', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonTextWithIcon(',
            '    onPressed: () {},',
            '    text: "Icon Button",',
            '    iconData: FontAwesomeIcons.user,',
            '),',
          ],
        ),
        verticalMargin8,
        Text('Outlined Button With Icon & Border Color', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonOutlinedWithIcon(',
            '    onPressed: () {},',
            '    text: "Border Color",',
            '    iconData: FontAwesomeIcons.user,',
            '''    borderColor: AppTheme.colors['warning'],''',
            '),',
          ],
        ),
      ],
    );
  }
}
