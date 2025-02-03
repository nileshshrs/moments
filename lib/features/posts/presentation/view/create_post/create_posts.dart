import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePostBottomSheet extends StatefulWidget {
  const CreatePostBottomSheet({super.key});

  @override
  _CreatePostBottomSheetState createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<File> _images = []; // List to store selected images

  Future<void> checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future _browseImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _images.add(File(image.path)); // Append the image to the list
          print('Image List: $_images'); // Print the image list to console
          context.read<PostBloc>().add(UploadImage(files: _images));
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = 16.0; // Horizontal padding for the images
    int extraImagesCount = _images.length - 3; // Number of images beyond 3

    return Material(
      color: Colors.white, // Modal background color
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Flex(
          direction: Axis.vertical, // Align children vertically
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[400]!, // Bottom border color
                    width: 1.0, // Bottom border width
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 20),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Align to both ends
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 17,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _images = [];
                            });
                            Navigator.pop(context); // Close the modal
                          },
                        ),
                        const Text(
                          'Create post',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _images.isNotEmpty
                          ? () async {
                              context
                                  .read<PostBloc>()
                                  .add(CreatePost(content: _controller.text));

                              // Wait for 2 seconds
                              await Future.delayed(Duration(seconds: 2));

                              // Clear the text controller
                              _controller.clear();

                              // Check if the widget is still mounted before calling setState and using context
                              if (!context.mounted) return;

                              setState(() {
                                _images = [];
                              });

                              Navigator.pop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0), // Button padding
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_images.isEmpty) ...[
                        SizedBox(
                          width: screenWidth - 2 * padding,
                          height: screenWidth - 2 * padding,
                        ),
                      ] else if (_images.isNotEmpty) ...[
                        if (_images.length == 1) ...[
                          Stack(
                            children: [
                              SizedBox(
                                width: screenWidth - 2 * padding,
                                height: screenWidth - 2 * padding,
                                child: Image.file(
                                  _images[0],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.white),
                                    onPressed: () => _removeImage(0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else if (_images.length == 2) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(2, (index) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    width: (screenWidth - 2 * padding) / 2,
                                    height: (screenWidth - 2 * padding) / 2,
                                    child: Image.file(
                                      _images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () => _removeImage(index),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ] else if (_images.length == 3) ...[
                          Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: screenWidth - 2 * padding,
                                    height: screenWidth - 2 * padding,
                                    child: Image.file(
                                      _images[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () => _removeImage(0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(2, (index) {
                                  return Stack(
                                    children: [
                                      SizedBox(
                                        width: (screenWidth - 2 * padding) / 2,
                                        height: (screenWidth - 2 * padding) / 2,
                                        child: Image.file(
                                          _images[index + 1],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          child: IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.white),
                                            onPressed: () =>
                                                _removeImage(index + 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ] else if (_images.length > 3) ...[
                          Column(
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: screenWidth - 2 * padding,
                                    height: screenWidth - 2 * padding,
                                    child: Image.file(
                                      _images[0],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        onPressed: () => _removeImage(0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(2, (index) {
                                  return Stack(
                                    children: [
                                      SizedBox(
                                        width: (screenWidth - 2 * padding) / 2,
                                        height: (screenWidth - 2 * padding) / 2,
                                        child: Image.file(
                                          _images[index + 1],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          child: IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.white),
                                            onPressed: () =>
                                                _removeImage(index + 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  '+$extraImagesCount more',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  TextButton(
                    onPressed: () {
                      checkCameraPermission();
                      _browseImage(ImageSource.camera);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey, width: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.lightBlue,
                            size: 20.0,
                          ),
                          const SizedBox(width: 8),
                          const Text("Camera",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _browseImage(ImageSource.gallery);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey, width: 0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/Ivw7nhRtXyo.png",
                            height: 20.0,
                            width: 20.0,
                          ),
                          const SizedBox(width: 8),
                          const Text("Gallery",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
