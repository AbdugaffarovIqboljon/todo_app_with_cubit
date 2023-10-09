import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:learn_bloc/cubit/detail_cubit/detail_cubit.dart';
import 'package:learn_bloc/cubit/home_cubit/home_cubit.dart';
import 'package:learn_bloc/cubit/theme_cubit/theme_state.dart';
import 'package:learn_bloc/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    homeCubit.fetchTodos();

    detailCubit.stream.listen(
      (state) {
        if (state is DetailDeleteSuccess ||
            detailCubit.state is DetailCreateSuccess) {
          homeCubit.fetchTodos();
        }

        if (state is DetailUpdateSuccess) {
          homeCubit.fetchTodos();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("todos").tr(),
        actions: [
          IconButton(
            onPressed: () {
              themeController.changeMode();
            },
            icon: StreamBuilder<ThemeState>(
              builder: (context, snapshot) {
                return Icon(
                  themeController.state.isLight
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                );
              },
              initialData: themeController.state,
              stream: themeController.stream,
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<Locale>(
            color: Colors.blue.shade100,
            elevation: 10,
            tooltip: 'languages'.tr(),
            shadowColor: Colors.cyanAccent,
            onSelected: context.setLocale,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: Locale('uz', 'UZ'),
                  child: Text(
                    "🇺🇿 UZ",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const PopupMenuItem(
                  value: Locale('en', 'US'),
                  child: Text(
                    "🇺🇸 EN",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const PopupMenuItem(
                  value: Locale('ru', 'RU'),
                  child: Text(
                    "🇷🇺 RU",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ];
            },
            icon: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                border: Border.all(color: Colors.red),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.language),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<HomeState>(
        initialData: homeCubit.state,
        stream: homeCubit.stream,
        builder: (context, snapshot) {
          final items = snapshot.data!.todos;

          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: Checkbox(
                        value: item.isCompleted,
                        onChanged: (value) {
                          detailCubit.complete(item);
                        },
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.description),
                      trailing: IconButton(
                        onPressed: () {
                          detailCubit.delete(item.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      onLongPress: () {
                        titleController.clear();
                        descController.clear();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('edit').tr(),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'title'.tr(),
                                    ),
                                    controller: titleController,
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: 'description'.tr(),
                                    ),
                                    controller: descController,
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    detailCubit.edit(
                                      titleController.text,
                                      descController.text,
                                      item.id,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('edit').tr(),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('cancel').tr(),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/detail");
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }
}
