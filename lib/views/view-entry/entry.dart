import 'package:airnote/components/audio-player.dart';
import 'package:airnote/components/badge.dart';
import 'package:airnote/components/formated-date.dart';
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
import 'package:airnote/views/view-entry/entry-panel.dart';
import 'package:airnote/views/view-entry/entry-title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    final uuid = userViewModel.user.uuid;
    final encryptionKey = userViewModel.user.encryptionKey;
    final isEncrypted = this._entryViewModel.currentEntry.recording.isEncrypted;
    await this
        ._entryViewModel
        .getRecording(id, isEncrypted, uuid, encryptionKey);
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
    if (_isLocked) {
      _snackBarService.showSnackBar(
          icon: Icon(Icons.lock_open), text: "Entry unlocked");
    } else {
      _snackBarService.showSnackBar(
          icon: Icon(Icons.lock), text: "Entry locked");
    }
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
    double panelHeightClosed = 40.0;
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: panelHeightOpen,
        minHeight: panelHeightClosed,
        parallaxEnabled: true,
        parallaxOffset: .3,
        panelBuilder: (sc) =>
            Consumer<EntryViewModel>(builder: (context, model, child) {
          return AirnoteEntryPanel(
            entry: model.currentEntry,
            scrollController: sc,
          );
        }),
        onPanelOpened: () async {
          final model = this._entryViewModel;
          final transcript = model.currentEntry.transcript;
          if (!transcript.isTranscriptionSubmitted &&
              !transcript.isTranscribed) {
            final localRecordingFilePath = model.currentEntryRecording;
            final id = model.currentEntry.id;
            await model.savePlainAudio(localRecordingFilePath);
            await model.updateOneNote(id, null, null, true);
            await model.getEntry(id);
          }
        },
        color: AirnoteColors.backgroundColor,
        borderRadius: radius,
        body: Container(
          child: Consumer<EntryViewModel>(builder: (context, model, child) {
            final entry = model.currentEntry;
            final isLoading = model.getStatus() == ViewStatus.LOADING || entry == null;
            final localRecordingFilePath = model.currentEntryRecording;
            return isLoading ? AirnoteLoadingScreen() : Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        EntryHeader(
                          heroTag: "entry-image-${entry.id}",
                          imageUrl: entry.imageUrl,
                        ),
                        Positioned(
                          bottom: 25,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: EntryDate(
                                    date: entry.created,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: EntryTitle(
                                    title: entry.title,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _buildEntryOptions(),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _isLocked
                          ? Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(
                                Icons.lock_outline,
                                size: 24,
                                color: AirnoteColors.grey.withOpacity(0.7),
                              ),
                            )
                          : Container(),
                      entry.questId != null
                          ? Container(
                              padding: EdgeInsets.only(left: 15),
                              child: AirnoteBadge(
                                text: "Quest",
                                isDark: true,
                              ),
                            )
                          : Container(),
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
        padding: const EdgeInsets.only(top: 40.0),
        child: AirnoteAudioPlayer(
          audioFilePath: localRecordingFilePath,
          backgroundMusicPath: entry.backgroundMusic,
          duration: entry.recording.duration,
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
        imageProvider: AssetImage("assets/images/placeholder.png"),
      ),
      errorWidget: (context, url, error) => _EntryHeaderImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/images/placeholder.png"),
      ),
    );
  }
}
