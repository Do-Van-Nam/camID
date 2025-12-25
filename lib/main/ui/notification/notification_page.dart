import 'package:cam_id/generated/app_localizations.dart';
import 'package:cam_id/main/data/model/notify/notify_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './notification_bloc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => NotificationBloc()
        ..add(LoadNewsNotifications())
        ..add(LoadComplainNotifications()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.notificationTitle), // "Thông báo"
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: l10n.notificationTabNews), // "Tin tức"
              Tab(text: l10n.notificationTabComplain), // "Khiếu nại"
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildNewsTab(l10n), _buildComplainTab(l10n)],
        ),
      ),
    );
  }

  Widget _buildNewsTab(AppLocalizations l10n) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.isLoadingNews) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.newsNotifications.isEmpty) {
          return Center(child: Text(l10n.notificationEmptyNews)); // "Không có thông báo"
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => context.read<NotificationBloc>().add(ReadAllEvent(true)),
                    child: Text(l10n.notificationReadAll), // "Đánh dấu tất cả đã đọc"
                  ),
                  OutlinedButton(
                    onPressed: () => context.read<NotificationBloc>().add(ClearAllEvent(true)),
                    child: Text(l10n.notificationClearAll), // "Xóa tất cả"
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.newsNotifications.length,
                itemBuilder: (context, index) {
                  final noti = state.newsNotifications[index];
                  return _buildNotificationCard(noti, context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildComplainTab(AppLocalizations l10n) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.isLoadingComplain) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.complainNotifications.isEmpty) {
          return Center(child: Text(l10n.notificationEmptyComplain)); // "Không có khiếu nại"
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => context.read<NotificationBloc>().add(ReadAllEvent(false)),
                    child: Text(l10n.notificationReadAll), // "Đánh dấu tất cả đã đọc"
                  ),
                  OutlinedButton(
                    onPressed: () => context.read<NotificationBloc>().add(ClearAllEvent(false)),
                    child: Text(l10n.notificationClearAll), // "Xóa tất cả"
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.complainNotifications.length,
                itemBuilder: (context, index) {
                  final noti = state.complainNotifications[index];
                  return _buildNotificationCard(noti, context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem noti, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!noti.isRead) {
          context.read<NotificationBloc>().add(MarkAsReadEvent(noti.id));
        }
        // Có thể mở chi tiết thông báo ở đây
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: noti.isRead ? Colors.grey[100] : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: noti.isRead ? Colors.grey : Colors.blue,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noti.title,
              style: TextStyle(
                fontWeight: noti.isRead ? FontWeight.normal : FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(noti.message),
            const SizedBox(height: 8),
            Text(
              '${noti.date.day}/${noti.date.month}/${noti.date.year} ${noti.date.hour}:${noti.date.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}