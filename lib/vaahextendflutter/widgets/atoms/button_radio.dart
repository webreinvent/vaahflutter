import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class RadioItem<T> {
  final String text;
  final T data;

  const RadioItem({
    required this.text,
    required this.data,
  });
}

class ButtonRadio<T> extends StatefulWidget {
  final T? initialValue;
  final List<RadioItem<T>> items;
  final void Function(T) onChanged;
  final EdgeInsets? padding;

  const ButtonRadio({
    Key? key,
    this.initialValue,
    required this.items,
    required this.onChanged,
    this.padding,
  }) : super(key: key);

  @override
  State<ButtonRadio<T>> createState() => _ButtonRadioState<T>();
}

class _ButtonRadioState<T> extends State<ButtonRadio<T>> {
  late T _selectedValue;

  @override
  void initState() {
    assert(widget.items.isNotEmpty);
    _selectedValue = widget.initialValue ?? widget.items.first.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (final item in widget.items)
          Padding(
            padding: widget.padding ?? rightPadding8 + bottomPadding8,
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedValue = item.data;
                });
                widget.onChanged(_selectedValue);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<T>(
                    value: item.data,
                    groupValue: _selectedValue,
                    onChanged: (T? value) {
                      if (value != null) {
                        setState(() {
                          _selectedValue = value;
                        });
                        widget.onChanged(_selectedValue);
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                  Flexible(
                    child: Text(item.text),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
