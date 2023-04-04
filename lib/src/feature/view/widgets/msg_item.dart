import 'package:flutter/material.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';

class MsgItem extends StatelessWidget {
  const MsgItem({super.key, required this.item, required this.onSpeak});

  final XMessage item;
  final void Function(String) onSpeak;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(item.msg),
        IconButton(
            onPressed: () {
              onSpeak(item.msg);
            },
            icon: Icon(Icons.volume_down_alt))
      ],
    );
  }
}
