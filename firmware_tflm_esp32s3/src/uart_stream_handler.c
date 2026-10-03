#include "uart_stream_handler.h"
#include <string.h>

static UartRxState current_state = UART_STATE_WAIT_HEADER_1;
static uint8_t payload_buffer[PAYLOAD_SIZE_BYTES];
static size_t payload_bytes_received = 0;
static uint8_t index_bytes[2];
static size_t index_bytes_received = 0;
static uint8_t received_checksum = 0;
static uint16_t current_window_idx = 0;

uint8_t calculate_checksum(const uint8_t *data, size_t length)
{
    uint8_t chk = 0;
    for (size_t i = 0; i < length; ++i)
    {
        chk ^= data[i];
    }
    return chk;
}

void uart_stream_init(void)
{
    current_state = UART_STATE_WAIT_HEADER_1;
    payload_bytes_received = 0;
    index_bytes_received = 0;
}

bool uart_stream_process_byte(uint8_t byte, WindowPacket *out_packet)
{
    switch (current_state)
    {
    case UART_STATE_WAIT_HEADER_1:
        if (byte == UART_FRAME_HEADER_1)
        {
            current_state = UART_STATE_WAIT_HEADER_2;
        }
        break;

    case UART_STATE_WAIT_HEADER_2:
        if (byte == UART_FRAME_HEADER_2)
        {
            current_state = UART_STATE_READ_INDEX;
            index_bytes_received = 0;
        }
        else
        {
            current_state = UART_STATE_WAIT_HEADER_1;
        }
        break;

    case UART_STATE_READ_INDEX:
        index_bytes[index_bytes_received++] = byte;
        if (index_bytes_received >= 2)
        {
            current_window_idx = (uint16_t)(index_bytes[0] | (index_bytes[1] << 8));
            current_state = UART_STATE_READ_PAYLOAD;
            payload_bytes_received = 0;
        }
        break;

    case UART_STATE_READ_PAYLOAD:
        payload_buffer[payload_bytes_received++] = byte;
        if (payload_bytes_received >= PAYLOAD_SIZE_BYTES)
        {
            current_state = UART_STATE_CHECK_SUM;
        }
        break;

    case UART_STATE_CHECK_SUM:
        received_checksum = byte;
        current_state = UART_STATE_WAIT_TAIL_1;
        break;

    case UART_STATE_WAIT_TAIL_1:
        if (byte == UART_FRAME_TAIL_1)
        {
            current_state = UART_STATE_WAIT_TAIL_2;
        }
        else
        {
            current_state = UART_STATE_WAIT_HEADER_1;
        }
        break;

    case UART_STATE_WAIT_TAIL_2:
        current_state = UART_STATE_WAIT_HEADER_1;
        if (byte == UART_FRAME_TAIL_2)
        {
            // Kiểm tra XOR Checksum của payload
            uint8_t computed_chk = calculate_checksum(payload_buffer, PAYLOAD_SIZE_BYTES);
            if (computed_chk == received_checksum)
            {
                if (out_packet != NULL)
                {
                    out_packet->window_index = current_window_idx;
                    memcpy(out_packet->samples, payload_buffer, PAYLOAD_SIZE_BYTES);
                }
                return true; // Khung trọn vẹn và hợp lệ
            }
        }
        break;

    default:
        current_state = UART_STATE_WAIT_HEADER_1;
        break;
    }

    return false;
}