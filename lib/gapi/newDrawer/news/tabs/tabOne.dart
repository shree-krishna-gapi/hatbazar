

import 'package:flutter/material.dart';
import 'package:hatbazar/config/ps_colors.dart';
import 'package:hatbazar/utils/utils.dart';
class TabOne extends StatefulWidget {
  @override
  _TabOneState createState() => _TabOneState();
}

class _TabOneState extends State<TabOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
//                  color: Colors.black12,
        child: ListView(
          children: <Widget>[
            SubTitle(title: 'news__section__main__tab__heading1'),
            FirstRow(),
            SubTitle(title: 'news__section__main__tab__heading3'),
            SecondRow(),
            rowChips()
          ],
        )
    );
  }
  rowChips() {
    return Row(
      children: <Widget>[
        chipForRow('title1',Color(0xFF79aa93)),
        chipForRow('title1',Color(0xFF89ab33)),
        chipForRow('title1',Color(0xFF69a223)),
        chipForRow('title1',Color(0xFF89a113)),
      ],
    );
  }
  Widget chipForRow(String label,Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.green,
        child: Text('AB'),
      ),
        label: Text(label,style: TextStyle(color: Colors.white),

      ),backgroundColor: color,
    );
  }
}


class SubTitle extends StatelessWidget {
  SubTitle({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left:15.0,bottom: 5.0),
        child: Text('${Utils.getString(context, title)}',style: TextStyle(
            fontSize: 15,color: Colors.grey
        )),
      ),
    );
  }
}


class FirstRow extends StatelessWidget {
  double videoContainerWidth = 120.0;
  double videoContainerHeight = 80.0;
  double sizedBoxWidth = 10.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: sizedBoxWidth),
          Container(
           width: videoContainerWidth,
           child:   Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Container(
                 width: double.infinity,
                 height: videoContainerHeight,
                 color: Colors.lightGreen[300],
               ),
               Text('Some phonetically similar Nepali letters:',
                 style: TextStyle(fontSize: 14,color: Colors.black87),),
               Text('BBC News Nepali',
                 style: TextStyle(fontSize: 12,color: Colors.black38),)
             ],
           ),
         ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green,
                ),
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green[200],
                ),
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.lightGreen[300],
                ),
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green,
                ),
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green[200],
                ),
                Text('Some phonetically similar Nepali letters:',
                  style: TextStyle(fontSize: 14,color: Colors.black87),),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
class SecondRow extends StatelessWidget {
  double videoContainerWidth = 120.0;
  double videoContainerHeight = 80.0;
  double sizedBoxWidth = 10.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
//      color: Colors.black12,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.lightGreen[300],
                ),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green,
                ),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green[200],
                ),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.lightGreen[300],
                ),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green,
                ),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),
          SizedBox(width: sizedBoxWidth),
          Container(
            width: videoContainerWidth,
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: videoContainerHeight,
                  color: Colors.green[200],
                ),
                Text('BBC News Nepali',
                  style: TextStyle(fontSize: 12,color: Colors.black38),)
              ],
            ),
          ),

        ],
      ),
    );
  }
}

