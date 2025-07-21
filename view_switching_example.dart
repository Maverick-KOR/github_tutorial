import 'package:flutter/material.dart';

/// Simple example demonstrating switching between different
/// Notion-style database views using a [BottomNavigationBar].
class ViewSwitchingExample extends StatefulWidget {
  const ViewSwitchingExample({Key? key}) : super(key: key);

  @override
  State<ViewSwitchingExample> createState() => _ViewSwitchingExampleState();
}

class _ViewSwitchingExampleState extends State<ViewSwitchingExample> {
  int _selectedIndex = 0;

  final List<Widget> _views = const [
    Center(child: Text('Table View Placeholder')),
    Center(child: Text('Calendar View Placeholder')),
    Center(child: Text('Timeline View Placeholder')),
    Center(child: Text('Board View Placeholder')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notion-style Views'),
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Table',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_kanban),
            label: 'Board',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ViewSwitchingExample()));
}
