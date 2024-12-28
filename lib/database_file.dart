import 'dart:io';

import 'package:ticket_management/models/Bus.dart';
import 'package:ticket_management/models/Passenger.dart';
import 'package:ticket_management/models/Ticket.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ManagementDatabaseHelper {
  static ManagementDatabaseHelper? _instance;
  static Database? _database;

  ManagementDatabaseHelper._createInstance();

  factory ManagementDatabaseHelper() {
    _instance ??= ManagementDatabaseHelper._createInstance();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/TicketManagement.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> closeDatabase() async {
    final db = await _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }

  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE busTable (
        busID TEXT PRIMARY KEY,
        route TEXT,
        totalCapacity INTEGER,
        availCapacity INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE passengerTable (
        passengerID TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        seatNo INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE ticketTable (
        ticketID TEXT PRIMARY KEY,
        passengerID TEXT,
        busID TEXT,
        price INTEGER,
        FOREIGN KEY (passengerID) REFERENCES passengerTable (passengerID),
        FOREIGN KEY (busID) REFERENCES busTable (busID)
      );
    ''');
  }

  // CRUD Operations
  Future<int> insertBus(Bus bus) async {
    final db = await database;
    return await db.insert('busTable', bus.toMap());
  }

  Future<int> insertPassenger(Passenger passenger) async {
    final db = await database;
    return await db.insert('passengerTable', passenger.toMap());
  }

  Future<int> insertTicket(Ticket ticket) async {
    final db = await database;

    // Fetch the current available capacity of the bus
    final bus = await db.query(
      'busTable',
      where: 'busID = ?',
      whereArgs: [ticket.busID],
    );

    if (bus.isNotEmpty) {
      final busData = bus.first;

      // Safely cast availCapacity to int, defaulting to 0 if null
      int currentAvailCapacity = (busData['availCapacity'] as int?) ?? 0;

      // Decrease the available capacity by 1 (as a ticket is being inserted)
      final newAvailCapacity = currentAvailCapacity - 1;

      // Update the bus available capacity
      await db.update(
        'busTable',
        {'availCapacity': newAvailCapacity},
        where: 'busID = ?',
        whereArgs: [ticket.busID],
      );
    }

    // Insert the ticket into the ticketTable
    return await db.insert('ticketTable', ticket.toMap());
  }



  Future<List<Map<String, dynamic>>> getBuses() async {
    final db = await database;
    return await db.query('busTable');
  }

  Future<List<Map<String, dynamic>>> getPassengers() async {
    final db = await database;
    return await db.query('passengerTable');
  }

  Future<List<Map<String, dynamic>>> getTickets() async {
    final db = await database;
    return await db.query('ticketTable');
  }

  Future<int> updateBus(Bus bus) async {
    final db = await database;
    return await db.update(
      'busTable',
      bus.toMap(),
      where: 'busID = ?',
      whereArgs: [bus.busID],
    );
  }

  Future<int> updatePassenger(Passenger passenger) async {
    final db = await database;
    return await db.update(
      'passengerTable',
      passenger.toMap(),
      where: 'passengerID = ?',
      whereArgs: [passenger.passengerID],
    );
  }

  Future<int> deleteTicket(String ticketID) async {
    final db = await database;

    // Fetch the ticket's busID
    final ticket = await db.query(
      'ticketTable',
      where: 'ticketID = ?',
      whereArgs: [ticketID],
    );

    if (ticket.isNotEmpty) {
      final ticketData = ticket.first;
      final busID = ticketData['busID'];

      // Fetch the current available capacity of the bus
      final bus = await db.query(
        'busTable',
        where: 'busID = ?',
        whereArgs: [busID],
      );

      if (bus.isNotEmpty) {
        final busData = bus.first;

        // Safely cast availCapacity to int, defaulting to 0 if null
        int currentAvailCapacity = (busData['availCapacity'] as int?) ?? 0;

        // Increase the available capacity by 1 (as the ticket is being deleted)
        final newAvailCapacity = currentAvailCapacity + 1;

        // Update the bus available capacity
        await db.update(
          'busTable',
          {'availCapacity': newAvailCapacity},
          where: 'busID = ?',
          whereArgs: [busID],
        );
      }
    }

    // Delete the ticket from the ticketTable
    return await db.delete(
      'ticketTable',
      where: 'ticketID = ?',
      whereArgs: [ticketID],
    );
  }



  Future<int> deleteBus(String busID) async {
    final db = await database;
    return await db.delete(
      'busTable',
      where: 'busID = ?',
      whereArgs: [busID],
    );
  }
  Future<int> deletePassenger(String passengerID) async {
    final db = await database;
    return await db.delete(
      'passengerTable',
      where: 'passengerID = ?',
      whereArgs: [passengerID],
    );
  }
}
