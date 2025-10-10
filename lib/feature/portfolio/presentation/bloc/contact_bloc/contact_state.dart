import 'package:equatable/equatable.dart';

class ContactError extends ContactState {
  final String message;

  const ContactError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ContactInitial extends ContactState {}

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactSubmitted extends ContactState {
  final String message;

  const ContactSubmitted({required this.message});

  @override
  List<Object?> get props => [message];
}

class ContactSubmitting extends ContactState {}
