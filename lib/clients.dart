import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Clients",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.09,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Image.asset(
                        "assets/ipo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('clients').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var clients = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        var clientData = clients[index].data() as Map<String, dynamic>;
                        var documentId = clients[index].id;

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  clientData['companyname'],
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "NAME: ",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                clientData['name'],
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "CONTACT: ",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                clientData['contact'],
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "CITY: ",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                clientData['city'],
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "ADDRESS: ",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                clientData['address'],
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "EMAIL: ",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                clientData['email'],
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.green),
                                    onPressed: () {
                                      _editClient(clientData, documentId);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _deleteClient(clientData, documentId);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editClient(Map<String, dynamic> clientData, String documentId) async {
    TextEditingController companyNameController = TextEditingController(text: clientData['companyname']);
    TextEditingController nameController = TextEditingController(text: clientData['name']);
    TextEditingController contactController = TextEditingController(text: clientData['contact']);
    TextEditingController cityController = TextEditingController(text: clientData['city']);
    TextEditingController addressController = TextEditingController(text: clientData['address']);
    TextEditingController emailController = TextEditingController(text: clientData['email']);

    bool edited = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Client"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Company Name:"),
                TextField(
                  controller: companyNameController,
                ),
                SizedBox(height: 10),
                Text("Name:"),
                TextField(
                  controller: nameController,
                ),
                SizedBox(height: 10),
                Text("Contact:"),
                TextField(
                  controller: contactController,
                ),
                SizedBox(height: 10),
                Text("City:"),
                TextField(
                  controller: cityController,
                ),
                SizedBox(height: 10),
                Text("Address:"),
                TextField(
                  controller: addressController,
                ),
                SizedBox(height: 10),
                Text("Email:"),
                TextField(
                  controller: emailController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Perform the update in Firestore
                try {
                  await FirebaseFirestore.instance.collection('clients').doc(documentId).update({
                    'companyname': companyNameController.text,
                    'name': nameController.text,
                    'contact': contactController.text,
                    'city': cityController.text,
                    'address': addressController.text,
                    'email': emailController.text,
                  });
                  print("Client ${companyNameController.text} updated successfully.");
                  Navigator.of(context).pop(true);
                } catch (e) {
                  print("Error updating client: $e");
                  // Handle error as needed
                  Navigator.of(context).pop(false);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );

    if (edited == true) {
      // Update successful, you can perform any additional actions if needed
    } else {
      // Update failed or was canceled, handle accordingly
    }
  }


  void _deleteClient(Map<String, dynamic> clientData, String documentId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete ${clientData['companyname']}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('clients').doc(documentId).delete();
                  print("Client ${clientData['companyname']} deleted successfully.");
                } catch (e) {
                  print("Error deleting client: $e");
                  // Handle error as needed
                }
                Navigator.of(context).pop(true);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
