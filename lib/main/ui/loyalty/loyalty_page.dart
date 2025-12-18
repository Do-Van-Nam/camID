import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';

class LoyaltyPage extends StatefulWidget{
  const LoyaltyPage({super.key});
  @override
  State<LoyaltyPage> createState() => _LoyaltyPageState();
}

class _LoyaltyPageState extends State<LoyaltyPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            color: AppColors.colorMain,
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: const Icon(Icons.menu_sharp, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }
}