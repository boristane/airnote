import 'package:airnote/components/audio-player.dart';
import 'package:airnote/components/badge.dart';
import 'package:airnote/components/forward-button.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/models/entry.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:airnote/services/dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  final _snackBarService = locator<SnackBarService>();

  bool _isOptionOpened = false;
  bool _isLocked = false;
  bool _hasPlayer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getEntry();
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
    final userViewModel = Provider.of<UserViewModel>(context);
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
    final email = userViewModel.user.email;
    final encryptionKey = userViewModel.user.encryptionKey;
    await this._entryViewModel.getRecording(id,
        this._entryViewModel.currentEntry.isEncrypted, email, encryptionKey);
    setState(() {
      _hasPlayer = _entryViewModel.currentEntryRecording == "" ? false : true;
    });
  }

  _deleteEntry() async {
    onYes() async {
      final id = ModalRoute.of(context).settings.arguments;
      await this._entryViewModel.deleteEntry(id);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Home.routeName, (Route<dynamic> route) => false,
            arguments: 1);
      }
    }

    await _dialogService.showQuestionDialog(
        title: AirnoteMessage.areYouSure,
        content: AirnoteMessage.entryDeleteDialog,
        onYes: onYes,
        onNo: _closeOptions);
  }

  _lockEntry() async {
    final id = ModalRoute.of(context).settings.arguments;
    await this._entryViewModel.updateIsLocked(id, !_isLocked);
    _snackBarService.showSnackBar(icon: Icon(Icons.lock), text: "Entry locked");
    setState(() {
      _isLocked = !_isLocked;
    });
    _closeOptions();
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(16.0),
    topRight: Radius.circular(16.0),
  );

  @override
  Widget build(BuildContext context) {
    double panelHeightOpen = MediaQuery.of(context).size.height * .80;
    double panelHeightClosed = 35.0;
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .3,
        panelBuilder: (sc) =>
            Consumer<EntryViewModel>(builder: (context, model, child) {
          return _AirnoteEntryPanel(
            entry: model.currentEntry,
            scrollController: sc,
          );
        }),
        color: AirnoteColors.backgroundColor,
        borderRadius: radius,
        body: Container(
          child: Consumer<EntryViewModel>(builder: (context, model, child) {
            if (model.getStatus() == ViewStatus.LOADING) {
              return AirnoteLoadingScreen();
            }
            final entry = model.currentEntry;
            if (entry == null) {
              return AirnoteLoadingScreen();
            }
            final localRecordingFilePath = model.currentEntryRecording;
            final heroTag = "entry-image-${entry.id}";
            return Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          EntryHeader(
                            heroTag: heroTag,
                            imageUrl: entry.imageUrl,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 230),
                            alignment: Alignment.center,
                            child: _EntryDate(
                              date: entry.createdAt,
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 250, left: 15, right: 15),
                            alignment: Alignment.center,
                            child: _EntryTitle(
                              title: entry.title,
                              isLocked: _isLocked,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: entry.quest != null
                                ? Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: AirnoteBadge(
                                      text: "Quest",
                                      isDark: true,
                                    ),
                                  )
                                : Container(),
                          ),
                          _buildEntryOptions(),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildAudioPlayer(localRecordingFilePath, entry),
                ),
                SizedBox(height: panelHeightClosed),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAudioPlayer(String localRecordingFilePath, Entry entry) {
    if (_hasPlayer) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: AirnoteAudioPlayer(
          audioFilePath: localRecordingFilePath,
          backgroundMusicPath: entry.backgroundMusic,
          duration: entry.duration,
        ),
      );
    }
    return AirnoteLoadingScreen();
  }

  Align _buildEntryOptions() {
    return Align(
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AirnoteOptionButton(
                icon: Icon(Icons.arrow_downward, color: AirnoteColors.primary),
                onTap: _onCloseEntryTap,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AirnoteOptionButton(
                    icon: _getOptionButtonIcon(),
                    onTap: _onOptionsTap,
                  ),
                  Transform.translate(
                      offset: _lockButtonAnimation.value,
                      child: AirnoteOptionButton(
                        icon: Icon(
                          _isLocked ? Icons.lock_open : Icons.lock_outline,
                          color: AirnoteColors.primary,
                        ),
                        onTap: _lockEntry,
                      )),
                  Transform.translate(
                      offset: _deleteButtonAnimation.value,
                      child: AirnoteOptionButton(
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
      Navigator.of(context).pushNamedAndRemoveUntil(
          Home.routeName, (Route<dynamic> route) => false,
          arguments: 1);
    }
  }

  void _onOptionsTap() {
    _isOptionOpened ? _closeOptions() : _openOptions();
  }

  Icon _getOptionButtonIcon() {
    return Icon(
      _isOptionOpened ? Icons.close : Icons.more_horiz,
      color: AirnoteColors.primary,
    );
  }
}

class _EntryDate extends StatelessWidget {
  final String date;
  _EntryDate({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(date);
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(dateTime);
    return Text(
      dateString,
      style: TextStyle(
        color: AirnoteColors.grey,
        fontSize: 14,
      ),
    );
  }
}

class _EntryTitle extends StatelessWidget {
  final String title;
  final bool isLocked;

  _EntryTitle({Key key, this.title, this.isLocked}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AirnoteColors.grey,
            letterSpacing: 1.0,
          ),
        ),
        Padding(
          padding: isLocked
              ? EdgeInsets.symmetric(horizontal: 8.0)
              : EdgeInsets.zero,
          child: isLocked
              ? Icon(
                  Icons.lock_outline,
                  size: 24,
                  color: AirnoteColors.grey.withOpacity(0.7),
                )
              : Container(),
        ),
      ],
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
            height: 299,
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

class EntryHeader extends StatelessWidget {
  final String heroTag;
  final String imageUrl;

  EntryHeader({Key key, this.imageUrl, this.heroTag}) : super(key: key);
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
        imageProvider: AssetImage("assets/placeholder.png"),
      ),
      errorWidget: (context, url, error) => _EntryHeaderImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.png"),
      ),
    );
  }
}

class _AirnoteEntryPanel extends StatelessWidget {
  final Entry entry;
  final ScrollController scrollController;
  _AirnoteEntryPanel({Key key, this.entry, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return AirnoteLoadingScreen();
    }
    final content = entry.content;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: scrollController,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: AirnoteColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Transcript",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: content == null
                  ? Center(
                      child: Text("There are no transcripts for this entry"),
                    )
                  : Text(
                      content,
                      softWrap: true,
                    ),
            ),
          ],
        ));
  }
}
