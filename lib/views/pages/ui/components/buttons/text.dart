import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/enums.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/buttons.dart';
import '../code_preview.dart';
import '../commons.dart';

class ButtonTextPreview extends StatelessWidget {
  const ButtonTextPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Text Buttons', style: heading),
        verticalMargin16,
        Wrap(
          spacing: defaultPadding / 2,
          children: [
            ButtonText(
              onPressed: () {},
              text: "Info",
              buttonType: ButtonType.info,
            ),
            ButtonText(
              onPressed: () {},
              text: "Success",
              buttonType: ButtonType.success,
            ),
            ButtonText(
              onPressed: () {},
              text: "Warning",
              buttonType: ButtonType.warning,
            ),
            ButtonText(
              onPressed: () {},
              text: "Danger",
              buttonType: ButtonType.danger,
            ),
            ButtonText(
              onPressed: () {},
              text: "Help",
              buttonType: ButtonType.help,
            ),
            ButtonText(
              onPressed: () {},
              text: "Primary",
              buttonType: ButtonType.primary,
            ),
            ButtonText(
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

class ButtonTextCode extends StatelessWidget {
  const ButtonTextCode({
    super.key,
  });

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
            'ButtonText(',
            '    onPressed: () {},',
            '    text: "Info",',
            '    buttonType: ButtonType.info,',
            '),'
          ],
        ),
        verticalMargin8,
        Text('Success', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonText(',
            '    onPressed: () {},',
            '    text: "Success",',
            '    buttonType: ButtonType.success,',
            '),'
          ],
        ),
        verticalMargin8,
        Text('Warning', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonText(',
            '    onPressed: () {},',
            '    text: "Warning",',
            '    buttonType: ButtonType.warning,',
            '),'
          ],
        ),
        verticalMargin8,
        Text('Danger', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonText(',
            '    onPressed: () {},',
            '    text: "Danger",',
            '    buttonType: ButtonType.danger,',
            '),'
          ],
        ),
        verticalMargin8,
        Text('Help', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonText(',
            '    onPressed: () {},',
            '    text: "Help",',
            '    buttonType: ButtonType.help,',
            '),'
          ],
        ),
        verticalMargin8,
        Text('Primary', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonText(',
            '    onPressed: () {},',
            '    text: "Primary",',
            '    buttonType: ButtonType.primary,',
            '),'
          ],
        ),
        verticalMargin8,
        Text('Secondary', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonText(',
            '    onPressed: () {},',
            '    text: "Secondary",',
            '    buttonType: ButtonType.secondary,',
            '),'
          ],
        ),
      ],
    );
  }
}
