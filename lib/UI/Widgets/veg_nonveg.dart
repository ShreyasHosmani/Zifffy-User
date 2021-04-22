import 'package:flutter/material.dart';



class SwitchWidgetNotification extends StatefulWidget {
  @override
  SwitchWidgetClass createState() => new SwitchWidgetClass();
}

class SwitchWidgetClass extends State {
  bool switchControl;
  var textHolder = 'Switch is OFF';

  void toggleSwitch(bool value) {

    if(switchControl == false)
    {
      setState(() {
        switchControl = true;
        textHolder = 'Switch is ON';
      });
      print('Switch is ON');

    }
    else
    {
      setState(() {
        switchControl = false;
        textHolder = 'Switch is OFF';
      });
      print('Switch is OFF');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      switchControl = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.scale(
          scale: 1,
          child: Switch(
            onChanged: toggleSwitch,
            value: switchControl,
            activeColor: Color(0xffb9ce82),
            activeTrackColor: Colors.grey.shade300,//.shade300,
            inactiveThumbColor: Colors.red[900],
            inactiveTrackColor: Colors.grey.shade300,
          )
      ),
    );
  }
}