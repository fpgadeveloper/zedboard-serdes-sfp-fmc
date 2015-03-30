/*
 * Opsero Electronic Design Inc.
 *
 * Description:
 * This code is derived from the Scatter Gather DMA example code supplied
 * by Xilinx. It is used here to test the SERDES FMC in loopback by
 * using the DMAs to feed the AXI-Streaming interfaces of the AXI SERDES IP
 * with data. The received data is then compared with the sent data to verify
 * correct operation of the SERDES FMC.
 *
 */
/***************************** Include Files *********************************/
#include "xaxidma.h"
#include "xbasic_types.h"
#include "xparameters.h"
#include "xdebug.h"
#include "platform.h"
#if (!defined(DEBUG))
extern void xil_printf(const char *format, ...);
#endif
/******************** Constant Definitions **********************************/
/*
 * Device hardware build related constants.
 */
#define DMA0_DEV_ID XPAR_AXIDMA_0_DEVICE_ID
#define DMA1_DEV_ID XPAR_AXIDMA_1_DEVICE_ID
#define MEM_BASE_ADDR 0x1F000000
#define TX_BD_SPACE_BASE (MEM_BASE_ADDR)
#define TX_BD_SPACE_HIGH (MEM_BASE_ADDR + 0x00000FFF)
#define RX_BD_SPACE_BASE (MEM_BASE_ADDR + 0x00001000)
#define RX_BD_SPACE_HIGH (MEM_BASE_ADDR + 0x00001FFF)
#define TX_BUFFER_BASE (MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE (MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH (MEM_BASE_ADDR + 0x004FFFFF)
#define MAX_PKT_LEN 0x20
#define TEST_START_VALUE 0xC
/**************************** Type Definitions *******************************/
/***************** Macros (Inline Functions) Definitions *********************/
/************************** Function Prototypes ******************************/
static int RxSetup(XAxiDma * AxiDmaInstPtr);
static int TxSetup(XAxiDma * AxiDmaInstPtr);
static int SendPacket(XAxiDma * AxiDmaInstPtr);
static int CheckData(void);
static int CheckDmaResult(XAxiDma * TxAxiDmaInstPtr,XAxiDma * RxAxiDmaInstPtr);
/************************** Variable Definitions *****************************/
/*
 * Device instance definitions
 */
XAxiDma AxiDma0;
XAxiDma AxiDma1;
/*
 * Buffer for transmit packet. Must be 32-bit aligned to be used by DMA.
 */
u32 *Packet = (u32 *) TX_BUFFER_BASE;

Xuint32 *baseaddr_p = (Xuint32 *)XPAR_AXI_SERDES_FMC_0_S00_AXI_BASEADDR;

/*****************************************************************************/
/**
 *
 * Main function
 *
 * This function is the main entry of the tests on DMA core. It sets up
 * DMA engine to be ready to receive and send packets, then a packet is
 * transmitted and will be verified after it is received via the DMA loopback
 * widget.
 *
 * @param None
 *
 * @return
 * - XST_SUCCESS if test passes
 * - XST_FAILURE if test fails.
 *
 * @note None.
 *
 ******************************************************************************/
