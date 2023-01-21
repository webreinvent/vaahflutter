import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';
import 'package:team/vaahextendflutter/widgets/atoms/inputs.dart';
import 'package:team/views/pages/ui/components/code_preview.dart';
import 'package:team/views/pages/ui/components/commons.dart';

class DefaultTextInputsPreview extends StatelessWidget {
  const DefaultTextInputsPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Defaults', style: heading),
          verticalMargin16,
          const TextInput(label: 'Default'),
          verticalMargin8,
          const TextInput(label: 'Disabled', isEnabled: false),
          verticalMargin8,
          TextInput(label: 'Invalid', validator: (_) => 'Message'),
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

class DefaultTextInputsCode extends StatelessWidget {
  const DefaultTextInputsCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Simple', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(code: ["const TextInput(label: 'Simple'),"]),
        verticalMargin8,
        Text('Disabled', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(code: ["const TextInput(label: 'Disabled', isEnabled: false),"]),
        verticalMargin8,
        Text('Invalid', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "TextInput(",
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
