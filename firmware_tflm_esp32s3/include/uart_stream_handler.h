#ifndef UART_STREAM_HANDLER_H_
#define UART_STREAM_HANDLER_H_

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C"
{
#endif

#define UART_FRAME_HEADER_1 0xAA
#define UART_FRAME_HEADER_2 0x55
#define UART_FRAME_TAIL_1 0x0D
#define UART_FRAME_TAIL_2 0x0A

#define SAMPLES_PER_WINDOW 32
#define PAYLOAD_SIZE_BYTES (SAMPLES_PER_WINDOW * sizeof(float)) // 128 bytes

    typedef enum
    {
        UART_STATE_WAIT_HEADER_1 = 0,
        UART_STATE_WAIT_HEADER_2,
        UART_STATE_READ_INDEX,
        UART_STATE_READ_PAYLOAD,
        UART_STATE_CHECK_SUM,
        UART_STATE_WAIT_TAIL_1,
        UART_STATE_WAIT_TAIL_2
    } UartRxState;

    typedef struct
    {
        uint16_t window_index;
        float samples[SAMPLES_PER_WINDOW];
    } WindowPacket;

    // Khởi tạo handler
    void uart_stream_init(void);

    // Xử lý byte đơn đọc từ UART theo State Machine
    // Trả về true khi nhận trọn vẹn và hợp lệ 1 khung 32 mẫu
    bool uart_stream_process_byte(uint8_t byte, WindowPacket *out_packet);

    // Tính checksum XOR
    uint8_t calculate_checksum(const uint8_t *data, size_t length);

#ifdef __cplusplus
}
#endif

#endif // UART_STREAM_HANDLER_H_