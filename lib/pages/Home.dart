import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusInfoCard extends StatelessWidget {
  Stream<DateTime> time$;
  DateTime defaultTime;

  StatusInfoCard(this.time$, { this.defaultTime }): super();

  final timeFormat = new DateFormat.jm(); // hm fr 24 hrs
  final dateFormat = DateFormat('d MMMM');
  
  @override
  Widget build(BuildContext ctx) {
    return StreamBuilder<DateTime>(
        stream: time$,
        initialData: defaultTime,
        builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
          Widget child = Text('Loading...', key: Key('loading'));

          if (snapshot.hasData) {
            child = Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(timeFormat.format(snapshot.data),
                      key: Key('time'),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                      ),
                  ),
                  Text(dateFormat.format(snapshot.data),
                      key: Key('date'),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 20.0,
                      ),
                  ),
                ]
            );
          }

          return Container(
            height: 300,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Align(alignment: Alignment.topLeft, child: child),
          );
        },
    );
  }
}

class HomeView extends StatelessWidget {
  Stream<DateTime> time$;
  DateTime defaultTime;

  HomeView(this.time$, { this.defaultTime }): super();

  @override
  Widget build(BuildContext ctx) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
           child: ConstrainedBox(
             constraints: BoxConstraints(
               minHeight: viewportConstraints.maxHeight,
             ),
             child: IntrinsicHeight(
               child: Container(
                   padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
                   height: viewportConstraints.maxHeight,
                   child: Column(
                       children: [
                         StatusInfoCard(time$, defaultTime: defaultTime),
                         Expanded(child: Text('Content')),
                       ],
                   ),
               )
             ),
            ),
          );
        }
    );
  }
}

