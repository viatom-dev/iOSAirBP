//
//  BTDefines.h
//  Checkme Mobile
//
//  Created by Joe on 14/9/20.
//  Copyright (c) 2014 VIATOM. All rights reserved.
//

#ifndef Checkme_Mobile_BTDefines_h
#define Checkme_Mobile_BTDefines_h


/**
 *  fileType  for request listData through blueTooth
 */
#define FILE_Type_None 0x00
#define FILE_Type_UserList 0x01
#define FILE_Type_xuserList  0x0E
#define FILE_Type_EcgList 0x03


/**
 *  FileType for request detailData through blueTooth
 */
#define FILE_Type_EcgDetailData 0x07
#define FILE_Type_ECGVoiceData 0x08
#define FILE_Type_SpcVoiceData 0x11

#define FILE_Type_Lang_Patch 0x0C
#define FILE_Type_App_Patch 0x0D


//Bluetooth write
#define WRITE_CONTENT_PKG_DATA_LENGTH 512
#define READ_CONTENT_ACK_DATA_LENGTH 512

//Bluetooth file name is long
#define BT_WRITE_FILE_NAME_MAX_LENGTH 30
#define BT_READ_FILE_NAME_MAX_LENGTH 30

//Bluetooth command word
#define CMD_WORD_START_WRITE  0x00
#define CMD_WORD_WRITE_CONTENT  0x01
#define CMD_WORD_END_WRITE  0x02
#define CMD_WORD_READ_CONTENT  0x04
#define CMD_WORD_END_READ  0x05

#define CMD_WORD_LANG_UPDATE_START 0x0A
#define CMD_WORD_LANG_UPDATE_DATA 0x0B
#define CMD_WORD_LANG_UPDATE_END 0x0C
#define CMD_WORD_APP_UPDATE_START 0x0D
#define CMD_WORD_APP_UPDATE_DATA 0x0E
#define CMD_WORD_APP_UPDATE_END 0x0F


#define BT_STATUS_WAITING_NONE 0

#define BT_STATUS_WAITING_START_WRITE_ACK 101
#define BT_STATUS_WAITING_WRITE_CONTENT_ACK 102
#define BT_STATUS_WAITING_END_WRITE_ACK 103
#define BT_STATUS_WAITING_START_READ_ACK 104
#define BT_STATUS_WAITING_READ_CONTENT_ACK 105
#define BT_STATUS_WAITING_END_READ_ACK 106
#define BT_STATUS_WAITING_PING_ACK 107

#define BT_STATUS_WAITING_DEL_INFO_ACK 108


/** Set time */
#define BT_STATUS_WAITING_UPDATA_TIME_ACK 33


/** echo */
#define BT_STATUS_WAITING_ECHO_ACK 0xE0

/** Get device information */
#define BT_STATUS_WAITING_GET_INFO_ACK 0xE1

/** reset */
#define BT_STATUS_WAITING_RESET_ACK 0xE2

/** Restore factory settings */
#define BT_STATUS_WAITING_Restorefactory_Setting_ACK 0xE3

/** Get battery status */
#define BT_STATUS_WAITING_Battery_Status_ACK 0xE4

/** Start firmware upgrade */
#define BT_STATUS_WAITING_Firmware_Upgrade_ACK 0xE5

/** Firmware upgrade data */
#define BT_STATUS_WAITING_Firmware_Upgrade_DATA_ACK 0xE6

/** End of firmware upgrade */
#define BT_STATUS_WAITING_END_Firmware_Upgrade_ACK 0xE7

/** Start language pack upgrade */
#define BT_STATUS_WAITING_START_Language_Pack_Upgrade_ACK 0xE8

/** Language pack upgrade is over */
#define BT_STATUS_WAITING_Language_Pack_Upgrade_Over_ACK 0xE9

/** Burn factory information */
#define BT_STATUS_WAITING_FactoryConfig_Setting_ACK 0xEA

