import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animation/motion_curves.dart';
import '../animation/reaction_picker.dart';
import '../animation/reaction_queue.dart';
import '../audio/sound_service.dart';
import '../models/drawing.dart';
import '../models/reaction.dart';
import '../models/wonder_object.dart';
import '../models/wonder_object_behavior.dart';
import '../models/wonder_object_registry.dart';
import '../widgets/particle_overlay.dart';

class AnimatedWonderObject extends StatefulWidget {
  const AnimatedWonderObject({
    super.key,
    required this.drawing,
    required this.objectType,
    this.soundService = const SilentSoundService(),
  });

  final Drawing drawing;
  final WonderObjectType objectType;
  final SoundService soundService;

  @override
  State<AnimatedWonderObject> createState() => _AnimatedWonderObjectState();
}

class _AnimatedWonderObjectState extends State<AnimatedWonderObject>
    with TickerProviderStateMixin {
  late final WonderObjectBehavior behavior =
      WonderObjectRegistry.behaviorFor(widget.objectType);

  late final AnimationController _idleController;
  late final AnimationController _reactionController;
  late final ReactionPicker _picker =
      ReactionPicker(behavior.touchReactions);
  late final ReactionQueue _queue =
      ReactionQueue(onPlay: _playReaction);

  ReactionSpec? _activeReaction;

  @override
  void initState() {
    super.initState();

    _idleController = AnimationController(
      vsync: this,
      duration: behavior.idleAnimation.duration,
    )..repeat(reverse: behavior.idleAnimation.reverses);

    _reactionController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _idleController.dispose();
    _reactionController.dispose();
    _queue.dispose();
    super.dispose();
  }

  void _onTap() {
    _queue.enqueue(_picker.next());
  }

  Future<void> _playReaction(ReactionSpec reaction) async {
    if (!mounted) return;

    setState(() {
      _activeReaction = reaction;
    });

    HapticFeedback.selectionClick();
    widget.soundService.play(reaction.sound);

    _reactionController.duration = reaction.duration;

    await _reactionController.forward(from: 0);

    if (!mounted) return;

    setState(() {
      _activeReaction = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bbox = widget.drawing.boundingBox;

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _idleController,
          _reactionController,
        ]),
        builder: (context, child) {
          final reaction = _activeReaction;

          final frame = reaction != null
              ? motionFrameFor(
                  reaction.kind,
                  easingFor(reaction.kind).transform(
                    _reactionController.value,
                  ),
                )
              : motionFrameFor(
                  behavior.idleAnimation.motion,
                  _idleController.value,
                );

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.translate(
                offset: frame.offset,
                child: Transform.rotate(
                  angle: frame.rotation,
                  alignment: Alignment.center,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(
                        frame.effectiveScaleX,
                        frame.effectiveScaleY,
                      ),
                    child: child,
                  ),
                ),
              ),
              if (frame.particle != null && !bbox.isEmpty)
                Positioned.fromRect(
                  rect: bbox.inflate(60),
                  child: ParticleOverlay(
                    progress: _reactionController.value,
                    shape: frame.particle!.shape,
                    color: frame.particle!.color,
                    fallsDown: frame.particle!.fallsDown,
                    count: frame.particle!.count,
                  ),
                ),
            ],
          );
        },
        child: CustomPaint(
          painter: _StaticDrawingPainter(widget.drawing),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _StaticDrawingPainter extends CustomPainter {
  _StaticDrawingPainter(this.drawing);

  final Drawing drawing;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in drawing.strokes) {
      if (stroke.points.length < 2) {
        if (stroke.points.isNotEmpty) {
          canvas.drawCircle(
            stroke.points.first,
            stroke.strokeWidth / 2,
            Paint()..color = stroke.color,
          );
        }
        continue;
      }

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path()
        ..moveTo(
          stroke.points.first.dx,
          stroke.points.first.dy,
        );

      for (final point in stroke.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(
    covariant _StaticDrawingPainter oldDelegate,
  ) {
    return false;
  }
}
