import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/enums.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';
import 'package:team/vaahextendflutter/widgets/atoms/input_text.dart';
import 'package:team/views/pages/ui/components/code_preview.dart';
import 'package:team/views/pages/ui/components/commons.dart';

class InputSizesPreview extends StatelessWidget {
  const InputSizesPreview({Key? key}) : super(key: key);

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
  const InputSizesCode({Key? key}) : super(key: key);

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