/** Encrypted flash */
#define BT_STATUS_WAITING_Encrypted_Flash_ACK 0xEB

/** Set time */
#define BT_STATUS_WAITING_Time_Setting_ACK 0xEC

/** Get host temperature */
#define BT_STATUS_WAITING_GET_Temp_ACK 0xED

/** Get file list */
#define BT_STATUS_WAITING_ _ACK 0xF1

/** Start reading file */
#define BT_STATUS_WAITING_Start_Reading_File_ACK 0xF2

/** Read file data */
#define BT_STATUS_WAITING_Read_File_Data_ACK 0xF3

/** End of reading file */
#define BT_STATUS_WAITING_End_Reading_File_ACK 0xF4

/** Start writing file */
#define BT_STATUS_WAITING_Start_Writing_File_ACK 0xF5

/** Write file content */
#define BT_STATUS_WAITING_Write_File_Content_ACK 0xF6

/** End of writing file */
#define BT_STATUS_WAITING_End_Writing_File_ACK 0xF7

/** Delete Files */
#define BT_STATUS_WAITING_Delete_Files_ACK 0xF8

/** Get user list */
#define BT_STATUS_WAITING_Get_User_List_ACK 0xF9



/** Get settings configuration parameters */
#define BT_STATUS_WAITING_GET_Configuartion_ACK 0x00

/** Zeroed out */
#define BT_STATUS_WAITING_SET_CalibrationZero_ACK 0x01

/** calibration */
#define BT_STATUS_WAITING_SET_CalibrationSlope_ACK 0x02

/** Set stop pumping pressure value */
#define BT_STATUS_WAITING_SET_StopPressure_ACK 0x03

/** Start measurement */
#define BT_STATUS_WAITING_START_Measure_ACK 0x04

/** Stop measurement */
#define BT_STATUS_WAITING_END_Measure_ACK 0x05

/** Current running status (Prompt message and sent when the algorithm running state is switched) */
#define BT_STATUS_WAITING_Current_Running_Status_ACK 0x06

/** Measurement result(The host takes the initiative to send at the end of the measurement) */
#define BT_STATUS_WAITING_Measure_Result_ACK 0x07

/** Engineering start measurement (engineering mode) */
#define BT_STATUS_WAITING_Engineering_Start_Measurement_ACK 0x08

/** Buzzer switch */
#define BT_STATUS_WAITING_Buzzer_Witch_ACK 0x09



#define BT_STATUS_WAITING_GET_FILELIST_ACK 50



//New Bluetooth communication protocol
#define COMMON_PKG_LENGTH 8
#define COMMON_ACK_PKG_LENGTH 12
#define READ_CONTENT_ACK_PKG_FRONT_LENGTH 8
#define GET_INFO_ACK_PKG_LENGTH (COMMON_PKG_LENGTH + 256)
#define UPData_TIME_ACK_PKG_LENGTH 4


#define ACK_CMD_OK 0
#define ACK_CMD_BAD 1


//airtrace parameter
#define type_other       0x00
#define type_ECG         0x01
#define type_oxi         0x02
#define type_resp        0x03
#define type_art         0x04
#define type_ECG_oxi     0x05


#define LE_P2U16(p,u) do{u=0;u = (p)[0]|((p)[1]<<8);}while(0)

#define LE_P2U32(p,u) do{u=0;u = (p)[0]|((p)[1]<<8)|((p)[2]<<16)|((p)[3]<<24);}while(0)

#define BE_P2U16(p,u) do{u=0;u = ((p)[0]<<8)|((p)[1]);}while(0)
#define BE_P2U32(p,u) do{u=0;u = ((p)[0]<<24)|((p)[1]<<16)|((p)[2]<<8)|((p)[3]);}while(0)

#define P2U16(p,u) LE_P2U16((p),(u))
#define P2U32(p,u) LE_P2U32((p),(u))

#endif
