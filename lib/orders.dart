
import 'package:eaglemachinesadminmain/driver_selection.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late List<Order> orders;
  String Selectedbutton = "New Orders";


  @override
  void initState() {
    super.initState();
    orders = [];

      fetchOrders();


  }
  Future<void> fetchOrders() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;

      if (Selectedbutton == "Current Month") {
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth =
        DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

        querySnapshot = await FirebaseFirestore.instance
            .collection('Orders')
            .where('Timestamp', isGreaterThanOrEqualTo: startOfMonth)
            .where('Timestamp', isLessThanOrEqualTo: endOfMonth)
            .orderBy('Timestamp')
            .get();
      } else if (Selectedbutton == "All Orders") {
        querySnapshot = await FirebaseFirestore.instance
            .collection('Orders')
            .orderBy('Timestamp')
            .get();
      } else {
        // Default to "New Orders"
        querySnapshot = await FirebaseFirestore.instance
            .collection('Orders')
            .where("Status", isEqualTo: "UNCHECKED")
            .get();
      }

      setState(() {
        orders = querySnapshot.docs
            .map((doc) => Order.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                //  color: Colors.deepPurple,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {

                                setState(() {
                                  Selectedbutton = "New Orders";


                                });

                                fetchOrders();



                              },
                              style: ElevatedButton.styleFrom(
                                primary: (Selectedbutton == "New Orders")
                                    ? Colors.green
                                    : Colors.white,
                                onPrimary: (Selectedbutton == "New Orders")
                                    ? Colors.white
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: Text("New Orders")),
                        ),  SizedBox(width: 4,), Container(
                          width: MediaQuery.of(context).size.width * 0.38,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {

                                setState(() {
                                  Selectedbutton = "Current Month";

                                });
                                fetchOrders();
                                },
                              style: ElevatedButton.styleFrom(
                                primary: (Selectedbutton == "Current Month")
                                    ? Colors.green
                                    : Colors.white,
                                onPrimary: (Selectedbutton == "Current Month")
                                    ? Colors.white
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: Text("Current Month")),
                        ) ,SizedBox(width: 4,),  Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {

                                setState(() {
                                  Selectedbutton = "All Orders";

                                });
                                fetchOrders();




                              },
                              style: ElevatedButton.styleFrom(
                                primary: (Selectedbutton == "All Orders")
                                    ? Colors.green
                                    : Colors.white,
                                onPrimary: (Selectedbutton == "All Orders")
                                    ? Colors.white
                                    : Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: Text("All Orders")),
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
              flex: 8,
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Builder(
                    builder: (context) {
                      return OrderDetailsWidget(order: orders[index], selected_button: Selectedbutton, fetchOrders: () { fetchOrders(); },);
                    }
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsWidget extends StatelessWidget {
  final Order order;
  final String selected_button;
  final VoidCallback fetchOrders;


  OrderDetailsWidget({

    required this.order,
    required this.selected_button,
    required this.fetchOrders,


  });



  @override
  Widget build(BuildContext context) {

    void showSnackbar(String message, Color color) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        // Implement onTap functionality, e.g., navigation or edit mode
        // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(order: order)));
      },
      child: Card(
        margin: EdgeInsets.all(2.0),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClientsDetailsWidget(order: order),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              _buildEditableField(context, 'Category', order.category, selected_button, order.id),
              _buildEditableField(
                  context, 'Timestamp', formatDateTime(order.timestamp),selected_button, order.id),
              _buildEditableField(
                  context, 'Capacity', order.capacity.toString(),selected_button, order.id),
              _buildEditableField(context, 'Daily Basis', order.dailyBasis,selected_button, order.id),
              _buildEditableField(context, 'Monthly Basis', order.monthlyBasis,selected_button, order.id),
              _buildEditableField(context, 'Order Starting Time',
                  formatTime(order.orderStartingTime),selected_button, order.id),
              _buildEditableField(context, 'Order Starting Date',
                  formatDate(order.orderStartingDate),selected_button, order.id),
              _buildEditableField(
                  context, 'Total Hours', order.totalHours.toString(),selected_button, order.id),
              _buildEditableField(context, 'Address', order.address,selected_button, order.id),
              _buildEditableField(context, 'Coordinates', order.coordinates,selected_button, order.id),
              _buildEditableField(context, 'Status', order.status,selected_button, order.id),
              _buildEditableField(
                  context, 'Total Bill', order.totalBill.toString(),selected_button, order.id),
              _buildEditableField(context, 'Payment', order.payment,selected_button, order.id),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () async {

                          CollectionReference collectionRef = FirebaseFirestore.instance.collection("Orders");

                          // Reference to the document
                          DocumentReference documentRef = collectionRef.doc(order.id);
                          if(selected_button=="New Orders"){
                            await documentRef.update({
                              "Status": "REJECTED",
                            });
                            showSnackbar("REJECTED", Colors.red);
                           fetchOrders();
                          }else {
                            await documentRef.delete();
                            showSnackbar("DELETED", Colors.red);
                            fetchOrders();
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          primary:
                          Colors.white,

                          onPrimary:
                          Colors.red,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child:  Text(selected_button=="New Orders"?"Reject":"Delete")),
                  ),
                  SizedBox(width: 10,),
                  (selected_button=="New Orders")? Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:  (context) => DriverSelection(documentId: order.id)));
                        },
                        style: ElevatedButton.styleFrom(
                          primary:
                               Colors.green,

                          onPrimary:
                               Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text("Confirm")),
                  ):SizedBox(),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime.toLocal());
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date.toLocal());
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime.toLocal());
  }

  Widget _buildEditableField(BuildContext context, String label, String value , String Selected_button, String documnt_id) {
    return InkWell(
      onTap: () {
        // Show Snackbar indicating the clicked field for editing

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                (Selected_button=="New Orders")? GestureDetector(onTap: () {
// category not working
                  if(label=="Category"){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String selectedCategory = value;

                        return AlertDialog(
                          title: Text('Select Category'),
                          content: Row(
                            children: [
                              Radio(
                                value: 'Forklift',
                                groupValue: selectedCategory,
                                onChanged: (value) {
                                  selectedCategory = value as String;
                                },
                              ),
                              Text('Forklift'),
                              Radio(
                                value: 'Crane',
                                groupValue: selectedCategory,
                                onChanged: (value) {
                                  selectedCategory = value as String;
                                },
                              ),
                              Text('Crane'),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                // Update the value in the Firebase collection
                                await FirebaseFirestore.instance.collection('Orders').doc(documnt_id).update({
                                  'Category': selectedCategory,
                                });

                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Update'),
                            ),
                          ],
                        );
                      },
                    );




                  }
                  },child: Icon(Icons.edit)): SizedBox(),
                SizedBox(width: 8.0),
                Text(
                  '$label:',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientsDetailsWidget extends StatelessWidget {
  final Order order;

  ClientsDetailsWidget({required this.order});

  @override
  Widget build(BuildContext context) {
    if (order.clientId == null || order.clientId.isEmpty) {
      return Text('Client ID is null or empty');
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('clients')
          .doc(order.clientId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can replace this with a loading indicator widget
        }

        if (snapshot.hasError) {
          return Text('Error fetching client details: ${snapshot.error}');
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.data() == null) {
          return Text('Client details not found for ID: ${order.clientId}');
        }

        // Updated type cast for clientDetails
        var clientDetails = snapshot.data!.data()! as Map<String, dynamic>;

        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.green,
              ),
            ),
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Clients Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text('Company Name: ${clientDetails['companyname']}'),
                Text('Person Name: ${clientDetails['name']}'),
                Text('Contact: ${clientDetails['contact']}'),
                Text('City: ${clientDetails['city']}'),
                Text('Email: ${clientDetails['email']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Order {
  String id; // Document ID for the order
  String clientId;
  String category;
  DateTime timestamp;
  int capacity;
  String dailyBasis;
  String monthlyBasis;
  int totalHours;
  DateTime orderStartingTime;
  DateTime orderStartingDate;
  String address;
  String coordinates;
  String status;
  double totalBill;
  String payment;

  Order({
    required this.id,
    required this.clientId,
    required this.category,
    required this.timestamp,
    required this.capacity,
    required this.dailyBasis,
    required this.monthlyBasis,
    required this.totalHours,
    required this.orderStartingTime,
    required this.orderStartingDate,
    required this.address,
    required this.coordinates,
    required this.status,
    required this.totalBill,
    required this.payment,
  });

  factory Order.fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      clientId: map['ClientId'] ?? '',
      // Use 'ClientId' field from the order document
      category: map['Category'] ?? '',
      timestamp:
          (map['Submission Date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      capacity: map['Capacity'] ?? 0,
      dailyBasis: map['DAILY_BASIS'] ?? '',
      monthlyBasis: map['MONTHLY_BASIS'] ?? '',
      totalHours: map['Total_Hours'] ?? 0,
      orderStartingTime: (map['Order_Starting_Time'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      orderStartingDate: (map['Order_Starting_Date'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      address: map['Address'] ?? '',
      coordinates: map['Quardinates'] ?? '',
      status: map['Status'] ?? '',
      totalBill: map['Total_Bill'] ?? 0.0,
      payment: map['Payment'] ?? '',
    );
  }
}




