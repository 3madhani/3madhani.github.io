import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class ContactFormReset extends ContactEvent {
  const ContactFormReset();
}

class ContactFormSubmitted extends ContactEvent {
  final String name;
  final String email;
  final String message;

  const ContactFormSubmitted({
    required this.name,
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [name, email, message];
}
