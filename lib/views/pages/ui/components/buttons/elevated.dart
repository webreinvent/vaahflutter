import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/enums.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/buttons.dart';
import '../code_preview.dart';
import '../commons.dart';

class ButtonElevatedPreview extends StatelessWidget {
  const ButtonElevatedPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Elevated Buttons', style: heading),
        verticalMargin16,
        Wrap(
          spacing: defaultPadding / 2,
          children: [
            ButtonElevated(
              onPressed: () {},
              text: "Info",
              buttonType: ButtonType.info,
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Success",
              buttonType: ButtonType.success,
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Warning",
              buttonType: ButtonType.warning,
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Danger",
              buttonType: ButtonType.danger,
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Help",
              buttonType: ButtonType.help,
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Primary",
              buttonType: ButtonType.primary,
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Secondary",
              buttonType: ButtonType.secondary,
            ),
          ],
        ),
      ],
    );
  }
}

class ButtonElevatedCode extends StatelessWidget {
  const ButtonElevatedCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Info', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(",',
            '    onPressed: () {},',
            '    text: "Info",',
            '    buttonType: ButtonType.info,',
            '),"'
          ],
        ),
        verticalMargin8,
        Text('Success', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(",',
            '    onPressed: () {},',
            '    text: "Success",',
            '    buttonType: ButtonType.success,',
            '),"'
          ],
        ),
        verticalMargin8,
        Text('Warning', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(",',
            '    onPressed: () {},',
            '    text: "Warning",',
            '    buttonType: ButtonType.warning,',
            '),"'
          ],
        ),
        verticalMargin8,
        Text('Danger', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(",',
            '    onPressed: () {},',
            '    text: "Danger",',
            '    buttonType: ButtonType.danger,',
            '),"'
          ],
        ),
        verticalMargin8,
        Text('Help', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(",',
            '    onPressed: () {},',
            '    text: "Help",',
            '    buttonType: ButtonType.help,',
            '),"'
          ],
        ),
        verticalMargin8,
        Text('Primary', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(",',
            '    onPressed: () {},',
            '    text: "Primary",',
            '    buttonType: ButtonType.primary,',
            '),"'
          ],
        ),
        verticalMargin8,
        Text('Secondary', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(",',
            '    onPressed: () {},',
            '    text: "Secondary",',
            '    buttonType: ButtonType.secondary,',
            '),"'
          ],
        ),
      ],
    );
  }
}
