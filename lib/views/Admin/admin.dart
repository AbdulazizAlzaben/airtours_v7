// ignore_for_file: use_build_context_synchronously
// Container(
//               margin: const EdgeInsets.all(5),
//               width: double.infinity,
//               decoration: BoxDecoration(boxShadow: const [
//                 BoxShadow(blurRadius: 2, offset: Offset(0, 0))
//               ], borderRadius: BorderRadius.circular(20), color: Colors.white),
//               child:
import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/cloud/cloud_flight.dart';
import '../../services/cloud/firestore_flight.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/show_error.dart';
import '../Global/global_var.dart';
import '../Global/show_city_name_search.dart';

class CreateFlight extends StatefulWidget {
  const CreateFlight({super.key});

  @override
  State<CreateFlight> createState() => _CreateFlightState();
}

class _CreateFlightState extends State<CreateFlight> {
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  TextEditingController fromAir = TextEditingController();
  TextEditingController toAir = TextEditingController();
  TextEditingController numOfGuest = TextEditingController();
  TextEditingController numOfBusiness = TextEditingController();
  TextEditingController guestPrice = TextEditingController();
  TextEditingController businessPrice = TextEditingController();
  TextEditingController depDate = TextEditingController();
  TextEditingController arrDate = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController depTime = TextEditingController();
  TextEditingController arrTime = TextEditingController();
  late DateTime? selectedDepDate;
  late DateTime? selectedArrDate;
  late TimeOfDay selectedDepTime;
  late TimeOfDay selectedArrTime;
  CloudFlight? _flight;
  late final FlightFirestore _flightsService;
  final formKey = GlobalKey<FormState>();
  String? selectedCity1;
  String? selectedCity2;

  @override
  void initState() {
    super.initState();
    _flightsService = FlightFirestore();
  }

  void clearAllFields() {
    from.clear();
    to.clear();
    fromAir.clear();
    toAir.clear();
    numOfGuest.clear();
    numOfBusiness.clear();
    guestPrice.clear();
    businessPrice.clear();
    depDate.clear();
    arrDate.clear();
    time.clear();
    depTime.clear();
    arrTime.clear();
  }

  Future<CloudFlight> createFlight({
    required fromCity,
    required toCity,
    required fromAirport,
    required toAirport,
    required numOfBusiness,
    required numOfGuest,
    required guestPrice,
    required busPrice,
    required depDate,
    required arrDate,
    required arrTime,
    required depTime,
  }) async {
    Timestamp depDateStamp = Timestamp.fromDate(depDate);
    Timestamp arrDateStamp = Timestamp.fromDate(arrDate);
    Timestamp depTimeStamp = Timestamp.fromDate(depTime);
    Timestamp arrTimeStamp = Timestamp.fromDate(arrTime);
    int intNumOfBus = int.parse(numOfBusiness);
    int intNumOfGuest = int.parse(numOfGuest);
    double guePrice = double.parse(guestPrice);
    double businessPrice = double.parse(busPrice);

    final newFlight = await _flightsService.createNewFlight(
      fromCity: fromCity,
      toCity: toCity,
      fromAirport: fromAirport,
      toAirport: toAirport,
      numOfBusiness: intNumOfBus,
      numOfGuest: intNumOfGuest,
      guestPrice: guePrice,
      busPrice: businessPrice,
      depDate: depDateStamp,
      arrDate: arrDateStamp,
      arrTime: arrTimeStamp,
      depTime: depTimeStamp,
    );

    _flight = newFlight;
    return newFlight;
  }

