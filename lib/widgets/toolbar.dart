import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum DrawTool { pen, eraser }

/// Büyük ikonlu, az yazılı araç çubuğu.
/// PRD: "Hepsi büyük ikonlarla gösterilir. Yazı minimum seviyededir."
class WonderToolbar extends StatelessWidget {
  const WonderToolbar({
    super.key,
    required this.activeTool,
    required this.activeColor,
    required this.canUndo,
    required this.canRedo,
    required this.onToolChanged,
    required this.onColorChanged,
    required this.onUndo,
    required this.onRedo,
    required this.onClear,
  });

  final DrawTool activeTool;
  final Color activeColor;
  final bool canUndo;
  final bool canRedo;
  final ValueChanged<DrawTool> onToolChanged;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(WonderRadii.sheet),
        boxShadow: const [
          BoxShadow(color: WonderColors.softShadow, blurRadius: 16, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Renk paleti — kaydırılabilir, büyük dokunma alanları.
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: WonderColors.brushPalette.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final color = WonderColors.brushPalette[index];
                final isSelected = color == activeColor;
                return GestureDetector(
                  onTap: () => onColorChanged(color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: isSelected ? 44 : 36,
                    height: isSelected ? 44 : 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [const BoxShadow(color: WonderColors.softShadow, blurRadius: 8)]
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Araçlar.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ToolButton(
                icon: Icons.edit_rounded,
                selected: activeTool == DrawTool.pen,
                onTap: () => onToolChanged(DrawTool.pen),
              ),
              _ToolButton(
                icon: Icons.cleaning_services_rounded,
                selected: activeTool == DrawTool.eraser,
                onTap: () => onToolChanged(DrawTool.eraser),
              ),
              _ToolButton(
                icon: Icons.undo_rounded,
                selected: false,
                enabled: canUndo,
                onTap: onUndo,
              ),
              _ToolButton(
                icon: Icons.redo_rounded,
                selected: false,
                enabled: canRedo,
                onTap: onRedo,
              ),
              _ToolButton(
                icon: Icons.refresh_rounded,
                selected: false,
                onTap: onClear,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.3,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: selected ? WonderColors.sunYellow.withOpacity(0.3) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: WonderColors.ink),
        ),
      ),
    );
  }
}
