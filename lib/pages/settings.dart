import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/user_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery, requestFullMetadata: false);
              if (image != null) {
                ref.read(userProvider.notifier).updateProfilePic(File(image.path));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(foregroundImage: NetworkImage(currentUser.user.profileUrl), radius: 100,),
            ),
          ),
          Text("Click to update profile pic"),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Enter your name"
              ),
            ),
          ),
          TextButton(onPressed: () {
            ref.read(userProvider.notifier).updateName(_nameController.text);
          }, child: Text("Update Name"))
        ],
      ),
    );
  }
}
