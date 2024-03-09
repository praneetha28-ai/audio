import 'package:audio/bloc/auth/auth_bloc.dart';
import 'package:audio/bloc/prod/prod_bloc.dart';
import 'package:audio/presentation/home/dashboard.dart';
import 'package:audio/presentation/auth/signin.dart';
import 'package:audio/presentation/auth/signup.dart';
import 'package:audio/repo/AuthRepo.dart';
import 'package:audio/repo/ProdRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel", 'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up: ${message.messageId}');
}
// Future<Map<Permission, PermissionStatus>> requestPermission() async {
//   Map<Permission, PermissionStatus> statuses =
//   await [Permission.notification].request();
//   return statuses;
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
          RepositoryProvider<ProductsRepository>(
            create: (context) => ProductsRepository(),
          ),],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
              create: (context) =>
                  AuthBloc(authRepository: RepositoryProvider.of<AuthRepository>(context)),
            ),
              BlocProvider<ProdBloc>(
                create: (context) =>
                    ProdBloc(prodRep: RepositoryProvider.of<ProductsRepository>(context)),
              ),],
            child: MaterialApp(
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                  useMaterial3: true,
                ),
                home: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                    // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                    if (snapshot.hasData) {
                    return const Dashboard();
                    }
                    // Otherwise, they're not signed in. Show the sign in page.
                    return SignIn();
                  }),
                ),
        ),
    );
  }
}


