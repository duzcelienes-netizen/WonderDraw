import 'package:flutter/material.dart';
import '../models/wonder_object.dart';
import '../theme/app_theme.dart';

/// "Hadi birlikte bakalım 😊" ekranı.
/// Sınav hissi vermemesi için: resmi soru cümlesi yok, büyük renkli ikonlar
/// tek tek zıplayarak sahneye giriyor, seçim anında yargı yok.
class ObjectSelectionScreen extends StatefulWidget {
  const ObjectSelectionScreen({super.key, required this.onSelected});

  final ValueChanged<WonderObjectType> onSelected;

  @override
  State<ObjectSelectionScreen> createState() => _ObjectSelectionScreenState();
}

class _ObjectSelectionScreenState extends State<ObjectSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    // M1'de sadece animasyonu hazır 3 nesne öne çıkar; tüm katalog da
    // gösterilir ama henüz animasyonu olmayanlar nazikçe "yakında" der.
    final items = wonderObjectCatalog;

    return Scaffold(
      backgroundColor: WonderColors.canvasBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                'Hadi birlikte bakalım 😊',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Bu ne olabilir?',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _StaggeredBounceIn(
                      delay: Duration(milliseconds: 60 * index),
                      child: _ObjectTile(
                        object: item,
                        onTap: () => widget.onSelected(item.type),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ObjectTile extends StatelessWidget {
  const _ObjectTile({required this.object, required this.onTap});

  final WonderObject object;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WonderRadii.card),
          boxShadow: const [
            BoxShadow(color: WonderColors.softShadow, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(object.emoji, style: const TextStyle(fontSize: 34)),
      ),
    );
  }
}

/// Her ikonun sahneye kendi kendine, sırayla, hafif zıplayarak girmesi.
/// "Çocuk butonu aramaz, buton çocuğu bulur" ilkesinin ikon versiyonu.
class _StaggeredBounceIn extends StatefulWidget {
  const _StaggeredBounceIn({required this.child, required this.delay});

  final Widget child;
  final Duration delay;

  @override
  State<_StaggeredBounceIn> createState() => _StaggeredBounceInState();
}

class _StaggeredBounceInState extends State<_StaggeredBounceIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
