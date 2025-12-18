import 'package:cam_id/res/app_colors.dart';
import 'package:flutter/material.dart';

class MetFonePage extends StatefulWidget{
  const MetFonePage({super.key});
  @override
  State<MetFonePage> createState() => _MetFonePageState();
}

class _MetFonePageState extends State<MetFonePage> with AutomaticKeepAliveClientMixin{
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