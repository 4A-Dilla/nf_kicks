import 'package:flutter/material.dart';
import 'package:nf_kicks/widgets/bottom_navigator_bar.dart';
import 'package:nf_kicks/widgets/brand_list_view.dart';
import 'package:nf_kicks/widgets/common_widgets.dart';
import 'package:nf_kicks/widgets/sidebar_home.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nf_Kicks',
      theme: mainThemeData,
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/logo.png',
            scale: 10,
          ),
          actions: <IconButton>[
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            BrandSliderListView(),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  SidebarHome(),
                  Expanded(
                    flex: 5,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Expanded(
                          child: Column(
                            children: [],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
