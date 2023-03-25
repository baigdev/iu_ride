import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../sharedPreferences/sharedPreferences.dart';
import 'rideDetailCard.dart';

final _firestore = FirebaseFirestore.instance;
final phone = FirebaseAuth.instance.currentUser!.phoneNumber;
var loggedInuser;

class FindaRide extends StatefulWidget {
  @override
  _FindaRideState createState() => _FindaRideState();
}

class _FindaRideState extends State<FindaRide> {
  String user = "";

  void getCurrentUserName() async {
    try {
      final user = MySharedPreferences.instance.getStringValue("userName");
      loggedInuser = user;
      print(loggedInuser);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text("Find a Ride"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            RideStream(),
          ],
        ),
      ),
    );
  }
}

class RideStream extends StatelessWidget {
  const RideStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('rides')
          // Sort the messages by timestamp DESC because we want the newest messages on bottom.
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // If we do not have data yet, show a progress indicator.
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Create the list of message widgets.

        List<Widget> rideWidgets =
            snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          // final data = r.data();
          final rideSender = data['sender'];
          final rideDestination = data['destination'];
          final rideTime = data['ridetime'];
          final ridePrice = data['price'];
          final ridePhone = data['phone'];
          final rideUPI = data['upi'];
          final rideVehicleNo = data['vechicleno'];
          final timeStamp = data['timestamp'];
          return RideDetailCard(
            rideSender: rideSender ?? "No sender found",
            rideDestination: rideDestination ?? "No destination found",
            rideTime: rideTime ?? "No time found",
            ridePrice: ridePrice ?? "No price found",
            ridePhone: ridePhone ?? "No phone found",
            rideUPI: rideUPI ?? "No UPI found",
            rideVehicleNo: rideVehicleNo ?? "No Vehicle found",
            timestamp: timeStamp ?? "No time found",
            isMe: ridePhone == phone,
          );
        }).toList();

        return Expanded(
          child: rideWidgets.isEmpty
              ? const Center(
                  child: Text("No data found"),
                )
              : ListView(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  children: rideWidgets,
                ),
        );
      },
    );
  }
}
