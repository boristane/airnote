import 'package:airnote/components/circular-button.dart';
import 'package:airnote/components/circular-button.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/note.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class NoteView extends StatefulWidget {
  static const routeName = 'view-entry';
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView>
    with SingleTickerProviderStateMixin {
  NoteViewModel _noteViewModel;
  AnimationController _optionsAnimationController;
  Animation<Offset> _optionsAnimation, _optionsDelayedAnimation;

  bool _isOptionOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getNote();
    });
    _optionsAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _optionsAnimation = Tween<Offset>(begin: Offset(100, 0), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _optionsAnimationController, curve: Curves.easeOutBack))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener(_setOptionsStatus);
  }

  _getNote() async {
    final noteViewModel = Provider.of<NoteViewModel>(context);
    if (this._noteViewModel == noteViewModel) {
      return;
    }
    this._noteViewModel = noteViewModel;
    final id = ModalRoute.of(context).settings.arguments;
    await this._noteViewModel.getCurrentNote(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NoteViewModel>(builder: (context, model, child) {
        if (model.getStatus() == ViewStatus.LOADING) {
          return AirnoteLoadingScreen();
        }
        final note = model.currentNote;
        if (note == null) {
          return AirnoteLoadingScreen();
        }
        final heroTag = "note-image-${note.id}";
        return Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    _NoteHeader(
                      heroTag: heroTag,
                      imageUrl: note.imageUrl,
                    ),
                    Positioned(
                      top: 200,
                      child: _NoteTitle(title: note.title),
                    ),
                    Positioned(
                      top: 330.0,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                topLeft: Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: AirnoteColors.primary.withOpacity(.4),
                                offset: Offset(0.0, -8),
                                blurRadius: 6,
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
                  child: Text(
                    note.content,
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
                        onTap: _onCloseNoteTap,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AirnoteCircularButton(
                            icon: _getOptionButtonIcon(),
                            onTap: _onOptionsTap,
                          ),
                          Transform.translate(
                              offset: _optionsAnimation.value,
                              child: AirnoteCircularButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: AirnoteColors.primary,
                                ),
                                onTap: () {
                                  print("Editing");
                                },
                              )),
                          Transform.translate(
                              offset: _optionsAnimation.value,
                              child: AirnoteCircularButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: AirnoteColors.danger,
                                ),
                                onTap: () {
                                  print("Deleting");
                                },
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
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

  void _onCloseNoteTap() {
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

class _NoteTitle extends StatelessWidget {
  final String title;

  _NoteTitle({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: TextStyle(
            color: AirnoteColors.white,
            fontSize: 24,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _NoteHeaderImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;

  _NoteHeaderImage({Key key, this.heroTag, this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageProvider,
      child: Container(
        height: 340,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AirnoteColors.grey,
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    AirnoteColors.primary, BlendMode.lighten))),
      ),
    );
  }
}

class _NoteHeader extends StatelessWidget {
  final String heroTag;
  final String imageUrl;

  _NoteHeader({Key key, this.imageUrl, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _NoteHeaderImage(
        heroTag: heroTag,
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _NoteHeaderImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
      errorWidget: (context, url, error) => _NoteHeaderImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
    );
  }
}
