import '../ImportAll.dart';

// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthenticationProvider>(context);
//     final userInfoProvider =
//         Provider.of<UserInfoProvider>(context, listen: false);
//     return AppBar(
//       title: Text(
//         'HealthTracker\n${authProvider.currentUserName}',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       // centerTitle: true,
//       leading: Padding(
//         padding: EdgeInsets.all(5),
//         child: ClipOval(
//           child: Image.network(
//             userInfoProvider.selectedUser?.image ??
//                 defaultImageLink,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => ScanCodePage(),
//             //   ),
//             // );
//             Navigator.pushNamed(context, '/scanCodePage');
//           },
//           icon: Icon(Icons.qr_code_scanner),
//         ),
//         IconButton(
//           onPressed: () {
//             authProvider.signOut(context);
//             Navigator.pushNamed(context, '/loginOrRegistration');
//           },
//           icon: Icon(Icons.logout),
//         ),
//       ],
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFA1FFCE),
//               Color(0xFFFAFFD1),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//       ),
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
//
//   const MyAppBar({super.key});
// }

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // Fetching the providers after the widget is built using addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch user info only if necessary
      final userInfoProvider =
          Provider.of<UserInfoProvider>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      // Fetch user data if it's not available yet
      if (userInfoProvider.selectedUser == null &&
          authProvider.currentUserName != null) {
        userInfoProvider.fetchUserInfo(authProvider.currentUserName ?? "");
      }
    });

    // Call providers only for rendering UI
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final userInfoProvider = Provider.of<UserInfoProvider>(context);

    return AppBar(
      title: Text(
        'HealthTracker\n${authProvider.currentUserName}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.all(5),
        child: ClipOval(
          child: Image.network(
            userInfoProvider.selectedUser?.image ?? defaultImageLink,
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/scanCodePage');
          },
          icon: Icon(Icons.qr_code_scanner),
        ),
        IconButton(
          onPressed: () {
            authProvider.signOut(context);
            Navigator.pushNamed(context, '/loginOrRegistration');
          },
          icon: Icon(Icons.logout),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA1FFCE),
              Color(0xFFFAFFD1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const MyAppBar({super.key});
}
