enum ETypeFilter { tv, movie }

extension ETypeFilterExtension on ETypeFilter {
  String get displayName {
    switch (this) {
      case ETypeFilter.tv:
        return "Series";
      case ETypeFilter.movie:
        return "Películas";
    }
  }
}

enum EOrderTV {
  firstAirDateAsc,
  firstAirDateDesc,
  nameAsc,
  nameDesc,
  originalNameAsc,
  originalNameDesc,
  popularityAsc,
  popularityDesc,
  voteAverageAsc,
  voteAverageDesc,
  voteCountAsc,
  voteCountDesc,
}

extension EOrderTVExtension on EOrderTV {
  String get displayName {
    switch (this) {
      case EOrderTV.firstAirDateAsc:
        return 'Primera Emisión Asc';
      case EOrderTV.firstAirDateDesc:
        return 'Primera Emisión Desc';
      case EOrderTV.nameAsc:
        return 'Nombre Asc';
      case EOrderTV.nameDesc:
        return 'Nombre Desc';
      case EOrderTV.originalNameAsc:
        return 'Nombre Original Asc';
      case EOrderTV.originalNameDesc:
        return 'Nombre Original Desc';
      case EOrderTV.popularityAsc:
        return 'Popularidad Asc';
      case EOrderTV.popularityDesc:
        return 'Popularidad Desc';
      case EOrderTV.voteAverageAsc:
        return 'Voto Medio Asc';
      case EOrderTV.voteAverageDesc:
        return 'Voto Medio Desc';
      case EOrderTV.voteCountAsc:
        return 'Número Votos Asc';
      case EOrderTV.voteCountDesc:
        return 'Número Votos Desc';
    }
  }

  String get apiName {
    switch (this) {
      case EOrderTV.firstAirDateAsc:
        return 'first_air_date.asc';
      case EOrderTV.firstAirDateDesc:
        return 'first_air_date.desc';
      case EOrderTV.nameAsc:
        return 'name.asc';
      case EOrderTV.nameDesc:
        return 'name.desc';
      case EOrderTV.originalNameAsc:
        return 'original_name.asc';
      case EOrderTV.originalNameDesc:
        return 'original_name.desc';
      case EOrderTV.popularityAsc:
        return 'popularity.asc';
      case EOrderTV.popularityDesc:
        return 'popularity.desc';
      case EOrderTV.voteAverageAsc:
        return 'vote_average.asc';
      case EOrderTV.voteAverageDesc:
        return 'vote_average.desc';
      case EOrderTV.voteCountAsc:
        return 'vote_cont.asc';
      case EOrderTV.voteCountDesc:
        return 'vote_count.desc';
    }
  }
}

enum EOrderMovie {
  originalTitleAsc,
  originalTitleDesc,
  popularityAsc,
  popularityDesc,
  revenueAsc,
  revenueDesc,
  primaryReleaseDateAsc,
  primaryReleaseDateDesc,
  titleAsc,
  titleDesc,
  voteAverageAsc,
  voteAverageDesc,
  voteCountAsc,
  voteCountDesc,
}

extension EOrderMovieExtension on EOrderMovie {
  String get displayName {
    switch (this) {
      case EOrderMovie.originalTitleAsc:
        return 'Título Original Asc';
      case EOrderMovie.originalTitleDesc:
        return 'Título Original Desc';
      case EOrderMovie.popularityAsc:
        return 'Populariad Asc';
      case EOrderMovie.popularityDesc:
        return 'Popularidad Desc';
      case EOrderMovie.revenueAsc:
        return 'Ingresos Asc';
      case EOrderMovie.revenueDesc:
        return 'Ingresos Desc';
      case EOrderMovie.primaryReleaseDateAsc:
        return 'Fecha Lanzamiento Asc';
      case EOrderMovie.primaryReleaseDateDesc:
        return 'Fecha Lanzamiento Desc';
      case EOrderMovie.titleAsc:
        return 'Título Asc';
      case EOrderMovie.titleDesc:
        return 'Título Desc';
      case EOrderMovie.voteAverageAsc:
        return 'Voto Medio Asc';
      case EOrderMovie.voteAverageDesc:
        return 'Voto Media Desc';
      case EOrderMovie.voteCountAsc:
        return 'Número Votos Asc';
      case EOrderMovie.voteCountDesc:
        return 'Número Votos Desc';
    }
  }

  String get apiName {
    switch (this) {
      case EOrderMovie.originalTitleAsc:
        return 'original_title.asc';
      case EOrderMovie.originalTitleDesc:
        return 'original_title.desc';
      case EOrderMovie.popularityAsc:
        return 'popularity.asc';
      case EOrderMovie.popularityDesc:
        return 'popularity.desc';
      case EOrderMovie.revenueAsc:
        return 'revenue.asc';
      case EOrderMovie.revenueDesc:
        return 'revenue.desc';
      case EOrderMovie.primaryReleaseDateAsc:
        return 'primary_release_date.asc';
      case EOrderMovie.primaryReleaseDateDesc:
        return 'primary_release_date.desc';
      case EOrderMovie.titleAsc:
        return 'title.asc';
      case EOrderMovie.titleDesc:
        return 'title.desc';
      case EOrderMovie.voteAverageAsc:
        return 'vote_average.asc';
      case EOrderMovie.voteAverageDesc:
        return 'vote_average.desc';
      case EOrderMovie.voteCountAsc:
        return 'vote_count.asc';
      case EOrderMovie.voteCountDesc:
        return 'vote_count.desc';
    }
  }
}
