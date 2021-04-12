// import 'package:flutter/material.dart';
// import "package:pull_to_refresh/pull_to_refresh.dart";


// class Pulltorefresh extends StatefulWidget{
//   final Function headerResult;
//   final Function footerResult;
//   final bool isHeaderShow;
//   final bool isFooterShow;
//   final List<Widget> data;
//   final double height;
//   final Axis axis; 
//   final bool isScrollbar;
//   final RefreshController controller;
//   Pulltorefresh({
//   Key key, 
//   this.headerResult, 
//   this.footerResult,
//   this.controller, 
//   @required this.data, 
//   @required this.height,
//   this.isHeaderShow: true,
//   this.isFooterShow: true,
//   this.axis: Axis.vertical,
//   this.isScrollbar: false,
//   });
//   PulltorefreshState createState() => new PulltorefreshState();

// }
// class PulltorefreshState extends State<Pulltorefresh> {
//   RefreshController refreshController;

//   @override
//   void initState() {
//     refreshController = new RefreshController();
//     super.initState();
//   }
//   Widget _buildHeader(context,mode){
//       var str;
//       if (mode == 2) {
//         str = Text('松手刷新');
//       }else if(mode == 1) {
//         str = Text('松手刷新');
//       } else if (mode == 3){
//         str = Text('刷新成功');
//       } else if (mode == 4) {
//          str = Text('4');
//       } else {
//         str = Text('下拉刷新');
//       }
//       return Container(
//         padding: EdgeInsets.only(bottom: 10.0),
//         child: str,
//       );
      
//       // return new ClassicIndicator(
//       //   mode: mode, 
//       //   textStyle: TextStyle(color: Colors.grey),
//       //   refreshingText: '刷新',
//       //   releaseText: '松手',
//       //   idleText: '下拉刷新',
//       //   completeText: '刷新成功',
//       // );
//     }
//     Widget _footerBuilder(context,mode) {
//         var str;
       
//         if (mode == 6) {
//            str = 
//            Container(
//              height: 40.0,
//              width: MediaQuery.of(context).size.width,
//              child: Center(
//                child: Container(
//                  width: 100.0,
//                  child:  Row(
//                   children: <Widget>[
//                     CircularProgressIndicator(),
//                     Text('加载中...')
//                   ],
//                 ),
//                ),
//              )
             
            
//            ) ;
//         }  else {
//           str = Text('');
//         }
//         return str;

//     }
//   @override
//   Widget build(BuildContext context) {
//     var cont = widget.controller == null ? refreshController : widget.controller;
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: widget.height,
//       // color: Colors.grey,
//       child: new SmartRefresher(
//         controller: cont,
//         enablePullDown: widget.isHeaderShow,
//         enablePullUp: widget.isFooterShow,
//         // isScrollbar: widget.isScrollbar,
//         // axis: widget.axis,
//         headerBuilder: _buildHeader,
//         footerBuilder: _footerBuilder,
//         headerConfig: RefreshConfig(
//           triggerDistance: 60.0,
//         ),
//         onRefresh: (ev) {

//             if (ev) {
//               if (widget.isHeaderShow) {
//                 widget.headerResult(cont);
//               }

//             } else {
//               if (widget.isFooterShow) {
//                 widget.footerResult(cont);
//               }
             
//             }

          

//         },
        
//         onOffsetChange:  (type, value,{id}) {
//             if (!type) {
//                 if (value > 10.0) {
//                   // cont.sendBack(false, 6);
//                 } 
//             }
        
//         },
//         child: ListView(
//           shrinkWrap: true,
//           padding: const EdgeInsets.all(0.0),
//           children: widget.data,
//         )
//       ),
//       );
//   }


// }