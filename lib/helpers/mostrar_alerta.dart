import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


mostrarAlerta( BuildContext context, String titulo, String subtitulo ){

  if ( Platform.isAndroid ){
    return showDialog(
      context: context,
      builder: ( _ ) => AlertDialog(
        title: Text( titulo ),
        content: Text( subtitulo ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
            elevation: 3,
            textColor: Colors.teal
          )
        ],
      )
    );
  }

  showCupertinoDialog(
    context: context,
    builder: ( _ ) => CupertinoAlertDialog(
      title: Text( titulo ),
      content: Text( subtitulo ),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );


}

