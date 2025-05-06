import 'package:flutter/cupertino.dart';

class Tag extends StatelessWidget {
  const Tag({super.key,required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: 24,top: 12,bottom: 12),child: Text(label,style: TextStyle(fontSize: 18),),);
  }
}
