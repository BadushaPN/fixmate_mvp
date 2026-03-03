import 'package:flutter/material.dart';
import 'task_tile.dart';
import 'package:fixmate/core/constants/app_colors.dart';

class TaskTabs extends StatefulWidget {
  const TaskTabs({super.key});

  @override
  State<TaskTabs> createState() => _TaskTabsState();
}

class _TaskTabsState extends State<TaskTabs>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: controller,
          labelColor: AppColors.brandBackgroundDark,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.brandSecondary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: "Active Tasks"),
            Tab(text: "Closed Tasks"),
          ],
        ),

        const SizedBox(height: 10),

        Expanded(
          child: TabBarView(
            controller: controller,
            children: [_activeTasksUI(), _closedTasksUI()],
          ),
        ),
      ],
    );
  }

  Widget _activeTasksUI() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: const [
        TaskTile(
          title: "Fix leaky faucet in kitchen",
          time: "Expected by: 5:00 PM",
        ),
        TaskTile(title: "Install ceiling fan", time: "Expected by: Tomorrow"),
      ],
    );
  }

  Widget _closedTasksUI() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: const [
        TaskTile(
          title: "Completed on: Oct 26, 2:30 PM",
          time: "Task: Replace switchboard",
          isClosed: true,
        ),
      ],
    );
  }
}
