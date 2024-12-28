

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Ticket {
  String ticketID;
  String passengerID;
  String busID;
  int price;

  Ticket({
    required this.ticketID,
    required this.passengerID,
    required this.busID,
    this.price = 500,
  });


  // Convert a Ticket object to a map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'ticketID': ticketID,
      'passengerID': passengerID,
      'busID': busID,
      'price': price,
    };
  }

  // Create a Ticket object from a map.
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      ticketID: map['ticketID'],
      passengerID: map['passengerID'],
      busID: map['busID'],
      price: map['price'],
    );
  }



}
