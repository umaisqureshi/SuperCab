class Language
{
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language({this.id,this.name,this.flag,this.languageCode});

  static List<Language> languageList()
  {
    return <Language>[
      Language(id: 1,name: 'English',flag: 'Au',languageCode: 'en-AU'),
      Language(id: 2,name: 'Chinese',flag: 'CN',languageCode: 'zh'),
    ];
  }

}

class FlagData
{
  final int id;
  final String countryFlag;
  final String flagName;

  FlagData({this.id,this.countryFlag,this.flagName});

  static List<FlagData> flagList()
  {
    return <FlagData>[
      FlagData(id: 1,countryFlag: 'Au',flagName: 'English'),
      FlagData(id: 2,countryFlag: 'CN',flagName: 'Chinese'),
    ];
  }
}