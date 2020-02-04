import 'package:airnote/components/audio-player.dart';
import 'package:airnote/components/circular-button.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/models/sentiment.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/views/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:airnote/services/dialog.dart';

class EntryView extends StatefulWidget {
  static const routeName = 'view-entry';
  @override
  State<EntryView> createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView>
    with SingleTickerProviderStateMixin {
  EntryViewModel _entryViewModel;
  AnimationController _optionsAnimationController;
  Animation<Offset> _lockButtonAnimation;
  Animation<Offset> _deleteButtonAnimation;
  final _dialogService = locator<DialogService>();

  bool _isOptionOpened = false;
  bool _isLocked;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getEntry();
    });
    _optionsAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _lockButtonAnimation =
        Tween<Offset>(begin: Offset(100, 0), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _optionsAnimationController, curve: Curves.easeOutBack))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener(_setOptionsStatus);
    _deleteButtonAnimation =
        Tween<Offset>(begin: Offset(100, 0), end: Offset(0, 0)).animate(
            CurvedAnimation(
                parent: _optionsAnimationController,
                curve: Interval(0.3, 1.0, curve: Curves.easeOutBack)))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener(_setOptionsStatus);
  }


  _getEntry() async {
    final entryViewModel = Provider.of<EntryViewModel>(context);
    if (this._entryViewModel == entryViewModel) {
      return;
    }
    this._entryViewModel = entryViewModel;
    final id = ModalRoute.of(context).settings.arguments;
    final success = await this._entryViewModel.getEntry(id);
    if (!success && Navigator.of(context).canPop()) {
      return Navigator.of(context).pop();
    }
        setState(() {
      _isLocked = this._entryViewModel.currentEntry.isLocked;
    });
  }

  _deleteEntry() async {
    onYes() async {
      final id = ModalRoute.of(context).settings.arguments;
      await this._entryViewModel.deleteEntry(id);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(Home.routeName);
      }
    }

    _dialogService.showQuestionDialog(
        title: "Are you sure?",
        content: "Deleting an entry is irreversible",
        onYes: onYes,
        onNo: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EntryViewModel>(builder: (context, model, child) {
        if (model.getStatus() == ViewStatus.LOADING) {
          return AirnoteLoadingScreen();
        }
        final entry = model.currentEntry;
        if (entry == null) {
          return AirnoteLoadingScreen();
        }
        final heroTag = "entry-image-${entry.id}";
        return Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: 300,
                  child: Stack(
                    children: <Widget>[
                      _EntryHeader(
                        heroTag: heroTag,
                        imageUrl: entry.imageUrl,
                      ),
                      Positioned(
                        top: 200,
                        child: _EntryTitle(
                          title: entry.title,
                          date: entry.createdAt,
                          isLocked: _isLocked,
                        ),
                      ),
                      Positioned(
                        top: 250,
                        child: _Sentiments(
                          sentiments: entry.sentiments,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 150),
                  color: AirnoteColors.backgroundColor,
                  child: Text(
                    entry.content,
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        color: AirnoteColors.text.withOpacity(0.8)),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AirnoteCircularButton(
                        icon: Icon(Icons.arrow_downward,
                            color: AirnoteColors.primary),
                        onTap: _onCloseEntryTap,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AirnoteCircularButton(
                            icon: _getOptionButtonIcon(),
                            onTap: _onOptionsTap,
                          ),
                          Transform.translate(
                              offset: _lockButtonAnimation.value,
                              child: AirnoteCircularButton(
                                icon: Icon(
                                  _isLocked ? Icons.lock_open : Icons.lock_outline,
                                  color: AirnoteColors.primary,
                                ),
                                onTap: () async {
                                  await this._entryViewModel.updateIsLocked(entry.id, !_isLocked);
                                  setState(() {
                                    _isLocked = !_isLocked;
                                  });
                                },
                              )),
                          Transform.translate(
                              offset: _deleteButtonAnimation.value,
                              child: AirnoteCircularButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: AirnoteColors.danger,
                                ),
                                onTap: () async {
                                  await _deleteEntry();
                                },
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: AirnoteAudioPlayer(
                audioUrl: entry.audioUrl,
              ),
            )
          ],
        );
      }),
    );
  }

  @override
  void dispose() async {
    _optionsAnimationController.dispose();
    super.dispose();
  }

  void _setOptionsStatus(AnimationStatus status) {
    setState(() {
      _isOptionOpened = status == AnimationStatus.forward ||
          status == AnimationStatus.completed;
    });
  }

  void _openOptions() {
    _optionsAnimationController.forward();
  }

  void _closeOptions() {
    _optionsAnimationController.reverse();
  }

  void _onCloseEntryTap() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _onOptionsTap() {
    _isOptionOpened ? _closeOptions() : _openOptions();
  }

  Icon _getOptionButtonIcon() {
    if (_isOptionOpened) {
      return Icon(
        Icons.close,
        color: AirnoteColors.primary,
      );
    }
    return Icon(
      Icons.more_horiz,
      color: AirnoteColors.primary,
    );
  }
}

class _Sentiments extends StatelessWidget {
  final List<Sentiment> sentiments;

  _Sentiments({Key key, this.sentiments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> w = sentiments
        .map((sentiment) => _SentimentItem(
              sentiment: sentiment,
            ))
        .toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: w,
      ),
    );
  }
}

class _SentimentItem extends StatelessWidget {
  final Sentiment sentiment;
  _SentimentItem({Key key, this.sentiment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Text(sentiment.emoji,
            style: TextStyle(
              fontSize: 30,
            )));
  }
}

class _EntryTitle extends StatelessWidget {
  final String title;
  final String date;
  final bool isLocked;

  _EntryTitle({Key key, this.title, this.date, this.isLocked}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(date);
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(dateTime);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: AirnoteColors.text,
                    fontSize: 24,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isLocked ? Icon(
                  Icons.lock_outline,
                  size: 24,
                  color: AirnoteColors.primary.withOpacity(0.7),
                ) : Container(),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.event_note,
                size: 18,
                color: AirnoteColors.grey.withOpacity(0.7),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  dateString,
                  style: TextStyle(
                    color: AirnoteColors.grey.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryHeaderImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;

  _EntryHeaderImage({Key key, this.heroTag, this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Stack(
        children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.cover)),
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AirnoteColors.backgroundColor.withOpacity(0.0),
                AirnoteColors.backgroundColor
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryHeader extends StatelessWidget {
  final String heroTag;
  final String imageUrl;

  _EntryHeader({Key key, this.imageUrl, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _EntryHeaderImage(
        heroTag: heroTag,
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _EntryHeaderImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
      errorWidget: (context, url, error) => _EntryHeaderImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
    );
  }
}
