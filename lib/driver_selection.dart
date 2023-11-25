import 'package:eaglemachinesadminmain/Maindashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DriverSelection extends StatefulWidget {
  final String documentId;

  const DriverSelection({Key? key, required this.documentId}) : super(key: key);

  @override
  State<DriverSelection> createState() => _DriverSelectionState();
}

class _DriverSelectionState extends State<DriverSelection> {
  late String storedDocumentId; // New variable to store the document ID

  @override
  void initState() {
    super.initState();
    storedDocumentId = widget.documentId; // Store the document ID when the widget initializes
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // You can customize the title
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Machine Selection",
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07, fontWeight: FontWeight.bold),
                ),
              ),


              SizedBox(height: 10,),
              Expanded(
                flex: 6,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Text("Available Machines"),
                                Expanded(
                                  child: FreeMachinesList(data: storedDocumentId,),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FreeMachinesList extends StatelessWidget {
  final String data;
  const FreeMachinesList({Key? key, required this.data}) : super(key: key);






  @override
  Widget build(BuildContext context) {
    void confirmSelection(String machineId, String driverId) async {
      // Add your logic to update the Firestore collection (Billing)
      try {

        final snackBar = SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: CustomSnackbarContent(message: "Adding information to Machine\n Driver and you client"),
          duration: Duration(seconds: 10),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await FirebaseFirestore.instance.collection('billing').add({
          'Order_id': data,
          'Machine_id': machineId,
          'Driver_id': driverId,
          'CHECKED_TIME': FieldValue.serverTimestamp(), // Add a timestamp for reference
        });

        CollectionReference collectionRef = FirebaseFirestore.instance.collection("Orders");

        // Reference to the document
        DocumentReference documentRef = collectionRef.doc(data);
        await documentRef.update({
          "Status": "CHECKED",
          "Driver_id":driverId,
        });

        CollectionReference collectionRef2 = FirebaseFirestore.instance.collection("machines");

        // Reference to the document
        DocumentReference documentRef2 = collectionRef2.doc(machineId);
        await documentRef2.update({
          "Status": "Working",
        });


        // You can add additional logic here if needed

        // Show a success message or perform any other actions

        Navigator.pop(context);

      } catch (error) {
        // Handle errors, show an error message, or log the error
        print('Error confirming selection: $error');
      }
    }








    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('machines').where("Status", isEqualTo: "Free").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var machine = snapshot.data!.docs[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('drivers').doc(machine['Driver_id']).get(),
              builder: (context, driverSnapshot) {
                if (!driverSnapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final registrationNumber = machine['RegistrationNumber'];
                final category = machine['Category'];
                final companyName = machine['Companyname'];
                final address = machine['Address'];
                final coordinates = machine['Quardinates'];
                final ton = machine['TON'];
                final driverId = machine['Driver_id'];

                // Get driver information from the drivers collection
                final driverName = driverSnapshot.data!['name'];
                final driverContact = driverSnapshot.data!['contact'];

                // Add a button to confirm for each machine
                Widget confirmButton = ElevatedButton(
                  onPressed: () {
                    confirmSelection(machine.id, driverId);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text('Select'),
                );

                // Display different image based on the category
                Widget categoryImage = SizedBox(); // Default empty container
                if (category == 'Forklift') {
                  categoryImage = Image.asset(
                    'assets/forklift.png',
                    width: 25,
                    height: 25,
                  );
                } else if (category == 'Crane') {
                  categoryImage = Image.asset(
                    'assets/crane.png',
                    width: 25,
                    height: 25,
                  );
                }

                // Create a widget for each machine
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Registration Number: $registrationNumber'),
                      Row(
                        children: [
                          Text('Category: $category' + " "), categoryImage,
                        ],
                      ),
                      Text('Company Name: $companyName'),
                      Text('Address: $address'),
                      Text('Coordinates: $coordinates'),
                      Text('Capacity: $ton'),
                      //Text('Driver ID: $driverId'),
                      // Display the category image
                      Text('Driver Name: $driverName'),
                      Text('Driver Contact: $driverContact'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          confirmButton,
                        ],
                      ), // Display the confirm button
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CustomSnackbarContent extends StatefulWidget {
  final String message;

  const CustomSnackbarContent({Key? key, required this.message}) : super(key: key);

  @override
  _CustomSnackbarContentState createState() => _CustomSnackbarContentState();
}

class _CustomSnackbarContentState extends State<CustomSnackbarContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: _animation.value,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 10.0,
                percent: 1 - _animation.value,
                animation: true,
                animationDuration: 10000,
                center: Text(
                  '${(_animation.value * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                progressColor: Colors.green,
              ),
              SizedBox(height: 16.0),
              Text(
                'Adding information to Machine\n Driver and your client',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

