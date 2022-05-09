import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/screens/search_city.dart';
import 'package:get/get.dart';

class WeatherSearchCityScreen extends StatefulWidget {
  final String cityValue;

  const WeatherSearchCityScreen({Key? key, required this.cityValue})
      : super(key: key);
  @override
  State<WeatherSearchCityScreen> createState() =>
      _WeatherSearchCityScreenState();
}

class _WeatherSearchCityScreenState extends State<WeatherSearchCityScreen> {
  Map objApi = {};
  bool isLoading = true;
  var key = "6c5f499f4449482a953183648220505";
  // variable to change the backroung color
  var bgColor;
  var textColor;

  Future fetchWeatherApi() async {
    try {
      // print(lat.toString() + " Lat en fetch");
      // print(lng.toString() + " lng en fetch");
      var resp = await http.get(
        Uri.parse("http://api.weatherapi.com/v1/current.json?key=" +
            key.toString() +
            "&q=" +
            widget.cityValue),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      var data = jsonDecode(resp.body);
      print(resp.body);
      return data;
    } catch (e) {
      return "Error";
    }
  }

  void getWeatherDataFromApi() async {
    var resp = await fetchWeatherApi();
    print(resp);
    if (resp != "Error") {
      setState(() {
        isLoading = false;
        objApi = resp;
      });
    } else {
      setState(() {});
    }
    validateColor(objApi['current']['condition']);
  }

  validateColor(temperature) {
    Color color;
    if (objApi['current']['is_day'] > 0) {
      switch (objApi['current']['condition']['text']) {
        case 'sunny':
          color = const Color.fromRGBO(255, 213, 0, 1);
          break;
        case "Clear":
          color = const Color.fromRGBO(255, 213, 0, 1);
          break;
        case "Mist":
          color = const Color.fromRGBO(216, 216, 216, 1);
          break;
        case 'Cloudy':
          color = const Color.fromRGBO(216, 216, 216, 1);
          break;
        case 'Light rain shower':
          color = Colors.blue;
          break;
        case "Moderate or heavy rain shower":
          color = Colors.blue;
          break;

        default:
          color = const Color.fromRGBO(255, 213, 0, 1);
      }
      setState(() {
        bgColor = color;
        textColor = Colors.black;
      });
    } else {
      switch (objApi['current']['condition']['text']) {
        case 'sunny':
          color = const Color.fromRGBO(1, 0, 49, 1);
          break;
        case "Clear":
          color = const Color.fromRGBO(1, 0, 49, 1);
          break;
        case 'Cloudy':
          color = Color.fromARGB(255, 68, 68, 68);
          break;
        case 'Light rain shower':
          color = Color.fromARGB(255, 17, 58, 88);
          break;
        case "Moderate or heavy rain shower":
          color = Color.fromARGB(255, 17, 58, 88);
          break;
        default:
          color = const Color.fromRGBO(1, 0, 49, 1);
      }
      setState(() {
        bgColor = color;
        textColor = Colors.white;
      });
    }
  }

  @override
  initState() {
    getWeatherDataFromApi();
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
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(objApi['location']['name'],
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 18,
            )),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SearchCityScreen(title: 'Search your City')));
            },
            icon: const Icon(
              Icons.search,
            ),
            color: textColor,
          ),
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
                    objApi['location']['tz_id']+ ", " +objApi['location']['country'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    objApi['location']['localtime'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Divider(
                    height: 4,
                    thickness: 2,
                    color: textColor,
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
                      objApi['current']['temp_c'].toString() + "°",
                      style: GoogleFonts.poppins(
                        fontSize: 92,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      objApi['current']['condition']['text'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: textColor,
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
                    Divider(
                      height: 4,
                      thickness: 2,
                      color: textColor,
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
                                  objApi['current']['cloud'].toString() +
                                      "% cloud",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                                Text(
                                  objApi['current']['feelslike_c'].toString() +
                                      "° Feels like",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  objApi['current']['humidity'].toString() +
                                      '% humidity',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                                Text(
                                  objApi['current']['wind_kph'].toString() +
                                      "km/h Wind",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
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
