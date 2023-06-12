import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../misc/convertTime.dart';
import '../sharedPreferences/sharedPreferences.dart';
import 'autocompletePrediction.dart';

class FindaRide extends StatefulWidget {
  @override
  _FindaRideState createState() => _FindaRideState();
}

class _FindaRideState extends State<FindaRide> {
  //texxtediting
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _setPriceController = TextEditingController();

  //Google map variables
  late Position position;
  bool mapToggle = false;

  late GoogleMapController _mapController;
  Map<MarkerId, Marker> markers = {};
  late BitmapDescriptor bitmapImage;

  //In app necessary variables
  var inputFormat = DateFormat('h:mm a dd/MM/yyyy');
  String? price;
  late DateTime dateTime;
  String name = "";
  String year = "";
  String branch = "";
  String phone = "";
  String vehicleno = "";
  String email = "";

  //booleans for widgets' visibility
  bool showStartingScreen = true;
  bool isTouchable = false;

  //Focus Node For Price Field
  FocusNode node = FocusNode();

  //firestore instancce
  final _firestore = FirebaseFirestore.instance;

  //custom icon
  Future<BitmapDescriptor> _createMarkerImageFromAsset(String iconPath) async {
    ImageConfiguration configuration = ImageConfiguration();
    bitmapImage =
        await BitmapDescriptor.fromAssetImage(configuration, iconPath);
    return bitmapImage;
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // setState(() {
    //   _mapCreated = true;
    // });
    // get current position here and use mapController when it is completed
  }

