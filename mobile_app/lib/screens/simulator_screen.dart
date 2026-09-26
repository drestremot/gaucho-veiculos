import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../providers/app_state.dart';
import '../widgets/loan_calculator_card.dart';

class SimulatorScreen extends StatelessWidget {
  final AppState state;

  const SimulatorScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBody,
      body: SingleChildScrollView(
        child: Column(
          children: [
            LoanCalculatorCard(state: state),

            // Vantagens de Financiamento
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Por que financiar na Gaúcho Veículos?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildPerkItem(
                    FontAwesomeIcons.bolt,
                    'Aprovação Imediata',
                    'Análise de crédito rápida com parecer em até 30 minutos.',
                  ),
                  const SizedBox(height: 12),
                  _buildPerkItem(
                    FontAwesomeIcons.calendarCheck,
                    'Até 60 dias para a 1ª Parcela',
                    'Saia de carro novo hoje e comece a pagar só daqui a dois meses.',
                  ),
                  const SizedBox(height: 12),
                  _buildPerkItem(
                    FontAwesomeIcons.moneyBillTransfer,
                    'Troca com Troco',
                    'Seu usado entra como entrada e a diferença vai para o seu bolso.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPerkItem(FaIconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primarySubtle,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: FaIcon(icon, size: 14, color: AppTheme.primary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
