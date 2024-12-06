import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var weatherData;
  late double widthDevice;
  late double heightDevice;

  Future<void> fetchAPI() async {
    var dio = Dio();
    try {
      var response = await dio.request(
        'https://mr-api-three.vercel.app/weather',
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        setState(() {
          weatherData = response.data;
        });
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAPI();
  }

  @override
  Widget build(BuildContext context) {
    widthDevice = MediaQuery.of(context).size.width;
    heightDevice = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          _gradientApply()!,
          _mainDisplay(),
        ],
      ),
    );
  }

  Widget? _gradientApply() {
    if(weatherData == null)
      return Container();
    if(weatherData["weather"]["condition"] == "Sunny")
     return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Rainy Background.png"),
            fit: BoxFit.fill,
          ),
        ),
      );
    if(weatherData["weather"]["condition"] == "Snowy")
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Snowy Background.png"),
            fit: BoxFit.fill,
          ),
        ),
      );
    if(weatherData["weather"]["condition"] == "Cloudy")
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Rainy Background.png"),
            fit: BoxFit.fill,
          ),
        ),
      );
    if(weatherData["weather"]["condition"] == "Rainy")
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Rainy Background.png"),
            fit: BoxFit.fill,
          ),
        ),
      );

  }

  Widget _mainDisplay() {
    return weatherData == null
        ? Center(child: CircularProgressIndicator())
        : Column(
      children: [
        topWidget(),
        showData(),
        recommendedPlaces(),
        chancesOfRain()
      ],
    );
  }

  Widget topWidget() {
    return Container(
      height: heightDevice * 0.2,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.location, color: Colors.white,size: 20,),
              Text(
                weatherData["location"]["city"],
                style: TextStyle(color: Colors.white,fontSize: 12),
              ),
            ],
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weatherData['weather']['temperature'].toString(),
                  style: TextStyle(fontSize: 40, color: Colors.white,fontWeight: FontWeight.bold),
                ),
                SizedBox(width: widthDevice * 0.25),
            Image.asset("assets/Line.png",color: Colors.white,),
                SizedBox(width: widthDevice * 0.1),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          weatherData["weather"]["condition"],
                          style: TextStyle(color: Colors.white,fontWeight:FontWeight.w600,fontSize: 18),
                        ),
                        Icon(CupertinoIcons.cloud_sun, color: Colors.white),
                      ],
                    ),
                    Text(
                      "${DateFormat('EEEE, d MMMM').format(DateTime.now())}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: widthDevice * 0.1),

          Text(
            "Feels like ${weatherData["weather"]["feels_like"]}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget showData() {
    return Container(
      width: widthDevice * 0.95,
      height: heightDevice * 0.15,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey)],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ SizedBox(
              width: 150,
              child: ListTile(
                leading: Image.asset("assets/precipitation.png", height: 25, width: 25),
                title: Column(
                  children: [
                    Text(
                      "${weatherData["weather"]["precipitation_probability"]}%".toString(),
                      style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Precipitation",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
              SizedBox(width: 30,),
              SizedBox(
                width: 150,
                child: ListTile(
                  leading: Image.asset("assets/wind.png", height: 25, width: 25),
                  title: Column(
                    children: [
                      Text(
                        "${weatherData["weather"]["wind_speed"].toString()} km/hr",
                        style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Wind Speed",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(
              width: 150,
              child: ListTile(
                leading: Image.asset("assets/wind.png", height: 25, width: 25),
                title: Column(
                  children: [
                    Text(
                      "${weatherData["weather"]["atm_pressure"]} mm".toString(),
                      style: TextStyle(color: Colors.black,  fontSize: 12,fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Atm Pressure",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 30),

            SizedBox(
              width: 150,
              child: ListTile(
                leading: Image.asset("assets/drops.png", width: 25, height: 25),
                title: Column(
                  children: [
                    Text(
                      "${weatherData["weather"]["humidity"]}%".toString(),
                      style: TextStyle(color: Colors.black,  fontSize: 12,fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Humidity",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],)
        ],
      ),
    );
  }
  Widget recommendedPlaces() {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recommended Places",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          ListTile(
            leading: Image.asset("assets/place.png"),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Kathmandu",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                Row(
                  children: [
                    Text("15 ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                    Text("KM",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600))
                  ],
                ),
                Text("City Full of temples and monkeys",style: TextStyle(fontSize: 10)),],

            ),
          ),
          ListTile(
            leading: Image.asset("assets/place.png"),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Chitwan",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                Row(
                  children: [
                    Text("50 ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                    Text("KM",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600))
                  ],
                ),
                Text("Meet the wildlife",style: TextStyle(fontSize: 10)),],

            ),
          ),
          ListTile(
            leading: Image.asset("assets/place.png"),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Pokhara",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                Row(
                  children: [
                    Text("90 ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                    Text("KM",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600))
                  ],
                ),
                Text("Tourist's hub",style: TextStyle(fontSize: 10)),],

            ),
          ),
          ListTile(
            leading: Image.asset("assets/place.png"),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Dhangadi",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                Row(
                  children: [
                    Text("15 ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                    Text("KM",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600))
                  ],
                ),
                Text("Beauty of Far-West",style: TextStyle(fontSize: 10)),],

            ),
          )        ],
      ),
    );
  }
Widget chancesOfRain(){
    return Container(
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chances of Rain",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          Row(
            children: [Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text("Heavy",style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w600),)],
            )],
          ),
        ],
      ),
    );
}
}
