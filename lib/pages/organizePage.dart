import 'package:flutter/material.dart';

class OrganizePage extends StatefulWidget {
  const OrganizePage({super.key});

  @override
  State<OrganizePage> createState() => _OrganizePageState();
}

class _OrganizePageState extends State<OrganizePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ORGANIZE',
          style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Text('ORGANIZE'),
      ),
    );
  }
}
