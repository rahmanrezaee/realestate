import 'package:badam/model/city.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SearchDialog extends StatefulWidget {
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

enum AimCharacter { buy, run, graw }
enum TypeCharacter { all, land, home, unit, office, shop, apartment, vela }

class _SearchDialogState extends State<SearchDialog> {
 
 
  String leastMount = "";
  String lastMount = "";
  String leastMeter = "";
  String lastMeter = "";
  String selectedValue = "";


  CityList cityList;
  final List<DropdownMenuItem> items = [];

  @override
  void initState() {
    CityList.list.forEach((word) {
      items.add(DropdownMenuItem(
        child: Text(word.toString()),
        value: word.toString(),
      ));
    });
    super.initState();
  }

  AimCharacter _aim = AimCharacter.buy;
  TypeCharacter _typeProperty = TypeCharacter.all;

  void searchString() {
    String mainSearchQuery = "";
    if (_aim == AimCharacter.buy) {
      mainSearchQuery += "?property-statuses=31";
    } else if (_aim == AimCharacter.graw) {
      mainSearchQuery += "?property-statuses=32";
    } else if (_aim == AimCharacter.run) {
      mainSearchQuery += "?property-statuses=30";
    }
    if (_typeProperty == TypeCharacter.all) {
    } else if (_typeProperty == TypeCharacter.apartment) {
      mainSearchQuery += "&property-types=48";
    } else if (_typeProperty == TypeCharacter.home) {
      mainSearchQuery += "&property-types=67";
    } else if (_typeProperty == TypeCharacter.office) {
      mainSearchQuery += "&property-types=40";
    } else if (_typeProperty == TypeCharacter.shop) {
      mainSearchQuery += "&property-types=43";
    } else if (_typeProperty == TypeCharacter.land) {
      mainSearchQuery += "&property-types=65";
    } else if (_typeProperty == TypeCharacter.unit) {
      mainSearchQuery += "&property-types=47";
    } else if (_typeProperty == TypeCharacter.vela) {
      mainSearchQuery += "&property-types=46";
    }

    if (lastMount != "" && leastMount != "") {
      mainSearchQuery +=
          "&filter[meta_query][0][key]=REAL_HOMES_property_price&filter[meta_query][0][value][0]=" +
              leastMount +
              "&filter[meta_query][0][value][1]=" +
              lastMount +
              "&filter[meta_query][0][compare]=BETWEEN&filter[meta_query][0][type]=numeric";
    }
    if (lastMeter != "" && leastMeter != "") {
      mainSearchQuery +=
          "&filter[meta_query][1][key]=REAL_HOMES_property_size&filter[meta_query][1][value][0]=" +
              leastMeter +
              "&filter[meta_query][1][value][1]=" +
              lastMeter +
              "&filter[meta_query][1][compare]=BETWEEN&filter[meta_query][1][type]=numeric";
    }
    print(selectedValue);
    if (selectedValue != "") {
      mainSearchQuery +=
          "&property-cities=" + CityList.getKeylist(selectedValue);
    }

    Navigator.pop(context, mainSearchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("فلتر کردن املاک"),
        leading: FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 28,
            )),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("هدف"),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('کرایی'),
                    Radio(
                      value: AimCharacter.run,
                      groupValue: _aim,
                      onChanged: (AimCharacter value) {
                        setState(() {
                          _aim = value;
                        });
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('فروشی'),
                    Radio(
                      value: AimCharacter.buy,
                      groupValue: _aim,
                      onChanged: (AimCharacter value) {
                        setState(() {
                          _aim = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('گروه'),
                    Radio(
                      value: AimCharacter.graw,
                      groupValue: _aim,
                      onChanged: (AimCharacter value) {
                        setState(() {
                          _aim = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            ListTile(
              title: Text("مکان ملک"),
            ),
            SearchableDropdown.single(
              items: items,
              value: selectedValue,
              hint: "شهر مورد نظر را انتخاب کنید",
              searchHint: "لیست شهر ها",
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
              doneButton: "انتخاب",
              displayItem: (item, selected) {
                return (Row(children: [
                  selected
                      ? Icon(
                          Icons.radio_button_checked,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey,
                        ),
                  SizedBox(width: 7),
                  Expanded(
                    child: item,
                  ),
                ]));
              },
              isExpanded: true,
            ),
            ListTile(
              title: Text("نوعیت ملک"),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('ّهمه'),
                    Radio(
                      value: TypeCharacter.all,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('زمین'),
                    Radio(
                      value: TypeCharacter.land,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('خانه'),
                    Radio(
                      value: TypeCharacter.home,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('دفتر'),
                    Radio(
                      value: TypeCharacter.office,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('دوکان'),
                    Radio(
                      value: TypeCharacter.shop,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('واحد'),
                    Radio(
                      value: TypeCharacter.unit,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('اپارتمان'),
                    Radio(
                      value: TypeCharacter.apartment,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('ویلا'),
                    Radio(
                      value: TypeCharacter.vela,
                      groupValue: _typeProperty,
                      onChanged: (TypeCharacter value) {
                        setState(() {
                          _typeProperty = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            ListTile(
              title: Text("قمیت ملک ( افغانی ) "),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      onChanged: (value) {
                        leastMount = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'کمترین مقدار',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        lastMount = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'بیشترین مقدار',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text("متراژ ( متر مربع ) "),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      onChanged: (value) {
                        leastMeter = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'کمترین مقدار',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      onChanged: (value) {
                        lastMeter = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'بیشترین مقدار',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 100,
              padding: EdgeInsets.all(10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: FlatButton(
                  onPressed: searchString,
                  child: Text(
                    "حستجو",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// http://192.168.43.186/sanhome/wp-json/wp/v2/properties?filter[meta_query][0][key]=REAL_HOMES_property_price&filter[meta_query][0][value][0]=10&filter[meta_query][0][value][1]=3000&filter[meta_query][0][compare]=BETWEEN&filter[meta_query][0][type]=numeric
// http://192.168.43.186/sanhome/wp-json/wp/v2/properties?title=hello&content=test contect&property_meta[REAL_HOMES_property_price]=10000
