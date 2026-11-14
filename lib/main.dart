import 'package:flutter/material.dart';

void main() => runApp(const ExploreMundoApp());

// ---------------------------------------------------------------------------
// Modelo de dados
// ---------------------------------------------------------------------------
class Destino {
  final String nome;
  final String local;
  final String descricao;
  final String imagem;
  final int avaliacoes;
  final String preco;

  const Destino({
    required this.nome,
    required this.local,
    required this.descricao,
    required this.imagem,
    required this.avaliacoes,
    required this.preco,
  });
}

const List<Destino> destinos = [
  Destino(
    nome: 'Rio de Janeiro',
    local: 'Rio de Janeiro, Brasil',
    descricao:
        'A Cidade Maravilhosa combina praias famosas, o Cristo Redentor e o Pão '
        'de Açúcar. Inclui passeio de bondinho, trilhas na Floresta da Tijuca e '
        'roteiro gastronômico pela Lapa e Santa Teresa.',
    imagem:
        'images/Rio_Cristo.jpg',
    avaliacoes: 320,
    preco: 'A partir de R\$ 2.490',
  ),
  Destino(
    nome: 'Paris',
    local: 'Paris, França',
    descricao:
        'Visite a Torre Eiffel, o Louvre e Montmartre. O pacote inclui cruzeiro '
        'pelo Rio Sena e café da manhã em um bistrô tradicional.',
    imagem:
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=900',
    avaliacoes: 214,
    preco: 'A partir de R\$ 7.890',
  ),
  Destino(
    nome: 'Santorini',
    local: 'Cíclades, Grécia',
    descricao:
        'Casas brancas com cúpulas azuis, pores do sol inesquecíveis em Oia e '
        'praias de areia vulcânica. Passeio de barco pela caldeira incluso.',
    imagem:
        'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=900',
    avaliacoes: 97,
    preco: 'A partir de R\$ 8.650',
  ),
  Destino(
    nome: 'Alpes Suíços',
    local: 'Kandersteg, Suíça',
    descricao:
        'O Lago Oeschinen fica aos pés do Blüemlisalp, nos Alpes Berneses, a '
        '1.578 metros de altitude. Um passeio de teleférico a partir de '
        'Kandersteg, seguido de meia hora de caminhada, leva você ao lago, que '
        'aquece até 20 °C no verão. Há remo e tobogã de verão.',
    imagem:
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=900',
    avaliacoes: 41,
    preco: 'A partir de R\$ 9.990',
  ),
];

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------
class ExploreMundoApp extends StatelessWidget {
  const ExploreMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Mundo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

Widget imagemRede(String url, {double? width, double? height}) {
  final erro = Container(
    width: width,
    height: height,
    color: Colors.grey[300],
    child: const Icon(Icons.image_not_supported, size: 48),
  );
  if (url.startsWith('http')) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => erro,
    );
  }
  return Image.asset(
    url,
    width: width,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => erro,
  );
}

// ---------------------------------------------------------------------------
// Home com barra de navegação superior (TabBar)
// ---------------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Mundo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.public), text: 'Destinos'),
              Tab(icon: Icon(Icons.luggage), text: 'Pacotes de viagem'),
              Tab(icon: Icon(Icons.phone), text: 'Contato'),
              Tab(icon: Icon(Icons.info_outline), text: 'Sobre nós'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DestinosTab(),
            PacotesTab(),
            ContatoTab(),
            SobreTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Aba Destinos: banner + pesquisa rápida + lista
// ---------------------------------------------------------------------------
class DestinosTab extends StatefulWidget {
  const DestinosTab({super.key});

  @override
  State<DestinosTab> createState() => _DestinosTabState();
}

class _DestinosTabState extends State<DestinosTab> {
  String _busca = '';

  List<Destino> get _filtrados {
    final q = _busca.trim().toLowerCase();
    if (q.isEmpty) return destinos;
    return destinos
        .where((d) =>
            d.nome.toLowerCase().contains(q) ||
            d.local.toLowerCase().contains(q))
        .toList();
  }

  void _abrirDestino(Destino d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DestinoPage(destino: d)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _filtrados;
    return ListView(
      children: [
        // 1. Banner de destaque (slideshow clicável)
        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: destinos.length,
            itemBuilder: (_, i) {
              final d = destinos[i];
              return GestureDetector(
                onTap: () => _abrirDestino(d),
                // Stack: texto sobreposto à imagem (Microatividade 5)
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imagemRede(d.imagem),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            d.local,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // 3. Pesquisa rápida
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (v) => setState(() => _busca = v),
            decoration: InputDecoration(
              hintText: 'Pesquisar destinos...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // Lista de destinos (ListView + ListTile)
        if (lista.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('Nenhum destino encontrado.')),
          )
        else
          for (final d in lista)
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imagemRede(d.imagem, width: 56, height: 56),
              ),
              title: Text(d.nome),
              subtitle: Text(d.local),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () => _abrirDestino(d),
            ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Aba Pacotes de viagem
// ---------------------------------------------------------------------------
class PacotesTab extends StatelessWidget {
  const PacotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final d in destinos)
          ListTile(
            leading: const Icon(Icons.flight_takeoff),
            title: Text('Pacote ${d.nome}'),
            subtitle: Text(d.preco),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DestinoPage(destino: d)),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Aba Contato (Row com 3 Columns)
// ---------------------------------------------------------------------------
class ContatoTab extends StatelessWidget {
  const ContatoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text(
            'Fale com a equipe Explore Mundo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButtonColumn(color, Icons.call, 'LIGAR'),
              buildButtonColumn(color, Icons.email, 'E-MAIL'),
              buildButtonColumn(color, Icons.chat, 'WHATSAPP'),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Aba Sobre nós
// ---------------------------------------------------------------------------
class SobreTab extends StatelessWidget {
  const SobreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'A Explore Mundo é uma agência de viagens dedicada a transformar '
        'sonhos em roteiros. Oferecemos pacotes nacionais e internacionais, '
        'atendimento personalizado e reservas pelo aplicativo e pelo site.',
        softWrap: true,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Componente reutilizável: coluna de botão (ícone + texto)
// ---------------------------------------------------------------------------
Column buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Página de detalhe do destino (imagem + título + botões + texto)
// ---------------------------------------------------------------------------
class DestinoPage extends StatelessWidget {
  final Destino destino;
  const DestinoPage({super.key, required this.destino});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    // Seção de título
    final Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    destino.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  destino.local,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          Text('${destino.avaliacoes}'),
        ],
      ),
    );

    // Seção de botões
    final Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButtonColumn(color, Icons.call, 'CALL'),
        buildButtonColumn(color, Icons.near_me, 'ROUTE'),
        buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
    );

    // Seção de texto
    final Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(destino.descricao, softWrap: true),
    );

    // Botão de reserva
    final Widget reservaSection = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            destino.preco,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reserva solicitada: ${destino.nome}')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Reservar'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(destino.nome),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // ListView para permitir rolagem em telas pequenas
      body: ListView(
        children: [
          imagemRede(destino.imagem, height: 240),
          titleSection,
          buttonSection,
          textSection,
          reservaSection,
        ],
      ),
    );
  }
}