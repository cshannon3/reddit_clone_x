


import 'package:flutter/material.dart';
import 'package:reddit_clone_x/Components/menu_items_expansion_tile.dart';
import 'package:reddit_clone_x/Controllers/reddit_controller.dart';
import 'package:reddit_clone_x/widget_utils.dart';

class MenuDrawer extends Drawer {
  final RedditController redditController;

  MenuDrawer(this.redditController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print("J");
              },
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '_fuzz_',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        )
                      ],
                    )),
              ),
            ),
            MenuItemsExpansionTile(
              backgroundColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
              },
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.person,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('My profile'),
              children: <Widget>[
                ListTile(
                  title: Text('Saved'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Comments'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Submitted'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Mail'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.subdirectory_arrow_right,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Go to'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.bug_report,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Report bug'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              ),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: Text('Multireddits'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              title: TextField(
                decoration: InputDecoration(
                  hintText: "Subreddit or domain",
                ),
              ),
              trailing: Icon(Icons.create),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ]..addAll(
            List.generate(redditController.subscribedSubreddits.length, (index) {
              return ListTile(
                title: Text(redditController.subscribedSubreddits[index]),
                onTap: () {
                  Navigator.pop(context);
                },
              );
            }),
          )),
    );
  }
}