import 'package:SIRA/screens/tabs/populaire_community.dart';
import 'package:flutter/material.dart';
import 'package:SIRA/services/auth_storage.dart';

class CommunityPage extends StatefulWidget {
  final int? initialTabIndex; // ✅ AJOUTÉ

  const CommunityPage({super.key, this.initialTabIndex});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  static const String pageName = 'community';

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
      body: PopulaireCommunity(),
    );
  }
}
