import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  TextEditingController perHourController = TextEditingController();
  TextEditingController monthlyController = TextEditingController();
  TextEditingController dailyController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController Capacity = TextEditingController();
  int value = 1;
  @override
  void initState() {
    super.initState();
    hoursController.text =
    '$value'; // Initialize hoursController with the initial value
  }

  int perHour = 0;

  int monthly = 0;
  int daily = 0;
  int hours = 0;
  int capacity=0;
  bool iscontiner = true;
 // Initial value for the TextField
  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
  bool isLoading = false;

  String selectedEquipment = "";
  void resetTextControllers() {
    perHourController.clear();
    monthlyController.clear();
    dailyController.clear();
    hoursController.text = '$value';
    Capacity.clear();
    // Add other controllers as needed
  }

  void handleButtonClick() async {
    if (perHourController.text.isEmpty) {
      showSnackbar("Please enter the rate per hour", Colors.red);
    } else if (hoursController.text.isEmpty) {
      showSnackbar("Please enter the minimum hours", Colors.red);
    } else if (dailyController.text.isEmpty) {
      showSnackbar("Please enter the daily basis", Colors.red);
    } else if (monthlyController.text.isEmpty) {
      showSnackbar("Please enter the monthly basis", Colors.red);

    }else if (Capacity.text.isEmpty) {
      showSnackbar("Enter Capacity", Colors.red);
    } else if (selectedEquipment.isEmpty) {
      showSnackbar("Please select equipment (Crane or Forklift)", Colors.red);
    } else {

      setState(() {
        isLoading = true;
      });
      // Convert text controller values to integers
      perHour = int.parse(perHourController.text);
      monthly = int.parse(monthlyController.text);
      daily = int.parse(dailyController.text);
      hours = int.parse(hoursController.text);
      capacity=int.parse(Capacity.text);

      // Store data in the Firebase collection
      await FirebaseFirestore.instance.collection('ratesperhour').add({
        'Rate_Per_Hour': perHour,
        'Monthly_Rate': monthly,
        'Daily_Rate': daily,
        'Minimum_Hours': hours,
        'Capacity': capacity,
        'Category': selectedEquipment,

      });

      setState(() {
        isLoading = false;
      });
      showSnackbar("Added", Colors.green);
      resetTextControllers();
      setState(() {
        iscontiner = !iscontiner;
      });
    }}


    void incrementValue() {
      setState(() {
        value++;
        hoursController.text = '$value';
      });
    }

    void decrementValue() {
      if (value > 1) {
        setState(() {
          value--;
          hoursController.text = '$value';
        });
      }
    }


    @override
    Widget build(BuildContext context) {
      double buttonSize = MediaQuery
          .of(context)
          .size
          .width * 0.1;
      return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.25,
                      width: double.infinity,
                      // color: Colors.blue,
                      child: (iscontiner)
                          ? Text(" Hello")
                          : SingleChildScrollView(
                        child: Column(
                            children: [


                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text("Add New Rates", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.05,
                                      ),),
                                      SizedBox(height: 4,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Container(

                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.28,
                                            //  color: Colors.blue,
                                            child: Container(
                                              child:
                                              TextField(
                                                controller: perHourController,
                                                keyboardType: TextInputType
                                                    .number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],
                                                decoration: InputDecoration(
                                                  labelText: 'Rate/h',
                                                  labelStyle: TextStyle(
                                                      color: Colors.green),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(5.0),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.monetization_on,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),

                                          Container(

                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.28,
                                            child: Container(
                                              child:
                                              TextField(
                                                controller: dailyController,
                                                keyboardType: TextInputType
                                                    .number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],

                                                decoration: InputDecoration(
                                                  labelText: 'Daily Basis',
                                                  labelStyle: TextStyle(
                                                      color: Colors.green),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(5.0),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons
                                                        .monetization_on_outlined,
                                                    color: Colors.green,
                                                  ),
                                                ),

                                              ),


                                            ),


                                          ),
                                          Container(

                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.28,
                                            //  color: Colors.blue,
                                            child: Container(
                                              child:
                                              TextField(
                                                controller: monthlyController,
                                                keyboardType: TextInputType
                                                    .number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],
                                                decoration: InputDecoration(
                                                  labelText: 'Montly Basis',
                                                  labelStyle: TextStyle(
                                                      color: Colors.green),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(5.0),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.monetization_on,
                                                    color: Colors.green,
                                                  ),
                                                ),

                                              ),


                                            ),


                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Container(

                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.38,
                                            child: Container(
                                              child:
                                              TextField(
                                                controller: hoursController,
                                                keyboardType: TextInputType
                                                    .number,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText: 'Minimum Hours',
                                                  labelStyle: TextStyle(
                                                      color: Colors.green),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(5.0),
                                                  ),
                                                  prefixIcon: GestureDetector(
                                                    onTap: decrementValue,
                                                    child: Icon(
                                                      Icons.linear_scale_sharp,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  suffixIcon: GestureDetector(
                                                    onTap: incrementValue,
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (newValue) {
                                                  // Handle changes to the text if needed
                                                },
                                              ),


                                            ),


                                          ),

                                          SizedBox(width: 10,),
                                          Container(

                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.38,
                                            //  color: Colors.blue,
                                            child: Container(
                                              child:
                                              TextField(
                                                controller: Capacity,
                                                keyboardType: TextInputType
                                                    .number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],
                                                decoration: InputDecoration(
                                                  labelText: 'Capacity',
                                                  labelStyle: TextStyle(
                                                      color: Colors.green),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(10.0),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.green),
                                                    borderRadius: BorderRadius
                                                        .circular(5.0),
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.monetization_on,
                                                    color: Colors.green,
                                                  ),
                                                ),

                                              ),


                                            ),


                                          ),
                                          SizedBox(width: 4,),





                                        ],
                                      ), SizedBox(height: 4,),
                                      Row( mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [

                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: "Crane",
                                                      groupValue: selectedEquipment,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedEquipment =
                                                          value!;
                                                        });
                                                      },
                                                      activeColor: Colors.green,
                                                    ),
                                                    Text("Crane"),
                                                    Radio(
                                                      value: "Forklift",
                                                      groupValue: selectedEquipment,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedEquipment =
                                                          value!;
                                                        });
                                                      },
                                                      activeColor: Colors.green,
                                                    ),
                                                    Text("Forklift"),
                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4,),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add your button click logic here
                                   handleButtonClick();

                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: CircleBorder(),
                                          primary: Colors.green,
                                          padding: EdgeInsets.all(buttonSize *
                                              0.3), // Adjust padding as needed
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: buttonSize * 0.5,
                                          // Adjust icon size as needed
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),


                            ]

                        ),
                      ),


                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green,

                        ),
                      ),

                    ),

                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                iscontiner = !iscontiner;
                              });
                            },
                            child: Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.25,

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(child:
                                      Icon(
                                        Icons.monetization_on_outlined,
                                        color: Colors.green,
                                        size: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            0.1, // Adjust the size as needed
                                      ),),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Container(child: Text(
                                        "Rates/h", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green
                                      ),))),
                                ],


                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.green,

                                ),
                              ),


                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                  if (isLoading)
                    Container(

                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                ],



              ),
            ),


          ),
        ),


      );
    }
  }

