import 'package:flutter/material.dart';

import './code_preview.dart';
import '../../../../vaahextendflutter/app_theme.dart';
import '../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../vaahextendflutter/widgets/atoms/app_expansion_panel.dart';
import '../../../../vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';
import '../../../../vaahextendflutter/widgets/atoms/tab_options.dart';

class AppThemeColors extends StatefulWidget {
  const AppThemeColors({Key? key}) : super(key: key);

  @override
  State<AppThemeColors> createState() => _AppThemeColorsState();
}

class _AppThemeColorsState extends State<AppThemeColors> {
  @override
  Widget build(BuildContext context) {
    return ContainerWithRoundedBorder(
      width: double.infinity,
      color: AppTheme.colors['white']!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AppTheme.colors', style: TextStyles.semiBold7),
          verticalMargin24,
          TabOptions(
            tabs: [
              TabOption(
                name: 'Preview',
                tab: Column(
                  children: [
                    ColorPalette(title: 'Primary', color: AppTheme.colors['primary']!),
                    verticalMargin8,
                    ColorPalette(title: 'Info', color: AppTheme.colors['info']!),
                    verticalMargin8,
                    ColorPalette(title: 'Success', color: AppTheme.colors['success']!),
                    verticalMargin8,
                    ColorPalette(title: 'Warning', color: AppTheme.colors['warning']!),
                    verticalMargin8,
                    ColorPalette(title: 'Danger', color: AppTheme.colors['danger']!),
                    verticalMargin8,
                    ColorPalette(title: 'Black', color: AppTheme.colors['black']!),
                    verticalMargin8,
                    ColorPalette(title: 'White', color: AppTheme.colors['white']!),
                  ],
                ),
              ),
              TabOption(
                name: 'Code',
                tab: Column(
                  children: [
                    ColorCodes(title: 'Primary', color: AppTheme.colors['primary']),
                    verticalMargin8,
                    ColorCodes(title: 'Info', color: AppTheme.colors['info']),
                    verticalMargin8,
                    ColorCodes(title: 'Success', color: AppTheme.colors['success']),
                    verticalMargin8,
                    ColorCodes(title: 'Warning', color: AppTheme.colors['warning']),
                    verticalMargin8,
                    ColorCodes(title: 'Danger', color: AppTheme.colors['danger']),
                    verticalMargin8,
                    ColorCodes(title: 'Black', color: AppTheme.colors['black']),
                    verticalMargin8,
                    ColorCodes(title: 'White', color: AppTheme.colors['white']),
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

class ColorPalette extends StatelessWidget {
  const ColorPalette({Key? key, required this.title, required this.color}) : super(key: key);

  final String title;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.regular4),
        verticalMargin8,
        Wrap(
          children: [
            colorBox(color),
            horizontalMargin16,
            colorBox(color.shade100),
            colorBox(color.shade200),
            colorBox(color.shade300),
            colorBox(color.shade400),
            colorBox(color.shade500),
            colorBox(color.shade600),
            colorBox(color.shade700),
            colorBox(color.shade800),
            colorBox(color.shade900),
          ],
        ),
      ],
    );
  }

  Widget colorBox(Color color) {
    return Padding(
      padding: rightPadding4 + bottomPadding4,
      child: Container(
        height: 20,
        width: 20,
        color: color,
      ),
    );
  }
}

@immutable
class ColorCodes extends StatelessWidget {
  const ColorCodes({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String title;
  final MaterialColor? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: bottomPadding1,
      child: AppExpansionPanel(
        padding: allPadding16,
        textStyle: TextStyles.regular4?.copyWith(color: AppTheme.colors['primary']),
        heading: title,
        children: color == null
            ? []
            : [
                Text(title, style: TextStyles.regular2),
                verticalMargin4,
                CodePreview(code: ["AppTheme.colors['${title.toLowerCase()}']"]),
                verticalMargin8,
                for (String shade in [
                  'shade50',
                  'shade100',
                  'shade200',
                  'shade300',
                  'shade400',
                  'shade500',
                  'shade600',
                  'shade700',
                  'shade800',
                  'shade900',
                ]) ...[
                  Text(shade, style: TextStyles.regular2),
                  verticalMargin4,
                  CodePreview(code: ["AppTheme.colors['${title.toLowerCase()}'].$shade"]),
                  verticalMargin8,
                ],
              ],
      ),
    );
  }
}
