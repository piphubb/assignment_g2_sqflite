import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen ({super.key});
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  _loadImages() async {
    final loadedImages = await dbHelper.getAllImages();
    setState(() {
      images = loadedImages;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final int imageId = await dbHelper.insertImage(pickedFile.path);
      _loadImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker and SQLite'),
      ),
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imagePath = images[index]['image_path'];
          final imageId = images[index]['id'];
          return ListTile(
            title: Text('Image ID: $imageId'),
            leading: Image.file(File(imagePath)),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.deleteImage(imageId);
                _loadImages();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImagePickerScreen(),
  ));
}
