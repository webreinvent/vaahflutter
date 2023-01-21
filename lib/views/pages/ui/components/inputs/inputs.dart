import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';
import 'package:team/vaahextendflutter/widgets/atoms/app_expansion_panel.dart';
import 'package:team/vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';
import 'package:team/vaahextendflutter/widgets/atoms/tab_options.dart';
import 'package:team/views/pages/ui/components/inputs/defaults.dart';
import 'package:team/views/pages/ui/components/inputs/icons.dart';
import 'package:team/views/pages/ui/components/inputs/sizes.dart';

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
          Text('Text Inputs', style: TextStyles.semiBold7),
          verticalMargin24,
          TabOptions(
            tabs: [
              TabOption(
                name: 'Preview',
                tab: Column(
                  children: const [
                    DefaultTextInputsPreview(),
                    verticalMargin24,
                    InputSizesPreview(),
                    verticalMargin24,
                    InputIconsPreview(),
                  ],
                ),
              ),
              TabOption(
                name: 'Code',
                tab: Column(
                  children: const [
                    ExpansionPanelWrap(
                      title: 'Defaults',
                      child: DefaultTextInputsCode(),
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
