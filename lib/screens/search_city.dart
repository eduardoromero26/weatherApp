import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/screens/weather_search_city.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:http/http.dart' as http;

import 'package:diacritic/diacritic.dart';

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<SearchCityScreen> createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {
  final TextEditingController _cityCtrl = TextEditingController();
  var key = "6c5f499f4449482a953183648220505";
  Map objApi = {};

  String cityValue = "";
  String countryValue = "";
  String stateValue = "";
  String address = "";
  GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

  Future fetchWeatherApi() async {
    try {
      // print(lat.toString() + " Lat en fetch");
      // print(lng.toString() + " lng en fetch");
      var resp = await http.get(
        Uri.parse("http://api.weatherapi.com/v1/current.json?key=" +
            key.toString() +
            "&q=" +
            cityValue),
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
    if (resp != "Error") {
      setState(() {
        objApi = resp;
      });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(1, 0, 49, 1),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Text(
                'Select your City   🌎',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 24,
              ),

              ///Adding CSC Picker Widget in app
              CSCPicker(
                showStates: true,
                showCities: true,
                flagState: CountryFlag.ENABLE,
                dropdownDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Colors.white,
                ),

                ///labels for dropdown
                countryDropdownLabel: " Country",
                stateDropdownLabel: "State",
                cityDropdownLabel: "City",

                ///selected item style [OPTIONAL PARAMETER]
                selectedItemStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),

                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                dropdownHeadingStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),

                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                dropdownItemStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                ),
                dropdownDialogRadius: 10.0,
                searchBarRadius: 10.0,
                onCountryChanged: (value) {
                  setState(() {
                    countryValue = value;
                  });
                },
                onStateChanged: (value) {
                  setState(() {
                    stateValue = value.toString();
                  });
                },
                onCityChanged: (value) {
                  setState(() {
                    cityValue = value.toString();
                  });
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: Container(
                  height: 52,
                  width: 260,
                  child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      side: const BorderSide(width: 1.0, color: Colors.white),
                      elevation: 1,
                    ),
                    onPressed: () async {
                      cityValue = removeDiacritics(cityValue);

                      //getWeatherDataFromApi();
                      //print(countryValue);
                      //if (countryValue != objApi['location']['country']) {
                      //showDialog(
                      //context: context,
                      //builder: (context) => AlertDialog(
                      // title: const Text("Try Again"),
                      // content: const Text("No matching location found."),
                      //actions: [
                      // IconButton(
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //           },
                      //           icon: const Icon(Icons.close),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WeatherSearchCityScreen(
                                  cityValue: cityValue)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Click to see the Weather',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text(address)
            ],
          )),
    );
/*
            Container(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _cityCtrl,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              cityValue = _cityCtrl.text.toString();
                              cityValueRegex =
                                  cityValue.replaceAll(RegExp(' +'), ' ');
                            });
                            print(cityValueRegex);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WeatherSearchCityScreen(
                                            cityValue: cityValueRegex)));
                          },
                          icon: const Icon(
                            Icons.search,
                          ),
                        ),
                        labelText: 'Search your City...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])),
    );*/
  }
}
