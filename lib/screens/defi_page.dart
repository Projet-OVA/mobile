import 'package:SIRA/screens/tabs/populaire.dart';
import 'package:flutter/material.dart';
import 'package:SIRA/services/auth_storage.dart';

class DefiPage extends StatefulWidget {
  final int? initialTabIndex; // AJOUTÉ

  const DefiPage({super.key, this.initialTabIndex});

  @override
  State<DefiPage> createState() => _DefiPageState();
}

class _DefiPageState extends State<DefiPage> {
  static const String pageName = 'defi';

  int selectedFilter = 0;
  @override
  void initState() {
    super.initState();
    _loadLastSelectedTab();
  }
  Future<void> _loadLastSelectedTab() async {
    final lastTab = widget.initialTabIndex ?? await AuthStorage.getPageTab(pageName);
    setState(() {
      selectedFilter = lastTab ?? 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Populaire(),
    );
  }
}
