import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class CheckboxItem<T> {
  final String text;
  final bool initialValue;
  final T data;

  const CheckboxItem({
    required this.text,
    this.initialValue = false,
    required this.data,
  });
}

class ButtonCheckBox<T> extends StatefulWidget {
  final List<CheckboxItem<T>> items;
  final void Function(List<T>) onChanged;
  final EdgeInsets? padding;

  const ButtonCheckBox({
    Key? key,
    required this.items,
    required this.onChanged,
    this.padding,
  }) : super(key: key);

  @override
  State<ButtonCheckBox<T>> createState() => _ButtonCheckBoxState<T>();
}

class _ButtonCheckBoxState<T> extends State<ButtonCheckBox<T>> {
  final List<bool> _values = [];
  final List<T> _selectedValues = [];

  @override
  void initState() {
    assert(widget.items.isNotEmpty);
    for (final item in widget.items) {
      _values.add(item.initialValue);
      if (item.initialValue) {
        _selectedValues.add(item.data);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (int index = 0; index < widget.items.length; index++)
          Padding(
            padding: widget.padding ?? rightPadding8 + bottomPadding8,
            child: InkWell(
              onTap: () {
                setState(() {
                  _values[index] = !_values[index];
                });
                updateSelectedValues(index);
                widget.onChanged(_selectedValues);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _values[index],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _values[index] = value;
                      });
                      updateSelectedValues(index);
                      widget.onChanged(_selectedValues);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                  Flexible(
                    child: Text(widget.items[index].text),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void updateSelectedValues(int index) {
    if (_values[index]) {
      _selectedValues.add(widget.items[index].data);
    } else {
      _selectedValues.remove(widget.items[index].data);
    }
  }
}
