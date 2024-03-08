/*
 * compute.c
 *
 *  Created on: Nov 29, 2023
 *      Author: dcdealme
 */

#include <stdio.h>
#include <string.h>
#include "xilmfs.h" // to interact with file system
#include "config_apps.h"
#include "myserver_utils.h"

#define PARAMS_FILENAME "params.txt"

void send_error_message(char * msg)
{
//	tcp_send_message(msg, HEAD_TCP_SERVER_IP, HEAD_TCP_SERVER_PORT);
	udp_send_message(msg, HEAD_UDP_SERVER_IP, HEAD_UDP_SERVER_PORT);
}

// This is the node compute function
// It read two integers from the buffer (it contains the TCP payload)
// Multiply the numbers and write back result to the buffer
void
compute(char *buffer, uint16_t buffer_len)
{
	int num1, num2;
	int result;
	int err;
	int fd;

	// Open file with computation parameters
	/* making sure the file exists and we can read the file */
	if (mfs_exists_file(PARAMS_FILENAME) != 1) {
		send_error_message("Unable to open parameters file!\r\n");
		return;
	}

	fd = mfs_file_open(PARAMS_FILENAME, MFS_MODE_READ);

	// Try to read the file into buffer
	if (mfs_file_read(fd, buffer, buffer_len) == 0)
	{
		send_error_message("Problem while reading the parameters file!\r\n");
		return;
	}

	// Extract parameters from file
	err = sscanf(buffer, "%d %d", &num1, &num2);

	if (err != 2)
	{
		send_error_message("The content of the file is not valid!\r\n");
		return;
	}
	else
	{
		result = num1 * num2;
		sprintf(buffer, "%d\n\r", result);
	}

	//tcp_send_message(buffer, HEAD_TCP_SERVER_IP, HEAD_TCP_SERVER_PORT);
	udp_send_message(buffer, HEAD_UDP_SERVER_IP, HEAD_UDP_SERVER_PORT);

}
