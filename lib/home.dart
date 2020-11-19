import 'package:contacts/helper/contact.dart';
import 'package:contacts/model/contact_model.dart';
import 'package:flutter/material.dart';

class Sqlflite extends StatefulWidget {
  Sqlflite({Key key}) : super(key: key);

  @override
  _SqlfliteState createState() => _SqlfliteState();
}

class _SqlfliteState extends State<Sqlflite> {
  @override
  final _formKey = GlobalKey<FormState>();
  Contact _contact = Contact();
  List<Contact> _contacts = [];
  DatabaseHelper _dbhelper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbhelper = DatabaseHelper.instance;
    });
  _refreshForm();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(title: Text("SQLFLITE")),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_forms(), _list()])),
    );
  }

  _forms() => Container(
    color: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            onSaved: (val) {
              setState(() {
                _contact.name = val;
              });
            },
            validator: (val) {
              return (val.length == 0) ? "This Field is Required" : null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Phone Number"),
            onSaved: (val) {
              setState(() {
                _contact.mobileNumber = val;
              });
            },
            validator: (val) {
              return (val.length != 10) ? "Enter valid number!!" : null;
            },
          ),
          Container(
              child: RaisedButton(
                  onPressed: () => _onSubmit(), child: Text("Add Contact"), color: Colors.blue[700],
                    textColor: Colors.white),)
        ]),
      ));

      _refreshForm() async{
        List<Contact> x=await _dbhelper.fetchContactsseq();
        setState(() {
          _contacts=x;
        });
      }

  _onSubmit() async{
    var form = _formKey.currentState;
    if(form.validate()){
      form.save();
     await  _dbhelper.insertContact(_contact);
     _refreshForm();
     _resetForm();
    }
  }
  _resetForm(){
    setState(() {
      _formKey.currentState.reset();
    });
  }

  _list() => Expanded(
      child: Container(
      color: Colors.amber,
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView.builder(
            itemCount: _contacts.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              return Column(children: [
                ListTile(
                  leading: Icon(Icons.account_circle, color: Colors.blue),
                  title: Text(_contacts[index].name),
                  subtitle: Text(_contacts[index].mobileNumber),
                  trailing: IconButton(icon: Icon(Icons.delete_sweep),onPressed: ()async{
                    await _dbhelper.deleteContact(_contacts[index].id);
                    _refreshForm();
                    _resetForm();
                  },),
                ),
                Divider(height : 5.0)
              ]);
            },
          ),
    ),
  );
}
