import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  MessageContainer({
    Key? key,
    @required this.text,
    @required this.sender,
    @required this.height,
    @required this.width,
    // this.userCheck,
    @required this.isSender,
    this.imageAdress,
  }) : super(key: key);

  final text;
  final sender;
  final height;
  final width;
  // final userCheck;
  final isSender;
  final imageAdress;

  @override
  Widget build(BuildContext context) {
    // DateTime dateTime = DateTime.now();
    // String time = (dateTime.hour ~/ 12 == 0)
    //     ? "${dateTime.hour}:${dateTime.minute} am"
    //     : "${dateTime.hour % 12}:${dateTime.minute} pm";
    if (!(imageAdress == null || imageAdress == '')) {
      return Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: isSender
                ? EdgeInsets.only(
                    top: height * .5 / 100,
                    bottom: height * .5 / 100,
                    right: width * 10 / 100)
                : EdgeInsets.only(
                    top: height * .5 / 100,
                    bottom: height * .5 / 100,
                    left: width * 10 / 100),
            child: Material(
              elevation: 8,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))
                  : BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
              color: isSender ? Color(0xFF18344E) : Colors.blue,
              child: Container(
                height: height * 30 / 100,
                width: width * 60 / 100,
                padding: EdgeInsets.all(12),
                child:
                    //  FutureBuilder(
                    //     future: FireStorageService.loadImage(context, imageAdress),
                    //     builder: (context, snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //       return
                    InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ImageViewerScreen(
                    //               imageUrl: snapshot.data.toString(),
                    //             )));
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(
                        right: width * 3 / 100, bottom: height * 1 / 100),
                    child: Text(
                      'sent  ✓',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF13293D),
                          fontSize: ((width + height) / 4) * 4 / 100),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              "https://idsb.tmgrup.com.tr/ly/uploads/images/2021/09/08/thumbs/800x531/142774.jpg"),
                        )),
                  ),
                )
                //   ;
                // })
                ,
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Padding(
          padding: isSender
              ? EdgeInsets.only(
                  top: height * .5 / 100,
                  bottom: height * .5 / 100,
                  right: width * 10 / 100)
              : EdgeInsets.only(
                  top: height * .5 / 100,
                  bottom: height * .5 / 100,
                  left: width * 10 / 100),
          child: Material(
            color: isSender ? Color(0xFFE5E5E5) : Color(0xFF68B3DF),
            //   Color(0xFF14213D),
            elevation: 0,
            borderRadius: isSender
                ? BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 5 / 100, vertical: height * 1.5 / 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$text",
                    style: TextStyle(
                      color: isSender
                          ?
                          //  Color(0xFF14213D)
                          Colors.black
                          : Colors.white,
                    ),
                  ),
                  SizedBox(height: height * .5 / 100),
                  Text(
                    (isSender) ? 'sent' : "received",
                    style: TextStyle(
                        color: isSender
                            ?
                            //  Color(0xFF14213D)
                            Colors.black
                            : Colors.white,
                        fontSize: ((width + height) / 4) * 4 / 100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
