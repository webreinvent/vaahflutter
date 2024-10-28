import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/enums.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/buttons.dart';
import '../code_preview.dart';
import '../commons.dart';

class ButtonIconPreview extends StatelessWidget {
  const ButtonIconPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Icon Buttons', style: heading),
        verticalMargin16,
        Wrap(
          spacing: defaultPadding / 2,
          children: [
            ButtonIcon(
              onPressed: () {},
              enableBorder: false,
              iconData: FontAwesomeIcons.bell,
            ),
            ButtonIcon(
              onPressed: () {},
              enableBorder: false,
              iconData: FontAwesomeIcons.xmark,
            ),
            ButtonIcon(
              onPressed: () {},
              buttonType: ButtonType.success,
              iconData: FontAwesomeIcons.user,
            ),
            ButtonIcon(
              onPressed: () {},
              color: Colors.pink,
              iconData: FontAwesomeIcons.heart,
            ),
          ],
        ),
      ],
    );
  }
}

class ButtonIconCode extends StatelessWidget {
  const ButtonIconCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Without Border', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonIcon(',
            '    onPressed: () {},',
            '    enableBorder: false,',
            '    iconData: FontAwesomeIcons.xmark,',
            '),',
          ],
        ),
        verticalMargin8,
        Text('With ButtonType', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonIcon(',
            '    onPressed: () {},',
            '    buttonType: ButtonType.success,',
            '    iconData: FontAwesomeIcons.user,',
            '),',
          ],
        ),
        verticalMargin8,
        Text('With Color', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonIcon(',
            '    onPressed: () {},',
            '    color: Colors.pink,',
            '    iconData: FontAwesomeIcons.heart,',
            '),',
          ],
        ),
      ],
    );
  }
}
