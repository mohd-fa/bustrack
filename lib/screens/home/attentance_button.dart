import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bustrack/models/models.dart';

class AttentanceButton extends StatelessWidget {
  final Widget pointer;
  const AttentanceButton({super.key, required this.pointer});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => Provider<AppUser>.value(
                  value: Provider.of<AppUser>(context), child: pointer)),
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Attentance',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.blue,
                    size: 35,
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
