import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallerium/logic/services/navigation_service.dart';
import 'package:gallerium/presentation/screens/settings_screen.dart';
import 'package:gallerium/presentation/styles/colors.dart';
import 'package:gallerium/presentation/widgets/error_dialog.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;
  List<String> imageUrls = [];
  bool isLoading = false;
  bool isUploading = false; // Added for tracking upload progress

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final ListResult result = await FirebaseStorage.instance
          .ref()
          .child('uploads/${user.uid}')
          .listAll();

      final List<String> urls =
          await Future.wait(result.items.map((ref) => ref.getDownloadURL()));

      setState(() {
        imageUrls = urls;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load images: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            text: 'Hello, ',
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
            children: [
              TextSpan(
                text: auth.currentUser?.displayName ?? 'User',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              push(
                context,
                const SettingsScreen(),
              );
            },
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                'assets/images/settings.png',
                scale: 5,
              ),
            ),
          ),
        ],
        toolbarHeight: 80,
        elevation: 6,
        backgroundColor: quaternaryColor,
        shadowColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 34,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  elevation: 4,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: quaternaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search...',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 192, 192, 192),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Image.asset(
                          'assets/images/search.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : imageUrls.isEmpty
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 120),
                                child: Text(
                                  'No photos uploaded yet!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 50,
                                  bottom: 120,
                                ),
                                child: Image.asset(
                                  'assets/images/empty-folder.png',
                                  width: 256,
                                  height: 256,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                            bottom: 24,
                          ),
                          child: SizedBox(
                            height: 558,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: imageUrls.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrls[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
            ],
          ),
          if (isUploading) // Show the overlay only if uploading
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          Positioned(
            bottom: 24,
            left: MediaQuery.of(context).size.width / 2 - 32,
            child: GestureDetector(
              onTap: () async {
                final image = await pickImage();
                if (image != null) {
                  setState(() {
                    isUploading = true; // Set uploading to true
                  });
                  await uploadImage(image);
                  setState(() {
                    isUploading = false; // Set uploading to false
                  });
                }
              },
              child: Material(
                elevation: 6,
                shape: const CircleBorder(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/add-image.png',
                      scale: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    return image;
  }

  Future<void> uploadImage(XFile? image) async {
    if (image == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not logged in');
      return;
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('uploads/${user.uid}/${image.name}');

    try {
      await storageRef.putFile(File(image.path));
      final downloadURL = await storageRef.getDownloadURL();
      print('Download URL: $downloadURL');

      setState(() {
        imageUrls.add(downloadURL);
      });

      print(imageUrls);
    } catch (e) {
      showError(
        context,
        title: 'Couldn\'t upload image',
      );
    }
  }
}
