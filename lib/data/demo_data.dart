import 'package:ticket_management/models/Bus.dart';
import 'package:ticket_management/models/Passenger.dart';
import 'package:ticket_management/models/Ticket.dart';
import 'package:ticket_management/database_file.dart';

// Demo Data for Buses
final List<Bus> buslist = [
  Bus(
    busID: 'bus001',
    route: 'Dhaka to Chittagong',
    totalCapacity: 40,
    availCapacity: 35,
  ),
  Bus(
    busID: 'bus002',
    route: 'Dhaka to Sylhet',
    totalCapacity: 30,
    availCapacity: 25,
  ),
  Bus(
    busID: 'bus003',
    route: 'Dhaka to Rajshahi',
    totalCapacity: 50,
    availCapacity: 45,
  ),
];

// Demo Data for Passengers
final List<Passenger> passengerList = [
  Passenger(
    passengerID: 'passenger001',
    name: 'John Doe',
    phone: '0123456789',
    seatNo: 1,
  ),
  Passenger(
    passengerID: 'passenger002',
    name: 'Jane Smith',
    phone: '0987654321',
    seatNo: 2,
  ),
  Passenger(
    passengerID: 'passenger003',
    name: 'Alice Johnson',
    phone: '0112233445',
    seatNo: 3,
  ),
];

// Demo Data for Tickets
final List<Ticket> ticketList = [
  Ticket(
    ticketID: 'ticket001',
    passengerID: 'passenger001',
    busID: 'bus001',
    price: 500,
  ),
  Ticket(
    ticketID: 'ticket002',
    passengerID: 'passenger002',
    busID: 'bus002',
    price: 450,
  ),
  Ticket(
    ticketID: 'ticket003',
    passengerID: 'passenger003',
    busID: 'bus003',
    price: 550,
  ),
];

// Function to Load Demo Data into Database
Future<void> loadDemoData() async {
  final dbHelper = ManagementDatabaseHelper();

  // Insert Bus Data
  for (var bus in buslist) {
    await dbHelper.insertBus(bus);
  }

  // Insert Passenger Data
  for (var passenger in passengerList) {
    await dbHelper.insertPassenger(passenger);
  }

  // Insert Ticket Data
  for (var ticket in ticketList) {
    await dbHelper.insertTicket(ticket);
  }

  print('Demo data loaded into the database successfully!');
}
