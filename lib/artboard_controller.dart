import 'dart:math';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/actor_node_solo.dart';

class ArtboardController extends FlareController {
  FlutterActorArtboard _artboard;
  String _animationName;
  double _mixSeconds = 0.1;
  List<FlareAnimationLayer> _animationLayers = [];

  ActorAnimation _inAnimation;
  //double _mixAmount = 1.0;
  double _speed = 1.0;
  double _mixTime = 0.0;


  void initialize(FlutterActorArtboard artboard) {

    _artboard = artboard;

    _inAnimation = artboard.getAnimation("In");

    play("K_In");

  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }

  ///when an animation is complete, this is called
  void onCompleted(String name) {
    if(name.compareTo("K_In") == 0){
      //go to waiting animation
      play("K_Waiting");

    }
    if(name.compareTo(_inAnimation.name) == 0){
      //reset to other Animation, we don't want to mix anything here!
      play("K_In", mix: 0);
    }
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {

    int lastFullyMixed = -1;
    double lastMix = 0.0;

    List<FlareAnimationLayer> completed = [];

    for (int i = 0; i < _animationLayers.length; i++) {
      FlareAnimationLayer layer = _animationLayers[i];
      layer.mix += elapsed;
      layer.time += elapsed;

      lastMix = (_mixSeconds == null || _mixSeconds == 0.0)
          ? 1.0
          : min(1.0, layer.mix / _mixSeconds);

      if (layer.animation.isLooping) {
        layer.time %= layer.animation.duration;
      }

      _mixTime += elapsed * _speed;

      layer.animation.apply(layer.time, _artboard, lastMix);

      if (lastMix == 1.0) {
        lastFullyMixed = i;
      }

      if (layer.time > layer.animation.duration) {
        completed.add(layer);
      }
    }

    if (lastFullyMixed != -1) {
      _animationLayers.removeRange(0, lastFullyMixed);
    }
    if (_animationName == null &&
        _animationLayers.length == 1 &&
        lastMix == 1.0) {
      _animationLayers.removeAt(0);

    }

    for (FlareAnimationLayer animation in completed) {
      _animationLayers.remove(animation);
      onCompleted(animation.name);
    }
    return _animationLayers.isNotEmpty;
  }

  ///use this for changing which Solo Node is active
  void setSolo(String soloName, int index) {
    ActorNodeSolo solo = _artboard.getNode(soloName) as ActorNodeSolo;
    solo.setActiveChildIndex(index);
  }

  ///use this to play animations, with mix options
  void play(String name,{double mix = 1.0, double mixSeconds = 0.2}) {
    _animationName = name;
    if (_animationName != null && _artboard != null) {
      ActorAnimation animation = _artboard.getAnimation(_animationName);
      if (animation != null) {

        _animationLayers.add(FlareAnimationLayer()
          ..name = _animationName
          ..animation = animation
          ..mix = mix
          ..mixSeconds = mixSeconds);
        isActive.value = true;
      }
    }
  }


}
