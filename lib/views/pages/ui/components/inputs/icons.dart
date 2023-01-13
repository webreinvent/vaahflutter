import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/alerts.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
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
          prefixIcon: FontAwesomeIcons.user,
        ),
        verticalMargin8,
        const TextInput(
          size: InputSize.medium,
          label: 'Medium',
          prefixIcon: FontAwesomeIcons.user,
        ),
        verticalMargin8,
        const TextInput(
          size: InputSize.large,
          label: 'Large',
          prefixIcon: FontAwesomeIcons.user,
        ),
        verticalMargin8,
        const TextInput(
          label: 'Search',
          suffixIcon: FontAwesomeIcons.magnifyingGlass,
        ),
        verticalMargin8,
        TextInput(
          label: 'Search',
          prefixOnTap: () {
            Alerts.showSuccessToast!(content: 'Prefix icon onTap');
          },
          suffixOnTap: () {
            Alerts.showErrorToast!(content: 'Suffix icon onTap');
          },
          prefixIcon: FontAwesomeIcons.user,
          prefixIconColor: AppTheme.colors['primary'],
          suffixIcon: FontAwesomeIcons.magnifyingGlass,
          suffixIconColor: AppTheme.colors['primary'],
        ),
      ],
    );
  }
}
