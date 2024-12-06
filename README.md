# desafio-ios-dev
Desafio iOS Developer

## Arquitectura
Dado el tiempo limitado, el interés en implementar separación de responsabilidades, y proveer una organización amigable con test unitarios, se decidió utilizar una arquitectura de estilo MVVM.

### View

* PokemonListViewController
* PokemonDetailViewController
* PokemonListLoadingView

Los bindings con el viewModel se realizaron de manera simple usando closures, en el caso de PokemonListViewController. Para PokemonDetailViewController no eran necesarios ya que esa pantalla no reacciona a cambios.

En estos componentes se evitó agregar lógica de la aplicación, y en general, solamente tienen lógica relacionada con el setup de las vistas.

### ViewModel
* PokemonListViewModel
* PokemonDetailViewModel
* PokemonListCellModel

Estos componentes tienen lógica relacionada con el UI y formateo de datos entregados por la capa del modelo.

### Model

* CacheManager
* CacheManagerImpl
* ApiPokeEndpoint
* DataMapper
* Y muchas más entidades...

En esta capa se implemento la lógica para obtener los datos de las fuentes remotas y la lógica para agregarlos al caché persistente. Por falta de tiempo no se alcanzó a separar más en componentes más especializados, pero hay un avance en la rama `feature/model-layer-refactor`

## Persistencia
Dado que se requería guardar cientos de elementos y con imágenes asociadas, se descartó usar `UserDefaults` ya que el objetivo de ese sistema es guardar configuraciones de usuario. Para evitar la gestión de archivos, se optó por usar Core Data (además, por defecto Xcode provee código boilerplate para utilizarlo).

## Test Unitarios
Al principio comencé a implementar la aplicación usando TDD, sin embargo, dado el tiempo limitado (principalmente por mi trabajo actual), decidí continuar sin tests para implementar la mayoría de lo requerido.

😀