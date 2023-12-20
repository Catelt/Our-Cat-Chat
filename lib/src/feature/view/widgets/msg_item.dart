import 'package:flutter/material.dart';
import 'package:my_chat_gpt/gen/assets.gen.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';

class MsgItem extends StatelessWidget {
  const MsgItem({
    super.key,
    required this.item,
    this.isSpeaking = false,
    this.isLast = false,
    this.index = 0,
  });

  final XMessage item;
  final bool isSpeaking;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isLeft = item.role.isModel;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p12).add(
            EdgeInsets.only(
                left: isLeft ? 0 : Sizes.p16, right: isLeft ? Sizes.p16 : 0)),
        child: isLeft ? msgBot(context) : msgUser(context));
  }

  Widget msgBot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.icApp.image(
            height: 30,
            width: 30,
          ),
          Gaps.w8,
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Sizes.p8, horizontal: Sizes.p16),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(Sizes.p12)),
              child: Text(
                item.msg,
                style: const TextStyle(fontSize: Sizes.p16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget msgUser(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Sizes.p8, horizontal: Sizes.p16),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(Sizes.p12)),
              child: Text(item.msg,
                  style: const TextStyle(
                      fontSize: Sizes.p16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
