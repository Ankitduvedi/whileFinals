import 'dart:developer';
import 'package:flutter/material.dart';
import '../message/apis.dart';
import '../message/helper/dialogs.dart';
import '../message/models/community_user.dart';
import 'community_user_card.dart';

//home screen -- where all available contacts are shown
class CommunityScreenFinal extends StatefulWidget {
  const CommunityScreenFinal(
      {super.key, required this.isSearching, required this.value});
  final bool isSearching;
  final String value;

  @override
  State<CommunityScreenFinal> createState() => _CommunityScreenFinalState();
}

class _CommunityScreenFinalState extends State<CommunityScreenFinal> {
  // for storing all users

  // for storing searched items

  // for storing search status
  List<CommunityUser> _list = [];
  final List<CommunityUser> _searchList = [];
  @override
  void initState() {
    super.initState();
    // APIs.getSelfInfo();

    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    // SystemChannels.lifecycle.setMessageHandler((message) {
    //   log('Message: $message');

    //   if (APIs.auth.currentUser != null) {
    //     if (message.toString().contains('resume')) {
    //       APIs.updateActiveStatus(true);
    //     }
    //     if (message.toString().contains('pause')) {
    //       APIs.updateActiveStatus(false);
    //     }
    //   }

    //   return Future.value(message);
    // });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = widget.isSearching;

    if (widget.value != '') {
      log(widget.value);
      _searchList.clear();

      for (var i in _list) {
        if (i.name.toLowerCase().contains(widget.value.toLowerCase()) ||
            i.email.toLowerCase().contains(widget.value.toLowerCase())) {
          _searchList.add(i);
          setState(() {
            _searchList;
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      //floating button to add new user

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            onPressed: () {
              _addCommunityDialog();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.add_comment_rounded, color: Colors.black,)),
      ),

      //body
      body: StreamBuilder(
        stream: APIs.getCommunityId(),

        //get id of only known users
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              return StreamBuilder(
                stream: APIs.getAllUserCommunities(
                    snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                //get only those communities, who's ids are provided
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());

                    //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      _list = data
                              ?.map((e) => CommunityUser.fromJson(e.data()))
                              .toList() ??
                          [];
                      log(_list.toString());

                      if (_list.isNotEmpty) {
                        log('//////////////////////');
                        log(_list.length.toString());
                        log(isSearching.toString());
                        return ListView.builder(
                            itemCount:
                                isSearching ? _searchList.length : _list.length,
                            //padding: EdgeInsets.only(top: mq.height * .01),
                            
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ChatCommunityCard(
                                      user: isSearching
                                          ? _searchList[index]
                                          : _list[index]),
                                          Divider(color: Colors.grey.shade800,
                                          height: 0,
                                          thickness: 1,)
                                ],
                              );
                            });
                      } else {
                        return const Center(
                          child: Text('No Connections Found!',
                              style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              );
          }
        },
      ),
    );
  }

  // for adding new chat user
  void _addCommunityDialog() {
    String name = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        //title
        title: const Row(
          children: [
            Icon(
              Icons.person_add,
              color: Colors.black,
              size: 28,
            ),
            SizedBox(width: 10,),
            Text('Add Community')
          ],
        ),

        //content
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => name = value,
          decoration: InputDecoration(
              hintText: 'Community Name',
              prefixIcon:
                  const Icon(Icons.email, color: Colors.black),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),

        //actions
        actions: [
          //cancel button
          MaterialButton(
              onPressed: () {
                //hide alert dialog
                Navigator.pop(context);
              },
              child: const Text('Cancel',
                  style:
                      TextStyle(color: Colors.black, fontSize: 16))),

          //add button
          MaterialButton(
              onPressed: () async {
                //hide alert dialog
                Navigator.pop(context);
                if (name.isNotEmpty) {
                  await APIs.addUserToCommunity(name).then((value) {
                    if (!value) {
                      Dialogs.showSnackbar(
                          context, 'Community does not Exists!');
                    }
                  });
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ))
        ],
      ),
    );
  }
}
