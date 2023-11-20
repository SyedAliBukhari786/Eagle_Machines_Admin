import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {
          _auth.signOut();


        }, child: Text("Hellooo")),
      ),





    );
  }
}
