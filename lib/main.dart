import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/home_screen.dart';
import 'screens/report_screen.dart';
import 'screens/add_transaction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyKhataApp());
}

class MyKhataApp extends StatelessWidget {
  const MyKhataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..loadTransactions(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Khata',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.grey[100],
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => HomeScreen(),
          '/add': (_) => AddTransactionScreen(),
          '/report': (_) => const ReportScreen(),
        },
      ),
    );
  }
}
