import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/button_checkbox.dart';
import '../../../../../vaahextendflutter/widgets/atoms/button_radio.dart';
import '../code_preview.dart';
import '../commons.dart';

class ButtonRadioAndCheckboxPreview extends StatelessWidget {
  const ButtonRadioAndCheckboxPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Radio And Checkbox Buttons', style: heading),
        verticalMargin16,
        Text('Radio Buttons', style: normal),
        verticalMargin12,
        ButtonRadio<Language>(
          initialValue: items.last,
          items: items.map((e) => RadioItem(text: e.language, data: e)).toList(),
          onChanged: (_) {},
        ),
        verticalMargin12,
        Text('Checkbox Buttons', style: normal),
        verticalMargin12,
        ButtonCheckBox<Language>(
          items: items.map((e) => CheckboxItem(text: e.language, data: e)).toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}

class ButtonRadioAndCheckboxCode extends StatelessWidget {
  const ButtonRadioAndCheckboxCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Radio Buttons', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "ButtonRadio<Language>(",
            "    initialValue: items.last,",
            "    items: items.map((e) => RadioItem(text: e.language, data: e)).toList(),",
            "    onChanged: (_) {},",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Checkbox Buttons', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "ButtonCheckBox<Language>(",
            "    items: items.map((e) => CheckboxItem(text: e.language, data: e)).toList(),",
            "    onChanged: (_) {},",
            "),",
          ],
        ),
      ],
    );
  }
}

enum Difficulty {
  easy,
  moderate,
  hard,
}

class Language {
  final String language;
  final Difficulty difficulty;

  const Language({
    required this.language,
    required this.difficulty,
  });
}

const List<Language> items = [
  Language(
    language: 'c / c++',
    difficulty: Difficulty.easy,
  ),
  Language(
    language: 'python',
    difficulty: Difficulty.easy,
  ),
  Language(
    language: 'dart',
    difficulty: Difficulty.easy,
  ),
  Language(
    language: 'other trash',
    difficulty: Difficulty.easy,
  ),
  Language(
    language: 'NA',
    difficulty: Difficulty.easy,
  ),
];
