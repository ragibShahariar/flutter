import 'package:ticket_management/models/Ticket.dart';
import 'package:ticket_management/models/Passenger.dart';
import 'package:ticket_management/models/Bus.dart';
import 'package:flutter/material.dart';
import 'package:ticket_management/widgets/ticket_card.dart';
import 'package:ticket_management/database_file.dart';

class Tickets extends StatefulWidget {
  Tickets({
    super.key,
    required this.ticketList,
    required this.passengerList,
    required this.busList,
  });

  final List<Ticket> ticketList;
  final List<Passenger> passengerList;
  final List<Bus> busList;

  @override
  State<Tickets> createState() => _TicketState();
}

class _TicketState extends State<Tickets> {
  List<Ticket> Tlist = [];
  Map<String, Passenger> passengerMap = {};
  Map<String, Bus> busMap = {};

  Future<void> loadTickets() async {
    final tickets = await ManagementDatabaseHelper().getTickets();
    final passengers = await ManagementDatabaseHelper().getPassengers();
    final buses = await ManagementDatabaseHelper().getBuses();

    setState(() {
      Tlist = tickets.map((ticket) => Ticket.fromMap(ticket)).toList();
      passengerMap = {
        for (var p in passengers)
          p['passengerID'].toString(): Passenger.fromMap(p),
      };
      busMap = {
        for (var b in buses) b['busID'].toString(): Bus.fromMap(b),
      };
    });
  }

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Tickets"),
        actions: [
          IconButton(
            onPressed: () async {
              final buses = await ManagementDatabaseHelper().getBuses();
              final passengers = await ManagementDatabaseHelper().getPassengers();

              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController priceController =
                  TextEditingController();
                  String? selectedBusID;
                  String? selectedPassengerID;

                  return AlertDialog(
                    title: Text('Register Ticket'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedBusID,
                          hint: Text('Select Bus'),
                          items: buses.map((bus) {
                            return DropdownMenuItem(
                              value: bus['busID'].toString(),
                              child: Text(bus['route'].toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedBusID = value;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedPassengerID,
                          hint: Text('Select Passenger'),
                          items: passengers.map((passenger) {
                            return DropdownMenuItem(
                              value: passenger['passengerID'].toString(),
                              child: Text(passenger['name'].toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedPassengerID = value;
                          },
                        ),
                        TextField(
                          controller: priceController,
                          decoration:
                          InputDecoration(labelText: 'Ticket Price'),
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
                          if (selectedBusID != null &&
                              selectedPassengerID != null) {
                            final ticketID = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()
                                .substring(5);

                            final ticket = Ticket(
                              ticketID: ticketID,
                              busID: selectedBusID!,
                              passengerID: selectedPassengerID!,
                              price: int.tryParse(priceController.text) ?? 0,
                            );

                            await ManagementDatabaseHelper()
                                .insertTicket(ticket);

                            setState(() {
                              Tlist.add(ticket);
                            });

                            Navigator.pop(context);
                          }
                        },
                        child: Text('Add Ticket'),
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
      body: ListView.builder(
        itemCount: Tlist.length,
        itemBuilder: (context, index) {
          final ticket = Tlist[index];
          final passenger = passengerMap[ticket.passengerID];
          final bus = busMap[ticket.busID];

          if (passenger == null || bus == null) {
            return ListTile(
              title: Text('Incomplete Ticket Data'),
              subtitle: Text('Ticket ID: ${ticket.ticketID}'),
            );
          }

          return GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Ticket'),
                  content: Text(
                      'Are you sure you want to delete this ticket?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await ManagementDatabaseHelper()
                            .deleteTicket(ticket.ticketID);
                        setState(() {
                          Tlist.removeAt(index);
                          loadTickets(); // Refresh data after adding/deleting ticket
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: ticketDetails(passenger, bus, ticket),
          );
        },
      ),
    );
  }
}
