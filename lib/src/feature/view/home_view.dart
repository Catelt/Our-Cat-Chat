import 'package:flutter/material.dart';
import 'package:my_chat_gpt/src/constants/app_sizes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          toolbarHeight: 60,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Sizes.p16, horizontal: Sizes.p20),
            child: SafeArea(
              child: Container(
                height: 60,
                child: Row(
                  children: [
                    Icon(Icons.home),
                    Gaps.w8,
                    Text('Chat GPT'),
                    Spacer(),
                    Icon(Icons.volume_up),
                    Gaps.w8,
                    Icon(Icons.language)
                  ],
                ),
              ),
            ),
          )),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 30,
                    itemBuilder: (context, index) => Text(
                          "Hello",
                          style: TextStyle(fontSize: 20),
                        )),
              ),
            ),
            Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: Sizes.p20),
                  child: Row(
                    children: [
                      Expanded(
                          child: Material(
                        borderRadius: BorderRadius.circular(Sizes.p12),
                        elevation: 8,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Say something',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.p12),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.all(Sizes.p12),
                          ),
                        ),
                      ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
