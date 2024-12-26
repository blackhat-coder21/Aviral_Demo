import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool back;
  final String routeName;
  final Function? onBackPressed;
  final Function(String) onNavigate;

  const CustomHeader({
    Key? key,
    required this.back,
    required this.routeName,
    this.onBackPressed,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();

    void handleLogout() async {
      await storage.delete(key: 'creds');
      Navigator.of(context).pushNamedAndRemoveUntil('Login', (route) => false);
    }

    void handleCreators() {
      Navigator.of(context).pushNamed('Creators');
    }

    return AppBar(
      backgroundColor: const Color(0xFF4F378B),
      centerTitle: true,
      title: Text(routeName, style: const TextStyle(color: Colors.white)),
      leading: back
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.of(context).pop();
          }
        },
      )
          : null,
      actions: routeName == 'Aviral'
          ? [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 'Creators') {
              handleCreators();
            } else if (value == 'Logout') {
              handleLogout();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'Creators',
              child: Text('Creators'),
            ),
            const PopupMenuItem<String>(
              value: 'Logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
