import 'package:async/async.dart';
import 'package:badam/apiReqeust/constants.dart';
import 'package:badam/modul/Search/hotel_app_theme.dart';
import 'package:badam/modul/customRadioButton/custom_radio_grouped_button.dart';

import 'package:badam/page/myProperties/addpropertise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class FiltersScreen extends StatefulWidget {
  Map filterdSearch;
  FiltersScreen(this.filterdSearch);
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  double distValue = 50.0;

  final CancelableCompleter<bool> _completer =
      CancelableCompleter(onCancel: () => false);

  // final GlobalKey _tagStateKey = GlobalKey();
  Map ?_loctionSearchWidget;

  SuggestionsBoxController _sbc = new SuggestionsBoxController();
  int _lowerDistanceValue = 20;
  int _upperDistanceValue = 9000;

  int _lowerPriceValue = 500;
  int _upperPriceValue = 9000000;

  List<Map<String, String>> propertytypes = [
    {"name": 'همه', "slug": "all"},
    {"name": 'اپارتمان', "slug": 'apartment'},
    {"name": 'اداری', "slug": 'office'},
    {"name": 'تجارتی', "slug": 'commerce'},
    {"name": 'خانه', "slug": 'home'},
    {"name": 'مستغلات', "slug": 'working'},
    {"name": 'زمین', "slug": 'land'},
    {"name": 'ویلا', "slug": 'villa'},
    {"name": 'باغ و باغچه', "slug": 'grabeg'},
    {"name": 'انبار و سوله', "slug": 'store'},
  ];

  Map<String, String>? propertyTypeSelected;
  @override
  void initState() {
    propertyTypeSelected = propertytypes[0];

    super.initState();
  }

  final locationTextController = TextEditingController();
  final cityTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'ولایت ملک',
                            ),
                            Text("0/100")
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //       bottom:
                          //           MediaQuery.of(context).viewInsets.bottom),
                          //   // padding: const EdgeInsets.only(
                          //   //     bottom: 8.0, left: 8, right: 8),
                          //   child: TypeAheadFormField<Map>(
                          //     textFieldConfiguration: TextFieldConfiguration(
                          //       decoration: InputDecoration(
                          //           suffixIcon: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: FaIcon(
                          //                 FontAwesomeIcons.locationArrow),
                          //           ),
                          //           border: OutlineInputBorder(),
                          //           hintText: 'مکان را بنویسید'),
                          //       controller: this.locationTextController,
                          //     ),
                          //     suggestionsCallback: (pattern) {
                          //       // return getSuggestions(pattern);
                          //     },
                          //     itemBuilder: (context, suggestion) {
                          //       return ListTile(
                          //         dense: true,
                          //         title: Text(suggestion.toString()),
                          //       );
                          //     },
                          //     hideSuggestionsOnKeyboardHide: true,
                          //     transitionBuilder:
                          //         (context, suggestionsBox, controller) {
                          //       return suggestionsBox;
                          //     },
                          //     onSuggestionSelected: (suggestion) {
                          //       setState(() {
                          //         // locationTextController.text =
                          //         //     suggestion!['display'];
                          //         // // property.city = {
                          //         // //   'term_slug': suggestion['value']
                          //         // // };
                          //         // _loctionSearchWidget = {
                          //         //   'term_slug': suggestion!['value']
                          //         // };

                          //         // _loctionSearchWidget.add(city);
                          //       });
                          //       // this.locationTextController.text = suggestion['value'];
                          //     },
                          //     validator: (value) =>
                          //         value.isEmpty ? 'Please select a city' : null,
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'شهر  ملک',
                            ),
                            Text("0/100")
                          ],
                        ),
                      ),
                      MyTextFormField(
                        textEditingController: cityTextController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'شهر ملک را وارد کنید';
                          }
                          return null;
                        },
                      ),
                      // Tags(
                      //   // key: _tagStateKey,
                      //   itemCount: _loctionSearchWidget.length,
                      //   itemBuilder: (index) {
                      //     final item = _loctionSearchWidget[index];
                      //     return ItemTags(
                      //       key: Key(index.toString()),
                      //       index: index,
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 10, vertical: 10),
                      //       title: item['name'],
                      //       pressEnabled: false,
                      //       singleItem: false,
                      //       splashColor: Colors.white,
                      //       color: Colors.white10,
                      //       combine: ItemTagsCombine.withTextBefore,
                      //       removeButton: ItemTagsRemoveButton(
                      //         onRemoved: () {
                      //           setState(() {
                      //             _loctionSearchWidget.removeAt(index);
                      //           });
                      //           return true;
                      //         },
                      //       ),
                      //       textStyle: TextStyle(
                      //         fontSize: 14,
                      //       ),
                      //       // onPressed: (item) => print(item),
                      //     );
                      //   },
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: TypeAheadField(
                      //     hideOnLoading: false,
                      //     hideOnEmpty: true,
                      //     loadingBuilder: (BuildContext con) {
                      //       return Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: <Widget>[
                      //           Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: CircularProgressIndicator(),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //     suggestionsBoxController: _sbc,
                      //     keepSuggestionsOnLoading: false,
                      //     textFieldConfiguration: TextFieldConfiguration(
                      //       autofocus: false,
                      //       controller: locationTextController,
                      //       decoration: InputDecoration(
                      //           suffixIcon: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: FaIcon(FontAwesomeIcons.locationArrow),
                      //           ),
                      //           border: OutlineInputBorder(),
                      //           hintText: 'مکان را بنویسید'),
                      //     ),
                      //     suggestionsCallback: (pattern) async {
                      //       await _completer.operation.cancel();
                      //       if (pattern != "") {
                      //         return await BackendService.getSuggestions(pattern);
                      //       }
                      //     },
                      //     itemBuilder: (context, suggestion) {
                      //       return ListTile(
                      //         leading: Icon(Icons.shopping_cart),
                      //         title: Text(suggestion['term_name']),
                      //         subtitle: Text(suggestion['term_parent_name']),
                      //       );
                      //     },
                      //     onSuggestionSelected: (suggestion) {
                      //       setState(() {
                      //         locationTextController.clear();
                      //         _sbc.close();
                      //         _loctionSearchWidget.add({
                      //           "slug": suggestion['term_slug'],
                      //           "name": suggestion['term_name'],
                      //         });
                      //       });
                      //       // Navigator.of(context).pop(suggestion);
                      //     },
                      //   ),
                      // ),
                      // Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  FaIcon(FontAwesomeIcons.hotel),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'نوع ملک',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                    360
                                                ? 18
                                                : 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              propertyTypeSelected!['name']!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.width > 360
                                          ? 18
                                          : 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      CustomRadioButton(
                        elevation: 0,
                        unSelectedColor: Theme.of(context).canvasColor,
                        height: 40,
                        defaultSelected: propertytypes[0]['slug'],
                        buttonLables:
                            propertytypes.map((m) => m['name']!).toList(),
                        buttonValues:
                            propertytypes.map((m) => m['slug']).toList(),
                        buttonTextStyle: ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: TextStyle(fontSize: 16)),
                        radioButtonValue: (value) {
                          setState(() {
                            propertytypes.map((data) {
                              if (data['slug'] == value) {
                                this.propertyTypeSelected = data;
                              }
                            }).toList();

                            // _propertyTpe = value;
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor,
                      ),
                      Divider(),

                      priceBarFilter(),
                      const Divider(
                        height: 1,
                      ),

                      distanceViewUI(),
                      const Divider(
                        height: 1,
                      ),
                      // allAccommodationUI()
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: HotelAppTheme.buildLightTheme().primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context, {
                          "place": _loctionSearchWidget,
                          "type": propertyTypeSelected!['slug'] == "all"
                              ? null
                              : propertyTypeSelected,
                          "price": {
                            "lower": _lowerPriceValue,
                            "upper": _upperPriceValue,
                          },
                          "size": {
                            "lower": _lowerDistanceValue,
                            "upper": _upperDistanceValue,
                          },
                          "city": cityTextController.text
                        });
                      },
                      child: Center(
                        child: Text(
                          'فلتر کردن',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget distanceViewUI() {
    String label = " $_lowerDistanceValue  -  $_upperDistanceValue ";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.objectGroup),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ' متراژ(متر)',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize:
                              MediaQuery.of(context).size.width > 360 ? 18 : 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        frs.RangeSlider(
          min: 0,
          max: 10000,
          lowerValue: _lowerDistanceValue.toDouble(),
          upperValue: _upperDistanceValue.toDouble(),
          divisions: 50,
          showValueIndicator: true,
          valueIndicatorMaxDecimals: 0,
          onChanged: (double newLowerValue, double newUpperValue) {
            setState(() {
              _lowerDistanceValue = newLowerValue.toInt();
              _upperDistanceValue = newUpperValue.toInt();
            });
          },
          onChangeStart: (double startLowerValue, double startUpperValue) {
            print(' $startLowerValue  -  $startUpperValue ');
          },
          onChangeEnd: (double newLowerValue, double newUpperValue) {
            print('Ended with values: $newLowerValue and $newUpperValue');
          },
        ),
      ],
    );
  }

  Widget priceBarFilter() {
    String label = " $_lowerPriceValue  -  $_upperPriceValue ";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.moneyCheck),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ' قمیت (افغانی) ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize:
                              MediaQuery.of(context).size.width > 360 ? 18 : 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        frs.RangeSlider(
          min: 500,
          max: 10000000,
          lowerValue: _lowerPriceValue.toDouble(),
          upperValue: _upperPriceValue.toDouble(),
          divisions: 500,
          showValueIndicator: true,
          valueIndicatorMaxDecimals: 1,
          onChanged: (double newLowerValue, double newUpperValue) {
            setState(() {
              _lowerPriceValue = newLowerValue.toInt();
              _upperPriceValue = newUpperValue.toInt();
            });
          },
          onChangeStart: (double startLowerValue, double startUpperValue) {
            print('Started with values: $startLowerValue and $startUpperValue');
          },
          onChangeEnd: (double newLowerValue, double newUpperValue) {
            print('Ended with values: $newLowerValue and $newUpperValue');
          },
        ),
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'فلتر ها',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List> getSuggestions(String query) async {
    List<Map<String, String>> matches = [];
    matches.addAll(PROVINCES_LIST);

    print(matches);

    matches.retainWhere((s) => s['display']!.contains(query));
    return matches;
  }
}
