// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:yemek_tarifi_app/backend/backend.dart';
import 'package:yemek_tarifi_app/global/global_functions.dart';

class FeedbackScreen extends StatefulWidget {
  final int recipeId;
  final String category;

  const FeedbackScreen({super.key, required this.recipeId, required this.category});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  bool _isValidEmail(String email) {
    final String trimmed = email.trim();
    final RegExp regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(trimmed);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [const Icon(Icons.error, color: Colors.white), const SizedBox(width: 10), Text(message)]),
        backgroundColor: Colors.red.withValues(alpha: 0.9),
        elevation: 10,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitFeedback() async {
    if (_isSubmitting) return;
    final String email = _emailController.text.trim();
    final String message = _messageController.text.trim();

    if (message.isEmpty) {
      _showError('error'.tr());
      return;
    }
    if (email.isEmpty || !_isValidEmail(email)) {
      _showError('invalidEmail'.tr());
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await BackendService.submitFeedback(recipeId: widget.recipeId, email: email, message: message);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [const Icon(Icons.check_circle, color: Colors.green), const SizedBox(width: 10), Text('thankyouForYourFeedback'.tr())]),
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          elevation: 10,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      _showError('feedbackSubmitFailed'.tr());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(appBar: globalAppBar('feedbackScreen'.tr(), context), body: feedbackBody());
  }

  Widget feedbackBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.grey[500],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email'.tr(),
                        prefixIcon: const Icon(Icons.email, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[600],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'yourFeedback'.tr(),
                        prefixIcon: const Icon(Icons.feedback, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[600],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: _isSubmitting ? null : _submitFeedback,
                        child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : Text('send'.tr(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: FadeIn(
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'yourFeedbackWillBeReview'.tr(),
                          style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
