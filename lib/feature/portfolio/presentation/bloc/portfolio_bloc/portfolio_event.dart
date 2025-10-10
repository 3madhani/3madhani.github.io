import 'package:equatable/equatable.dart';

import '../../../domain/entities/project.dart';

class FilterProjects extends PortfolioEvent {
  final ProjectCategory category;

  const FilterProjects(this.category);

  @override
  List<Object?> get props => [category];
}

class LoadPortfolioData extends PortfolioEvent {
  const LoadPortfolioData();
}

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class RefreshPortfolioData extends PortfolioEvent {
  const RefreshPortfolioData();
}
