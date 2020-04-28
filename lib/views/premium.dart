import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/page-header-image.dart';
import 'package:airnote/components/submit-button.dart';
import 'package:airnote/data/premium-item.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/promotion-code.dart';
import 'package:airnote/views/root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinPremium extends StatefulWidget {
  static const routeName = "join-premium";

  @override
  _JoinPremiumState createState() => _JoinPremiumState();
}

class _JoinPremiumState extends State<JoinPremium> {
  final imageUrl = "http://d1apvrodb6vxub.cloudfront.net/premium.png";
  final _dialogService = locator<DialogService>();
  PromotionCodeViewModel _promotionCodeViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final promotionCodeViewModel = Provider.of<PromotionCodeViewModel>(context);
    if (this._promotionCodeViewModel == promotionCodeViewModel) {
      return;
    }
    this._promotionCodeViewModel = promotionCodeViewModel;
  }

  Future<bool> _redeemPromoCode(String code) async {
    final result = await _promotionCodeViewModel.redeemCode(code);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  PageHeader(
                    imageUrl: imageUrl,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    height: 250,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Your journal, your journey",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AirnoteColors.grey,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: Text("Unlock your complete personalised audio journal"),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        premiumItems.where((a) => !a.isAvailableBasic).length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = premiumItems
                          .where((a) => !a.isAvailableBasic)
                          .toList()[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _ItemDescriptionView(
                          item: item,
                        ),
                      );
                    }),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  "Lesley is better with Premium",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              DataTable(
                columns: [
                  DataColumn(label: Text("")),
                  DataColumn(label: Text("Basic")),
                  DataColumn(label: Text("Premium")),
                ],
                rows: premiumItems.map((a) => buildRow(a)).toList(),
              ),
              Container(
                height: 150,
              )
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: AirnoteOptionButton(
                  icon: Icon(Icons.arrow_downward),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: AirnoteSubmitButton(
                text: "Join",
                onPressed: () async {
                  await _dialogService.showInputDialog(
                      title: "Promotion Code",
                      content:
                          "Please enter the promotion code we sent you via email.",
                      isLoading: false,
                      onPressed: (String value) async {
                        final result = await _redeemPromoCode(value);
                        if (result) {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Root.routeName, (Route<dynamic> route) => false);
                        }
                      },
                      inputHint: "Promotion Code",
                      inputValidator: InputValidator.promotionCode,
                      inputSuffix: Icon(Icons.star));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

DataRow buildRow(PremiumItem item) {
  return DataRow(cells: [
    DataCell(Text(item.title)),
    DataCell(item.isAvailableBasic
        ? Icon(
            Icons.check,
            color: AirnoteColors.primary,
          )
        : Icon(
            Icons.lock_outline,
            color: AirnoteColors.grey,
          )),
    DataCell(Icon(
      Icons.check,
      color: AirnoteColors.primary,
    )),
  ]);
}

class _ItemDescriptionView extends StatelessWidget {
  final PremiumItem item;

  _ItemDescriptionView({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.check,
        color: AirnoteColors.primary,
      ),
      title: Text(
        item.description,
        style: TextStyle(
          color: AirnoteColors.grey,
          fontSize: 15,
        ),
      ),
    );
  }
}
