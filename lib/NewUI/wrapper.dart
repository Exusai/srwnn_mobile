
import 'package:flutter/cupertino.dart';
import 'package:srwnn_mobile/Controllers/ModelConfigs.dart';
import 'package:srwnn_mobile/Controllers/app_localizations.dart';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:srwnn_mobile/NewUI/srwnnExampleView.dart';

class Wrapper extends StatefulWidget {
  //const Wrapper({ Key? key }) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

//SRModelSelector selector = SRModelSelector();


class _WrapperState extends State<Wrapper> {
  List<String> categories = ["Súper Resolution", "Background Remover", "New", "Soon"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            alignment: Alignment.center,
            height: height/3.5,
            //width: 40,
            child: SRWNNExample(inImg: selector.getImageInExample(), outImg: selector.getImageOutExmaple(),),
          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: ElevatedButton(
            onPressed: (){
              
            }, 
            child: Text(AppLocalizations.of(context).translate('select_image_tr'),)
          ),
        ),
        SizedBox(height: 10,),
        //Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            //height: 400,
            decoration: BoxDecoration(
              color: Color(0xff0E0E0E),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
                bottomLeft: const Radius.circular(20.0),
                bottomRight: const Radius.circular(20.0),
              )
            ),
        
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 5,),
                SizedBox(
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return categoriesBuild(index, context);
                    }
                  ),
                ), 
                Divider(),
                Container(
                  alignment: Alignment.center,
                  child: controllers(),
                )
              ],
            ),
            
          ),
        ),
        SizedBox(height: 10,),
        
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: ElevatedButton(
            onPressed: (){
              
            }, 
            child: Text(AppLocalizations.of(context).translate('process'),)
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget controllers(){
    if (selectedIndex == 0){
      return Column(
        children: [
          Text(
            AppLocalizations.of(context).translate('style_tr'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          CupertinoSlidingSegmentedControl(
            children: styles, 
            onValueChanged: (int val) {
              setState(() {
                selector.style = val;
                message = selector.updateParameters();
              });
            },
            groupValue: selector.style,
          ),
          SizedBox(height: 10,),

          Text(
            AppLocalizations.of(context).translate('noise_lvl'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          CupertinoSlidingSegmentedControl(
            children: noise, 
            onValueChanged: (int val) {
              setState(() {
                selector.noiseLevel = val;
                message = selector.updateParameters();
              });
            },
            groupValue: selector.noiseLevel,
          ),
          SizedBox(height: 10,),

          Text(
            AppLocalizations.of(context).translate('blur_lvl'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5,),
          CupertinoSlidingSegmentedControl(
            children: blur, 
            onValueChanged: (int val) {
              setState(() {
                selector.blurLevel = val;
                message = selector.updateParameters();
              });
            },
            groupValue: selector.blurLevel,
          ),
          SizedBox(height: 10,),
          Text(
              AppLocalizations.of(context).translate(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange[900],
              ),
            ),
            SizedBox(height: 10,),
        ],
      );
    } else {
      return Container();
    }
  }

  GestureDetector categoriesBuild(int index, BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categories[index],
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: selectedIndex == index ? Colors.white : Colors.white70,
                  ),
                ),
                Container(
                  width: 90,
                  height: 2,
                  margin: EdgeInsets.only(top: 5),
                  color: selectedIndex == index ? Colors.white : Colors.transparent,
                )
              ],
            ),
            /* SizedBox(width: 10,),
            Container(
              width: 1,
              height: 20,
              color: Colors.grey,
            ) */
          ],
        ),
      ),
    );
  }
}