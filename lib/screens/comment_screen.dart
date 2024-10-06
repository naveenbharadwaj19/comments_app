import 'package:comments_app/providers/auth_provider.dart';
import 'package:comments_app/providers/comment_provider.dart';
import 'package:comments_app/widgets/comment_card.dart';
import 'package:comments_app/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommentProvider>(context, listen: false).fetchComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider =
        Provider.of<CommentProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: const Text('Comments Feed'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
                Navigator.of(context).pushReplacementNamed('/auth');
              },
            ),
          ],
        ),
        body: StreamBuilder<bool>(
          stream: commentProvider.maskEmailStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            bool maskEmail = snapshot.data ?? false;

            return Consumer<CommentProvider>(
              builder: (context, commentProvider, child) {
                if (commentProvider.isLoading) {
                  return LoadingSpinner();
                }

                return commentProvider.comments.isEmpty
                    ? const Center(child: Text("No comments found."))
                    : ListView.builder(
                        itemCount: commentProvider.comments.length,
                        itemBuilder: (ctx, index) {
                          return CommentCard(
                            comment: commentProvider.comments[index],
                            maskEmail: maskEmail,
                          );
                        },
                      );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<CommentProvider>().fetchComments();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
