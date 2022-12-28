import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../misc/themes.dart';

class RideDetailCard extends StatelessWidget {
  final String? rideSender,
      rideDestination,
      rideTime,
      ridePrice,
      ridePhone,
      rideUPI,
      rideVehicleNo;
  final Timestamp? timestamp;
  final bool? isMe;

  const RideDetailCard(
      {super.key,
      this.rideSender,
      this.rideDestination,
      this.rideTime,
      this.ridePrice,
      this.ridePhone,
      this.rideUPI,
      this.rideVehicleNo,
      this.timestamp,
      this.isMe});

  initiateTransaction() async {
    String upiUrl =
        "upi://pay?pa=$rideUPI&pn=$rideSender&am=$ridePrice&cu=INR;&tn=Thank You Friend..!";
    await launch(upiUrl).then((value) {
      print(value);
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
    return isMe!
        ? Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  border:
                      Border(left: BorderSide(color: Colors.blue, width: 7.0))),
              child: Material(
                elevation: 4.0,
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 5.0,
                      right: 70.0,
                      width: 120.0,
                      child: Container(
                        height: 120.0,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 0.0, left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text(
                                    "SHARED RIDE DETAILS",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ClipOval(
                                child: Image.asset(
                                  'assets/accountAvatar.png',
                                  fit: BoxFit.cover,
                                  height: 45.0,
                                  width: 45.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    rideDestination!,
                                    style: boldBlackLargeTextStyle,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        rideTime!,
                                        style: normalGreyTextStyle,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                "PKR $ridePrice",
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 0.0,
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Your ride was shared at ${DateFormat('h:mm a').format(dateTime)} .\nWait for confirmation call.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Material(
              elevation: 4.0,
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(4.0),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 5.0,
                    right: 70.0,
                    width: 120.0,
                    child: Container(
                      height: 120.0,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 0.0, left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  rideDestination!,
                                  style: boldBlackLargeTextStyle,
                                ),
                                Text(
                                  rideTime!,
                                  style: normalGreyTextStyle,
                                ),
                              ],
                            ),
                            const Spacer(),
                            const ClipOval(
                              child: Icon(
                                Icons.account_circle_rounded,
                                size: 45,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  rideSender!,
                                  style: boldBlackLargeTextStyle,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      ridePhone!,
                                      style: normalGreyTextStyle,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 1.0),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(1.0),
                                        ),
                                        border: Border.all(color: greyColor),
                                      ),
                                      child: Text(
                                        rideVehicleNo!,
                                        style: normalGreyTextStyle,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              "PKR $ridePrice",
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 0.0,
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(12.0),
                        child: isMe!
                            ? Row(
                                children: const [
                                  Text("Ride Submitted"),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.call),
                                    label: const Text("CALL"),
                                    onPressed: () async {
                                      FlutterPhoneDirectCaller.callNumber(
                                          "$ridePhone");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      initiateTransaction();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    child: const Text("PAY AND CONFIRM"),
                                  ),
                                  const SizedBox(height: 60),
                                ],
                              ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 225.0, left: 280),
                    child: Text(
                      DateFormat('h:mm a').format(dateTime),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
