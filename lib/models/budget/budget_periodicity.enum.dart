enum BudgetPeriodicityEnum {

  invalid('invalid', 'Invalid'),
  weekly('weekly', 'Weekly'),
  monthly('monthly', 'Monthly'),
  trimesterly('trimesterly', 'Trimesterly'),
  yearly('yearly', 'Yearly');

  final String code;
  final String name;

  const BudgetPeriodicityEnum(this.code, this.name);

  static BudgetPeriodicityEnum fromCode(String code) {
    return BudgetPeriodicityEnum.values.firstWhere((e) => e.code == code, orElse: () => BudgetPeriodicityEnum.invalid);
  }

}