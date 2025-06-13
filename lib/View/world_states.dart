import 'package:covid_tracker/Modal/WorldStatesModel.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Services/state_services.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Color> colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices stateServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView( // Wrap the Column inside SingleChildScrollView
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .01),
                FutureBuilder<WorldStatesModel>(
                  future: stateServices.fetchWorldStatesRecords(),
                  builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox( // Wrap the spinner in a SizedBox
                        height: MediaQuery.of(context).size.height * 0.5, // Set a height to avoid overflow
                        child: Center(
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 50.0,
                            controller: _controller,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      // If data is fetched successfully, display the data
                      return Column(
                        children: [
                          PieChart(
                            dataMap: {
                              "Total": double.parse(snapshot.data!.cases!.toString()),
                              "Recovered": double.parse(snapshot.data!.recovered!.toString()),
                              "Deaths": double.parse(snapshot.data!.deaths!.toString()),
                            },
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            chartRadius: MediaQuery.of(context).size.width / 3.2,
                            legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.left,
                            ),
                            animationDuration: const Duration(milliseconds: 1200),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * .06,
                            ),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(
                                    title: 'Total Cases',
                                    value: snapshot.data!.cases.toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Recovered',
                                    value: snapshot.data!.recovered.toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Deaths',
                                    value: snapshot.data!.deaths.toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Active',
                                    value: snapshot.data!.active.toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Critical',
                                    value: snapshot.data!.critical.toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Today deaths',
                                    value: snapshot.data!.todayDeaths.toString(),
                                  ),
                                  ReusableRow(
                                    title: 'Today Recovered',
                                    value: snapshot.data!.todayRecovered.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CountriesListScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xff1aa260),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title;
  final String value;

  ReusableRow({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
