import 'package:flutter/material.dart';
import 'package:ticket_management/models/Bus.dart';
import 'package:ticket_management/models/Passenger.dart';
import 'package:ticket_management/models/Ticket.dart';

ticketDetails(Passenger passenger, Bus bus, Ticket ticket) {
  return Card(
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.attach_money_outlined),
              SizedBox(
                width: 10,
              ),
              Text(ticket.price.toString()),
              Spacer(),
              Text("Ticket ID: "),
              SizedBox(
                width: 4,
              ),
              Text(
                ticket.ticketID,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontSize: 29),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            clipBehavior: Clip.hardEdge,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [Colors.white24, Colors.black26],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
            child: Center(
              child: Text("Seat No: ${passenger.seatNo}"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Passenger: ${passenger.name}",
                style: TextStyle(color: Colors.teal, fontSize: 15),
              ),
              Spacer(),
              Text("Phone: ${passenger.phone}")
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                bus.busID,
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(
                width: 10,
              ),
              Text("Route: ${bus.route}"),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text("Available seats: ${bus.availCapacity.toString()}")
        ],
      ),
    ),
  );
}
