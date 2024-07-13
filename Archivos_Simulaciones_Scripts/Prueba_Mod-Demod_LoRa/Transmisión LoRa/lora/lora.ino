#include "LoRaWan_APP.h"
#include "Arduino.h"

// Configuración para el módulo LoRa
#define RF_FREQUENCY 902000000  // Hz (915 MHz)
#define TX_OUTPUT_POWER 0 // Incrementar la potencia de salida para mejorar la calidad de la señal

#define LORA_BANDWIDTH 0  // 500 kHz
#define LORA_SPREADING_FACTOR 12 // Mayor SF para mayor resistencia al ruido
#define LORA_CODINGRATE 4  // Mayor tasa de codificación para más corrección de errores

#define LORA_PREAMBLE_LENGTH 8  // Longitud del preámbulo
#define LORA_SYMBOL_TIMEOUT 0  // Sin tiempo de espera
#define LORA_FIX_LENGTH_PAYLOAD_ON false  // Carga útil de longitud variable
#define LORA_IQ_INVERSION_ON false  // No invertir la polaridad de IQ

#define BUFFER_SIZE 64  // Tamaño del buffer para la carga útil (incrementado)
#define RX_TIMEOUT_VALUE 1000

// Variables globales
char txpacket[BUFFER_SIZE];
double txNumber = 0;  // Contador para los mensajes
bool lora_idle = true;

static RadioEvents_t RadioEvents;  // Eventos de radio para LoRa

// Funciones de evento para LoRa
void OnTxDone(void) {
  Serial.println("Transmisión completada.");
  lora_idle = true;  // Permitir la siguiente transmisión
}

void OnTxTimeout(void) {
  Radio.Sleep();
  Serial.println("Transmisión agotada.");
  lora_idle = true;
}

void setup() {
  Serial.begin(115200);  // Iniciar el puerto serie
  Mcu.begin(HELTEC_BOARD, SLOW_CLK_TPYE);  // Iniciar la placa Heltec
  
  // Configurar eventos de transmisión
  RadioEvents.TxDone = OnTxDone;
  RadioEvents.TxTimeout = OnTxTimeout;

  // Inicializar Radio y configurar canal
  Radio.Init(&RadioEvents);
  Radio.SetChannel(RF_FREQUENCY);

  // Configurar parámetros de transmisión
  Radio.SetTxConfig(MODEM_LORA, TX_OUTPUT_POWER, 0, LORA_BANDWIDTH, LORA_SPREADING_FACTOR,
                    LORA_CODINGRATE, LORA_PREAMBLE_LENGTH, LORA_FIX_LENGTH_PAYLOAD_ON,
                    true, 0, 0, LORA_IQ_INVERSION_ON, 3000);  // Tiempo de espera de 3 segundos
}

void loop() {
  if (lora_idle) {
    delay(5000);  // Aumentar el intervalo de tiempo entre transmisiones a 10 segundos (10000 milisegundos)
    
    // Incrementar el número del mensaje
    txNumber += 0.01;
    
    // Crear un mensaje para transmitir
    sprintf(txpacket, "Hola FICA %0.2f", txNumber);
    
    // Imprimir mensaje y longitud en el puerto serie
    Serial.printf("\r\nEnviando paquete \"%s\", longitud %d\r\n", txpacket, strlen(txpacket));
    
    // Enviar el paquete
    Radio.Send((uint8_t *)txpacket, strlen(txpacket));  // Transmitir la carga útil
    
    // Cambiar a modo ocupado hasta que se complete la transmisión
    lora_idle = false;
  }

  // Procesar interrupciones de radio
  Radio.IrqProcess();
}
