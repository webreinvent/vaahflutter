import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/resources/assets.dart';
import 'package:team/vaahextendflutter/widgets/atoms/inputs.dart';
import 'package:team/views/pages/ui/components/commons.dart';

class InputIcons extends StatelessWidget {
  const InputIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Icons', style: heading),
        verticalMargin16,
        const TextInput(
          size: InputSize.small,
          label: 'Small',
          prefixIconPath: ImageAssets.iconGeneralUser,
        ),
        verticalMargin8,
        const TextInput(
          size: InputSize.medium,
          label: 'Medium',
          prefixIconPath: ImageAssets.iconGeneralUser,
        ),
        verticalMargin8,
        const TextInput(
          size: InputSize.large,
          label: 'Large',
          prefixIconPath: ImageAssets.iconGeneralUser,
        ),
        verticalMargin8,
        const TextInput(
          label: 'Search',
          suffixIconPath: ImageAssets.iconGeneralSearch,
        ),
        verticalMargin8,
        TextInput(
          label: 'Search',
          prefixOnTap: () {
            Console.danger('hello');
          },
          suffixOnTap: () {
            Console.danger('world');
          },
          prefixIconPath: ImageAssets.iconGeneralUser,
          suffixIconPath: ImageAssets.iconGeneralSearch,
        ),
      ],
    );
  }
}
