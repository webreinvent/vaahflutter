import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../../vaahextendflutter/helpers/constants.dart';
import '../../../../../vaahextendflutter/helpers/styles.dart';
import '../../../../../vaahextendflutter/services/logging_library/logging_library.dart';
import '../../../../../vaahextendflutter/widgets/atoms/input_auto_complete.dart';
import '../../../../../vaahextendflutter/widgets/atoms/input_date_time.dart';
import '../../../../../vaahextendflutter/widgets/atoms/input_file_picker.dart';
import '../../../../../vaahextendflutter/widgets/atoms/input_slider.dart';
import '../code_preview.dart';
import '../commons.dart';

class InputDateTimePreview extends StatelessWidget {
  const InputDateTimePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Date Time', style: heading),
        verticalMargin16,
        InputDateTime(
          label: 'Choose Date',
          pickerType: PickerType.dateOnly,
          callback: (data) {
            Log.info(data, disableCloudLogging: true);
          },
        ),
        verticalMargin16,
        InputDateTime(
          label: 'Choose Time',
          pickerType: PickerType.timeOnly,
          callback: (data) {
            Log.info(data, disableCloudLogging: true);
          },
        ),
        verticalMargin16,
        InputDateTime(
          label: 'Choose Date And Time',
          pickerType: PickerType.dateAndTime,
          callback: (data) {
            Log.info(data, disableCloudLogging: true);
          },
        ),
      ],
    );
  }
}

class InputDateTimeCode extends StatelessWidget {
  const InputDateTimeCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Only', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "DateTimeInput(",
            "    label: 'Choose Date',",
            "    pickerType: PickerType.dateOnly,",
            "    callback: (data) {",
            "        Console.danger(data.toString());",
            "    },",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Time Only', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "DateTimeInput(",
            "    label: 'Choose Time',",
            "    pickerType: PickerType.timeOnly,",
            "    callback: (data) {",
            "        Console.danger(data.toString());",
            "    },",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Date and Time both', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "DateTimeInput(",
            "    label: 'Choose Date And Time',",
            "    pickerType: PickerType.dateAndTime,",
            "    callback: (data) {",
            "        Console.danger(data.toString());",
            "    },",
            "),",
          ],
        ),
      ],
    );
  }
}

class InputSliderPreview extends StatelessWidget {
  const InputSliderPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Sliders', style: heading),
        verticalMargin16,
        Text('basic slider', style: normal),
        InputSlider(
          initialValue: 0.8,
          onChanged: (value) => Log.info(value, disableCloudLogging: true),
        ),
        Text('with input slider', style: normal),
        InputSlider(
          min: 0,
          max: 100,
          initialValue: 50,
          step: 2,
          forceInputBox: true,
          onChanged: (value) => Log.info(value, disableCloudLogging: true),
        ),
        Text('step', style: normal),
        InputSlider(
          initialValue: 20,
          min: 0,
          max: 100,
          step: 20,
          onChanged: (value) => Log.info(value, disableCloudLogging: true),
        ),
        Text('decimal step', style: normal),
        InputSlider(
          initialValue: 4,
          min: 0,
          max: 10,
          step: 0.5,
          onChanged: (value) => Log.info(value, disableCloudLogging: true),
        ),
        Text('vertical slider', style: normal),
        Padding(
          padding: verticalPadding24,
          child: InputSlider(
            initialValue: 0,
            onChanged: (value) => Log.info(value, disableCloudLogging: true),
            forceVertical: true,
          ),
        ),
        Text('range slider', style: normal),
        InputRangeSlider(
          min: 0,
          max: 10,
          initialValues: const RangeValues(2, 6),
          step: 0.1,
          onChanged: (value) => Log.info(value, disableCloudLogging: true),
          precision: 1,
        ),
      ],
    );
  }
}

class InputSliderCode extends StatelessWidget {
  const InputSliderCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Basic Slider', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "SliderInput(",
            "    initialValue: 0.0,",
            "    onChanged: (_) => Console.danger(_.toString()),",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Slider With Input', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "SliderInput(",
            "    min: 0,",
            "    max: 100,",
            "    initialValue: 50,",
            "    forceInputBox: true,",
            "    onChanged: (_) => Console.danger(_.toString()),",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Slider With Steps', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "SliderInput(",
            "    initialValue: 20,",
            "    min: 0,",
            "    max: 100,",
            "    step: 20,",
            "    onChanged: (_) => Console.danger(_.toString()),",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Slider With Decimal Steps', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "SliderInput(",
            "    initialValue: 4,",
            "    min: 0,",
            "    max: 10,",
            "    step: 0.5,",
            "    onChanged: (_) => Console.danger(_.toString()),",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Vertical Slider', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "SliderInput(",
            "    initialValue: 0,",
            "    onChanged: (_) => Console.danger(_.toString()),",
            "    forceVertical: true,",
            "),",
          ],
        ),
        verticalMargin8,
        Text('Range Slider', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "RangeSliderInput(",
            "    min: 0,",
            "    max: 10,",
            "    initialValues: const RangeValues(2, 6),",
            "    step: 0.1,",
            "    onChanged: (_) => Console.danger(_.toString()),",
            "    precision: 1,",
            "),",
          ],
        ),
      ],
    );
  }
}

class InputFilePickerPreview extends StatelessWidget {
  const InputFilePickerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input File Picker', style: heading),
        verticalMargin16,
        InputFilePicker(
          label: 'Pick Files',
          allowMultiple: true,
          callback: (List<PlatformFile>? files) {
            if (files == null) return;
            for (final element in files) {
              Log.info(element.name, disableCloudLogging: true);
            }
          },
        ),
      ],
    );
  }
}

class InputFilePickerCode extends StatelessWidget {
  const InputFilePickerCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input File Picker', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "VaahFilePicker(",
            "    label: 'Pick Files',",
            "    allowMultiple: true,",
            "    callback: (List<PlatformFile>? files) {",
            "        if (files == null) return;",
            "        for (final element in files) {",
            "            Console.danger(element.name);",
            "        }",
            "    },",
            "),",
          ],
        ),
      ],
    );
  }
}

class InputAutoCompletePreview extends StatelessWidget {
  const InputAutoCompletePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Auto Complete', style: heading),
        verticalMargin16,
        const InputAutoComplete(
          label: 'Select Continent',
          hints: [
            'Asia',
            'Africa',
            'North America',
            'South America',
            'Antarctica',
            'Europe',
            'Australia',
          ],
        ),
        const SizedBox(height: 250),
      ],
    );
  }
}

class InputAutoCompleteCode extends StatelessWidget {
  const InputAutoCompleteCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Input Auto Complete', style: TextStyles.regular2),
        verticalMargin4,
        const CodePreview(
          code: [
            "const AutoCompleteInput(",
            "    label: 'Select Continent',",
            "    hints: [",
            "        'Asia',",
            "        'Africa',",
            "        'North America',",
            "        'South America',",
            "        'Antarctica',",
            "        'Europe',",
            "        'Australia',",
            "    ],",
            "),",
          ],
        ),
      ],
    );
  }
}
