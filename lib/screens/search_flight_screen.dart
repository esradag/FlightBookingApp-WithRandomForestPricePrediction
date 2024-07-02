import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchFlightScreen extends StatefulWidget {
  final DateTime departureDate;
  final DateTime? returnDate;
  final int adults;
  final int children;
  final int bags;
  final String travelClass;
  final bool nonstopFlights;
  final String fromCity;
  final String toCity;

  const SearchFlightScreen({
    super.key,
    required this.departureDate,
    this.returnDate,
    required this.adults,
    required this.children,
    required this.bags,
    required this.travelClass,
    required this.nonstopFlights,
    required this.fromCity,
    required this.toCity,
  });

  @override
  SearchFlightScreenState createState() => SearchFlightScreenState();
}

class SearchFlightScreenState extends State<SearchFlightScreen> {
  int selectedDateIndex = 0;
  double? predictedPrice;
  String flightNo = '';
  String duration = '';
  int availableFlights = 0;

  List<DateTime> getNextSevenDays(DateTime startDate) {
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  Future<void> fetchPricePrediction() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/predict'), // Flask API'nin URL'sini belirtin
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'source_city': widget.fromCity,
        'destination_city': widget.toCity,
        'class': widget.travelClass,
        'stops': widget.nonstopFlights ? 'non-stop' : 'one-stop',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        predictedPrice = responseData['predicted_price'];
        flightNo = responseData['flight_no'].toString();
        duration = responseData['duration'].toString();
        availableFlights = responseData['available_flights'];
      });
    } else {
      throw Exception('Failed to load price prediction');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPricePrediction();
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = getNextSevenDays(widget.departureDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flights'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDateIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: index == selectedDateIndex ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('EEE d').format(date),
                                  style: TextStyle(
                                    color: index == selectedDateIndex ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM').format(date),
                                  style: TextStyle(
                                    color: index == selectedDateIndex ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Sort by:', style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: 'Price',
                              dropdownColor: Colors.blue,
                              onChanged: (String? newValue) {},
                              items: <String>['Price', 'Duration', 'Departure']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: const TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$availableFlights flights available from ${widget.fromCity} to ${widget.toCity}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          final selectedDate = dates[selectedDateIndex];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${widget.fromCity} (SYD)',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            const Text('Depart'),
                                            Text(
                                              DateFormat.yMd().format(selectedDate),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(duration),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${widget.toCity} (LCY)',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          const Text('Flight No'),
                                          Text(
                                            flightNo,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/emirates_logo.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            predictedPrice != null ? '\$${predictedPrice!.toStringAsFixed(2)}' : 'Loading...',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        child: const Text('View Details'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}