// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';
import '../../widgets/constants.dart';
import '../loading_page.dart';

class ImageUpload extends StatefulWidget {
  final String uid;
  final DatabaseApi databaseApi;

  const ImageUpload({Key key, @required this.uid, @required this.databaseApi})
      : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool _isLoading = false;

  File _imageFile;
  final String _defaultImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/nfkicks-35620.appspot.com/o/avatar.jpg?alt=media&token=a95e1f32-eb65-49cd-8e30-3f26693f4d2f";
  final picker = ImagePicker();

  Future<void> _cropImage() async {
    final File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<void> _uploadImage() async {
    setState(() {
      _isLoading = true;
    });
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
    if (_isLoading) {
      return Loading(
        loadingWidget: kLoadingLogo,
      );
    }
    List<Widget> returnHome() {
      if (_imageFile != null) {
        return <Widget>[
          Image.file(
            _imageFile,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlineButton(
                borderSide: const BorderSide(width: 2),
                color: Colors.white,
                onPressed: _cropImage,
                child: const Icon(
                  Icons.crop,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              OutlineButton(
                borderSide: const BorderSide(color: Colors.green, width: 2),
                color: Colors.white,
                onPressed: _uploadImage,
                child: const Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.green,
                ),
              ),
              OutlineButton(
                borderSide: const BorderSide(color: Colors.red, width: 2),
                color: Colors.white,
                onPressed: _clear,
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.red,
                ),
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
                icon: const Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                color: Colors.white,
                iconSize: 35,
                icon: const Icon(Icons.photo_library),
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
