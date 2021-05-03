import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/job/job.dart';
import 'package:time_tracker/common_widgets/alert_dialog.dart';
import 'package:time_tracker/common_widgets/exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(
        Job(
          name: 'Markeeting                                                                                                                   ',
          ratePerHour: 10,
        ),
      );
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Jobs'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs.map((job) => Text(job.name)).toList();
            return ListView(
              children: children,
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Some Error Occured'));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
