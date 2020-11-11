import 'package:flutter/material.dart';
import 'package:nf_kicks/widgets/brand_button.dart';

class BrandSliderListView extends StatefulWidget {
  @override
  _BrandSliderListViewState createState() => _BrandSliderListViewState();
}

class _BrandSliderListViewState extends State<BrandSliderListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          BrandButton(
              image:
                  "https://assets.stickpng.com/images/5847f18dcef1014c0b5e485a.png"),
          BrandButton(
              image:
                  "https://www.thengfq.com/site/wp-content/uploads/2018/01/Q_Top100_Logos_UnderArmour-1.jpg"),
          BrandButton(
              image:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Adidas_Logo.svg/1200px-Adidas_Logo.svg.png"),
          BrandButton(
              image:
                  "https://upload.wikimedia.org/wikipedia/en/thumb/4/49/Puma_AG.svg/1200px-Puma_AG.svg.png"),
          BrandButton(
              image:
                  "https://seeklogo.com/images/C/converse-shoes-logo-2D01894308-seeklogo.com.png"),
          BrandButton(
              image:
                  "https://www.baldingbeards.com/wp-content/uploads/2019/03/timberland-logo-1024x576.png"),
        ],
      ),
    );
  }
}
