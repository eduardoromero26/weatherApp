import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var lat = 0.0;
  var lng = 0.0;
  List objApi = [];
  bool isLoading = true;
  var key = "6c5f499f4449482a953183648220505";

  findMyLocation() async {
    bool devicePermission;
    devicePermission = await Geolocator.isLocationServiceEnabled();
    if (devicePermission) {
      var appLevel = await Geolocator.checkPermission();
      if (appLevel == LocationPermission.denied) {
        appLevel = await Geolocator.requestPermission();
      } else if (appLevel == LocationPermission.deniedForever) {
        print("Error: App location permission denied forever");
      }
      var location = await Geolocator.getCurrentPosition();
      setState(() {
        lat = location.latitude;
        lng = location.longitude;
      });
    } else {
      print("Error : GPS sensor permission issue, device level");
    }
    print(lat.toString() + "Lat en LOCATION");
    print(lng.toString() + "lng en LOCATION");
  }

  Future fetchWeatherApi() async {
    try {
      print(lat.toString() + " Lat en fetch");
      print(lng.toString() + " lng en fetch");
      var resp = await http.get(
        Uri.parse("http://api.weatherapi.com/v1/current.json?key=" +
            key.toString() +
            "&q=" +
            lat.toString() +
            ',' +
            lng.toString()),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      var data = jsonDecode(resp.body);
      return data['location'];
    } catch (e) {
      return "Error";
    }
  }

  Future getWeatherDataFromApi() async {
    var resp = await fetchWeatherApi();
    print(resp);
    if (resp != "Error") {
      setState(() {
        isLoading = false;
        objApi = resp;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  printObj() {
    print(objApi);
  }

  @override
  void initState() {
    findMyLocation();
    getWeatherDataFromApi();
    // printObj();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 213, 0, 1),
      appBar: AppBar(
        title: Text('City',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 213, 0, 1),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      /*drawer: const Drawer(
        backgroundColor: Color.fromRGBO(255, 213, 0, 1),
        elevation: 1,
      ),*/
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Monday",
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "04 September",
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Divider(
                    height: 4,
                    thickness: 2,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "27°",
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                            fontSize: 120, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Sunny",
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Divider(
                      height: 4,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "21°",
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "8°",
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "0% ´recipitation",
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "3 km/h Wind",
                                  style: GoogleFonts.quicksand(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
