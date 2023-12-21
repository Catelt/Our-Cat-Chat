import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';
import 'package:my_chat_gpt/src/localization/localization_utils.dart';
import 'package:my_chat_gpt/src/services/image_picker.dart';

class CustomEditText extends StatefulWidget {
  const CustomEditText({
    super.key,
    required this.onSendText,
    this.isLoading = false,
  });
  final void Function(String, String) onSendText;
  final bool isLoading;

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  final controller = TextEditingController();
  String path = '';
  bool isLoading = false;

  bool isValid = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      checkValid();
    });
    _setLoading(widget.isLoading);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomEditText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setLoading(widget.isLoading);
  }

  void _handleSendText() async {
    if (!isValid) return;
    widget.onSendText(controller.text.trim(), path);
    controller.text = '';
    _removeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(Sizes.p12),
          elevation: 8,
          child: Column(
            children: [
              _buildImage(),
              Row(
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
                    onPressed: () async {
                      final path = await XImagePicker().selectImage();
                      if (path != null) {
                        _addImage(path);
                      }
                    },
                    icon: const Icon(
                      Icons.image_rounded,
                      size: Sizes.p28,
                    ),
                  ),
                  IconButton(
                    onPressed: isValid ? _handleSendText : null,
                    icon: Icon(
                      Icons.send_rounded,
                      size: Sizes.p28,
                      color: isValid
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Visibility(
      visible: path.isNotEmpty,
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                File(path),
                height: 100,
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              onPressed: () {
                _removeImage();
              },
              icon: const Icon(Icons.close),
            ),
          )
        ],
      ),
    );
  }

  void _setLoading(bool value) {
    if (value != isLoading) {
      isLoading = value;
      checkValid();
      setState(() {});
    }
  }

  void _addImage(String path) {
    this.path = path;
    checkValid();
    setState(() {});
  }

  void _removeImage() {
    path = '';
    setState(() {});
  }

  void checkValid() {
    var check = isValid;
    check = _validation();
    // Just rebuild when different isValid
    if (check != isValid) {
      isValid = check;
      setState(() {});
    }
  }

  bool _validation() {
    if (isLoading) return false;
    if (path.isNotEmpty && controller.text.isEmpty) return false;
    if (controller.text.isEmpty) return false;
    return true;
  }
}
