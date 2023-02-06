import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';
import 'package:team/vaahextendflutter/widgets/atoms/input_text.dart';
import 'package:team/views/pages/ui/components/code_preview.dart';
import 'package:team/views/pages/ui/components/commons.dart';

class InputTextPreview extends StatelessWidget {
  const InputTextPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Input Text', style: heading),
          verticalMargin16,
          const InputText(label: 'Default'),
          verticalMargin8,
          const InputText(label: 'Disabled', isEnabled: false),
          verticalMargin8,
          InputText(label: 'Invalid', validator: (_) => 'Message'),
          verticalMargin8,
          ElevatedButton(
            onPressed: () => formKey.currentState?.validate(),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class InputTextCode extends StatelessWidget {
  const InputTextCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Simple', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(code: ["const InputText(label: 'Simple'),"]),
        verticalMargin8,
        Text('Disabled', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(code: ["const InputText(label: 'Disabled', isEnabled: false),"]),
        verticalMargin8,
        Text('Invalid', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "InputText(",
            "    label: 'Invalid',",
            "    validator: (value) {",
            "        if (value!.isEmpty) {",
            "            return 'Field is empty';",
            "        }",
            "        return null;",
            "    },",
            "),",
            "",
            "",
            "// Call below method to validate, also wrap the input with form and key",
            "formKey.currentState?.validate()"
          ],
        ),
      ],
    );
  }
}
