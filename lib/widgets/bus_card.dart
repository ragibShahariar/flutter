import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  BusCard(
      {super.key,
      required this.busID,
      required this.route,
      required this.capacity});

  String busID;
  String route;
  int capacity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  'https://assets.volvo.com/is/image/VolvoInformationTechnologyAB/blue-bus?qlt=82&wid=1024&ts=1660212095501&dpr=off&fit=constrain',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.model_training_sharp,
                    color: Colors.teal,
                  ),
                  Text(' Bus ID: '),
                  Text(
                    busID,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 29),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions_bus_outlined,
                        color: Colors.teal,
                      ),
                      Text(
                        route,
                        style: TextStyle(color: Colors.teal, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      Text('capacity '),
                      Text(
                        capacity.toString(),
                        style: TextStyle(color: Colors.teal, fontSize: 20),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
