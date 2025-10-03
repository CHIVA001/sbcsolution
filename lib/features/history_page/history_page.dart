import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/features/home_page/components/app_drawer.dart';
import 'package:flutter/material.dart';

import '../../widgets/build_app_bar.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final _keyState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyState,
      appBar: buildAppBarMain(scaffoldKey: _keyState),
      // drawer
      drawer: AppDrawer(),
      body: Center(
        child: Text('History update soon', style: textdefualt()),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         //
        //         // HandleMessage.error("msg");
        //         // HandleMessage.info("msg");
        //         // HandleMessage.noNetwork();
        //         // HandleMessage.warning("msg");
        //         // MessageDialog.networkError();
        //         // MessageDialog.error('msg');
        //         // MessageDialog.success('msg');

        //         // AttendanceDialog.confirmCheckIn(onConfirm: () {});
        //         AttendanceDialog.confirmCheckOut(onConfirm: () {});
        //       },
        //       child: Text('click'),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
