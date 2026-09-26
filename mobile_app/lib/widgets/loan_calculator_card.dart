import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../providers/app_state.dart';

class LoanCalculatorCard extends StatelessWidget {
  final AppState state;

  const LoanCalculatorCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderGlass),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.calculator,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Simulador de Financiamento',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Taxas reduzidas a partir de 0,99% a.m.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Valor do Veículo',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                Text(
                  AppConstants.formatBRL(state.simCarPrice),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            Slider(
              value: state.simCarPrice,
              min: 40000,
              max: 700000,
              divisions: 132,
              onChanged: (val) => state.setSimCarPrice(val),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Entrada (${state.simDownPercent.toStringAsFixed(0)}%)',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                Text(
                  AppConstants.formatBRL(state.simDownPayment),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            Slider(
              value: state.simDownPayment,
              min: 0,
              max: state.simCarPrice * 0.8,
              onChanged: (val) => state.setSimDownPayment(val),
            ),
            const SizedBox(height: 14),

            const Text(
              'Prazo do Financiamento',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [12, 24, 36, 48, 60].map((months) {
                final isSelected = state.simMonths == months;
                return ChoiceChip(
                  label: Text('${months}x'),
                  selected: isSelected,
                  selectedColor: AppTheme.primary,
                  backgroundColor: AppTheme.bgDark,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.bgDark : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (_) => state.setSimMonths(months),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.bgDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                children: [
                  const Text(
                    'PARCELA ESTIMADA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.formatBRL(state.simMonthlyInstallment),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.accentGold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Valor Financiado: ${AppConstants.formatBRL(state.simFinancedAmount)} em ${state.simMonths} meses',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.whatsappGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                label: const Text(
                  'Enviar Proposta ao Consultor',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  final msg =
                      'Olá Gaúcho Veículos! Fiz uma simulação pelo Aplicativo:\n'
                      '• Valor do Carro: ${AppConstants.formatBRL(state.simCarPrice)}\n'
                      '• Entrada: ${AppConstants.formatBRL(state.simDownPayment)} (${state.simDownPercent.toStringAsFixed(0)}%)\n'
                      '• Parcelas: ${state.simMonths}x de ${AppConstants.formatBRL(state.simMonthlyInstallment)}\n\n'
                      'Gostaria de solicitar a aprovação do meu crédito!';
                  AppConstants.openWhatsApp(msg);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
