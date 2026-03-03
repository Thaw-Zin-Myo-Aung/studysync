import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DiscussionPostCard extends StatefulWidget {
  final String authorName;
  final String timeAgo;
  final String postTitle;
  final String postBody;
  final int replyCount;
  final int likeCount;
  final bool isLiked;
  final VoidCallback? onTap; // opens thread
  final VoidCallback? onLike; // toggles like
  final VoidCallback? onShowLikers; // tapping the like count

  const DiscussionPostCard({
    super.key,
    required this.authorName,
    required this.timeAgo,
    required this.postTitle,
    required this.postBody,
    required this.replyCount,
    this.likeCount = 0,
    this.isLiked = false,
    this.onTap,
    this.onLike,
    this.onShowLikers,
  });

  @override
  State<DiscussionPostCard> createState() => _DiscussionPostCardState();
}

class _DiscussionPostCardState extends State<DiscussionPostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartCtrl;
  late Animation<double> _heartScale;
  late bool _liked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _liked = widget.isLiked;
    _likeCount = widget.likeCount;
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _heartScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(DiscussionPostCard old) {
    super.didUpdateWidget(old);
    _liked = widget.isLiked;
    _likeCount = widget.likeCount;
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
    _heartCtrl.forward(from: 0);
    widget.onLike?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Card body tap → open thread
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.fromBorderSide(BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(LucideIcons.user, color: Color(0xFF94A3B8), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.authorName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      Text(widget.timeAgo,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
                const Icon(LucideIcons.ellipsis,
                    color: Color(0xFFCBD5E1), size: 20),
              ],
            ),
            const SizedBox(height: 12),
            // ── Title & body ──
            Text(widget.postTitle,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 8),
            Text(
              widget.postBody,
              style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            // ── Action row — absorbs its own taps, never propagates to card ──
            Row(
              children: [
                // Heart button
                _ActionButton(
                  onTap: _handleLike,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _heartScale,
                        child: Icon(
                          LucideIcons.heart,
                          size: 18,
                          color: _liked
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _likeCount > 0 ? '$_likeCount' : 'Like',
                        style: TextStyle(
                            fontSize: 13,
                            color: _liked
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                // Like count chip (tap → who liked)
                if (_likeCount > 0)
                  _ActionButton(
                    onTap: widget.onShowLikers,
                    child: Text(
                      'See likes',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                const Spacer(),
                // Reply count
                _ActionButton(
                  onTap: widget.onTap, // also opens thread
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.messageCircle,
                          size: 18, color: Color(0xFF94A3B8)),
                      const SizedBox(width: 4),
                      Text('${widget.replyCount}',
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A tap target that absorbs the tap so it never bubbles to the parent card.
class _ActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _ActionButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Opaque + stop propagation — tap is consumed here, NOT by the parent card
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: child,
      ),
    );
  }
}
