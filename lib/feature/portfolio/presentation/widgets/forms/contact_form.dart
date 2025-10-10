import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/contact_bloc/contact_bloc.dart';
import '../../bloc/contact_bloc/contact_event.dart';
import '../../bloc/contact_bloc/contact_state.dart';
import 'floating_label_field.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ContactBloc>().add(
        ContactFormSubmitted(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    context.read<ContactBloc>().add(const ContactFormReset());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.primary,
            ),
          );
          _resetForm();
        } else if (state is ContactError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send me a message',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            FloatingLabelField(
              controller: _nameController,
              label: 'Your Name',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Email Field
            FloatingLabelField(
              controller: _emailController,
              label: 'Your Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Message Field
            FloatingLabelField(
              controller: _messageController,
              label: 'Your Message',
              icon: Icons.message,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your message';
                }
                if (value.trim().length < 10) {
                  return 'Message must be at least 10 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                final isSubmitting = state is ContactSubmitting;

                return FilledButton.icon(
                  onPressed: isSubmitting ? null : _submitForm,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    isSubmitting ? 'Sending...' : 'Send Magical Message',
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
