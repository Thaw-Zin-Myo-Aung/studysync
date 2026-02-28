import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AnimatedGroupCard extends StatefulWidget {
  final String groupName;
  final String course;
  final String nextSession;
  final List<String> members;
  final VoidCallback onOpenGroup;

  const AnimatedGroupCard({
    super.key,
    required this.groupName,
    required this.course,
    required this.nextSession,
    required this.members,
    required this.onOpenGroup,
  });

  @override
  State<AnimatedGroupCard> createState() => _AnimatedGroupCardState();
}

class _AnimatedGroupCardState extends State<AnimatedGroupCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;
  late final Animation<double> _opacity;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF0077B6),
                    radius: 20,
                    child: Icon(LucideIcons.users, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.groupName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.course,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: const Icon(LucideIcons.chevronDown, size: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          // Animated dropdown body
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => Align(
                heightFactor: _heightFactor.value,
                child: FadeTransition(opacity: _opacity, child: child),
              ),
              child: Column(
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Next session
                        Row(
                          children: [
                            const Icon(LucideIcons.clock, size: 15, color: Color(0xFF0077B6)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.nextSession,
                                style: const TextStyle(fontSize: 13, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Member chips
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.members.map((m) => Chip(
                            label: Text(m, style: const TextStyle(fontSize: 12)),
                            backgroundColor: const Color(0xFFE0F2FE),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                        const SizedBox(height: 14),
                        // Open Group button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onOpenGroup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0077B6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Open Group'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

