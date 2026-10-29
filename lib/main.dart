import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'services/auth_service.dart';
import 'services/currency_service.dart';
import 'services/marketplace_service.dart';
import 'services/escrow_order_service.dart';
import 'screens/home/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NaijaBeninTissusApp());
}

class NaijaBeninTissusApp extends StatelessWidget {
  const NaijaBeninTissusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CurrencyService()),
        ChangeNotifierProvider(create: (_) => MarketplaceService()),
        ChangeNotifierProvider(create: (_) => EscrowOrderService()),
      ],
      child: MaterialApp(
        title: 'BridgeMart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
