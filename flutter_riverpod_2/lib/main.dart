import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod_2/post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostsRepository {
  Future<List<Post>> fetchPostsLocal() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final response =
          await http.get(Uri.https('jsonplaceholder.typicode.com', 'posts'));
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;
        final List<Post> posts = body.map((dynamic json) {
          return Post(
              id: json['id'] as int,
              title: json['title'] as String,
              body: json['body'] as String);
        }).toList();
        return posts;
      } else {
        throw Exception('Erro ao buscar postagens');
      }
    } on Exception {
      throw Exception();
    }
  }

  Future<List<Post>> fetchPostsRemote() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final response =
          await http.get(Uri.https('jsonplaceholder.typicode.com', 'posts'));
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;
        final List<Post> posts = body.map((dynamic json) {
          return Post(
              id: json['id'] as int,
              title: json['title'] as String,
              body: json['body'] as String);
        }).toList();
        return posts;
      } else {
        throw Exception('Erro ao buscar postagens');
      }
    } on Exception {
      throw Exception();
    }
  }
}

final postsRepositoryProvider = Provider(
  (ref) => PostsRepository(),
);

final postsFutureProvider =
    FutureProvider.family<List<Post>, String>((ref, typeDb) async {
  final postsRepository = ref.watch(postsRepositoryProvider);

  if (typeDb == 'local') {
    return postsRepository.fetchPostsLocal();
  } else {
    return postsRepository.fetchPostsRemote();
  }
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Post>> posts = ref.watch(postsFutureProvider('local'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Riverpod 2'),
      ),
      body: posts.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(data[index].title),
            );
          },
        ),
        error: (e, st) => const Text('Erro ao buscar postagens'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
