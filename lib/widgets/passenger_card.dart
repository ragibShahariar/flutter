import 'package:flutter/material.dart';

class PassengerCard extends StatelessWidget {
  PassengerCard({
    super.key,
    required this.name,
    required this.phone,
    required this.id,
    required this.seat,
    required this.delete,
  });

  final String name;
  final String phone;
  final String id;
  final int seat;
  final VoidCallback delete; // Function to delete a passenger

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.white24, Colors.black26],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(Icons.person_4_outlined),
              ),
              SizedBox(width: 10),
              Expanded( // Use Expanded here to ensure text fits properly in the remaining space
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('  Name:  '),
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('  Phone:  '),
                        Text(phone),
                      ],
                    ),
                    Row(
                      children: [
                        Text('  Seat:  '),
                        Text(seat.toString()),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: delete, // Call the delete function
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
