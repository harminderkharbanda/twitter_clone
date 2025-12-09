import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';

class CreateTweet extends ConsumerWidget {
  CreateTweet({super.key});
  final TextEditingController _tweetController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post a Tweet"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _tweetController,
                maxLines: 4,
                maxLength: 280,
                decoration: InputDecoration(border: OutlineInputBorder(),),
              ),
            ),
            TextButton(onPressed: () {
              ref.read(tweetProvider).postTweet(_tweetController.text);
            }, child: Text("Post"))
          ],
        ),
      ),
    );
  }
}
