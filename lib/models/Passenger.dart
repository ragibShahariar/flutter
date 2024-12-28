class Passenger {
  String passengerID;
  String name;
  String phone;
  int seatNo;

  Passenger({
    required this.passengerID,
    required this.name,
    required this.phone,
    this.seatNo = 0,
  });

  // Convert a Passenger object to a map for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'passengerID': passengerID,
      'name': name,
      'phone': phone,
      'seatNo': seatNo,
    };
  }

  // Create a Passenger object from a map.
  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      passengerID: map['passengerID'],
      name: map['name'],
      phone: map['phone'],
      seatNo: map['seatNo'],
    );
  }
}
