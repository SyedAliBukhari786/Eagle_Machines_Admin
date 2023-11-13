import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Machines extends StatefulWidget {
  const Machines({Key? key}) : super(key: key);

  @override
  State<Machines> createState() => _MachinesState();
}

class _MachinesState extends State<Machines> {
  TextEditingController registrationnumber=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController companyname=TextEditingController();
  bool isContainerVisible = false; // To track the visibility of the container.
  String driverid = '';
  String driverName = '';
  String Companyname='';
  String Address='';
  String RegistrationNumber='';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _openDriverList() {
    // Show a modal or dropdown here to display the list of drivers
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Driver'),
          content: Container(
            width: double.maxFinite,
            child: StreamBuilder(
              stream: _firestore.collection('drivers').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<QueryDocumentSnapshot> drivers = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: drivers.length,
                  itemBuilder: (context, index) {
                    var driver = drivers[index];

                    return ListTile(
                      title: Text(driver['name']),
                      subtitle: Text(driver['contact']),
                      onTap: () {
                        // Update the selected driver's ID and close the modal
                        setState(() {
                          driverid = driver.id;
                          driverName = driver['name'];
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  String selectedCategory = "";

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }
  void displayErrorSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  List<int> circleValues = [3, 5, 7, 10, 15, 25, 50, 75, 100, 150, 200, 500];
  int TON = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text('Your content goes here'), // Replace with your content
          ),
          Visibility(
            visible: isContainerVisible,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                //  alignment: Alignment.center,
                width: 0.85 *
                    MediaQuery.of(context)
                        .size
                        .width, // 80% of the screen width
                height: 0.75 *
                    MediaQuery.of(context)
                        .size
                        .height, // 70% of the screen height
                // color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: toggleContainerVisibility,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Machine Registration",
                        style: GoogleFonts.bebasNeue(
                            fontSize: MediaQuery.of(context).size.width * 0.1),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                selectCategory("Crane");
                              },
                              child: Container(
                                // fisrt Conatier
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.33,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // color: Colors.green,
                                child: Column(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                          // color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              "assets/crane.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Crane",
                                            style: GoogleFonts.acme(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            // color: Colors.green,
                                            decoration: BoxDecoration(
                                              color:
                                                  (selectedCategory == "Crane")
                                                      ? Colors.green
                                                      : Colors.transparent,
                                              // Set the background color of the container as transparent
                                              border: Border.all(
                                                color: Colors.green,
                                                // Set the border color to green
                                                width:
                                                    1.0, // Set the border width
                                              ),
                                              shape: BoxShape
                                                  .circle, // Make the container circular
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                selectCategory("Forklift");
                              },
                              child: Container(
                                // second Conatier
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.33,

                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                // color: Colors.red,
                                child: Column(
                                  children: [
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                          // color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              "assets/forklift.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Fork Lift",
                                            style: GoogleFonts.acme(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            // color: Colors.green,
                                            decoration: BoxDecoration(
                                              color: (selectedCategory ==
                                                      "Forklift")
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              // Set the background color of the container as transparent
                                              border: Border.all(
                                                color: Colors.green,
                                                // Set the border color to green
                                                width:
                                                    1.0, // Set the border width
                                              ),
                                              shape: BoxShape
                                                  .circle, // Make the container circular
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          children: [
                            Text(
                              "Capacity",
                              style: GoogleFonts.acme(
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.05,
                              ),

                            ),


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                spacing: 8.0, // Space between the circular containers
                                runSpacing: 8.0, // Space between rows
                                alignment: WrapAlignment.center,
                                children: circleValues.map((value) {
                                  bool isSelected = TON == value;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        TON = isSelected ? 0 : value;
                                      });
                                    },
                                    child: Container(
                                      width:  MediaQuery.of(context).size.width * 0.1,
                                      height:  MediaQuery.of(context).size.width * 0.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? Colors.green : Colors.black,
                                        ),
                                        color: isSelected ? Colors.green : Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 10,),

                       Container(
                         width: MediaQuery.of(context).size.width * 0.7,
                         child: Column(
                           children: [
                             Container(
                               child:
                                    TextField(
                                      controller: registrationnumber,
                                      decoration: InputDecoration(
                                        labelText: 'Registration Number',
                                        labelStyle: TextStyle(color: Colors.green),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.green),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.green),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.numbers,
                                          color: Colors.green,
                                        ),
                                      ),

                                    ),


                              ),
                             SizedBox(height: 5,),
                             Container(
                               child:
                               TextField(
                                 controller: address,
                                 decoration: InputDecoration(
                                   labelText: 'Address',
                                   labelStyle: TextStyle(color: Colors.green),
                                   focusedBorder: OutlineInputBorder(
                                     borderSide: BorderSide(color: Colors.green),
                                     borderRadius: BorderRadius.circular(10.0),
                                   ),
                                   enabledBorder: OutlineInputBorder(
                                     borderSide: BorderSide(color: Colors.green),
                                     borderRadius: BorderRadius.circular(10.0),
                                   ),
                                   prefixIcon: Icon(
                                     Icons.location_on,
                                     color: Colors.green,
                                   ),
                                 ),

                               ),


                             ),
                             SizedBox(height: 5,),
                             Container(
                               child:
                               TextField(
                                 onTap: _openDriverList, // Open the driver list on tap
                                 controller: TextEditingController(text: driverName),
                                 decoration: InputDecoration(
                                   labelText: 'Driver',
                                   labelStyle: TextStyle(color: Colors.green),
                                   focusedBorder: OutlineInputBorder(
                                     borderSide: BorderSide(color: Colors.green),
                                     borderRadius: BorderRadius.circular(10.0),
                                   ),
                                   enabledBorder: OutlineInputBorder(
                                     borderSide: BorderSide(color: Colors.green),
                                     borderRadius: BorderRadius.circular(10.0),
                                   ),
                                   prefixIcon: Icon(
                                     Icons.person,
                                     color: Colors.green,
                                   ),
                                 ),

                               ),


                             ),
                             SizedBox(height: 5,),
                             Container(
                               child:
                               TextField(
                                 controller: companyname,
                                 decoration: InputDecoration(
                                   labelText: 'Company Name',
                                   labelStyle: TextStyle(color: Colors.green),
                                   focusedBorder: OutlineInputBorder(
                                     borderSide: BorderSide(color: Colors.green),
                                     borderRadius: BorderRadius.circular(10.0),
                                   ),
                                   enabledBorder: OutlineInputBorder(
                                     borderSide: BorderSide(color: Colors.green),
                                     borderRadius: BorderRadius.circular(10.0),
                                   ),
                                   prefixIcon: Icon(
                                     Icons.location_city_sharp,
                                     color: Colors.green,
                                   ),
                                 ),

                               ),


                             ),

                             SizedBox(height: 5,),
                             Container(
                               width: MediaQuery.of(context).size.width * 0.45, // 30% of the screen width
                               height: 40,
                               child: ElevatedButton(
                                 style: ButtonStyle(
                                   backgroundColor: MaterialStateProperty.all(Colors.green),
                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                     RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(10),
                                       side: BorderSide(color: Colors.green),
                                     ),
                                   ),
                                 ),
                                 onPressed: () async {
                                   String tonString = TON.toString();
                                   Address = address.text.trim();
                                   Companyname = companyname.text.trim();
                                   RegistrationNumber = registrationnumber.text.replaceAll(' ', ''); // Remove spaces

                                   if (RegistrationNumber.isEmpty) {
                                     displayErrorSnackbar("Registration Number is Missing");
                                   } else if (Address.isEmpty) {
                                     displayErrorSnackbar("Address is Missing");
                                   } else if (Companyname.isEmpty) {
                                     displayErrorSnackbar("Company is Missing");
                                   } else if (driverid == "") {
                                     displayErrorSnackbar("Select is Driver");
                                   } else if (selectedCategory == "") {
                                     displayErrorSnackbar("Select is Category");
                                   } else if (tonString == "0") {
                                     displayErrorSnackbar("Select is Capacity");
                                   } else {
                                     try {
                                       // Show CircularProgressIndicator while adding data
                                       showDialog(
                                         context: context,
                                         builder: (BuildContext context) {
                                           return Center(
                                             child: CircularProgressIndicator(),
                                           );
                                         },
                                       );

                                       // Add data to Firestore
                                       await _firestore.collection('machines').doc(RegistrationNumber).set({
                                         'Address': Address,
                                         'Companyname': Companyname,
                                         'RegistrationNumber': RegistrationNumber,
                                         'TON': tonString,
                                         'Driver_id': driverid,
                                         'Category': selectedCategory,
                                         'Quardinates': "NULL",
                                         // Add other fields if needed
                                       });

                                       // Add data to the 'driver_machines' collection
                                       await _firestore.collection('driver_machines').add({
                                         'Driver_id': driverid,
                                         'Machine_id': RegistrationNumber,
                                       });

                                       // Close the CircularProgressIndicator dialog
                                       Navigator.pop(context);

                                       // Show success message
                                       final snackBar = SnackBar(
                                         content: Text("ADDED"),
                                         duration: Duration(seconds: 2),
                                       );
                                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                     } catch (e) {
                                       // Close the CircularProgressIndicator dialog
                                       Navigator.pop(context);

                                       // Show error message
                                       displayErrorSnackbar("Error adding data to Firestore: $e");
                                     }
                                   }
                                 },

                                 child: Text(
                                   'Register',
                                   style: TextStyle(
                                     color: Colors.white, // Green text color
                                   ),
                                 ),
                               ),
                             ),
                             SizedBox(height: 5,),


                           ],
                         ),
                       ),


                      // Your container content goes here
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleContainerVisibility,
        child: Icon(Icons.add),
      ),
    );
  }
}
