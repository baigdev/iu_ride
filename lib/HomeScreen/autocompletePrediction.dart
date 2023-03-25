import 'dart:math';

class BackendService {
  static Future<List> getSuggestions(String query) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    });
  }
}

class CitiesService {
  static final List<String> predictionList = [
    "Shaheed-e-Millat Road",
    "Clifton",
    "Defence View",
    "Univeristy Road",
    "Tariq Road",
    "Gulistan e Johar",
    "Saadi Town",
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(predictionList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}






// TextField(
// onChanged: (val) {
// to = val;
//
// },
// autofocus: false,
//
// controller: _controller,
//
// cursorColor: Colors.black,
// // controller: appState.locationController,
// decoration: InputDecoration(
// filled: true,
// prefixIcon: Icon(
// Icons.location_on,
// color: clr,
// ),
// hintText: str,
// border: InputBorder.none,
// contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
// fillColor: Colors.white,
// ),
// ),