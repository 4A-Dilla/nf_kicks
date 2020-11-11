import 'package:flutter/material.dart';

class BrandButton extends StatelessWidget {
  BrandButton({@required this.image, this.onSelected, this.border, this.color});

  final String image;
  final Function onSelected;
  final RoundedRectangleBorder border;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FlatButton(
        color: Colors.deepOrange,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(image, color: Colors.white),
        ),
      ),
    );
  }
}
