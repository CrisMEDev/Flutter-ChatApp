import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String navigationRoute;
  final String label1;
  final String label2;

  const Labels({
    Key? key,
    required this.navigationRoute,
    required this.label1,
    required this.label2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          Text(
            this.label1,
            style: TextStyle(
              fontSize: screenSize.width * 0.04,
              fontWeight: FontWeight.w300
            )
          ),
          SizedBox( height: 5.0 ),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, this.navigationRoute),

            child: Text(
              this.label2,
              style: TextStyle(
                fontSize: screenSize.width * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.teal
              )
            ),
          ),
        ],
      ),
    );
  }
}