int main(void)
{
	int Status;
	XAxiDma_Config *Config;
	volatile Xuint32 reg;

	init_platform();
	xil_printf("\r\n--- Entering main() --- \r\n");

	// Reset transceiver 0
	reg = *baseaddr_p;
	reg &= ~(1 << 0);
	reg &= ~(1 << 16);
	*baseaddr_p = reg;
	// Reset transceiver 1
	reg = *(baseaddr_p+1);
	reg &= ~(1 << 0);
	reg &= ~(1 << 16);
	*(baseaddr_p+1) = reg;
	xil_printf("Reset transceivers\r\n");

	// Release Reset transceiver 0
	reg = *baseaddr_p;
	reg |= (1 << 0);
	reg |= (1 << 16);
	*baseaddr_p = reg;
	// Release Reset transceiver 1
	reg = *(baseaddr_p+1);
	reg |= (1 << 0);
	reg |= (1 << 16);
	*(baseaddr_p+1) = reg;
	xil_printf("Released reset\r\n");

	// wait for locks
	xil_printf("Waiting for tx lock\r\n");
	reg = *baseaddr_p;
	while(reg & (Xuint32)(1 << 8))
		reg = *baseaddr_p;
	xil_printf("Waiting for rx lock\r\n");
	while(reg & (Xuint32)(1 << 24))
		reg = *(baseaddr_p+1);
	while((reg & (Xuint32)(1 << 8)) || (reg & (Xuint32)(1 << 24)))
		reg = *(baseaddr_p+1);

	// allow 110 SYNC symbols

	for(reg = 0; reg < 10000000; reg++){
		if(reg == 9000000)
			break;
	}

	// Set loopback mode trx0
	reg = *baseaddr_p;
	reg &= ~(1 << 18);
	//reg |= (1 << 18);
	*baseaddr_p = reg;
	// Set loopback mode trx1
	reg = *(baseaddr_p+1);
	reg &= ~(1 << 18);
	//reg |= (1 << 18);
	*(baseaddr_p+1) = reg;

	xil_printf("Register0: 0x%08X\r\n", *baseaddr_p);
	xil_printf("Register1: 0x%08X\r\n", *(baseaddr_p+1));

	/* Configure DMA engine 0 */
	Config = XAxiDma_LookupConfig(DMA0_DEV_ID);
	if (!Config) {
		xil_printf("DMA0 No config found for %d\r\n", DMA0_DEV_ID);
		return XST_FAILURE;
	}
	/* Initialize DMA engine 0 */
	Status = XAxiDma_CfgInitialize(&AxiDma0, Config);
	if (Status != XST_SUCCESS) {
		xil_printf("DMA0 Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}
	if(!XAxiDma_HasSg(&AxiDma0)) {
		xil_printf("DMA0 Device configured as Simple mode \r\n");
		return XST_FAILURE;
	}
	/* Configure DMA engine 1 */
	Config = XAxiDma_LookupConfig(DMA1_DEV_ID);
	if (!Config) {
		xil_printf("DMA1 No config found for %d\r\n", DMA1_DEV_ID);
		return XST_FAILURE;
	}
	/* Initialize DMA engine 1 */
	Status = XAxiDma_CfgInitialize(&AxiDma1, Config);
	if (Status != XST_SUCCESS) {
		xil_printf("DMA1 Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}
	if(!XAxiDma_HasSg(&AxiDma1)) {
		xil_printf("DMA1 Device configured as Simple mode \r\n");
		return XST_FAILURE;
	}

	/* Setup Transfer from DMA0 to DMA1 */
	xil_printf("TxSetup\r\n");
	Status = TxSetup(&AxiDma0);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	xil_printf("RxSetup\r\n");
	Status = RxSetup(&AxiDma1);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/* Send a packet */
	xil_printf("SendPacket\r\n");
	Status = SendPacket(&AxiDma0);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	/* Check DMA transfer result */
	xil_printf("CheckDmaResult\r\n");
	Status = CheckDmaResult(&AxiDma0,&AxiDma1);
	xil_printf("AXI DMA SG Polling Test %s\r\n",
			(Status == XST_SUCCESS)? "passed":"failed");
	xil_printf("--- Exiting main() --- \r\n");
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
/*****************************************************************************/
/**
 *
 * This function sets up RX channel of the DMA engine to be ready for packet
 * reception
 *
 * @param AxiDmaInstPtr is the pointer to the instance of the DMA engine.
 *
 * @return XST_SUCCESS if the setup is successful, XST_FAILURE otherwise.
 *
 * @note None.
 *
 ******************************************************************************/
static int RxSetup(XAxiDma * AxiDmaInstPtr)
{
	XAxiDma_BdRing *RxRingPtr;
	int Delay = 0;
	int Coalesce = 1;
	int Status;
	XAxiDma_Bd BdTemplate;
	XAxiDma_Bd *BdPtr;
	XAxiDma_Bd *BdCurPtr;
	u32 BdCount;
	u32 FreeBdCount;
	u32 RxBufferPtr;
	int Index;
	RxRingPtr = XAxiDma_GetRxRing(AxiDmaInstPtr);
	//RxRingPtr = XAxiDma_GetRxRing(&AxiDma);
	/* Disable all RX interrupts before RxBD space setup */
	XAxiDma_BdRingIntDisable(RxRingPtr, XAXIDMA_IRQ_ALL_MASK);
	/* Set delay and coalescing */
	XAxiDma_BdRingSetCoalesce(RxRingPtr, Coalesce, Delay);
	/* Setup Rx BD space */
	BdCount = XAxiDma_BdRingCntCalc(XAXIDMA_BD_MINIMUM_ALIGNMENT,
			RX_BD_SPACE_HIGH - RX_BD_SPACE_BASE + 1);
	Status = XAxiDma_BdRingCreate(RxRingPtr, RX_BD_SPACE_BASE,
			RX_BD_SPACE_BASE,
			XAXIDMA_BD_MINIMUM_ALIGNMENT, BdCount);
	if (Status != XST_SUCCESS) {
		xil_printf("RX create BD ring failed %d\r\n", Status);
		return XST_FAILURE;
	}
	/*
	 * Setup an all-zero BD as the template for the Rx channel.
	 */
	XAxiDma_BdClear(&BdTemplate);
	Status = XAxiDma_BdRingClone(RxRingPtr, &BdTemplate);
	if (Status != XST_SUCCESS) {
		xil_printf("RX clone BD failed %d\r\n", Status);
		return XST_FAILURE;
	}
	/* Attach buffers to RxBD ring so we are ready to receive packets */
	FreeBdCount = XAxiDma_BdRingGetFreeCnt(RxRingPtr);
	Status = XAxiDma_BdRingAlloc(RxRingPtr, FreeBdCount, &BdPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("RX alloc BD failed %d\r\n", Status);
		return XST_FAILURE;
	}
	BdCurPtr = BdPtr;
	RxBufferPtr = RX_BUFFER_BASE;
	for (Index = 0; Index < FreeBdCount; Index++) {
		Status = XAxiDma_BdSetBufAddr(BdCurPtr, RxBufferPtr);
		if (Status != XST_SUCCESS) {
			xil_printf("Set buffer addr %x on BD %x failed %d\r\n",
					(unsigned int)RxBufferPtr,
					(unsigned int)BdCurPtr, Status);
			return XST_FAILURE;
		}
		Status = XAxiDma_BdSetLength(BdCurPtr, MAX_PKT_LEN,
				RxRingPtr->MaxTransferLen);
		if (Status != XST_SUCCESS) {
			xil_printf("Rx set length %d on BD %x failed %d\r\n",
					MAX_PKT_LEN, (unsigned int)BdCurPtr, Status);
			return XST_FAILURE;
		}
		/* Receive BDs do not need to set anything for the control
		 * The hardware will set the SOF/EOF bits per stream status
		 */
		XAxiDma_BdSetCtrl(BdCurPtr, 0);
		XAxiDma_BdSetId(BdCurPtr, RxBufferPtr);
		RxBufferPtr += MAX_PKT_LEN;
		BdCurPtr = XAxiDma_BdRingNext(RxRingPtr, BdCurPtr);
	}
	/* Clear the receive buffer, so we can verify data
	 */
	memset((void *)RX_BUFFER_BASE, 0, MAX_PKT_LEN);
	Status = XAxiDma_BdRingToHw(RxRingPtr, FreeBdCount,
			BdPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("RX submit hw failed %d\r\n", Status);
		return XST_FAILURE;
	}
	/* Start RX DMA channel */
	Status = XAxiDma_BdRingStart(RxRingPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("RX start hw failed %d\r\n", Status);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
/*****************************************************************************/
/**
 *
 * This function sets up the TX channel of a DMA engine to be ready for packet
 * transmission
 *
 * @param AxiDmaInstPtr is the instance pointer to the DMA engine.
 *
 * @return XST_SUCCESS if the setup is successful, XST_FAILURE otherwise.
 *
 * @note None.
 *
 ******************************************************************************/
static int TxSetup(XAxiDma * AxiDmaInstPtr)
{
	XAxiDma_BdRing *TxRingPtr;
	XAxiDma_Bd BdTemplate;
	int Delay = 0;
	int Coalesce = 1;
	int Status;
	u32 BdCount;
	TxRingPtr = XAxiDma_GetTxRing(AxiDmaInstPtr);
	/* Disable all TX interrupts before TxBD space setup */
	XAxiDma_BdRingIntDisable(TxRingPtr, XAXIDMA_IRQ_ALL_MASK);
	/* Set TX delay and coalesce */
	XAxiDma_BdRingSetCoalesce(TxRingPtr, Coalesce, Delay);
	/* Setup TxBD space */
	BdCount = XAxiDma_BdRingCntCalc(XAXIDMA_BD_MINIMUM_ALIGNMENT,
			TX_BD_SPACE_HIGH - TX_BD_SPACE_BASE + 1);
	Status = XAxiDma_BdRingCreate(TxRingPtr, TX_BD_SPACE_BASE,
			TX_BD_SPACE_BASE,
			XAXIDMA_BD_MINIMUM_ALIGNMENT, BdCount);
	if (Status != XST_SUCCESS) {
		xil_printf("failed create BD ring in txsetup\r\n");
		return XST_FAILURE;
	}
	/*
	 * We create an all-zero BD as the template.
	 */
	XAxiDma_BdClear(&BdTemplate);
	Status = XAxiDma_BdRingClone(TxRingPtr, &BdTemplate);
	if (Status != XST_SUCCESS) {
		xil_printf("failed bdring clone in txsetup %d\r\n", Status);
		return XST_FAILURE;
	}
	/* Start the TX channel */
	Status = XAxiDma_BdRingStart(TxRingPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("failed start bdring txsetup %d\r\n", Status);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
/*****************************************************************************/
/**
 *
 * This function transmits one packet non-blockingly through the DMA engine.
 *
 * @param AxiDmaInstPtr points to the DMA engine instance
 *
 * @return - XST_SUCCESS if the DMA accepts the packet successfully,
 * - XST_FAILURE otherwise.
 *
 * @note None.
 *
 ******************************************************************************/
static int SendPacket(XAxiDma * AxiDmaInstPtr)
{
	XAxiDma_BdRing *TxRingPtr;
	u8 *TxPacket;
	u8 Value;
	XAxiDma_Bd *BdPtr;
	int Status;
	int Index;
	TxRingPtr = XAxiDma_GetTxRing(AxiDmaInstPtr);
	/* Create pattern in the packet to transmit */
	TxPacket = (u8 *) Packet;
	Value = 0x01;
	for(Index = 0; Index < MAX_PKT_LEN; Index++) {
		TxPacket[Index] = Value;
		//TxPacket[Index] = Value + Value*16;

		/*
		TxPacket[Index] = 0x01;
		TxPacket[Index+1] = 0x02;
		TxPacket[Index+2] = 0x02;
		TxPacket[Index+3] = 0x03;
		TxPacket[Index+4] = 0x23;
		TxPacket[Index+5] = 0x45;
		TxPacket[Index+6] = 0x67;
		TxPacket[Index+7] = 0x89;*/
		Value = (Value + 1) & 0xFF;
		//Value = Value ^ 0xFF;
	}
	xil_printf("Transmit packet: ");
	for(Index = 0; Index < MAX_PKT_LEN; Index++)
		xil_printf("%02X ",TxPacket[Index]);
	xil_printf("\r\n");
	/* Flush the SrcBuffer before the DMA transfer, in case the Data Cache
	 * is enabled
	 */
	Xil_DCacheFlushRange((u32)TxPacket, MAX_PKT_LEN);
	/* Allocate a BD */
	Status = XAxiDma_BdRingAlloc(TxRingPtr, 1, &BdPtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	/* Set up the BD using the information of the packet to transmit */
	Status = XAxiDma_BdSetBufAddr(BdPtr, (u32) Packet);
	if (Status != XST_SUCCESS) {
		xil_printf("Tx set buffer addr %x on BD %x failed %d\r\n",
				(unsigned int)Packet, (unsigned int)BdPtr, Status);
		return XST_FAILURE;
	}
	Status = XAxiDma_BdSetLength(BdPtr, MAX_PKT_LEN,
			TxRingPtr->MaxTransferLen);
	if (Status != XST_SUCCESS) {
		xil_printf("Tx set length %d on BD %x failed %d\r\n",
				MAX_PKT_LEN, (unsigned int)BdPtr, Status);
		return XST_FAILURE;
	}
#if (XPAR_AXIDMA_0_SG_INCLUDE_STSCNTRL_STRM == 1)
	Status = XAxiDma_BdSetAppWord(BdPtr,
			XAXIDMA_LAST_APPWORD, MAX_PKT_LEN);
	/* If Set app length failed, it is not fatal
	 */
	if (Status != XST_SUCCESS) {
		xil_printf("Set app word failed with %d\r\n", Status);
	}
#endif
	/* For single packet, both SOF and EOF are to be set
	 */
	XAxiDma_BdSetCtrl(BdPtr, XAXIDMA_BD_CTRL_TXEOF_MASK |
			XAXIDMA_BD_CTRL_TXSOF_MASK);
	XAxiDma_BdSetId(BdPtr, (u32) Packet);
	/* Give the BD to DMA to kick off the transmission. */
	Status = XAxiDma_BdRingToHw(TxRingPtr, 1, BdPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("to hw failed %d\r\n", Status);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
/*****************************************************************************/
/*
 *
 * This function checks data buffer after the DMA transfer is finished.
 *
 * @param None
 *
 * @return - XST_SUCCESS if validation is successful
 * - XST_FAILURE if validation is failure.
 *
 * @note None.
 *
 ******************************************************************************/
static int CheckData(void)
{
	u8 *RxPacket;
	int Index = 0;
	u8 Value;
	RxPacket = (u8 *) RX_BUFFER_BASE;
	Value = TEST_START_VALUE;
	/* Invalidate the DestBuffer before receiving the data, in case the
	 * Data Cache is enabled
	 */
	Xil_DCacheInvalidateRange((u32)RxPacket, MAX_PKT_LEN);
	xil_printf("Received packet: ");
	for(Index = 0; Index < MAX_PKT_LEN; Index++) {
		xil_printf("%02X ",RxPacket[Index]);
		/*
		if (RxPacket[Index] != Value) {
			xil_printf("\r\nData error %d: %x/%x\r\n",
					Index, (unsigned int)RxPacket[Index],
					(unsigned int)Value);
			return XST_FAILURE;
		}
		*/
		Value = (Value + 1) & 0xFF;
	}
	xil_printf("\r\n");
	return XST_SUCCESS;
}
/*****************************************************************************/
/**
 *
 * This function waits until the DMA transaction is finished, checks data,
 * and cleans up.
 *
 * @param None
 *
 * @return - XST_SUCCESS if DMA transfer is successful and data is correct,
 * - XST_FAILURE if fails.
 *
 * @note None.
 *
 ******************************************************************************/
static int CheckDmaResult(XAxiDma * TxAxiDmaInstPtr,XAxiDma * RxAxiDmaInstPtr)
{
	XAxiDma_BdRing *TxRingPtr;
	XAxiDma_BdRing *RxRingPtr;
	XAxiDma_Bd *BdPtr;
	int ProcessedBdCount;
	int FreeBdCount;
	int Status;
	TxRingPtr = XAxiDma_GetTxRing(TxAxiDmaInstPtr);
	RxRingPtr = XAxiDma_GetRxRing(RxAxiDmaInstPtr);
	/* Wait until the one BD TX transaction is done */
	//xil_printf("Wait until the one BD TX transaction is done\r\n");
	while ((ProcessedBdCount = XAxiDma_BdRingFromHw(TxRingPtr,
			XAXIDMA_ALL_BDS,
			&BdPtr)) == 0) {
	}
	/* Free all processed TX BDs for future transmission */
	//xil_printf("Free all processed TX BDs for future transmission\r\n");
	Status = XAxiDma_BdRingFree(TxRingPtr, ProcessedBdCount, BdPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed to free %d tx BDs %d\r\n",
				ProcessedBdCount, Status);
		return XST_FAILURE;
	}
	/* Wait until the data has been received by the Rx channel */
	//xil_printf("Wait until the data has been received by the Rx channel\r\n");
	while ((ProcessedBdCount = XAxiDma_BdRingFromHw(RxRingPtr,
			XAXIDMA_ALL_BDS,
			&BdPtr)) == 0) {
	}
	/* Check received data */
	if (CheckData() != XST_SUCCESS) {
		return XST_FAILURE;
	}
	/* Free all processed RX BDs for future transmission */
	//xil_printf("Free all processed RX BDs for future transmission\r\n");
	Status = XAxiDma_BdRingFree(RxRingPtr, ProcessedBdCount, BdPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Failed to free %d rx BDs %d\r\n",
				ProcessedBdCount, Status);
		return XST_FAILURE;
	}
	/* Return processed BDs to RX channel so we are ready to receive new
	 * packets:
	 * - Allocate all free RX BDs
	 * - Pass the BDs to RX channel
	 */
	//xil_printf("Return processed BDs to RX channel so we are ready to receive new\r\n");
	FreeBdCount = XAxiDma_BdRingGetFreeCnt(RxRingPtr);
	Status = XAxiDma_BdRingAlloc(RxRingPtr, FreeBdCount, &BdPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("bd alloc failed\r\n");
		return XST_FAILURE;
	}
	Status = XAxiDma_BdRingToHw(RxRingPtr, FreeBdCount, BdPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Submit %d rx BDs failed %d\r\n", FreeBdCount, Status);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}
