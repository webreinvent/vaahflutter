import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/enums.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/buttons.dart';
import '../code_preview.dart';
import '../commons.dart';

class ButtonOutlinedPreview extends StatelessWidget {
  const ButtonOutlinedPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Outlined Buttons', style: heading),
        verticalMargin16,
        Wrap(
          spacing: defaultPadding / 2,
          children: [
            ButtonOutlined(
              onPressed: () {},
              text: "Info",
              buttonType: ButtonType.info,
            ),
            ButtonOutlined(
              onPressed: () {},
              text: "Success",
              buttonType: ButtonType.success,
            ),
            ButtonOutlined(
              onPressed: () {},
              text: "Warning",
              buttonType: ButtonType.warning,
            ),
            ButtonOutlined(
              onPressed: () {},
              text: "Danger",
              buttonType: ButtonType.danger,
            ),
            ButtonOutlined(
              onPressed: () {},
              text: "Help",
              buttonType: ButtonType.help,
            ),
            ButtonOutlined(
              onPressed: () {},
              text: "Primary",
              buttonType: ButtonType.primary,
            ),
            ButtonOutlined(
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

class ButtonOutlinedCode extends StatelessWidget {
  const ButtonOutlinedCode({
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
            'ButtonOutlined(',
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
            'ButtonOutlined(',
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
            'ButtonOutlined(',
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
            'ButtonOutlined(',
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
            'ButtonOutlined(',
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
            'ButtonOutlined(',
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
            'ButtonOutlined(',
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
