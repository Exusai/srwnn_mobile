
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

List<String> imgList = [
  //'assets/icon.png',
  'assets/Banners/Banner2.png',
  'assets/Banners/Banner4.png',
  //'assets/Banners/Banner5.png',
  //'assets/Banners/BanneBGR1.png',
  'assets/Banners/BannerBGR2.png',
  //'assets/Banners/BannerBGR3.png',
  'assets/Banners/BannerBGR4.png',
];

class Carousel extends StatelessWidget {
  final List<Widget> imageSliders = imgList.map((item) => Container(
    child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: Stack(
          children: <Widget>[
            item == 'assets/icon.png' ? Image.asset(item, fit: BoxFit.cover) : Image.asset(item, fit: BoxFit.cover,),
          ],
        )
      ),
    ),
  )).toList();
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imageSliders, 
      options: CarouselOptions(
        aspectRatio: 2,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      )
    );
  }
}