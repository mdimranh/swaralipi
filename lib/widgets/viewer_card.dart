import 'package:flutter/material.dart';

class ViewCard extends StatelessWidget {
  bool showEmpty;
  bool isLoading = false;
  final IconData? emptyIcon;
  final String emptytitle;
  final String? emptyMessage;
  final ViewCardHeader header;
  final Widget body;
  ViewCard({
    super.key,
    this.showEmpty = false,
    required this.header,
    required this.body,
    this.emptyIcon,
    this.emptytitle = "No Data",
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withAlpha(50),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            header,
            const SizedBox(height: 15),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : showEmpty
                  ? Center(
                      child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          emptyIcon != null
                              ? Icon(emptyIcon, color: Colors.white, size: 70)
                              : Container(),
                          const SizedBox(height: 10),
                          Text(
                            emptytitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            emptyMessage ?? "",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : body,
            ),
          ],
        ),
      ),
    );
  }
}

class ViewCardAction {
  final IconData icon;
  final VoidCallback onPressed;

  ViewCardAction({required this.icon, required this.onPressed});
}

class ViewCardHeader extends StatelessWidget {
  final IconData sortIcon;
  final String sortTitle;
  final List<ViewCardAction> actions;

  const ViewCardHeader({
    super.key,
    this.sortIcon = Icons.sort_sharp,
    this.sortTitle = "Name",
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(sortIcon, color: Colors.white.withAlpha(180)),
            const SizedBox(width: 3),
            Text(
              sortTitle,
              style: TextStyle(color: Colors.white.withAlpha(180)),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          children: actions
              .map(
                (action) => GestureDetector(
                  onTap: action.onPressed,
                  child: _circleIcon(action.icon),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(100),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white.withAlpha(180)),
    );
  }
}
