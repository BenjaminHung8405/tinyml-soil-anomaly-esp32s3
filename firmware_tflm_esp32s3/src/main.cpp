#include <Arduino.h>
#include "model_runner.h"
#include "uart_stream_handler.h"

namespace
{
    WindowPacket current_packet;
    uint32_t total_packets_received = 0;
}

void setup()
{
    Serial.begin(115200);
    // Tăng kích thước bộ đệm nhận UART của ESP32 để không bị drop byte khi truyền nhanh
    Serial.setRxBufferSize(1024);

    delay(1000);
    Serial.println("\n[ESP32-S3] UART STREAM HANDLER READY (Baud: 115200)");

    ModelRunner &runner = ModelRunner::getInstance();
    if (!runner.init())
    {
        Serial.println("[ERROR] Khoi tao ModelRunner that bai!");
    }
    else
    {
        Serial.println("[+] ModelRunner san sang tiep nhan chuoi du lieu!");
    }

    uart_stream_init();
}

void loop()
{
    while (Serial.available() > 0)
    {
        uint8_t in_byte = (uint8_t)Serial.read();

        if (uart_stream_process_byte(in_byte, &current_packet))
        {
            total_packets_received++;

            // Xuất phản hồi ACK chuẩn định dạng JSON nhẹ cho script Host Python
            Serial.printf("{\"status\":\"ACK\",\"window_idx\":%u,\"total\":%lu}\n",
                          current_packet.window_index, total_packets_received);
        }
    }
}