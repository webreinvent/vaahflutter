import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/helpers/styles.dart';
import 'package:team/vaahextendflutter/widgets/atoms/app_expansion_panel.dart';
import 'package:team/vaahextendflutter/widgets/atoms/container_with_rounded_border.dart';
import 'package:team/views/pages/ui/components/section_title_selector.dart';

class AppThemeColors extends StatefulWidget {
  const AppThemeColors({Key? key}) : super(key: key);

  @override
  State<AppThemeColors> createState() => _AppThemeColorsState();
}

class _AppThemeColorsState extends State<AppThemeColors> {
  int _selectedIndex = 0;

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
          tabOptions(),
          Divider(color: AppTheme.colors['primary']!.shade200),
          verticalMargin16,
          _selectedIndex == 0 ? preview() : code(),
        ],
      ),
    );
  }

  Widget tabOptions() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        sectionTitleSelector(
          title: 'Preview',
          condition: _selectedIndex == 0,
          callback: () {
            setState(() {
              _selectedIndex = 0;
            });
          },
        ),
        verticalMargin12,
        horizontalMargin12,
        sectionTitleSelector(
          title: 'Code',
          condition: _selectedIndex == 1,
          callback: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
        ),
      ],
    );
  }
}

Widget preview() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
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
  );
}

Widget code() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
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
  );
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
        headerBuilder: (BuildContext context, ExpansionControl control) {
          return InkWell(
            onTap: () {
              control.expanded = !control.expanded;
            },
            child: Padding(
              padding: allPadding16,
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: TextStyles.bold5),
                  ),
                  const AppExpansionPanelIcon(),
                ],
              ),
            ),
          );
        },
        children: color == null
            ? []
            : [
                Text('Primary', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}']"),
                verticalMargin8,
                Text('shade50', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade50"),
                verticalMargin8,
                Text('shade100', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade100"),
                verticalMargin8,
                Text('shade200', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade200"),
                verticalMargin8,
                Text('shade300', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade300"),
                verticalMargin8,
                Text('shade400', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade400"),
                verticalMargin8,
                Text('shade500', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade500"),
                verticalMargin8,
                Text('shade600', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade600"),
                verticalMargin8,
                Text('shad700', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade700"),
                verticalMargin8,
                Text('shade800', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade800"),
                verticalMargin8,
                Text('shade900', style: TextStyles.regular2),
                verticalMargin4,
                codePreview("AppTheme.colors['${title.toLowerCase()}'].shade900"),
              ],
      ),
    );
  }

  Widget codePreview(String code) {
    return ContainerWithRoundedBorder(
      width: double.infinity,
      color: AppTheme.colors['black']!,
      padding: allPadding12,
      borderRadius: 6,
      child: Text(
        code,
        style: TextStyles.regular2?.copyWith(color: AppTheme.colors['white']),
      ),
    );
  }
}
