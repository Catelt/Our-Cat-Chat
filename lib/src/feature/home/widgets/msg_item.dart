import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_chat_gpt/gen/assets.gen.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/network/model/message.dart';
import 'package:my_chat_gpt/src/utils/base64.dart';
import 'package:url_launcher/url_launcher.dart';

class MsgItem extends StatelessWidget {
  const MsgItem({
    super.key,
    required this.item,
  });

  final XMessage item;

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
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(Sizes.p12)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(context),
                  _buildMsg(context,
                      color: Theme.of(context).colorScheme.background),
                ],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildImage(context),
                  _buildMsg(context, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMsg(BuildContext context, {Color? color}) {
    return MarkdownBody(
      data: item.msg,
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href));
        }
      },
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: Sizes.p16, color: color),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (item.image.isNotEmpty) {
      final bytes = XBase64.convertBase64ToBytes(item.image);
      if (bytes != null) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.p8),
            child: Image.memory(
              bytes,
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
          ),
        );
      }
    }
    return const SizedBox();
  }
}
