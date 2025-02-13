import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moments/core/utils/image_picker_service.dart';
import 'package:moments/core/utils/permission_checker.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';

class CreatePostBottomSheet extends StatefulWidget {
  const CreatePostBottomSheet({super.key});

  @override
  CreatePostBottomSheetState createState() => CreatePostBottomSheetState();
}

class CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<File> _images = [];
  List<String> _uploadedImageUrls = [];
  final List<String> _firebasePaths = []; // Store Firebase paths for deletion
  final ImagePickerService _imagePickerService = ImagePickerService();

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      _uploadedImageUrls.removeAt(index);
    });
    _imagePickerService.deleteImage(_firebasePaths[index]);
    setState(() {
      _firebasePaths.removeAt(index);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Show image in UI immediately
      setState(() {
        _images.add(imageFile);
      });

      // Start background upload without calling ImagePicker again
      _imagePickerService.uploadImageToFirebase(imageFile).then((result) {
        if (result != null) {
          setState(() {
            _uploadedImageUrls.add(result["url"]); // Firebase Image URL
            _firebasePaths.add(result["path"]); // Firebase Storage Path
          });
        }
      }).catchError((error) {
        debugPrint("Error uploading image: $error");
      });
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
                      onPressed: (_images.isNotEmpty &&
                              _uploadedImageUrls.length == _images.length)
                          ? () async {
                              context.read<PostBloc>().add(CreatePost(
                                  content: _controller.text,
                                  images: _uploadedImageUrls));
                              // Clear the text controller
                              _controller.clear();
                              // Check if the widget is still mounted before calling setState and using context
                              if (!context.mounted) return;
                              setState(() {
                                _images = [];
                                _uploadedImageUrls = [];
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
                      PermissionChecker.checkCameraPermission();
                      _pickImage(ImageSource.camera);
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
                      _pickImage(ImageSource.gallery);
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
