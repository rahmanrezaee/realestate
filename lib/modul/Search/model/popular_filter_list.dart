class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'اجانس',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'پارکینک',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'حوض',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'خواب گاه',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'وایرلس',
      isSelected: false,
    ),
  ];

  static List<Map> accomodationList = [
    
    {
      "slug":"apartement",
      "name":"اپارتمان",
    },
    {
      "slug":"land",
      "name":"زمین",
    },
    {
      "slug":"home",
      "name":"خانه",
    },
    {
      "slug":"store",
      "name":"امبار",
    },
    {
      "slug":"office",
      "name":"دفتر",
    },
  
  ];
}