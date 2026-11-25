import 'dart:ui';

class CurrencyItem {
  final String code;
  final String symbolAr;
  final String symbolEn;
  final String nameAr;
  final String nameEn;
  final String flag;
  final List<String> countryCodes;

  const CurrencyItem({
    required this.code,
    required this.symbolAr,
    required this.symbolEn,
    required this.nameAr,
    required this.nameEn,
    required this.flag,
    required this.countryCodes,
  });

  String getSymbol(bool isArabic) => isArabic ? symbolAr : symbolEn;
  String getName(bool isArabic) => isArabic ? nameAr : nameEn;

  /// Complete list of supported currencies (Arab world + major foreign currencies).
  static const List<CurrencyItem> supportedCurrencies = [
    // ─── الدول العربية (Arab Countries) ─────────────────────────────────
    CurrencyItem(
      code: 'EGP',
      symbolAr: 'ج.م',
      symbolEn: 'EGP',
      nameAr: 'جنيه مصري',
      nameEn: 'Egyptian Pound',
      flag: '🇪🇬',
      countryCodes: ['EG'],
    ),
    CurrencyItem(
      code: 'SAR',
      symbolAr: 'ر.س',
      symbolEn: 'SAR',
      nameAr: 'ريال سعودي',
      nameEn: 'Saudi Riyal',
      flag: '🇸🇦',
      countryCodes: ['SA'],
    ),
    CurrencyItem(
      code: 'AED',
      symbolAr: 'د.إ',
      symbolEn: 'AED',
      nameAr: 'درهم إماراتي',
      nameEn: 'UAE Dirham',
      flag: '🇦🇪',
      countryCodes: ['AE'],
    ),
    CurrencyItem(
      code: 'KWD',
      symbolAr: 'د.ك',
      symbolEn: 'KWD',
      nameAr: 'دينار كويتي',
      nameEn: 'Kuwaiti Dinar',
      flag: '🇰🇼',
      countryCodes: ['KW'],
    ),
    CurrencyItem(
      code: 'QAR',
      symbolAr: 'ر.ق',
      symbolEn: 'QAR',
      nameAr: 'ريال قطري',
      nameEn: 'Qatari Riyal',
      flag: '🇶🇦',
      countryCodes: ['QA'],
    ),
    CurrencyItem(
      code: 'OMR',
      symbolAr: 'ر.ع',
      symbolEn: 'OMR',
      nameAr: 'ريال عماني',
      nameEn: 'Omani Rial',
      flag: '🇴🇲',
      countryCodes: ['OM'],
    ),
    CurrencyItem(
      code: 'BHD',
      symbolAr: 'د.ب',
      symbolEn: 'BHD',
      nameAr: 'دينار بحريني',
      nameEn: 'Bahraini Dinar',
      flag: '🇧🇭',
      countryCodes: ['BH'],
    ),
    CurrencyItem(
      code: 'IQD',
      symbolAr: 'د.ع',
      symbolEn: 'IQD',
      nameAr: 'دينار عراقي',
      nameEn: 'Iraqi Dinar',
      flag: '🇮🇶',
      countryCodes: ['IQ'],
    ),
    CurrencyItem(
      code: 'JOD',
      symbolAr: 'د.أ',
      symbolEn: 'JOD',
      nameAr: 'دينار أردني',
      nameEn: 'Jordanian Dinar',
      flag: '🇯🇴',
      countryCodes: ['JO'],
    ),
    CurrencyItem(
      code: 'LYD',
      symbolAr: 'د.ل',
      symbolEn: 'LYD',
      nameAr: 'دينار ليبي',
      nameEn: 'Libyan Dinar',
      flag: '🇱🇾',
      countryCodes: ['LY'],
    ),
    CurrencyItem(
      code: 'DZD',
      symbolAr: 'د.ج',
      symbolEn: 'DZD',
      nameAr: 'دينار جزائري',
      nameEn: 'Algerian Dinar',
      flag: '🇩🇿',
      countryCodes: ['DZ'],
    ),
    CurrencyItem(
      code: 'MAD',
      symbolAr: 'د.م',
      symbolEn: 'MAD',
      nameAr: 'درهم مغربي',
      nameEn: 'Moroccan Dirham',
      flag: '🇲🇦',
      countryCodes: ['MA'],
    ),
    CurrencyItem(
      code: 'TND',
      symbolAr: 'د.ت',
      symbolEn: 'TND',
      nameAr: 'دينار تونسي',
      nameEn: 'Tunisian Dinar',
      flag: '🇹🇳',
      countryCodes: ['TN'],
    ),
    CurrencyItem(
      code: 'SDG',
      symbolAr: 'ج.س',
      symbolEn: 'SDG',
      nameAr: 'جنيه سوداني',
      nameEn: 'Sudanese Pound',
      flag: '🇸🇩',
      countryCodes: ['SD'],
    ),
    CurrencyItem(
      code: 'YER',
      symbolAr: 'ر.ي',
      symbolEn: 'YER',
      nameAr: 'ريال يمني',
      nameEn: 'Yemeni Rial',
      flag: '🇾🇪',
      countryCodes: ['YE'],
    ),
    CurrencyItem(
      code: 'LBP',
      symbolAr: 'ل.ل',
      symbolEn: 'LBP',
      nameAr: 'ليرة لبنانية',
      nameEn: 'Lebanese Pound',
      flag: '🇱🇧',
      countryCodes: ['LB'],
    ),
    CurrencyItem(
      code: 'SYP',
      symbolAr: 'ل.س',
      symbolEn: 'SYP',
      nameAr: 'ليرة سورية',
      nameEn: 'Syrian Pound',
      flag: '🇸🇾',
      countryCodes: ['SY'],
    ),
    CurrencyItem(
      code: 'ILS',
      symbolAr: '₪',
      symbolEn: 'ILS',
      nameAr: 'شيكل',
      nameEn: 'Shekel',
      flag: '🇵🇸',
      countryCodes: ['PS', 'IL'],
    ),

    // ─── العملات العالمية والأجنبية (Foreign Currencies) ───────────────────
    CurrencyItem(
      code: 'USD',
      symbolAr: '\$',
      symbolEn: '\$',
      nameAr: 'دولار أمريكي',
      nameEn: 'US Dollar',
      flag: '🇺🇸',
      countryCodes: ['US', 'EC', 'SV', 'PA'],
    ),
    CurrencyItem(
      code: 'EUR',
      symbolAr: '€',
      symbolEn: '€',
      nameAr: 'يورو أوروبي',
      nameEn: 'Euro',
      flag: '🇪🇺',
      countryCodes: [
        'DE', 'FR', 'IT', 'ES', 'NL', 'BE', 'AT', 'PT', 'FI', 'GR', 'IE', 'SK', 'SI', 'EE', 'LV', 'LT', 'CY', 'MT', 'LU'
      ],
    ),
    CurrencyItem(
      code: 'GBP',
      symbolAr: '£',
      symbolEn: '£',
      nameAr: 'جنيه إسترليني',
      nameEn: 'British Pound',
      flag: '🇬🇧',
      countryCodes: ['GB'],
    ),
    CurrencyItem(
      code: 'TRY',
      symbolAr: '₺',
      symbolEn: '₺',
      nameAr: 'ليرة تركية',
      nameEn: 'Turkish Lira',
      flag: '🇹🇷',
      countryCodes: ['TR'],
    ),
    CurrencyItem(
      code: 'CAD',
      symbolAr: 'C\$',
      symbolEn: 'C\$',
      nameAr: 'دولار كندي',
      nameEn: 'Canadian Dollar',
      flag: '🇨🇦',
      countryCodes: ['CA'],
    ),
    CurrencyItem(
      code: 'AUD',
      symbolAr: 'A\$',
      symbolEn: 'A\$',
      nameAr: 'دولار أسترالي',
      nameEn: 'Australian Dollar',
      flag: '🇦🇺',
      countryCodes: ['AU'],
    ),
    CurrencyItem(
      code: 'CHF',
      symbolAr: 'CHF',
      symbolEn: 'CHF',
      nameAr: 'فرنك سويسري',
      nameEn: 'Swiss Franc',
      flag: '🇨🇭',
      countryCodes: ['CH', 'LI'],
    ),
    CurrencyItem(
      code: 'RUB',
      symbolAr: '₽',
      symbolEn: '₽',
      nameAr: 'روبل روسي',
      nameEn: 'Russian Ruble',
      flag: '🇷🇺',
      countryCodes: ['RU'],
    ),
    CurrencyItem(
      code: 'CNY',
      symbolAr: '¥',
      symbolEn: '¥',
      nameAr: 'يوان صيني',
      nameEn: 'Chinese Yuan',
      flag: '🇨🇳',
      countryCodes: ['CN'],
    ),
    CurrencyItem(
      code: 'JPY',
      symbolAr: '¥',
      symbolEn: '¥',
      nameAr: 'ين ياباني',
      nameEn: 'Japanese Yen',
      flag: '🇯🇵',
      countryCodes: ['JP'],
    ),
    CurrencyItem(
      code: 'INR',
      symbolAr: '₹',
      symbolEn: '₹',
      nameAr: 'روبية هندية',
      nameEn: 'Indian Rupee',
      flag: '🇮🇳',
      countryCodes: ['IN'],
    ),
    CurrencyItem(
      code: 'PKR',
      symbolAr: 'Rs',
      symbolEn: 'Rs',
      nameAr: 'روبية باكستانية',
      nameEn: 'Pakistani Rupee',
      flag: '🇵🇰',
      countryCodes: ['PK'],
    ),
    CurrencyItem(
      code: 'BDT',
      symbolAr: '৳',
      symbolEn: '৳',
      nameAr: 'تاكا بنغلاديشية',
      nameEn: 'Bangladeshi Taka',
      flag: '🇧🇩',
      countryCodes: ['BD'],
    ),
    CurrencyItem(
      code: 'PHP',
      symbolAr: '₱',
      symbolEn: '₱',
      nameAr: 'بيزو فلبيني',
      nameEn: 'Philippine Peso',
      flag: '🇵🇭',
      countryCodes: ['PH'],
    ),
    CurrencyItem(
      code: 'MYR',
      symbolAr: 'RM',
      symbolEn: 'RM',
      nameAr: 'رينغيت ماليزي',
      nameEn: 'Malaysian Ringgit',
      flag: '🇲🇾',
      countryCodes: ['MY'],
    ),
    CurrencyItem(
      code: 'IDR',
      symbolAr: 'Rp',
      symbolEn: 'Rp',
      nameAr: 'روبية إندونيسية',
      nameEn: 'Indonesian Rupiah',
      flag: '🇮🇩',
      countryCodes: ['ID'],
    ),
    CurrencyItem(
      code: 'BRL',
      symbolAr: 'R\$',
      symbolEn: 'R\$',
      nameAr: 'ريال برازيلي',
      nameEn: 'Brazilian Real',
      flag: '🇧🇷',
      countryCodes: ['BR'],
    ),
    CurrencyItem(
      code: 'ZAR',
      symbolAr: 'R',
      symbolEn: 'R',
      nameAr: 'راند جنوب أفريقي',
      nameEn: 'South African Rand',
      flag: '🇿🇦',
      countryCodes: ['ZA'],
    ),
  ];

  /// Auto-detects the currency from device locale country code.
  /// Falls back to EGP for Arabic locales, or USD for others.
  static CurrencyItem detectFromLocale(Locale? locale) {
    if (locale == null) return supportedCurrencies.first;

    final countryCode = locale.countryCode?.toUpperCase();
    if (countryCode != null && countryCode.isNotEmpty) {
      for (final item in supportedCurrencies) {
        if (item.countryCodes.contains(countryCode)) {
          return item;
        }
      }
    }

    // Fallback based on language
    if (locale.languageCode.toLowerCase() == 'ar') {
      return supportedCurrencies.firstWhere((c) => c.code == 'EGP');
    }
    return supportedCurrencies.firstWhere((c) => c.code == 'USD');
  }

  /// Finds a currency by its 3-letter code.
  static CurrencyItem findByCode(String code) {
    return supportedCurrencies.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => supportedCurrencies.first,
    );
  }
}