  void _currentLocation() async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 17.0,
      ),
    ));
  }

  void getCurrentPosition() async {
    Position currentPosition = await GeolocatorPlatform.instance
        .getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high));
    setState(() {
      position = currentPosition;
      mapToggle = true;
      print(position);
    });

    CollectionReference location =
        FirebaseFirestore.instance.collection('location');
    // final coordinated = new Coordinates(position.latitude, position.longitude);
    GeoCode geoCode = GeoCode();
    var address = await geoCode.reverseGeocoding(
        latitude: position.latitude, longitude: position.longitude);
    var firstAddress = address;

    location.add({
      'username': await MySharedPreferences.instance.getStringValue("userName"),
      'locationpoint': GeoPoint(position.latitude, position.longitude),
      'address':
          '${firstAddress.streetAddress}, ${firstAddress.city}, ${firstAddress.countryName}',
      'postalcode': firstAddress.postal,
      'locality': firstAddress.streetAddress,
    });

    print(await MySharedPreferences.instance.getStringValue("userName"));
    // print(position.latitude);
    // print(position.longitude);
    // print(firstAddress.addressLine);
    // print(firstAddress.postalCode);
    // print(firstAddress.locality);

    //set custom icon
    _createMarkerImageFromAsset("assets/locationpin.png");

    //calling marker function
    await fetchData();
    await getMarkerData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    getCurrentPosition();
    return await Geolocator.getCurrentPosition();
  }

  fetchData() async {
    MySharedPreferences.instance
        .getStringValue("userName")
        .then((value) => setState(() {
              name = value;
              print("Name fetched $value");
            }));
    MySharedPreferences.instance
        .getStringValue("userBranch")
        .then((value) => setState(() {
              branch = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userYear")
        .then((value) => setState(() {
              year = value;
            }));
    MySharedPreferences.instance
        .getStringValue("userPhone")
        .then((value) => setState(() {
              phone = value;
            }));
    MySharedPreferences.instance
        .getStringValue("vechicleno")
        .then((value) => setState(() {
              vehicleno = value;
            }));
    MySharedPreferences.instance
        .getStringValue("email")
        .then((value) => setState(() {
              email = value;
            }));
  }

  void initMarker(specify, specifyID) async {
    var markerIdval = specifyID;
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
      markerId: markerId,
      icon: bitmapImage,
      position: LatLng(specify['locationpoint'].latitude,
          specify['locationpoint'].longitude),
      infoWindow:
          InfoWindow(title: specify['username'], snippet: specify['address']),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    await FirebaseFirestore.instance
        .collection('location')
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (int i = 0; i < snapshot.docs.length; i++) {
          initMarker(snapshot.docs[i].data(), snapshot.docs[i].id);
        }
      }
    });
  }

  Set<Marker> getMarker() {
    return <Marker>{
      const Marker(
        markerId: MarkerId("one"),
        position: LatLng(9.880892, 78.112317),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "one"),
      )
    };
  }

  @override
  Widget build(BuildContext context) {
    return homeScaffold();
  }

  Widget homeScaffold() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          mapToggle
              ? _googleMap(context)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          _startingScreen(showStartingScreen),
        ],
      ),
    );
  }

  Widget _startingScreen(bool isVisible) {
    return Visibility(
      visible: isVisible,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 250.0,
            child: ListView(
              children: <Widget>[
                _fillField("From: ", Colors.red, 10.0, Icons.location_pin,
                    _fromController,
                    isFrom: true),
                _fillField(
                    "To: ", Colors.red, 10.0, Icons.location_pin, _toController,
                    isTo: true),
                _dateField(),
              ],
            ),
          ),
          _customButton(Alignment.bottomRight, 80.0, Icons.my_location, "Me",
              _onLocationPressed),
          _customButton(Alignment.bottomRight, 15.0, Icons.add, "Create",
              _onCreatePressed),
        ],
      ),
    );
  }

  Align _fillField(String str, Color clr, double top, IconData icon,
      TextEditingController controller,
      {bool isTo = false, bool isFrom = false}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: top),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(
                Icons.location_on,
                color: clr,
              ),
              hintText: str,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 15.0, top: 16.0),
              fillColor: Colors.white,
            ),
          ),
          suggestionsCallback: (pattern) async {
            return CitiesService.getSuggestions(pattern);
          },
          itemBuilder: (context, String? suggestion) {
            return ListTile(
              title: Text(suggestion!),
            );
          },
          onSuggestionSelected: (String? suggestion) {
            if (isFrom && _toController.text.isNotEmpty) {
              if (suggestion!.contains(_toController.text)) {
                _showToast(
                    "To and from can not be same please select different location");
                return;
              } else {
                controller.text = suggestion;
                return;
              }
            }

            if (isTo && _fromController.text.isNotEmpty) {
              if (suggestion!.contains(_fromController.text)) {
                _showToast(
                    "To and from can not be same please select different location");
                return;
              } else {
                controller.text = suggestion;
                return;
              }
            } else {
              controller.text = suggestion!;
              return;
            }
          },
        ),
      ),
    );
  }

  Align _dateField() {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: DateTimeField(
              format: inputFormat,
              onChanged: (DateTime? dt) {
                dateTime = dt!;
              },
              resetIcon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5.0)),
                  //suffixIcon: Icon(Icons.calendar_today, color: Colors.black,),
                  fillColor: Colors.white,
                  labelText: "Date: ",
                  labelStyle: const TextStyle(color: Colors.black)),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            )));
  } //dateField

  Widget _customButton(Alignment alignment, double bottom, IconData icon,
      String label, Function onPressed) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding:
            EdgeInsets.only(right: 10.0, bottom: bottom, left: 10.0, top: 10.0),
        child: SizedBox(
          height: 50.0,
          width: 120.0,
          child: ElevatedButton.icon(
            icon: Icon(icon),
            label: Text(label),
            onPressed: () {
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //the method called when the user presses the create button
  _onCreatePressed() async {
    await fetchData();
    if (_areFieldsFilled()) {
      Alert(
          context: context,
          title: "Confirm Ride",
          content: Column(
            children: <Widget>[
              //userdetails
              Container(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/accountAvatar.jpg"),
                  ),
                  title: Text(
                    "Name: $name",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Text(
                        "Branch: $branch",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Year: $year",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Ride Details -- Destination and Time
              Container(
                // color: Colors.cyan,
                child: ListTile(
                  leading: Text(
                    "FROM",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    _fromController.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Time : " + convertTimeTo12Hour(dateTime),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                // color: Colors.cyan,
                child: ListTile(
                  leading: Text(
                    "TO",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    _toController.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Time : " + convertTimeTo12Hour(dateTime),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                // color: Colors.greenAccent,
                child: ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    color: Colors.blue,
                  ),
                  title: TextField(
                    controller: _setPriceController,
                    onChanged: (v) {
                      price = v;
                    },
                    focusNode: node,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Price",
                    ),
                  ),
                  trailing: TextButton(
                    child: const Text(
                      "Set Price",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      _showToast("Price Requested");
                      FocusScope.of(context).requestFocus(node);
                      setState(() {
                        price = _setPriceController.text;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          buttons: [
            DialogButton(
              onPressed: () {
                _firestore.collection('rides').add({
                  'sender': name,
                  "from": _fromController.text,
                  'destination': _toController.text,
                  'ridetime': convertTimeTo12Hour(dateTime),
                  'price': price,
                  'phone': phone,
                  'upi': email,
                  'vechicleno': vehicleno,
                  'timestamp': Timestamp.now(),
                });

                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'Success',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                        'Your ride was shared. \nWait for confirmation call'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          _toController.clear();
                          _fromController.clear();
                        },
                        child: new Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                "Offer Ride",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
    }
  } //onCreatePressed

  _onLocationPressed() {
    _currentLocation();
  }

  bool _areFieldsFilled() {
    if (_toController.text.isEmpty) {
      _showToast("Missing 'To' field!");
      return false;
    }
    if (dateTime == null) {
      _showToast("Missing 'Date' field!");
      return false;
    }
    return true;
  }

  _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 1,
    );
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: false,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: onMapCreated,
        markers: Set<Marker>.of(markers.values),
        onTap: _onMapTap,
      ),
    );
  }

  void _onMapTap(LatLng point) {
    if (isTouchable) {
      _showPointDialog(point);
    }
  }

  void _showPointDialog(LatLng point) async {
    final String name = await _getAddressFromLatLng(point);
    print(name);
  }

  Future<String> _getAddressFromLatLng(LatLng point) async {
    // final coordinates = new Coordinates(point.latitude, point.longitude);
    GeoCode geoCode = GeoCode();
    // var address =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var address = await geoCode.reverseGeocoding(
        latitude: position.latitude, longitude: position.longitude);
    var first = address;
    String name = first.streetAddress!;
    return name;
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    // _mapController.setMapStyle(mapStyle);
  }
}