  void _navigateToCitySelectionPage(BuildContext context, int num) async {
    final city = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FromSearch(fromOrTo: 1)),
    );

    if (city != null) {
      setState(() {
        if (num == 1) {
          selectedCity1 = city;
        }
        if (num == 2) {
          selectedCity2 = city;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Admin",
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(addAdminRoute);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuthProvider.authService().logOut();
              Navigator.of(context).pushNamed(loginRoute);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: GestureDetector(
                              onTap: () {
                                _navigateToCitySelectionPage(context, 1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("From"),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedCity1 != null
                                              ? '${selectedCity1}'
                                              : 'Select city',
                                        ),
                                        Text(">")
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: GestureDetector(
                                onTap: () {
                                  _navigateToCitySelectionPage(context, 2);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("To"),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedCity2 != null
                                                ? '${selectedCity2}'
                                                : 'Select city',
                                          ),
                                          Text(">")
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 1),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required Field";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: depDate,
                                  readOnly: true,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                      hintText: "Departure Date",
                                      suffixIcon: Icon(Icons.calendar_month),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 20)),
                                  onTap: () async {
                                    DateTime? temp = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );

                                    if (temp != null) {
                                      setState(() {
                                        depDate.text = DateFormat('yyyy-MM-dd')
                                            .format(temp);
                                        selectedDepDate = temp;
                                      });
                                    }
                                  },
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 1),
                                child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Required Field";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: arrDate,
                                    readOnly: true,
                                    textAlign: TextAlign.start,
                                    decoration: const InputDecoration(
                                      hintText: "Arrival Date",
                                      suffixIcon: Icon(Icons.calendar_month),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                    onTap: () async {
                                      selectedArrDate = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDepDate!,
                                        firstDate: selectedDepDate!,
                                        lastDate: DateTime(2100),
                                      );

                                      if (selectedArrDate != null) {
                                        setState(() {
                                          arrDate.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(selectedArrDate!);
                                        });
                                      }
                                    }),
                              )),
                          const SizedBox(
                            height: 2,
                          ),

                          //Time of the flight
                          Container(
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 1),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required Field";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: depTime,
                                  readOnly: true,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    hintText: "Departure Time",
                                    suffixIcon: Icon(Icons.timer),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (pickedTime != null) {
                                      setState(() {
                                        depTime.text =
                                            pickedTime.format(context);
                                        selectedDepTime = pickedTime;
                                      });
                                    }
                                  },
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              margin: const EdgeInsets.all(5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 1),
                                child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Required Field";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: arrTime,
                                    readOnly: true,
                                    textAlign: TextAlign.start,
                                    decoration: const InputDecoration(
                                      hintText: "Arrival Time",
                                      suffixIcon: Icon(Icons.timer),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                    onTap: () async {
                                      final TimeOfDay? selectTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if (selectTime != null) {
                                        setState(() {
                                          arrTime.text =
                                              selectTime.format(context);
                                          selectedArrTime = selectTime;
                                        });
                                      }
                                    }),
                              )),

                          //End of time of flight

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    //width: double.infinity,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 2,
                                              offset: Offset(0, 0))
                                        ],
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          bottom: 12,
                                          top: 8),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("From Airport"),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              selectedCity1 != null
                                                  ? '${shortCutFlightName[selectedCity1]}'
                                                  : '',
                                            ),
                                          ]),
                                    )),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    //width: double.infinity,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 2,
                                              offset: Offset(0, 0))
                                        ],
                                        borderRadius: BorderRadius.circular(13),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          bottom: 12,
                                          top: 8),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //const Icon(Icons.airplanemode_active),

                                            Text("To Airport"),
                                            Text(
                                              selectedCity2 != null
                                                  ? '${shortCutFlightName[selectedCity2]}'
                                                  : '',
                                            ),
                                          ]),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),

                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin: const EdgeInsets.all(5),
                                //width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 2, offset: Offset(0, 0))
                                    ],
                                    borderRadius: BorderRadius.circular(13),
                                    color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 0),
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Please Enter an integer';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: numOfGuest,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.start,
                                      decoration: const InputDecoration(
                                        hintText: "Guest Seats",
                                        suffixIcon: Icon(Icons.man_4),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 20),
                                      )),
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Container(
                                margin: const EdgeInsets.all(5),
                                //width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 2, offset: Offset(0, 0))
                                    ],
                                    borderRadius: BorderRadius.circular(13),
                                    color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 0),
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Please Enter an integer';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: numOfBusiness,
                                      textAlign: TextAlign.start,
                                      decoration: const InputDecoration(
                                        hintText: "Business Seats",
                                        suffixIcon: Icon(Icons.man),
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 20),
                                      )),
                                ),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                margin: const EdgeInsets.all(5),
                                //width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 2, offset: Offset(0, 0))
                                    ],
                                    borderRadius: BorderRadius.circular(13),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, bottom: 0, right: 8),
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^\d+(\.\d+)?$')
                                            .hasMatch(value)) {
                                          return 'Please a price';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: guestPrice,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.start,
                                      decoration: const InputDecoration(
                                        hintText: "Guset Price",
                                        suffixText: "SAR",
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 20),
                                      )),
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Container(
                                margin: const EdgeInsets.all(5),
                                //width: double.infinity,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 2, offset: Offset(0, 0))
                                    ],
                                    borderRadius: BorderRadius.circular(13),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, bottom: 0, right: 8),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Required Field";
                                      }

                                      if (!RegExp(r'^\d+(\.\d+)?$')
                                          .hasMatch(value)) {
                                        return 'Please a price';
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: businessPrice,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.start,
                                    decoration: const InputDecoration(
                                      hintText: "Business Price",
                                      suffixText: "SAR",
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 20),
                                    ),
                                  ),
                                ),
                              ))
                            ],
                          ),

                          //
                          TextButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  try {
                                    DateTime departur = DateTime(
                                        selectedDepDate!.year,
                                        selectedDepDate!.month,
                                        selectedDepDate!.day,
                                        selectedDepTime.hour,
                                        selectedDepTime.minute);

                                    DateTime arriv = DateTime(
                                        selectedArrDate!.year,
                                        selectedArrDate!.month,
                                        selectedArrDate!.day,
                                        selectedArrTime.hour,
                                        selectedArrTime.minute);

                                    if (departur.isBefore(arriv)) {
                                      DateTime dateTimeDep = DateTime(
                                          1980,
                                          1,
                                          1,
                                          selectedDepTime.hour,
                                          selectedDepTime.minute);

                                      DateTime dateTimeArr = DateTime(
                                          1980,
                                          1,
                                          1,
                                          selectedArrTime.hour,
                                          selectedArrTime.minute);

                                      createFlight(
                                          fromCity: selectedCity1,
                                          toCity: selectedCity2,
                                          fromAirport: fromAir.text,
                                          toAirport: toAir.text,
                                          numOfBusiness: numOfBusiness.text,
                                          numOfGuest: numOfGuest.text,
                                          guestPrice: guestPrice.text,
                                          busPrice: businessPrice.text,
                                          depDate: selectedDepDate,
                                          arrDate: selectedArrDate,
                                          arrTime: dateTimeArr,
                                          depTime: dateTimeDep);

                                      clearAllFields();
                                      await showFeedback(
                                          context, 'Flight Added');
                                    } else {
                                      await showErrorDialog(context,
                                          'The arrival  must be after the departure ');
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(5),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 2, offset: Offset(0, 0))
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.green[500]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Create flight",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ));
  }
}
