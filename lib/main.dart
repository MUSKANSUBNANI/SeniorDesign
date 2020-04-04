import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc_example/bloc_delegate.dart';
import 'package:flutter_form_bloc_example/forms/complex_async_prefilled_form.dart';
import 'package:flutter_form_bloc_example/forms/complex_login_form.dart';
import 'package:flutter_form_bloc_example/forms/crud_form.dart';
import 'package:flutter_form_bloc_example/forms/dynamic_fields_form.dart';
import 'package:flutter_form_bloc_example/forms/field_bloc_async_validation_form.dart';
import 'package:flutter_form_bloc_example/forms/form_fields_example_form.dart';
import 'package:flutter_form_bloc_example/forms/manually_set_field_bloc_error_form.dart';
import 'package:flutter_form_bloc_example/forms/not_auto_validation_form.dart';
import 'package:flutter_form_bloc_example/forms/progress_form.dart';
import 'package:flutter_form_bloc_example/forms/simple_async_prefilled_form.dart';
import 'package:flutter_form_bloc_example/forms/login_form.dart';
import 'package:flutter_form_bloc_example/forms/simple_register_form.dart';
import 'package:flutter_form_bloc_example/styles/themes.dart';
import 'package:flutter_form_bloc_example/widgets/widgets.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'rfid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = MyBlocDelegate();

  // FormBlocDelegate.notifyOnFieldBlocTransition = true;
  // FormBlocDelegate.notifyOnFormBlocTransition = true;
  runApp(App());
}

class App extends StatelessWidget {
  //const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.formTheme,
      initialRoute: 'home',
      routes: {
        'home': (context) => HomeScreen(title:"RFIDs"),
        'success': (context) => SuccessScreen(),
      },
    );
  }
}
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{
  List<Rfid> dataList=new List<Rfid>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
        elevation: 2,
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => Divider(height: 1),
        itemCount: this.dataList.length,
        itemBuilder: (context, index) => ListItem(index, Form(dataList[index].name ,dataList[index].rfid, ComplexAsyncPrefilledForm())),
      ),
    );
  }

  Future getData() async{

    var url = 'https://breakthru2020.000webhostapp.com/get-rfids.php';
    http.Response response = await http.get(url);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      dataList= List<Rfid>.from(json.decode(response.body)
          .map((data) => Rfid.fromJson(data)));
  }

  @override
  void initState() {
    getData();
  }
}

//class _HomeScreenState extends StatefulWidget {
//  Rfid data;
// @override
//Widget build(BuildContext context) {
// return Scaffold(
//  appBar: AppBar(
//    title: Text('Flutter Form BLoC Example'),
// elevation: 2,
//  ),
//  body: ListView.separated(
//     separatorBuilder: (_, __) => Divider(height: 1),
//  itemCount: Form.forms.length,
//   itemBuilder: (context, index) => ListItem(index, Form.forms[index]),
//  ),
// );
//}

// Future getData() async{
//  var url = 'https://disgusted-vapors.000webhostapp.com/get.php';
//   http.Response response = await http.get(url);
// var data = jsonDecode(response.body);
//  print(data.toString());
// }

// @override
// void initState() {
//  getData();
//  }
//}

class ListItem extends StatelessWidget {
  final int index;
  final Form form;
  const ListItem(this.index, this.form, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 28,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).iconTheme.color,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
      isThreeLine: true,
      title:form.title !=null? Text(form.title): Text("Click to Set Name"),
      subtitle: Text(
        form.description,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => Navigator.of(context)
          .push<void>(MaterialPageRoute(builder: (_) => form.widget)),
    );
  }
}

class Form {
  final String title;
  final String description;
  final Widget widget;
  Form(this.title, this.description, this.widget);
}

