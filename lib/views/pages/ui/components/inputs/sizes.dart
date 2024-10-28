import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/enums.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/input_text.dart';
import '../code_preview.dart';
import '../commons.dart';

class InputSizesPreview extends StatelessWidget {
  const InputSizesPreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Sizes', style: heading),
        verticalMargin16,
        const InputText(size: InputSize.small, label: 'Small'),
        verticalMargin8,
        const InputText(size: InputSize.medium, label: 'Medium'),
        verticalMargin8,
        const InputText(size: InputSize.large, label: 'Large'),
      ],
    );
  }
}

class InputSizesCode extends StatelessWidget {
  const InputSizesCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Small', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(code: ["const InputText(size: InputSize.small, label: 'Small'),"]),
        verticalMargin8,
        Text('Medium', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(code: ["const InputText(size: InputSize.medium, label: 'Medium'),"]),
        verticalMargin8,
        Text('Large', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(code: ["const InputText(size: InputSize.large, label: 'Large'),"]),
      ],
    );
  }
}
