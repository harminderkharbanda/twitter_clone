import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/create.dart';
import 'package:twitter_clone/pages/settings.dart';
import 'package:twitter_clone/providers/tweet_provider.dart';
import 'package:twitter_clone/providers/user_provider.dart';

import '../models/tweet.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Image(image: AssetImage('assets/images/twitter_logo.png'), width: 50,),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => {
                Scaffold.of(context).openDrawer()
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(backgroundImage: NetworkImage(currentUser.user.profileUrl),),
              ),
            );
          }
        ),
        bottom: PreferredSize(preferredSize: Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 1.0,
            )),
      ),
      body: ref.watch(feedProvider).when(
          data: (List<Tweet> tweets) {
            return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                  );
                },
                itemCount: tweets.length,
                itemBuilder: (context, count) {
                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(tweets[count].profileUrl),),
                    title: Text(tweets[count].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    subtitle: Text(tweets[count].tweet),

                  );
            });
          },
          error: (err, stackTrace) => const Center(child: Text("Error"),),
          loading: () => const CircularProgressIndicator()
          ),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(currentUser.user.profileUrl),
            ListTile(title: Text("Hello, ${currentUser.user.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),),
            ListTile(
              title: Text("Settings"),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },),
            ListTile(
              title: Text("Sign out"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTweet()));
          },
          child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
