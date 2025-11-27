import 'package:cloud_firestore/cloud_firestore.dart';
import '../../p2_local_bd/model/composicao.dart';

class FirestoreService {
  final CollectionReference _compsCollection =
      FirebaseFirestore.instance.collection('comunidade_comps');

  // 1. CREATE (Atualizado)
  Future<void> addComposicao(Composicao comp, String authorEmail) {
    return _compsCollection.add({
      'nome': comp.nome,
      'campeoes': comp.campeoes,
      'itens': comp.itens,
      'tier': comp.tier,
      'dificuldade': comp.dificuldade,
      'custo': comp.custo,
      'observacoes': comp.observacoes,
      'author': authorEmail,
      'timestamp': FieldValue.serverTimestamp(),
      
      // MUDANÇA AQUI:
      'likes': 0, 
      'likedBy': [], // Lista vazia para guardar os IDs de quem curtiu
    });
  }

  // 2. READ (Igual)
  Stream<QuerySnapshot> getComposicoesStream() {
    return _compsCollection.orderBy('likes', descending: true).snapshots();
  }

  // 3. TOGGLE LIKE (A Lógica do YouTube)
  Future<void> toggleLike(String docId, String userId) async {
    final docRef = _compsCollection.doc(docId);
    
    // Lemos o documento primeiro para saber se o usuário já deu like
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) return;

    final data = docSnapshot.data() as Map<String, dynamic>;
    final List<dynamic> likedBy = data['likedBy'] ?? [];

    if (likedBy.contains(userId)) {
      // SE JÁ TEM O ID: O usuário quer REMOVER o like (Descurtir)
      await docRef.update({
        'likes': FieldValue.increment(-1), // Diminui contador
        'likedBy': FieldValue.arrayRemove([userId]), // Remove ID da lista
      });
    } else {
      // SE NÃO TEM O ID: O usuário quer DAR like (Curtir)
      await docRef.update({
        'likes': FieldValue.increment(1), // Aumenta contador
        'likedBy': FieldValue.arrayUnion([userId]), // Adiciona ID na lista
      });
    }
  }
  // 4. UPDATE: Atualizar uma comp existente (apenas se for o dono)
  Future<void> updateComposicao(String docId, Composicao comp) {
    return _compsCollection.doc(docId).update({
      'nome': comp.nome,
      'campeoes': comp.campeoes,
      'itens': comp.itens,
      'tier': comp.tier,
      'dificuldade': comp.dificuldade,
      'custo': comp.custo,
      'observacoes': comp.observacoes,
      // Não atualizamos autor, likes ou data original
    });
  }

  // 5. DELETE: Apagar da nuvem
  Future<void> deleteComposicao(String docId) {
    return _compsCollection.doc(docId).delete();
  }
}