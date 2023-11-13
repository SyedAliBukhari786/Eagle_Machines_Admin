import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Drivers extends StatefulWidget {
  const Drivers({Key? key}) : super(key: key);

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String email = '';
  String name = '';
  String contact = '';
  String machine = '';
  String password = '';
  String confirmPassword = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isContainerVisible = false; // To track the visibility of the container.
  bool isLoading = false;

  void toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  void registerDriver() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Register user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add additional user data to Firestore
      await _firestore.collection('drivers').doc(userCredential.user!.uid).set({
        'name': name,
        'contact': contact,
        'machineid': "NULL",
      });

      // Registration successful
      displaySnackbar("Registration successful");
    } on FirebaseAuthException catch (e) {
      displaySnackbar("Registration failed. ${e.message}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isValidEmail(String email) {
    final emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  void displaySnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<User?> _getUserForDriver(String driverId) async {
    List<String> methods = await _auth.fetchSignInMethodsForEmail(driverId);
    if (methods.isNotEmpty) {
      return _auth.currentUser;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
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

                        return FutureBuilder<User?>(
                          future: _getUserForDriver(driver.id),
                          builder: (context, userSnapshot) {
                            User? driverUser = userSnapshot.data;

                            return DriverCard(
                              email: driverUser?.email ?? 'Email not available',
                              name: driver['name'],
                              contact: driver['contact'],
                              onDelete: () async {
                                // Show a confirmation dialog
                                bool deleteConfirmed = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Are you sure?'),
                                      content: Text('Do you want to delete this driver?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // Delete the driver if confirmed
                                if (deleteConfirmed == true) {
                                  await _firestore.collection('drivers').doc(driver.id).delete();
                                  // You may also want to delete the corresponding user from Firebase Authentication
                                  if (driverUser != null) {
                                    await driverUser!.delete();
                                    print('User deleted from Firebase Authentication');
                                  }
                                }
                              },
                              onEdit: () async {
                                // Show a dialog for editing
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    TextEditingController editedNameController =
                                    TextEditingController(text: driver['name']);
                                    TextEditingController editedContactController =
                                    TextEditingController(text: driver['contact']);

                                    return AlertDialog(
                                      title: Text('Edit Driver'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: editedNameController,
                                            decoration: InputDecoration(labelText: 'Edit Name'),
                                          ),
                                          TextField(
                                            controller: editedContactController,
                                            decoration: InputDecoration(labelText: 'Edit Contact'),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            // Update Firestore with edited values
                                            await _firestore
                                                .collection('drivers')
                                                .doc(driver.id)
                                                .update({
                                              'name': editedNameController.text,
                                              'contact': editedContactController.text,
                                            });

                                            print('Driver details updated in Firestore');
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: isContainerVisible,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 0.85 * MediaQuery.of(context).size.width,
                    height: 0.75 * MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                          Container(
                            height: MediaQuery.of(context).size.width * 0.25,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/bus-driver.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Driver Registration",
                            style: GoogleFonts.bebasNeue(
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              children: [
                                Container(
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
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
                                        Icons.email,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  child: TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
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
                                SizedBox(height: 5),
                                Container(
                                  child: TextField(
                                    controller: contactController,
                                    decoration: InputDecoration(
                                      labelText: 'Contact',
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
                                        Icons.phone,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
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
                                        Icons.lock,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  child: TextField(
                                    controller: confirmPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
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
                                        Icons.lock,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.45,
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
                                    onPressed: () {
                                      email = emailController.text;
                                      name = nameController.text;
                                      contact = contactController.text;
                                      password = passwordController.text;
                                      confirmPassword = confirmPasswordController.text;
                                      registerDriver();
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleContainerVisibility,
        child: Icon(Icons.add),
      ),
    );
  }
}

class DriverCard extends StatelessWidget {
  final String email;
  final String name;
  final String contact;

  final VoidCallback onDelete;
  final VoidCallback onEdit;

  DriverCard({
    required this.email,
    required this.name,
    required this.contact,

    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' Driver Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.05),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Name: $name'),
            SizedBox(height: 8),
            Text('Contact: $contact'),
            SizedBox(height: 16),
            Center(
              child: Container(
                height: 200,
                width: 200,
                color: Colors.green,
                child: Center(child: Text("Machines data")),

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
