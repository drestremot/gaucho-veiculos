import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/custom_app_bar.dart';
import 'home_screen.dart';
import 'catalog_screen.dart';
import 'simulator_screen.dart';
import 'tradein_screen.dart';
import 'favorites_screen.dart';

class MainNavigation extends StatefulWidget {
  final AppState state;

  const MainNavigation({
    super.key,
    required this.state,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    final List<Widget> screens = [
      HomeScreen(state: state, onNavigateTab: _onTabChanged),
      CatalogScreen(state: state),
      SimulatorScreen(state: state),
      const TradeInScreen(),
      FavoritesScreen(state: state, onNavigateTab: _onTabChanged),
    ];

    final List<String> titles = [
      'GAÚCHO VEÍCULOS',
      'ESTOQUE COMPLETO',
      'SIMULADOR DE CRÉDITO',
      'AVALIAÇÃO DE USADOS',
      'MEUS FAVORITOS',
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: titles[_currentIndex],
        favoritesCount: state.favoritesCount,
        onFavoritesTap: () => _onTabChanged(4),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.borderSubtle)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
          items: [
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house, size: 18),
              label: 'Início',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.car, size: 18),
              label: 'Estoque',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calculator, size: 18),
              label: 'Simulador',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.handshake, size: 18),
              label: 'Vender',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const FaIcon(FontAwesomeIcons.heart, size: 18),
                  if (state.favoritesCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Favoritos',
            ),
          ],
        ),
      ),
    );
  }
}
