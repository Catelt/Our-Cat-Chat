import 'package:flutter/material.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';

class CustomEditText extends StatefulWidget {
  const CustomEditText({super.key, required this.onSendText});
  final void Function(String) onSendText;

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleSendText() async {
    widget.onSendText(controller.text);
    controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(Sizes.p12),
          elevation: 8,
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: controller,
                decoration: InputDecoration(
                  hintText: S.of(context).hint_edit_text,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Sizes.p12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(Sizes.p12),
                ),
                onSubmitted: (value) {
                  _handleSendText();
                },
              )),
              IconButton(
                onPressed: _handleSendText,
                icon: Icon(
                  Icons.send_rounded,
                  size: Sizes.p28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
