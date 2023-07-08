import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pagination_with_riverpod/controller.dart';
import 'package:pagination_with_riverpod/next.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pagination With Riverpod'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final int _lastPage = 5;
  int _currentPage = 1;

  List<String> data = [];

  inital() async {
    data = await ref.read(controllerProvider.future);
    setState(() {});
  }

  @override
  void initState() {
    inital();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(controllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: InkWell(
          child: Text(widget.title),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Next()));
          },
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter == 0) {
            _loadMore();
          }
          return false;
        },
        child: ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: data.length + 1,
          itemBuilder: (context, index) {
            if (index < data.length) {
              return Text(data[index]);
            } else if (state.isLoading) {
              return Container(
                alignment: Alignment.center,
                height: 40,
                child: const CircularProgressIndicator(),
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  void _loadMore() {
    if (_currentPage < _lastPage) {
      setState(() {
        _currentPage++;
        ref
            .read(controllerProvider.notifier)
            .addData(currentPage: _currentPage);
        print;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your scroll already done')));
    }
  }
}
