import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorType implements Exception {
  final String message;
  final Widget? customContent;

  const ErrorType(this.message, {Key? key, this.customContent});
}

abstract class ErrorTypes {
  static const pageDoseNotExist = ErrorType("This page does not exist");
  static const failedToCreate = ErrorType("Failed to create the LOD",
      customContent: Icon(Icons.priority_high_rounded));
  static const ErrorType failedToUploadImage = ErrorType(
      "Failed to upload image",
      customContent: Icon(Icons.priority_high_rounded));
}

class CustomErrorView extends StatelessWidget {
  final ErrorType errorType;
  const CustomErrorView(this.errorType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go("/");
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
      ),
      body: Center(
        child: Text(errorType.message),
      ),
    );
  }
}
