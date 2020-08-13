import 'package:Radar/requests/controller/RequestsController.dart';
import 'package:Radar/chat/view/ChatAppBar.dart';
import 'package:Radar/chat/view/ChatInput.dart';
import 'package:Radar/chat/view/ChatItem.dart';
import 'package:Radar/utils/Role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:Radar/utils/ConnectionState.dart' as util;

class ChatScreen extends StatelessWidget {
  final _schedulerBinding = SchedulerBinding.instance;
  @override
  Widget build(BuildContext context) {
    final _routeName = ModalRoute.of(context).settings.name;
    Role _role;

    return Consumer<RequestsController>(
      builder: (context, _requestsController, child) {
        ScrollController _scrollController = ScrollController();
        if (_routeName == '/requestAccepterChat') {
          _role = _requestsController.roles.requestAccepter;
        } else {
          _role = _requestsController.roles.requestCreater;
        }

        if (_role.connectionState != util.ConnectionState.Connected) {
          _schedulerBinding.addPostFrameCallback((_) {
            Navigator.of(context).popUntil(ModalRoute.withName('/home'));
            return Container();
          });
        }

        _schedulerBinding.addPostFrameCallback((_) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut);
        });

        return Scaffold(
          appBar: ChatAppBar(
            _role.requestTitle,
            _role.requestDescription,
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        ChatItem(_role.messages[index]),
                    itemCount: _role.messages.length,
                    controller: _scrollController,
                  ),
                ),
                ChatInput(_role.sendMessage),
              ],
            ),
          ),
        );
      },
    );
  }
}
