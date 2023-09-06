// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_riverpod/models/users.dart';
import 'package:dio/dio.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  final usersProvider = FutureProvider<List<Users>>((ref) async {
    var res = await Dio().get('https://jsonplaceholder.typicode.com/users');
    var body = res.data as List;
    var data = body.map((e) => Users.fromJson(e)).toList();
    return data;
  });

  final dataProvider = StateProvider((ref) => []);
  final isFetchedProvider = StateProvider((ref) => false);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersData = ref.watch(dataProvider);
    bool isFetched = ref.watch(isFetchedProvider);
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  ref.read(isFetchedProvider.notifier).update((state) => true);
                  final users = await ref.read(usersProvider.future);
                  ref.read(dataProvider.notifier).update((state) => users);
                  ref.read(isFetchedProvider.notifier).update((state) => false);
                },
                child: const Text('Get Data'),
              ),
            ),
            if (isFetched)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!isFetched && usersData.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: usersData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(usersData[index].name),
                      subtitle: Text(usersData[index].email),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
