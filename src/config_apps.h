/*
 * config.h
 *
 * Configuration file
 * Used to configure the servers to run and its parameters
 *
 *  Created on: Feb 7, 2024
 *      Author: dcdealme
 */

// Define this to enable debugging messages via UART
//#define UART_DEBUG

// Network mask and gateway
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"10.0.0.254"

// Define the board IP to a specific IP address
// By default the board IP will be 10.0.0.sw, where sw is the board switch configuration
//#define BOARD_IP "10.0.0.100"

// Applications to run
#define TCP_SERVER_APP  0
#define UDP_SERVER_APP  1
#define TFTP_SERVER_APP 1
#define WEB_SERVER_APP  1

// TCP Server Parameters
#define TCP_SERVER_PORT 40000
#define HEAD_TCP_SERVER_IP "10.0.0.254"
#define HEAD_TCP_SERVER_PORT 50000

// UDP Server Parameters
#define UDP_SERVER_PORT 40001
#define HEAD_UDP_SERVER_IP "10.0.0.254"
#define HEAD_UDP_SERVER_PORT 50001
#define BROADCAST_IP "10.0.0.255"

// TFTP Server Parameters
#define TFTP_PORT 69

// WEB Server Parameters
#define HTTP_PORT 80
