import 'package:blockpass/config/app.dart';
import 'package:blockpass/data/db/db.dart';
import 'package:blockpass/utils/utils.dart';
import 'package:blockpass/widgets/combobox_widget.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List<dynamic> entries = ['Network', 'Chain', 'AutoSync', 'ChangePwd', 'Sync', 'Logout'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: .5,
        bottomOpacity: .2,
        title: Text(
          'SETTINGS',
          style: Theme.of(context).textTheme.title,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: ListView.separated(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return StickyHeader(
              header: Container(
                height: 45.0,
                color: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'CONFIGS',
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              content: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: buildComponents(index),
              ),
            );

          } else {
            return Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: buildComponents(index),
            );
          }
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(color: Color.fromRGBO(108, 123, 138, 0.2)),
      ),
    );
  }

  Widget buildComponents(int index) => showComponents(entries[index]);

  Widget showComponents(String name) {
    switch (name) {
      case 'Network':
        return ComboboxWidget(
          lblLeading: 'Network',
          lblContent: app.user.network,
          entries: ['EOS'],
        );

      case 'Chain':
        return ComboboxWidget(
          lblLeading: 'Chain',
          lblContent: app.user.chainID,
          entries: app.eosChains,
          onChangedChain: (name) => { 
            Utils.showPopup(
              context, 
              'INFO', 
              'Make sure you have an account with this private key in $name!', 
              buttons: ['Confirm', 'Close'],
              callback: (int index) {
                if (index == 0) { // Confirm

                }
              },
            )
          },
        );

      case 'ChangePwd':
        return GestureDetector(
          child: Container(
            color: Color(0xFFFFFF),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Change Password',
              ),
            ),
          ), 
          onTap: () => Navigator.pushNamed(context, '/change_pwd'),
        );

      case 'Sync':
        return GestureDetector(
          child: Container(
            color: Color(0xFFFFFF),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sync Now',
              ),
            ),
          ),
          onTap: () => print('Sync now touched'),
        );

      case 'Logout':
        return GestureDetector (
          child: Container(
            color: Color(0xFFFFFF),
            padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
            height: 50,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Sign out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          onTap: () => logOut(),
        );      

      case 'AutoSync':
        return Container(
          color: Color(0xFFFFFF),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Enable auto sync'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'If there are any changes after 24 hours',
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    value: true,
                    onChanged: (value) => print(value),
                  ),
                ),
              ),
            ],
          ), 
        );
      
      default:
    }

    return null;
  }

  void logOut() {
    app.user = null;
    db.deleteAllUsers();
    utils.deletSecureData('priKey');
    Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
  }
}