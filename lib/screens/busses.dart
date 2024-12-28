import 'package:flutter/material.dart';
import 'package:ticket_management/models/Bus.dart';
import 'package:ticket_management/database_file.dart';
import 'package:ticket_management/widgets/bus_card.dart'; // Import BusCard

class BussesPage extends StatefulWidget {
  @override
  _BussesPageState createState() => _BussesPageState();
}

class _BussesPageState extends State<BussesPage> {
  List<Bus> busList = [];

  @override
  void initState() {
    super.initState();
    loadBusses();
  }

  Future<void> loadBusses() async {
    final data = await ManagementDatabaseHelper().getBuses();
    setState(() {
      busList = data.map((bus) => Bus.fromMap(bus)).toList();
    });
  }

  void addBusDialog() {
    final TextEditingController routeController = TextEditingController();
    final TextEditingController totalCapacityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Bus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: routeController,
                decoration: InputDecoration(labelText: 'Route'),
              ),
              TextField(
                controller: totalCapacityController,
                decoration: InputDecoration(labelText: 'Total Capacity'),
                keyboardType: TextInputType.number,
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
                final busID = DateTime.now().millisecondsSinceEpoch.toString();
                final totalCapacity =
                    int.tryParse(totalCapacityController.text) ?? 0;

                final bus = Bus(
                  busID: busID,
                  route: routeController.text,
                  totalCapacity: totalCapacity,
                  availCapacity: totalCapacity, // Initially available equals total
                );

                await ManagementDatabaseHelper().insertBus(bus);

                setState(() {
                  busList.add(bus);
                });

                Navigator.pop(context);
              },
              child: Text('Add Bus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busses'),
        actions: [
          IconButton(
            onPressed: addBusDialog,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: busList.length,
        itemBuilder: (context, index) {
          final bus = busList[index];
          return Stack(
            children: [
              BusCard(
                busID: bus.busID,
                route: bus.route,
                capacity: bus.totalCapacity,
              ),
              Positioned(
                top: 30,
                right: 30,
                child: IconButton(
                  tooltip: 'delete bus',
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ManagementDatabaseHelper().deleteBus(bus.busID);
                    setState(() {
                      busList.removeAt(index);
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
