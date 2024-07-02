import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_flight_screen.dart'; // Make sure SearchFlightScreen class is defined in this file

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DateTime _departureDate = DateTime.now();
  DateTime _returnDate = DateTime.now();
  int _adults = 1;
  int _children = 0;
  int _bags = 0;
  String _travelClass = 'Economy';
  bool _nonstopFlights = false;
  bool _isRoundTrip = true;

  final List<String> _fromCities = ['Delhi', 'Mumbai', 'Bangalore', 'Kolkata', 'Hyderabad', 'Chennai'];
  final List<String> _toCities = ['Mumbai', 'Bangalore', 'Kolkata', 'Hyderabad', 'Chennai', 'Delhi'];

  String _selectedFromCity = 'Delhi';
  String _selectedToCity = 'Mumbai';

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? _departureDate : _returnDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isDeparture ? _departureDate : _returnDate)) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _toggleTripType() {
    setState(() {
      _isRoundTrip = !_isRoundTrip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/plane.png',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 10),
            const Text(
              'Book your Flight',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/plane.png',
              height: 32,
              width: 32,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _isRoundTrip ? _toggleTripType : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isRoundTrip ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          Text(
                            'Round Trip',
                            style: TextStyle(
                              color: _isRoundTrip ? Colors.blue : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          if (_isRoundTrip)
                            Container(
                              height: 2,
                              width: 60,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: !_isRoundTrip ? _toggleTripType : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: !_isRoundTrip ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          Text(
                            'One-Way',
                            style: TextStyle(
                              color: !_isRoundTrip ? Colors.blue : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          if (!_isRoundTrip)
                            Container(
                              height: 2,
                              width: 60,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('From', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedFromCity,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFromCity = newValue!;
                      });
                    },
                    items: _fromCities.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('To', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedToCity,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedToCity = newValue!;
                      });
                    },
                    items: _toCities.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Depart', style: TextStyle(fontWeight: FontWeight.bold)),
                            GestureDetector(
                              onTap: () => _selectDate(context, true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  DateFormat.yMd().format(_departureDate),
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isRoundTrip) const SizedBox(width: 20),
                      if (_isRoundTrip)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Return', style: TextStyle(fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () => _selectDate(context, false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    DateFormat.yMd().format(_returnDate),
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Passengers', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Adults'),
                            DropdownButton<int>(
                              value: _adults,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _adults = newValue!;
                                });
                              },
                              items: List.generate(10, (index) => index + 1)
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Kids'),
                            DropdownButton<int>(
                              value: _children,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _children = newValue!;
                                });
                              },
                              items: List.generate(10, (index) => index)
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bags'),
                            DropdownButton<int>(
                              value: _bags,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _bags = newValue!;
                                });
                              },
                              items: List.generate(10, (index) => index)
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Class', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _travelClass,
                    onChanged: (String? newValue) {
                      setState(() {
                        _travelClass = newValue!;
                      });
                    },
                    items: <String>['Economy', 'Business']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Nonstop flights first', style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _nonstopFlights,
                    onChanged: (bool value) {
                      setState(() {
                        _nonstopFlights = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchFlightScreen(
                              departureDate: _departureDate,
                              returnDate: _isRoundTrip ? _returnDate : null,
                              adults: _adults,
                              children: _children,
                              bags: _bags,
                              travelClass: _travelClass,
                              nonstopFlights: _nonstopFlights,
                              fromCity: _selectedFromCity,
                              toCity: _selectedToCity,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text('Search Flights', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
