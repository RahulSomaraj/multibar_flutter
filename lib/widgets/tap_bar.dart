import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final Map<String, dynamic> dummyData; // Define a parameter to hold dummyData

  const CustomTabBar({super.key, required this.dummyData});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  List<String>? get tabTitles =>
      dummyData.keys.toList(); // Getter for tabTitles
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late PageController _tabController;
  late int _selectedTabIndex; // To keep track of the selected tab index
  late List<Future<List<dynamic>>> _dataFutures; // Future data for each tab

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = 0; // Initialize with the first tab selected
    _tabController = PageController(initialPage: _selectedTabIndex);
    _dataFutures = List.generate(widget.tabTitles!.length, (index) {
      // Create a future that fetches data for the corresponding tab
      return fetchDataForTab(_selectedTabIndex, widget.tabTitles![index]);
    });
    printDataWhenFuturesComplete();
  }

  Future<void> printDataWhenFuturesComplete() async {
    // Wait for all futures in _dataFutures to complete
    List<List<dynamic>> dataForTabs = await Future.wait(_dataFutures);

    // Print the data for each tab
    for (int i = 0; i < dataForTabs.length; i++) {
      print('Data for ${widget.tabTitles![i]}: ${dataForTabs[i]}');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchDataForTab(int index, String tabTitle) async {
    // Simulate fetching data for the tabTitle
    // Replace this with your actual data fetching logic
    await Future.delayed(const Duration(seconds: 1)); // Simulating a delay
    return widget.dummyData[tabTitle] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.tabTitles?.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                    _tabController.animateToPage(
                      _selectedTabIndex,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: _selectedTabIndex == index
                      ? Colors.blue
                      : Colors.transparent,
                  child: Text(
                    widget.tabTitles![index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedTabIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _tabController,
            itemCount: widget.tabTitles!.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<List<dynamic>>(
                future: _dataFutures[index],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              snapshot.data!.removeAt(itemIndex);
                            });
                          },
                          child: ListTile(
                            title: Text(snapshot.data![itemIndex]['heading']),
                            subtitle:
                                Text(snapshot.data![itemIndex]['sub-heading']),
                            trailing: Text(snapshot.data![itemIndex]['time']),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
