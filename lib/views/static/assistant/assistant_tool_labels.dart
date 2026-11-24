/// Nom lisible des outils de Sika (pour dire à l'utilisateur d'où viennent les chiffres).
const Map<String, String> assistantToolLabels = {
  'get_activity_summary': "Activité et finances",
  'get_branches_ranking': "Classement des boutiques",
  'get_branch_report': "Bilan d'une boutique ou d'un atelier",
  'get_clients_summary': "Clients",
  'get_stock_status': "État du stock",
  'get_expenses_summary': "Dépenses et caisses",
  'get_orders_status': "Commandes",
  'get_staff_summary': "Personnel",
  'search_app_help': "Aide Ateliya (FAQ)",
};

String assistantToolLabel(String name) => assistantToolLabels[name] ?? name;

String formatDuration(int ms) =>
    ms >= 1000 ? '${(ms / 1000).toStringAsFixed(1)} s' : '$ms ms';
