import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:eleven/app_state.dart';
import 'package:eleven/tabs/game_tab.dart';
import 'package:eleven/tabs/players_tab.dart';
import 'package:eleven/tabs/final_score_tab.dart';

void main() {
  runApp(ChangeNotifierProvider<AppState>(
    create: (context) => AppState(),
    child: ElevenScoreKeeper(),
  ),
  );
}

class ElevenScoreKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<AppState>(context, listen: true).theme,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 10,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.group)),
                  Tab(icon: Icon(Icons.equalizer)),
                  Tab(icon: Icon(Icons.grade)),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PlayersSelection(),
            Scores(),
            FinalScores(),
          ],
        ),
        drawer: Drawer(
            child: preferencesDrawer()
        ),
      ),
    );
  }

  Widget preferencesDrawer() {
    final appState = Provider.of<AppState>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("Eleven!", style: TextStyle(color: Colors.white, fontSize: 40)),
            decoration: BoxDecoration(
              color: Colors.cyan,
              image: DecorationImage(
                  image: AssetImage("images/preferences.jpg"),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter
              ),
            ),
          ),
          ListTile(
              leading: Text("Text size"),
              title: Slider(
                value: appState.prefs['textSize'],
                min: 18,
                max: 40,
                onChanged: (size) => appState.themeTextSize(size),
              ),
              onTap: () => Navigator.of(context).pop()
          ),
          SwitchListTile(
              title: Text("Dark mode"),
              value: appState.prefs['brightness'] == Brightness.dark ? true : false,
              onChanged: (state) => appState.flipDark(state)
          ),
          ListTile(
              title: Text("Primary color"),
              trailing: Container(
                width: 20.0,
                height: 20.0,
                color: appState.prefs['primaryColor'],
              ),
              onTap: () async {
                Color newColor = await getColor("primary", appState.prefs['primaryColor']);
                appState.setColor("primaryColor", newColor);
              }
          ),
          ListTile(
              title: Text("Accent color"),
              trailing: Container(
                width: 20.0,
                height: 20.0,
                color: appState.prefs['accentColor'],
              ),
              onTap: () async {
                Color newColor = await getColor("accent", appState.prefs['accentColor']);
                appState.setColor("accentColor", newColor);
              }
          ),
          SwitchListTile(
              title: Text("Blitz mode"),
              value: appState.blitz,
              onChanged: (state) => appState.blitz = state
          ),
          ListTile(
              title: Text("Blitz round timer"),
              trailing: Text("${appState.timerDuration.inMinutes.toString()} min"),
              onTap: () async => appState.timerDuration = await blitzDurationPicker(appState.timerDuration)
          ),
          ListTile(
            title: Text("Blitz alarm sound"),
            trailing: DropdownButton<String>(
              underline: SizedBox(),
              value: appState.timerAlarmSound,
              items: <String>['Foghorn', 'Huge temple bell', 'Siren', 'Temple bell'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (x) => appState.timerAlarmSound = x,
            )
        ),
        ],
      ),
    );
  }

  Future<Duration> blitzDurationPicker(Duration duration) async {
    int newDurationInMinutes = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 1,
            maxValue: 10,
            title: Text("Pick blitz round duration:"),
            initialIntegerValue: duration.inMinutes,
          );
        }
    );
    return newDurationInMinutes == null
        ? duration
        : Duration(minutes: newDurationInMinutes);
  }

  Future<Color> getColor(String colorType, Color currentColor) {
    Color newColor;
    return showDialog(
      context: this.context,
      child: AlertDialog(
        title: Text('Select $colorType color:'),
        content: SingleChildScrollView(
          child: MaterialPicker(
            enableLabel: true,
            pickerColor: currentColor,
            onColorChanged: (c) => newColor = c,
          ),
        ),
        actions: [
          FlatButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(currentColor),
          ),
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(newColor),
          ),
        ],
      ),
    );
  }
}