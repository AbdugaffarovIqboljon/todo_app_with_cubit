import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:learn_bloc/cubit/detail_cubit/detail_cubit.dart';
import 'package:learn_bloc/main.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key? key}) : super(key: key);

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    detailCubit.stream.listen((state) {
      /// listen
      if(detailCubit.state is DetailFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((detailCubit.state as DetailFailure).message)));
      }

      if(detailCubit.state is DetailCreateSuccess && context.mounted) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("add_task").tr(),
        actions: [
          IconButton(
            onPressed: () {
              detailCubit.create(titleCtrl.text, descCtrl.text);
            },
            icon: const Icon(Icons.save),
          ),

        ],
      ),
      body:  Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(hintText: "title".tr()),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descCtrl,
                  decoration: InputDecoration(hintText: "description".tr()),
                ),
                const SizedBox(height: 15),

              ],
            ),
          ),

          StreamBuilder(
            initialData: detailCubit.state,
            stream: detailCubit.stream,
            builder: (context, snapshot) {

              /// builder
              if(detailCubit.state is DetailLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
