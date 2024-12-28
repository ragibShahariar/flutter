class Bus {
  final String busID;
  final String route;
  final int totalCapacity;
  final int availCapacity;

  Bus({
    required this.busID,
    required this.route,
    required this.totalCapacity,
    required this.availCapacity,
  });

  // Method to convert Bus object to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'busID': busID,
      'route': route,
      'totalCapacity': totalCapacity,
      'availCapacity': availCapacity,
    };
  }

  // Method to create a Bus object from a Map (e.g., from the database)
  factory Bus.fromMap(Map<String, dynamic> map) {
    return Bus(
      busID: map['busID'],
      route: map['route'],
      totalCapacity: map['totalCapacity'],
      availCapacity: map['availCapacity'],
    );
  }
}
