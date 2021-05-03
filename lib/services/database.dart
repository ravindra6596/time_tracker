import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker/app/home/job/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FireStoreService.instance;
  Future<void> createJob(Job job) =>_service.setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );
// _setData defines single entry point for all writes to Firestore
// (its useful for logging/debugging)

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
