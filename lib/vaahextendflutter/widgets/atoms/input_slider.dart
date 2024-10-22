import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

import '../../app_theme.dart';
import '../../helpers/constants.dart';
import 'input_text.dart';

class InputSlider extends StatefulWidget {
  final double initialValue;
  final Function(double)? onChanged;
  final Function(double)? onChangeStart;
  final Function(double)? onChangeEnd;
  final double min;
  final double max;
  final double? step;
  final String? label;
  final int? precision;
  final bool forceVertical;
  final bool forceInputBox;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  const InputSlider({
    super.key,
    required this.initialValue,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.step,
    this.label,
    this.precision,
    this.forceVertical = false,
    this.forceInputBox = false,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  @override
  State<InputSlider> createState() => _InputSliderState();
}

class _InputSliderState extends State<InputSlider> {
  String? err;
  late double _value;
  String? label;
  int? divisions;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    if (_value < widget.min) {
      err = 'Initial value is less than minimum value.';
      return;
    }
    if (_value > widget.max) {
      err = 'Initial value is greater than maximum value.';
      return;
    }
    controller.text = _value.toStringAsFixed(widget.precision ?? AppTheme.precision);
    if (widget.step != null) {
      divisions = (widget.max - widget.min) ~/ widget.step!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return err != null
        ? Padding(
            padding: bottomPadding8,
            child: Text(err!, style: TextStyle(color: AppTheme.colors['danger'])),
          )
        : Builder(
            builder: (context) {
              final SliderTheme slider = SliderTheme(
                data: SliderThemeData(
                  trackShape: TrackShape(),
                ),
                child: Slider(
                  value: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = double.parse(
                        value.toStringAsFixed(widget.precision ?? AppTheme.precision),
                      );
                    });
                    controller.text = _value.toString();
                    if (widget.onChanged != null) {
                      widget.onChanged!(_value);
                    }
                  },
                  onChangeStart: widget.onChangeStart,
                  onChangeEnd: widget.onChangeEnd,
                  min: widget.min,
                  max: widget.max,
                  divisions: divisions,
                  label: widget.label ??
                      _value.toStringAsFixed(widget.precision ?? AppTheme.precision),
                  activeColor: widget.activeColor ?? AppTheme.colors['primary'],
                  inactiveColor: widget.inactiveColor ?? AppTheme.colors['primary']!.shade200,
                  thumbColor: widget.thumbColor ?? AppTheme.colors['primary'],
                ),
              );
              if (widget.forceVertical) {
                return RotatedBox(
                  quarterTurns: -1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      slider,
                    ],
                  ),
                );
              }
              if (widget.forceInputBox) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (!widget.forceVertical && widget.forceInputBox)
                      Container(
                        margin: verticalPadding24,
                        child: InputText(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final double updatedValue =
                                (double.tryParse(value) ?? widget.initialValue)
                                    .clamp(widget.min, widget.max);
                            setState(() {
                              _value = updatedValue;
                            });
                          },
                          // TODO: fix to allow negative input
                          inputFormatters: [
                            services.FilteringTextInputFormatter.allow(
                                RegExp(r'^\-?\d+\.?\d{0,2}')),
                          ],
                        ),
                      ),
                    slider,
                  ],
                );
              }
              return slider;
            },
          );
  }
}

class InputRangeSlider extends StatefulWidget {
  final RangeValues initialValues;
  final Function(RangeValues)? onChanged;
  final Function(RangeValues)? onChangeStart;
  final Function(RangeValues)? onChangeEnd;
  final double min;
  final double max;
  final double? step;
  final RangeLabels? labels;
  final int? precision;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  const InputRangeSlider({
    super.key,
    required this.initialValues,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.step,
    this.labels,
    this.precision,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  @override
  State<InputRangeSlider> createState() => _InputRangeSliderState();
}

class _InputRangeSliderState extends State<InputRangeSlider> {
  late RangeValues _values;
  RangeLabels? _labels;
  int? divisions;
  String? err;

  @override
  void initState() {
    _values = widget.initialValues;
    if (widget.step != null && (widget.step! < widget.max)) {
      divisions = (widget.max - widget.min) ~/ widget.step!;
    }
    if (_values.start < widget.min || _values.end > widget.max) {
      err = "Failed assertion: 'values.start >= min && values.start <= max': is not true.";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return err != null
        ? Text(err!, style: TextStyle(color: AppTheme.colors['danger']))
        : SliderTheme(
            data: SliderThemeData(
              rangeTrackShape: RangeTrackShape(),
            ),
            child: RangeSlider(
              values: _values,
              onChanged: (values) {
                setState(() {
                  _values = RangeValues(
                    double.parse(
                        values.start.toStringAsFixed(widget.precision ?? AppTheme.precision)),
                    double.parse(
                        values.end.toStringAsFixed(widget.precision ?? AppTheme.precision)),
                  );
                  _labels = RangeLabels(
                    _values.start.toStringAsFixed(widget.precision ?? AppTheme.precision),
                    _values.end.toStringAsFixed(widget.precision ?? AppTheme.precision),
                  );
                });
                if (widget.onChanged != null) widget.onChanged!(_values);
              },
              onChangeStart: widget.onChangeStart,
              onChangeEnd: widget.onChangeEnd,
              min: widget.min,
              max: widget.max,
              labels: widget.labels ?? _labels,
              activeColor: widget.activeColor,
              inactiveColor: widget.inactiveColor,
              divisions: divisions,
            ),
          );
  }
}

class TrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class RangeTrackShape extends RoundedRectRangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
