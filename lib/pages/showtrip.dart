import 'dart:developer';
import 'package:app1/pages/config/config.dart';
import 'package:app1/pages/profile.dart';
import 'package:app1/pages/response/trips_res.dart';
import 'package:app1/pages/trip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class LishTrip extends StatefulWidget {
   int cid = 0;
  LishTrip({super.key, required this.cid});

  @override
  State<LishTrip> createState() => _LishTripState();
}

class _LishTripState extends State<LishTrip> {
  String url = '';
  List<TripsgetResponse> tripGetResponses = [];
  late Future<void> loadData;
  final List<String> categories = [
    'ทั้งหมด',
    'ยุโรป',
    'เอเชีย',
    'Thailand',
    'สวิตเซอร์แลนด์',
  ];
  String selectedCategory = 'ทั้งหมด';

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/trips'));
    log(res.body);
    tripGetResponses = tripsgetResponseFromJson(res.body);
    log(tripGetResponses.length.toString());
  }


  List<TripsgetResponse> get filteredTrips {
    if (selectedCategory == 'ทั้งหมด') {
      return tripGetResponses;
    }
  
    return tripGetResponses.where((trip) {
      return trip.destinationZone == selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("รายการทริป"),
      automaticallyImplyLeading: false,
      actions: [
         PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'profile') {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ProfilePage(idx: widget.cid,)),
          );
        } else if (value == 'logout') {
	Navigator.of(context).popUntil((route) => route.isFirst);
  }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          child: Text('ข้อมูลส่วนตัว'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text(
            'ออกจากระบบ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
      ],),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ปลายทาง'),
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        selectedCategory == category
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Text(category),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder(
              future: loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final trips = filteredTrips;
                  if (trips.isEmpty) {
                    return const Center(
                        child: Text('ไม่พบข้อมูลทริปในหมวดนี้'));
                  }
                  return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];

                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 10 + (index * 5)),
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..translate(0.0, 50 * (1 - value), 0)
                                ..scale(0.95 + 0.05 * value),
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          elevation: 6,
                          shadowColor: Colors.black26,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.name.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox( height: 10,),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                          trip.coverimage.toString(),
                                          height: 150,
                                          width: 180,
                                          fit: BoxFit.cover, errorBuilder:
                                              (context, error, stack) {
                                        return Image.asset(
                                          'assets/images/h2.jpg',
                                          height: 150,
                                          width: 180,
                                          fit: BoxFit.cover,
                                        );
                                      }),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('ประเทศ: ${trip.country}'),
                                          Text('ราคา: ${trip.price} บาท'),
                                          const SizedBox(height: 14),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: FilledButton(
                                              onPressed: () {
                                                Navigator.push(
		  context,
		  MaterialPageRoute(
			builder: (context) =>
				TripPage(
					idx: trip
						.idx),
		  ));
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child:
                                                    Text('รายละเอียดเพิ่มเติม'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}