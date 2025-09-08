import 'dart:developer';

import 'package:app1/pages/config/config.dart';
import 'package:app1/pages/response/restrips_idx.dart';
import 'package:app1/pages/response/trips_res.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late TripIdxGetResponse tripIdxGetResponse;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    // Call async function
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              margin: const EdgeInsets.all(2),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        tripIdxGetResponse.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        tripIdxGetResponse.country,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.network(
                      tripIdxGetResponse.coverimage,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return Image.asset(
                          'assets/images/image.png',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ราคา ${tripIdxGetResponse.price} บาท',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'โซน ${tripIdxGetResponse.destinationZone} ',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(' ${tripIdxGetResponse.detail}'),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: () {},

                                child: const Text(
                                  'จองเลย',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Async function for api call
  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
