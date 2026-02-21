import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/group_model.dart';
import '../widgets/discussion_tab.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GroupModel group;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    group = mockGroups.firstWhere(
      (g) => g.id == widget.groupId,
      orElse: () => mockGroups.first,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              group.subject,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D9488),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.grey.shade400),
            onPressed: () => print('Settings'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0D9488),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF0D9488),
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'Discussion'),
            Tab(text: 'Sessions'),
            Tab(text: 'Members'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TabBarView(
          controller: _tabController,
          children: const [
            DiscussionTab(),
            Center(child: Text('Sessions - Coming Soon', style: TextStyle(color: Colors.grey))),
            Center(child: Text('Members - Coming Soon', style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}

