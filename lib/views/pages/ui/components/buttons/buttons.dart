import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/app_theme.dart';
import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/app_expansion_panel.dart';
import '../../../../../vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';
import '../../../../../vaahextendflutter/widgets/atoms/tab_options.dart';
import 'elevated.dart';
import 'extra.dart';
import 'icon.dart';
import 'icon_and_label.dart';
import 'outlined.dart';
import 'radioandcheckbox.dart';
import 'rating_bar.dart';
import 'text.dart';

class Buttons extends StatelessWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerWithRoundedBorder(
      width: double.infinity,
      color: AppTheme.colors['white']!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buttons', style: TextStyles.semiBold7),
          verticalMargin24,
          TabOptions(
            tabs: [
              TabOption(
                name: 'Preview',
                tab: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ButtonElevatedPreview(),
                    Divider(height: defaultPadding * 2),
                    ButtonTextPreview(),
                    Divider(height: defaultPadding * 2),
                    ButtonOutlinedPreview(),
                    Divider(height: defaultPadding * 2),
                    ButtonIconPreview(),
                    Divider(height: defaultPadding * 2),
                    ButtonIconLabelPreview(),
                    Divider(height: defaultPadding * 2),
                    ButtonExtrasPreview(),
                    Divider(height: defaultPadding * 2),
                    ButtonRadioAndCheckboxPreview(),
                    Divider(height: defaultPadding * 2),
                    RatingBarPreview(),
                  ],
                ),
              ),
              TabOption(
                name: 'Code',
                tab: Column(
                  children: const [
                    ExpansionPanelWrap(
                      title: 'Elevated Buttons',
                      child: ButtonElevatedCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Text Buttons',
                      child: ButtonTextCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Outlined Buttons',
                      child: ButtonOutlinedCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Icon Buttons',
                      child: ButtonIconCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Label and Icon Buttons',
                      child: ButtonIconLabelCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Button Properties',
                      child: ButtonExtrasCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Radio and Checkbox Buttons',
                      child: ButtonRadioAndCheckboxCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Rating Bar',
                      child: RatingBarCode(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@immutable
class ExpansionPanelWrap extends StatelessWidget {
  const ExpansionPanelWrap({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: bottomPadding1,
      child: AppExpansionPanel(
        padding: allPadding16,
        textStyle: TextStyles.regular4?.copyWith(color: AppTheme.colors['primary']),
        heading: title,
        children: [
          child,
        ],
      ),
    );
  }
}
