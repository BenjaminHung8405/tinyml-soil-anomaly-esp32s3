#include <Arduino.h>
#include "model_runner.h"
#include "uart_stream_handler.h"
#include "edge_pipeline.h"

namespace
{
    WindowPacket current_packet;
    constexpr float kDetectionTau = 0.005f;
}

void setup()
{
    Serial.begin(115200);
    Serial.setRxBufferSize(2048);
    Serial.setTxBufferSize(2048);
    delay(1500);

    ModelRunner &runner = ModelRunner::getInstance();
    if (!runner.init())
    {
        Serial.println("{\"error\":\"ModelRunner init failed\"}");
        return;
    }

    EdgePipeline::getInstance().init(kDetectionTau);
    uart_stream_init();
    Serial.println("{\"status\":\"READY\"}");
}

void loop()
{
    while (Serial.available() > 0)
    {
        uint8_t in_byte = (uint8_t)Serial.read();

        if (uart_stream_process_byte(in_byte, &current_packet))
        {
            EdgePipelineResult res = EdgePipeline::getInstance().processWindow(
                current_packet.window_index, current_packet.samples);

            Serial.printf("{\"idx\":%u,\"rule_err\":%d,\"anomaly\":%d,\"lockout\":%d,\"mse\":%.6f,\"Ct\":%.4f,\"lat_us\":%u}\n",
                          res.window_index,
                          res.rule_violation ? 1 : 0,
                          res.anomaly_detected ? 1 : 0,
                          res.pump_lockout ? 1 : 0,
                          res.reconstruction_mse,
                          res.confidence_score,
                          (unsigned int)res.inference_latency_us);
            Serial.flush();
        }
    }
}