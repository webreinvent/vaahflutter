import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/widgets/atoms/inputs.dart';
import 'package:team/views/pages/ui/components/commons.dart';

class InputSizes extends StatelessWidget {
  const InputSizes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Sizes', style: heading),
        verticalMargin16,
        const TextInput(size: InputSize.small, label: 'Small'),
        verticalMargin8,
        const TextInput(size: InputSize.medium, label: 'Medium'),
        verticalMargin8,
        const TextInput(size: InputSize.large, label: 'Large'),
      ],
    );
  }
}
