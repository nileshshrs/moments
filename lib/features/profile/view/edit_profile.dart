import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moments/core/utils/image_picker_service.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';

class EditProfile extends StatefulWidget {
  final UserEntity user;
  const EditProfile(this.user, {super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<String> _uploadedImageUrls = [];
  final ImagePickerService _imagePickerService = ImagePickerService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.user.fullname ?? "";
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    _bioController.text = widget.user.bio ?? "";

    _fullNameController.addListener(_checkForChanges);
    _usernameController.addListener(_checkForChanges);
    _emailController.addListener(_checkForChanges);
    _bioController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    bool hasChanges =
        _fullNameController.text != (widget.user.fullname ?? "") ||
            _usernameController.text != (widget.user.username ?? "") ||
            _emailController.text != (widget.user.email ?? "") ||
            _bioController.text != (widget.user.bio ?? "");

    if (_isEdited != hasChanges) {
      setState(() {
        _isEdited = hasChanges;
      });
    }
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _imagePickerService.uploadImageToFirebase(imageFile).then((result) {
        if (result != null) {
          setState(() {
            _uploadedImageUrls = [result["url"]];
          });
        }
        context.read<ProfileBloc>().add(
              UpdateProfile(
                  email: _emailController.text,
                  username: _usernameController.text,
                  image: _uploadedImageUrls),
            );
      }).catchError((error) {
        debugPrint("Error uploading image: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: const Text(
                      "Edit profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                if (_isEdited)
                  IconButton(
                    onPressed: () {
                      // Save action
                      context.read<ProfileBloc>().add(
                            UpdateProfile(
                              email: _emailController.text,
                              username: _usernameController.text,
                              fullname: _fullNameController.text,
                              bio: _bioController.text,
                              image: [widget.user.image![0]]
                            ),
                          );
                    },
                    icon: const Icon(
                      Icons.check,
                      size: 25,
                      color: Colors.green,
                    ),
                  ),
                if (!_isEdited)
                  SizedBox(width: 48), // Ensures the text remains centered
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage(ImageSource.gallery, context);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        _uploadedImageUrls.isNotEmpty
                            ? _uploadedImageUrls[0]
                            : widget.user.image![0],
                      ),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
