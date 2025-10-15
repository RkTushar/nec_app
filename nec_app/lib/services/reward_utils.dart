String computeInviteBonusAmount(String? currencyCode) {
  final String cc = (currencyCode ?? '').toUpperCase();
  final bool isUsd = cc == 'USD' || cc == 'US' || cc == 'USA' || cc == 'USDT';
  final bool isEuro = cc == 'EUR' || cc == 'EU' || cc == 'EURO' || cc == 'UK' || cc == 'GB' || cc == 'GBR' || cc == 'GBP';
  return (isUsd || isEuro) ? '5' : '50';
}


