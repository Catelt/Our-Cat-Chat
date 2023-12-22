import 'package:flutter/material.dart';
import 'package:my_chat_gpt/src/utils/theme.dart';

class DialogSelectTheme extends StatelessWidget {
  const DialogSelectTheme({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildItem(context, ThemeMode.system),
        _buildItem(context, ThemeMode.light),
        _buildItem(context, ThemeMode.dark),
      ],
    );
  }

  Widget _buildItem(BuildContext context, ThemeMode mode) {
    return InkWell(
      onTap: () {
        _onChanged(context, mode.index);
      },
      child: Row(
        children: [
          _radio(context, mode.index),
          Expanded(child: Text(mode.getTitle)),
        ],
      ),
    );
  }

  Widget _radio(BuildContext context, int value) {
    return Radio(
      value: value,
      groupValue: selected,
      onChanged: (data) {
        if (data != null) {
          _onChanged(context, data);
        }
      },
    );
  }

  void _onChanged(BuildContext context, int value) {
    Navigator.of(context).pop();
    onSelected.call(value);
  }
}
