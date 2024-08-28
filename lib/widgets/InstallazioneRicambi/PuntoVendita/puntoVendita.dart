class PuntoVendita{
  PuntoVendita({this.codDest, this.nome,this.indirizzo,this.citta,this.prov});
  String? codDest;
  String? nome;
  String? indirizzo;
  String? citta;
  String? prov;

  PuntoVendita.fromJson(Map<String, dynamic> json){
    codDest = json['CodDest'].toString();
    nome = json['Nome'];
    indirizzo = json['Indirizzo'];
    citta = json['Citta'];
    prov = json['Prov'];
  }

  String puntoVenditaFormattato(){
    return 
    '''
$codDest
$indirizzo
$citta ($prov)''';
  }

}

