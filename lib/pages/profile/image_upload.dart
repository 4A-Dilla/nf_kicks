import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';

class ImageUpload extends StatefulWidget {
  final String uid;
  final DatabaseApi databaseApi;

  const ImageUpload({Key key, @required this.uid, @required this.databaseApi})
      : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File _imageFile;
  final String _defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/nfkicks-35620.appspot.com/o/avatar.jpg?alt=media&token=a95e1f32-eb65-49cd-8e30-3f26693f4d2f";
  final picker = ImagePicker();

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<void> _uploadImage() async {
    widget.databaseApi.uploadUserAvatar(uid: widget.uid, imageFile: _imageFile);
    Navigator.pop(context);
    showToast(context, "Avatar image uploaded");
  }

  Future<void> _pickImage(ImageSource source) async {
    final selected = await picker.getImage(source: source);
    setState(() {
      if (selected != null) {
        _imageFile = File(selected.path);
      } else {
        showAlertDialog(context,
            title: "No image selected",
            description: "No image was selected",
            actionBtn: "OK");
      }
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> returnHome() {
      if (_imageFile != null) {
        return <Widget>[
          Image.file(
            _imageFile,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlineButton(
                borderSide: BorderSide(color: Colors.black, width: 2),
                color: Colors.white,
                child: Icon(
                  Icons.crop,
                  size: 30,
                  color: Colors.black,
                ),
                onPressed: _cropImage,
              ),
              OutlineButton(
                borderSide: BorderSide(color: Colors.green, width: 2),
                color: Colors.white,
                child: Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.green,
                ),
                onPressed: _uploadImage,
              ),
              OutlineButton(
                borderSide: BorderSide(color: Colors.red, width: 2),
                color: Colors.white,
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.red,
                ),
                onPressed: _clear,
              ),
            ],
          ),
        ];
      } else {
        return <Widget>[
          Image.network(
            _defaultImageUrl,
            scale: 1.6,
          ),
        ];
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Image Upload",
          style: GoogleFonts.permanentMarker(),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4,
        color: Colors.deepOrangeAccent,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.white,
                iconSize: 35,
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                color: Colors.white,
                iconSize: 35,
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: returnHome(),
      ),
    );
  }
}
