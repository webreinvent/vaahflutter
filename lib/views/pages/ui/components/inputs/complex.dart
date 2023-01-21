import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/vaahextendflutter/widgets/atoms/auto_complete_input.dart';
import 'package:team/vaahextendflutter/widgets/atoms/date_time_input.dart';
import 'package:team/vaahextendflutter/widgets/atoms/file_picker.dart';
import 'package:team/vaahextendflutter/widgets/atoms/slider_input.dart';
import 'package:team/views/pages/ui/components/commons.dart';

class ComplexInputsPreview extends StatefulWidget {
  const ComplexInputsPreview({Key? key}) : super(key: key);

  @override
  State<ComplexInputsPreview> createState() => _ComplexInputsPreviewState();
}

class _ComplexInputsPreviewState extends State<ComplexInputsPreview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        DateTimeSection(),
        verticalMargin16,
        SlidersSection(),
        verticalMargin16,
        AutoCompleteAndFilePickerSection(),
      ],
    );
  }
}

class DateTimeSection extends StatelessWidget {
  const DateTimeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Complex Inputs', style: heading),
        verticalMargin16,
        DateTimeInput(
          label: 'Choose Date',
          pickerType: PickerType.dateOnly,
          callback: (data) {
            Console.danger(data.toString());
          },
        ),
        verticalMargin16,
        DateTimeInput(
          label: 'Choose Time',
          pickerType: PickerType.timeOnly,
          callback: (data) {
            Console.danger(data.toString());
          },
        ),
        verticalMargin16,
        DateTimeInput(
          label: 'Choose Date And Time',
          pickerType: PickerType.dateAndTime,
          callback: (data) {
            Console.danger(data.toString());
          },
        ),
      ],
    );
  }
}

class SlidersSection extends StatelessWidget {
  const SlidersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sliders', style: heading),
        verticalMargin16,
        Text('basic slider', style: normal),
        SliderInput(
          initialValue: 0.8,
          onChanged: (_) => Console.danger(_.toString()),
        ),
        Text('with input slider', style: normal),
        SliderInput(
          min: 0,
          max: 100,
          initialValue: 50,
          step: 2,
          forceInputBox: true,
          onChanged: (_) => Console.danger(_.toString()),
        ),
        Text('step', style: normal),
        SliderInput(
          initialValue: 20,
          min: 0,
          max: 100,
          step: 20,
          onChanged: (_) => Console.danger(_.toString()),
        ),
        Text('decimal step', style: normal),
        SliderInput(
          initialValue: 4,
          min: 0,
          max: 10,
          step: 0.5,
          onChanged: (_) => Console.danger(_.toString()),
        ),
        Text('range slider', style: normal),
        RangeSliderInput(
          min: 0,
          max: 10,
          initialValues: const RangeValues(2, 6),
          step: 0.1,
          onChanged: (_) => Console.danger(_.toString()),
          precision: 1,
        ),
        Text('vertical slider', style: normal),
        SliderInput(
          initialValue: 0,
          onChanged: (_) => Console.danger(_.toString()),
          forceVertical: true,
        ),
      ],
    );
  }
}

class AutoCompleteAndFilePickerSection extends StatelessWidget {
  const AutoCompleteAndFilePickerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('File picker and Auto Complete', style: heading),
        verticalMargin16,
        VaahFilePicker(
          label: 'Pick Files',
          allowMultiple: true,
          callback: (List<PlatformFile>? files) {
            if (files == null) return;
            for (final element in files) {
              Console.danger(element.name);
            }
          },
        ),
        verticalMargin16,
        const AutoCompleteInput(
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
