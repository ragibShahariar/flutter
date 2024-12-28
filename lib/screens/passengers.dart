import 'package:flutter/material.dart';
import 'package:ticket_management/database_file.dart';
import 'package:ticket_management/models/Passenger.dart';
import 'package:ticket_management/widgets/passenger_card.dart';

class Passengers extends StatefulWidget {
  Passengers({super.key});

  @override
  State<Passengers> createState() {
    return _PassengersState();
  }
}

class _PassengersState extends State<Passengers> {
  List<Passenger> passengerList = [];

  Future<void> loadPassengers() async {
    final data = await ManagementDatabaseHelper().getPassengers();
    setState(() {
      passengerList =
          data.map((passenger) => Passenger.fromMap(passenger)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadPassengers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Passengers"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController nameController = TextEditingController();
                  final TextEditingController phoneController = TextEditingController();
                  final TextEditingController seatController = TextEditingController();

                  return AlertDialog(
                    title: Text('Add Passenger'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: phoneController,
                          decoration: InputDecoration(labelText: 'Phone'),
                        ),
                        TextField(
                          controller: seatController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Seat Number'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (nameController.text.isEmpty ||
                              phoneController.text.isEmpty ||
                              seatController.text.isEmpty) {
                            // Handle invalid input
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }

                          final passengerID =
                          DateTime.now().millisecondsSinceEpoch.toString();

                          final passenger = Passenger(
                            passengerID: passengerID,
                            name: nameController.text,
                            phone: phoneController.text,
                            seatNo: int.tryParse(seatController.text) ?? 0,
                          );

                          await ManagementDatabaseHelper().insertPassenger(passenger);

                          setState(() {
                            passengerList.add(passenger);
                          });

                          Navigator.pop(context);
                        },
                        child: Text('Add Passenger'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),

        ],
      ),
      body: ListView.builder( // Removed Expanded, directly used ListView.builder
        itemCount: passengerList.length,
        itemBuilder: (context, index) {
          final passenger = passengerList[index];
          return PassengerCard(
            name: passenger.name,
            phone: passenger.phone,
            id: passenger.passengerID,
            seat: passenger.seatNo,
            delete: () async {
              // Delete the passenger from the database and update the list
              await ManagementDatabaseHelper()
                  .deletePassenger(passenger.passengerID);
              setState(() {
                passengerList.removeAt(index);
              });
            },
          );
        },
      ),
    );
  }
}
