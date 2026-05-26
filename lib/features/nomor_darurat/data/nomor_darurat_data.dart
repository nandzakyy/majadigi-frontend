class NomorDaruratData {
  // Default numbers (Jawa Timur - no specific region)
  static const List<Map<String, String>> defaultContacts = [
    {
      'title': 'Ambulans / Keadaan Darurat',
      'number': '112',
    },
    {
      'title': 'Polda Jawa Timur',
      'number': '(031) 8280748',
    },
    {
      'title': 'Call Center',
      'number': '1500979',
    },
  ];

  // Regional contacts data
  static const Map<String, List<Map<String, String>>> regionalContacts = {
    'Surabaya': [
      {
        'title': 'RSUD Dr. Soetomo dan PMI',
        'number': '(031) 5501001',
      },
      {
        'title': 'Polrestabes',
        'number': '(031) 3523927',
      },
      {
        'title': 'Pemadam Kebakaran',
        'number': '(031) 3533843',
      },
    ],
    'Malang': [
      {
        'title': 'Ambulans',
        'number': '1185',
      },
      {
        'title': 'Polisi',
        'number': '110',
      },
      {
        'title': 'Pemadam Kebakaran',
        'number': '2646176',
      },
    ],
    'Sidoarjo': [
      {
        'title': 'Ambulans',
        'number': '31',
      },
      {
        'title': 'Polisi',
        'number': '110',
      },
      {
        'title': 'Pemadam Kebakaran',
        'number': '113',
      },
    ],
    'Blitar': [
      {
        'title': 'Ambulans',
        'number': '(0342) 801119',
      },
      {
        'title': 'Polisi',
        'number': '110',
      },
      {
        'title': 'Pemadam Kebakaran',
        'number': '113',
      },
    ],
    'Kediri': [
      {
        'title': 'Ambulans',
        'number': '(0354) 695119',
      },
      {
        'title': 'SPKT Polres',
        'number': '(0354) 391710',
      },
      {
        'title': 'Pemadam Kebakaran',
        'number': '(0354) 113',
      },
    ],
  };

  static List<String> get regions => regionalContacts.keys.toList();

  static List<Map<String, String>> getContactsByRegion(String? region) {
    if (region == null || region.isEmpty) {
      return List.from(defaultContacts);
    }
    return regionalContacts[region] ?? List.from(defaultContacts);
  }
}
