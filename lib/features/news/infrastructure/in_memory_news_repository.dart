import '../domain/entities/news_article.dart';

class InMemoryNewsRepository {
  const InMemoryNewsRepository();

  List<NewsArticle> load() => const [
    NewsArticle(
      category: 'Destaque',
      title: 'Informação de Goiás em tempo real na Rádio Sagres',
      publishedLabel: 'Conteúdo demonstrativo',
    ),
    NewsArticle(
      category: 'Política',
      title: 'Acompanhe as principais notícias do estado',
      publishedLabel: 'Conteúdo demonstrativo',
    ),
    NewsArticle(
      category: 'Esporte',
      title: 'A cobertura esportiva que faz parte da história de Goiás',
      publishedLabel: 'Conteúdo demonstrativo',
    ),
  ];
}
