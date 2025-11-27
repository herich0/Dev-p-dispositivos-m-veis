import 'dart:io'; // Necessário para File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import do Image Picker
import '../model/composicao.dart';
import '../helper/database_helper.dart';
import '../utils/tft_data.dart';
import '../../components/tft_background.dart';

class ComposicaoFormPage extends StatefulWidget {
  final Composicao? composicao;
  final Function(Composicao)? onSaveExternal; // Callback externo opcional
  const ComposicaoFormPage({super.key, this.composicao,this.onSaveExternal});

  @override
  State<ComposicaoFormPage> createState() => _ComposicaoFormPageState();
}

class _ComposicaoFormPageState extends State<ComposicaoFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nomeController = TextEditingController();
  final _itensController = TextEditingController();
  final _custoController = TextEditingController();
  final _obsController = TextEditingController();
  final TextEditingController _championTextController = TextEditingController();

  // Variáveis de Estado
  String? _selectedTier;
  String? _selectedDifficulty;
  String? _selectedChampion;
  String? _imagePath; // Caminho da imagem no celular

  final DatabaseHelper _helper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker(); // Instância do Picker [cite: 1004]

  @override
  void initState() {
    super.initState();
    if (widget.composicao != null) {
      _nomeController.text = widget.composicao!.nome ?? "";
      _itensController.text = widget.composicao!.itens ?? "";
      _custoController.text = widget.composicao!.custo ?? "";
      _obsController.text = widget.composicao!.observacoes ?? "";
      _selectedTier = widget.composicao!.tier;
      _selectedDifficulty = widget.composicao!.dificuldade;
      _selectedChampion = widget.composicao!.campeoes;
      _championTextController.text = widget.composicao!.campeoes ?? "";
      _imagePath = widget.composicao!.imagem; // Recupera imagem
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.composicao == null ? "Nova Estratégia" : "Editar Estratégia",
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (widget.composicao != null && widget.onSaveExternal == null) // Só mostra se for local
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: _confirmarExclusao, // Chama a função de confirmação
            ),
          const SizedBox(width: 8), // Espacinho extra na direita
        ],
      ),
      body: Stack(
        children: [
          // CAMADA 1: O Fundo (Fixo e Esticado)
          Positioned.fill(
            child: TFTBackground(
              // Passamos um container vazio só para exibir a imagem
              child: Container(),
            ),
          ),

          // CAMADA 2: O Conteúdo (Rolável)
          Positioned.fill(
            child: SingleChildScrollView(
              // O Padding do teclado vai aqui
              padding: EdgeInsets.fromLTRB(16, 100, 16, 16 + bottomPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ROW SUPERIOR (IMAGEM + CAMPOS)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Alinha ao topo
                      children: [
                        // 1. IMAGEM (Esquerda)
                        GestureDetector(
                          onTap: _pickImage, // Função para pegar imagem [cite: 1043]
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12), // Quadrado com bordas arredondadas
                              border: Border.all(color: Colors.white24),
                              image: _imagePath != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(_imagePath!),
                                      ), // Mostra foto [cite: 1051]
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _imagePath == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: Colors.white54),
                                      Text(
                                        "Foto",
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // 2. CAMPOS DA DIREITA (Nome + Tier/Diff)
                        Expanded(
                          child: Column(
                            children: [
                              // Nome da Comp
                              TextFormField(
                                controller: _nomeController,
                                maxLength: 52,
                                decoration: const InputDecoration(
                                  labelText: "Nome da Composição",
                                  border: OutlineInputBorder(),
                                  counterText: "",
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? "Obrigatório" : null,
                              ),
                              const SizedBox(height: 10),

                              // Linha com Tier e Dificuldade
                              Row(
                                children: [
                                  // Tier
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      initialValue: _selectedTier,
                                      decoration: const InputDecoration(
                                        labelText: "Tier",
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                      ),
                                      items: tierOptions.map((String tier) {
                                        return DropdownMenuItem<String>(
                                          value: tier,
                                          child: Text(
                                            tier,
                                            style: TextStyle(
                                              color: _getTierColor(tier),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (v) =>
                                          setState(() => _selectedTier = v),
                                      validator: (v) => v == null ? "Erro" : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Dificuldade
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      initialValue: _selectedDifficulty,
                                      isExpanded: true, // Para caber o texto
                                      decoration: const InputDecoration(
                                        labelText: "Dif.",
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                      ),
                                      items: difficultyOptions.map((String diff) {
                                        return DropdownMenuItem<String>(
                                          value: diff,
                                          child: Text(
                                            diff,
                                            style: const TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (v) =>
                                          setState(() => _selectedDifficulty = v),
                                      validator: (v) => v == null ? "Erro" : null,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),

                    // Autocomplete Campeão
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return championsList.where(
                          (String option) => option.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          ),
                        );
                      },
                      onSelected: (String selection) =>
                          _selectedChampion = selection,
                      initialValue: TextEditingValue(text: _selectedChampion ?? ""),
                      fieldViewBuilder: (
                        context,
                        textEditingController,
                        focusNode,
                        onFieldSubmitted,
                      ) {
                        if (_championTextController.text.isNotEmpty &&
                            textEditingController.text.isEmpty) {
                          textEditingController.text =
                              _championTextController.text;
                        }
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: "Campeão Principal (Carry)",
                            border: OutlineInputBorder(),
                            counterText: "",
                            prefixIcon: Icon(Icons.person_search),
                          ),
                          onChanged: (text) => _selectedChampion = text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Selecione um campeão";
                            }
                            // Verifica se o que foi digitado existe na nossa lista oficial
                            // (Ignorando maiúsculas/minúsculas para ser gentil com o usuário)
                            bool existe = championsList.any(
                              (c) => c.toLowerCase() == value.toLowerCase(),
                            );

                            if (!existe) {
                              return "Campeão inválido. Selecione da lista.";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _itensController,
                      maxLength: 72,
                      decoration: const InputDecoration(
                        labelText: "Itens Essenciais",
                        border: OutlineInputBorder(),
                        counterText: "",
                        prefixIcon: Icon(Icons.shield),
                      ),
                      validator: (value) => value!.isEmpty ? "Obrigatório" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _custoController,
                      maxLength: 32,
                      decoration: const InputDecoration(
                        labelText: "Estilo de Jogo / Custo",
                        border: OutlineInputBorder(),
                        counterText: "",
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) => value!.isEmpty ? "Obrigatório" : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _obsController,
                      maxLines: 5,
                      maxLength: 200,
                      decoration: const InputDecoration(
                        labelText: "Anotações Extras",
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: _saveComposicao,
                        child: const Text(
                          "Salvar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para pegar imagem da galeria [cite: 1096]
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveComposicao() async {
    if (_formKey.currentState!.validate()) {
      Composicao c = Composicao(
        id: widget.composicao?.id,
        nome: _nomeController.text,
        campeoes: _selectedChampion,
        itens: _itensController.text,
        tier: _selectedTier,
        dificuldade: _selectedDifficulty,
        custo: _custoController.text,
        observacoes: _obsController.text,
        imagem: _imagePath, // Salva o caminho da imagem
      );

      if (widget.onSaveExternal != null) {
        // Se tiver função externa (Firebase), usa ela!
        await widget.onSaveExternal!(c);
      } else {
        // Se não, usa o comportamento padrão (SQLite)
        if (widget.composicao == null) {
          await _helper.saveComposicao(c);
        } else {
          await _helper.updateComposicao(c);
        }
      }
      if (mounted) Navigator.pop(context, true);
    }
  }

  void _confirmarExclusao() {
    showDialog(
      context: context, // Contexto da Página (Pai)
      // MUDANÇA 1: Renomeamos 'context' para 'dialogContext' aqui
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Excluir Estratégia?"),
          content: const Text("Tem certeza que deseja apagar esta composição?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Fecha o DIÁLOGO
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Fecha o DIÁLOGO primeiro

                // Operação Assíncrona (Espera o banco)
                if (widget.composicao != null &&
                    widget.composicao!.id != null) {
                  await _helper.deleteComposicao(widget.composicao!.id!);
                }

                // MUDANÇA 2: Verificamos 'mounted' (se a tela ainda existe)
                // e usamos 'context' (da Página) e não 'dialogContext'
                if (mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'S':
        return Colors.amber;
      case 'A':
        return Colors.redAccent;
      case 'B':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}