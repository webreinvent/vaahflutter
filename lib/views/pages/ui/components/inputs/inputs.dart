import 'package:flutter/material.dart';

import './complex.dart';
import './defaults.dart';
import './icons.dart';
import './sizes.dart';
import '../../../../../vaahextendflutter/app_theme.dart';
import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/widgets/atoms/app_expansion_panel.dart';
import '../../../../../vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';
import '../../../../../vaahextendflutter/widgets/atoms/tab_options.dart';

class AppInputs extends StatefulWidget {
  const AppInputs({Key? key}) : super(key: key);

  @override
  State<AppInputs> createState() => _AppInputsState();
}

class _AppInputsState extends State<AppInputs> {
  @override
  Widget build(BuildContext context) {
    return ContainerWithRoundedBorder(
      width: double.infinity,
      color: AppTheme.colors['white']!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inputs', style: TextStyles.semiBold7),
          verticalMargin24,
          TabOptions(
            tabs: [
              TabOption(
                name: 'Preview',
                tab: Column(
                  children: const [
                    InputTextPreview(),
                    verticalMargin24,
                    InputSizesPreview(),
                    verticalMargin24,
                    InputIconsPreview(),
                    verticalMargin24,
                    InputDateTimePreview(),
                    verticalMargin24,
                    InputSliderPreview(),
                    verticalMargin24,
                    InputFilePickerPreview(),
                    verticalMargin24,
                    InputAutoCompletePreview(),
                  ],
                ),
              ),
              TabOption(
                name: 'Code',
                tab: Column(
                  children: const [
                    ExpansionPanelWrap(
                      title: 'Input Text',
                      child: InputTextCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Input Sizes',
                      child: InputSizesCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Input Icons',
                      child: InputIconsCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Input Date Time',
                      child: InputDateTimeCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Input Slider',
                      child: InputSliderCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Input File Picker',
                      child: InputFilePickerCode(),
                    ),
                    verticalMargin8,
                    ExpansionPanelWrap(
                      title: 'Input Auto Complete',
                      child: InputAutoCompleteCode(),
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
