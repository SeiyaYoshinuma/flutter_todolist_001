import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,// デバッグバナーを非表示にする
      home: TaskScreen(),               // メイン画面として `TaskScreen` を表示
    );
  }
}

class Task {
  String title;  // タスクのタイトル（例："買い物に行く"）
  bool isDone;   // タスクの完了状態（true = 完了, false = 未完了）

  Task({required this.title, this.isDone = false});
}

//ToDoリストの画面を作る
class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

//`TaskScreen` の状態を管理するクラス
class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = []; // タスクリスト（状態として管理）

  //新しいタスクをリストに追加するメソッド
  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title)); // 新しいタスクをリストに追加
    });
  }

  //タスクの完了状態を切り替えるメソッド（チェックボックス用）
  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone; // `true ⇄ false` を切り替え
    });
  }

  //指定したタスクを削除するメソッド
  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index); // 指定したインデックスのタスクを削除
    });
  }

  //タスクを追加するためのダイアログを表示するメソッド
  void _showAddTaskDialog() {
    final TextEditingController controller = TextEditingController(); // 入力用のコントローラー
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('新しいタスクを追加'), // ダイアログのタイトル
        content: TextField(
          controller: controller, // 入力フィールド
          decoration: InputDecoration(hintText: 'タスクを入力'), // ヒントテキスト
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // ダイアログを閉じる
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                addTask(controller.text); // タスクを追加
              }
              Navigator.pop(context); // ダイアログを閉じる
            },
            child: Text('追加'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ToDo リスト')), //アプリのタイトルバー

      //タスクリストを `ListView.builder` で表示
      body: ListView.builder(
        itemCount: tasks.length, // タスクの数を取得
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              tasks[index].title, // タスクのタイトルを表示
              style: TextStyle(
                decoration: tasks[index].isDone ? TextDecoration.lineThrough : null, // 完了したタスクは打ち消し線
              ),
            ),
            leading: Checkbox(
              value: tasks[index].isDone, // チェックボックスの状態を反映
              onChanged: (value) {
                toggleTask(index); // チェック状態を切り替え
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red), // 削除ボタン（赤色）
              onPressed: () {
                removeTask(index); // タスクを削除
              },
            ),
          );
        },
      ),

      //タスクを追加するためのボタン
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), // プラスアイコン
        onPressed: _showAddTaskDialog, // ダイアログを表示
      ),
    );
  }
}