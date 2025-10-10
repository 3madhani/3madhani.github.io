import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<ContactFormSubmitted>(_onContactFormSubmitted);
    on<ContactFormReset>(_onContactFormReset);
  }

  void _onContactFormReset(ContactFormReset event, Emitter<ContactState> emit) {
    emit(ContactInitial());
  }

  Future<void> _onContactFormSubmitted(
    ContactFormSubmitted event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactSubmitting());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would send the message to your backend
      // await _sendContactMessage(event.name, event.email, event.message);

      emit(
        const ContactSubmitted(
          message:
              'Thank you! Your magical message has been sent successfully.',
        ),
      );
    } catch (e) {
      emit(
        ContactError(message: 'Oops! Something went wrong. Please try again.'),
      );
    }
  }
}
