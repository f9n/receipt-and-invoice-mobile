import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receiptocr/src/views/detail_view.dart';
import 'package:receiptocr/src/views/edit_view.dart';

import '../controllers/gs.dart';
import '../controllers/helper.dart';
import '../models/recin.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  List<RecIn>? receipts;
  List<RecIn>? invoices;
  int tabIndex = 0;

  hydrate() async {
    receipts = await gs.fetch('receipts');
    invoices = await gs.fetch('invoices');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  refresh() async {
    if (tabIndex == 0) {
      setState(() => receipts = null);
      receipts = await gs.fetch('receipts');
    } else {
      setState(() => invoices = null);
      invoices = await gs.fetch('invoices');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    gs.getCategories();
    super.initState();
    hydrate();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffd1dce0),
        appBar: AppBar(
          backgroundColor: tabIndex == 0 ? Colors.blue : Colors.purple,
          title: TabBar(
            onTap: (int index) {
              if (mounted) {
                setState(() {
                  tabIndex = index;
                });
              }
            },
            tabs: const [
              Tab(icon: Icon(Icons.receipt), text: 'Receipts'),
              Tab(icon: Icon(Icons.receipt_long), text: 'Invoices'),
            ],
          ),
          //title: const Text(''),
        ),
        body: TabBarView(
          children: [
            list(receipts),
            list(invoices),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: tabIndex == 0 ? Colors.blue : Colors.purple,
          onPressed: onTapAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget list(List<RecIn>? items) {
    if (items == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await refresh();
        return;
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.only(top: 5),
        children: items.map((e) => tile(e)).toList(),
      ),
    );
  }

  Widget tile(e) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (_) async {
          onDismissed(e);
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: ListTile(
            title: Text(
              e.firm,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              e.date,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${e.totalamount}₺',
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'kdv: ${e.totalkdv}₺',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              navTo(context, DetailView(recIn: e));
            },
          ),
        ),
      ),
    );
  }

  onDismissed(e) async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to remove this!'),
          actions: [
            TextButton(
              onPressed: () {
                return Navigator.of(context).pop(true);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (res) {
      await gs.remove(e.id, slug());
      refresh();
    }
  }

  String slug() => tabIndex == 0 ? 'receipt' : 'invoice';

  onTapAdd() async {
    String? imagePath;
    try {
      imagePath = await EdgeDetection.detectEdge;
    } on PlatformException catch (e) {
      log(e.message);
    }
    if (imagePath != null) {
      if (mounted) {
        setState(() {
          showDialog(
            context: context,
            builder: (context) {
              return const Material(
                color: Colors.transparent,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        });
      }
      final RecIn? res = await gs.ocr(imagePath, slug());
      if (!mounted) return;
      Navigator.pop(context);
      if (res != null) {
        final Map? payload = await navTo(context, EditView(recIn: res));
        if (payload == null) {
          return;
        }
        payload.remove('Metadata');
        payload.remove('_id');
        await gs.add(payload, slug());
        refresh();
      }
    }
  }
}
