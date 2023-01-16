import 'package:flutter/material.dart';
import 'package:to_do_list_v1/consts/consts.dart';
import 'package:to_do_list_v1/models/taks.dart';
import 'package:to_do_list_v1/repositories/taks_repository.dart';
import 'package:to_do_list_v1/widget/todo_list_itens.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController taksListController = TextEditingController();
  final TaksRepository taksRepository = TaksRepository();
  final Consts consts = Consts();

  List<Taks> taksList = [];
  Taks? deleteTaks;
  int? deleteTaksPos;

  @override
  void initState() {
    super.initState();

    taksRepository.getTaksList().then((value) {
      setState(() {
        taksList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: taksListController,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: const OutlineInputBorder(),
                          hintText: consts.addTask,
                          errorText: consts.errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: consts.defautColor,
                              width: 2,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: consts.defautColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = taksListController.text;

                        if (text.isEmpty) {
                          setState(() {
                            consts.errorText = consts.errorTextValue;
                          });
                          return;
                        }

                        setState(() {
                          Taks task = Taks(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          task.title.isEmpty ? null : taksList.add(task);
                          taksListController.clear();
                          taksRepository.saveTaksList(taksList);
                          consts.errorText = null;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: consts.defautColor,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Taks toDo in taksList)
                        ToDoListItens(
                          task: toDo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                taksList.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            child:
                                Text('${taksList.length} ${textLengthTaks()}'),
                          ),
                          ElevatedButton(
                            onPressed: showDeleteTaksDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: consts.defautColor,
                              padding: const EdgeInsets.all(14),
                            ),
                            child: Text(consts.allClean),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String textLengthTaks() {
    if (taksList.isEmpty) {
      return consts.noTask;
    } else if (taksList.length == 1) {
      return consts.oneTask;
    }
    return consts.manyTasks;
  }

  void onDelete(Taks taks) {
    deleteTaks = taks;
    deleteTaksPos = taksList.indexOf(taks);
    setState(() {
      taksList.remove(taks);
    });
    taksRepository.saveTaksList(taksList);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${consts.task} ${taks.title} ${consts.textRemoveTaks}',
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: consts.dissolver,
            textColor: consts.defautColor,
            onPressed: () {
              setState(() {
                taksList.insert(deleteTaksPos!, deleteTaks!);
              });
              taksRepository.saveTaksList(taksList);
            }),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void showDeleteTaksDialog() {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: Text(consts.clean),
              content: Text(consts.cleanTasksAll),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    shadowColor: Colors.white,
                    backgroundColor: consts.defautColor,
                  ),
                  child: Text(
                    consts.cancel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTaks();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    consts.clean,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            )));
  }

  void deleteAllTaks() {
    setState(() {
      taksList.clear();
      taksRepository.saveTaksList(taksList);
    });
  }
}
