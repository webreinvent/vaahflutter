import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/widgets/atoms/inputs.dart';
import 'package:team/views/pages/ui/components/commons.dart';

class DefaultTextInputs extends StatelessWidget {
  const DefaultTextInputs({Key? key}) : super(key: key);

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
