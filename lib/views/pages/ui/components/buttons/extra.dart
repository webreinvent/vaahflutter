import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/buttons.dart';
import '../code_preview.dart';
import '../commons.dart';

class ButtonExtrasPreview extends StatelessWidget {
  const ButtonExtrasPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Button Properties', style: heading),
        verticalMargin16,
        Wrap(
          spacing: defaultPadding / 2,
          children: [
            ButtonElevated(
              onPressed: () {},
              text: "Background Color",
              backgroundColor: Colors.pink,
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Foreground Color",
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Button Style",
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
            ),
            ButtonElevated(
              onPressed: () {},
              text: "Border Radius",
              borderRadius: 100,
            ),
            const Divider(),
            ButtonElevatedWithIcon(
              onPressed: () {},
              text: "Size",
              iconData: FontAwesomeIcons.user,
              fontSize: 22,
              iconSize: 21,
              padding: horizontalPadding32 + verticalPadding12,
            ),
          ],
        ),
      ],
    );
  }
}

class ButtonExtrasCode extends StatelessWidget {
  const ButtonExtrasCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Background Color', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(',
            '    onPressed: () {},',
            '    text: "Background Color",',
            '    backgroundColor: Colors.pink,',
            '),',
          ],
        ),
        verticalMargin8,
        Text('Foreground Color', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(',
            '    onPressed: () {},',
            '    text: "Foreground Color",',
            '    style: ElevatedButton.styleFrom(',
            '        backgroundColor: Colors.white,',
            '        foregroundColor: Colors.black,',
            '    ),',
            '),',
          ],
        ),
        verticalMargin8,
        Text('Button Style', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(',
            '    onPressed: () {},',
            '    text: "Button Style",',
            '    style: ElevatedButton.styleFrom(',
            '        backgroundColor: Colors.purple,',
            '    ),',
            '),',
          ],
        ),
        verticalMargin8,
        Text('Border Radius', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevated(',
            '    onPressed: () {},',
            '    text: "Border Radius",',
            '    borderRadius: 100,',
            '),',
          ],
        ),
        verticalMargin8,
        Text('Button Size', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            'ButtonElevatedWithIcon(',
            '    onPressed: () {},',
            '    text: "Size",',
            '    iconData: FontAwesomeIcons.user,',
            '    fontSize: 22,',
            '    iconSize: 21,',
            '    padding: horizontalPadding32 + verticalPadding12,',
            '),',
          ],
        ),
      ],
    );
  }
}
