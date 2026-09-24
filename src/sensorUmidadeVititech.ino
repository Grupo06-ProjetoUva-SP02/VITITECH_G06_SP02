const int ValorAgua = 550;
const int ValorAr = 230; 

int valorUmidadeSolo = 0;
float porcentagemUmidade = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  valorUmidadeSolo = analogRead(A5);

  int faixa = ValorAgua - ValorAr;

  int distancia = valorUmidadeSolo - ValorAr;

  porcentagemUmidade = (float)distancia / faixa * 100.0;

  if (porcentagemUmidade < 0) porcentagemUmidade = 0;
  if (porcentagemUmidade > 100) porcentagemUmidade = 100;


  Serial.println(porcentagemUmidade);

  delay(1000);
}
