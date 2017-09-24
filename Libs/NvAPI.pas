{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
(*****************************************************************************
|*                                                                           *|
|*      Copyright 2005-2008 NVIDIA Corporation.  All rights reserved.        *|
|*                                                                           *|
|*   NOTICE TO USER:                                                         *|
|*                                                                           *|
|*   This source code is subject to NVIDIA ownership rights under U.S.       *|
|*   and international Copyright laws.  Users and possessors of this         *|
|*   source code are hereby granted a nonexclusive, royalty-free             *|
|*   license to use this code in individual and commercial software.         *|
|*                                                                           *|
|*   NVIDIA MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS SOURCE     *|
|*   CODE FOR ANY PURPOSE. IT IS PROVIDED "AS IS" WITHOUT EXPRESS OR         *|
|*   IMPLIED WARRANTY OF ANY KIND. NVIDIA DISCLAIMS ALL WARRANTIES WITH      *|
|*   REGARD TO THIS SOURCE CODE, INCLUDING ALL IMPLIED WARRANTIES OF         *|
|*   MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR          *|
|*   PURPOSE. IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY SPECIAL,            *|
|*   INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES          *|
|*   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN      *|
|*   AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING     *|
|*   OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOURCE      *|
|*   CODE.                                                                   *|
|*                                                                           *|
|*   U.S. Government End Users. This source code is a "commercial item"      *|
|*   as that term is defined at 48 C.F.R. 2.101 (OCT 1995), consisting       *|
|*   of "commercial computer  software" and "commercial computer software    *|
|*   documentation" as such terms are used in 48 C.F.R. 12.212 (SEPT 1995)   *|
|*   and is provided to the U.S. Government only as a commercial end item.   *|
|*   Consistent with 48 C.F.R.12.212 and 48 C.F.R. 227.7202-1 through        *|
|*   227.7202-4 (JUNE 1995), all U.S. Government End Users acquire the       *|
|*   source code with only those rights set forth herein.                    *|
|*                                                                           *|
|*   Any use of this source code in individual and commercial software must  *|
|*   include, in the user documentation and internal comments to the code,   *|
|*   the above Disclaimer and U.S. Government End Users Notice.              *|
|*                                                                           *|
|*                                                                           *|
 *****************************************************************************)

{ Header translation by (2008) Andreas Hausladen (Andreas DOTT Hausladen ATT gmx DOTT de) }

///////////////////////////////////////////////////////////////////////////////
//
// Date: Aug 24, 2008
// File: nvapi.h
//
// NvAPI provides an interface to NVIDIA devices. This file contains the
// interface constants, structure definitions and function prototypes.
//
// Target Profile: developer
// Target OS-Arch: windows
//
///////////////////////////////////////////////////////////////////////////////

unit NvAPI;

interface

// ====================================================
// Universal NvAPI Definitions
// ====================================================

{ 64-bit types for compilers that support them, plus some obsolete variants }
type
  {$IF declared(UInt64)}
  NvU64 = UInt64;                 { 0 to 18446744073709551615 }
  {$ELSE}
  NvU64 = Int64;                 { 0 to 18446744073709551615 }
  {$IFEND}

// mac os 32-bit still needs this
  NvS32 = Longint;                { -2147483648 to 2147483647 }

  NvU32 = LongWord;
  NvU16 = Word;
  NvU8 = Byte;
  PNvU8 = ^NvU8;

// NVAPI Handles - These handles are retrieved from various calls and passed in to others in NvAPI
//                 These are meant to be opaque types.  Do not assume they correspond to indices, HDCs,
//                 display indexes or anything else.
//
//                 Most handles remain valid until a display re-configuration (display mode set) or GPU
//                 reconfiguration (going into or out of SLI modes) occurs.  If NVAPI_HANDLE_INVALIDATED
//                 is received by an app, it should discard all handles, and re-enumerate them.
//

  // Display Device driven by NVIDIA GPU(s) (an attached display)
  NvDisplayHandle__ = record end;
  PNvDisplayHandle = ^NvDisplayHandle__;

  // Unattached Display Device driven by NVIDIA GPU(s)
  NvUnAttachedDisplayHandle__ = record end;
  PNvUnAttachedDisplayHandle = ^NvUnAttachedDisplayHandle__;

  // One or more physical GPUs acting in concert (SLI)
  NvLogicalGpuHandle__ = record end;
  PNvLogicalGpuHandle = ^NvLogicalGpuHandle__;

  // A single physical GPU
  NvPhysicalGpuHandle__ = record end;
  PNvPhysicalGpuHandle = ^NvPhysicalGpuHandle__;

  // A handle to an event registration instance
  NvEventHandle__ = record end;
  PNvEventHandle = ^NvEventHandle__;

const
  NVAPI_DEFAULT_HANDLE     = 0;
  NVAPI_GENERIC_STRING_MAX = 4096;
  NVAPI_LONG_STRING_MAX    = 256;
  NVAPI_SHORT_STRING_MAX   = 64;

type
  NvSBox = record
    sX: NvS32;
    sY: NvS32;
    sWidth: NvS32;
    sHeight: NvS32;
  end;

const
  NVAPI_MAX_PHYSICAL_GPUS            = 64;
  NVAPI_MAX_LOGICAL_GPUS             = 64;
  NVAPI_MAX_AVAILABLE_GPU_TOPOLOGIES = 256;
  NVAPI_MAX_GPU_TOPOLOGIES           = NVAPI_MAX_PHYSICAL_GPUS;
  NVAPI_MAX_GPU_PER_TOPOLOGY         = 8;
  NVAPI_MAX_DISPLAY_HEADS            = 2;
  NVAPI_MAX_DISPLAYS                 = NVAPI_MAX_PHYSICAL_GPUS * NVAPI_MAX_DISPLAY_HEADS;

  NV_MAX_HEADS        = 4;   // Maximum heads, each with NVAPI_DESKTOP_RES resolution
  NV_MAX_VID_STREAMS  = 4;   // Maximum input video streams, each with a NVAPI_VIDEO_SRC_INFO
  NV_MAX_VID_PROFILES = 4;   // Maximum output video profiles supported

type
  NvAPI_String = array[0..NVAPI_GENERIC_STRING_MAX - 1] of AnsiChar;
  NvAPI_LongString = array[0..NVAPI_LONG_STRING_MAX - 1] of AnsiChar;
  NvAPI_ShortString = array[0..NVAPI_SHORT_STRING_MAX - 1] of AnsiChar;

type
  TNvPhysicalGpuHandleArray = array[0..NVAPI_MAX_PHYSICAL_GPUS - 1] of PNvPhysicalGpuHandle;
  TNvLogicalGpuHandleArray = array[0..NVAPI_MAX_LOGICAL_GPUS - 1] of PNvLogicalGpuHandle;

// =========================================================================================
// NvAPI Version Definition
// Maintain per structure specific version define using the MAKE_NVAPI_VERSION macro.
// Usage: #define NV_GENLOCK_STATUS_VER  MAKE_NVAPI_VERSION(NV_GENLOCK_STATUS, 1)
// =========================================================================================
//#define MAKE_NVAPI_VERSION(typeName,ver) (NvU32)(sizeof(typeName) | ((ver)<<16))
//#define GET_NVAPI_VERSION(ver) (NvU32)((ver)>>16)
//#define GET_NVAPI_SIZE(ver) (NvU32)((ver) & 0xffff)
function GetNvAPIVersion(Ver: NvU32): NvU32; {$IF CompilerVersion >= 18.0} inline; {$IFEND}
function GetNvAPISize(Ver: NvU32): NvU32; {$IF CompilerVersion >= 18.0} inline; {$IFEND}

// ====================================================
// NvAPI Status Values
//    All NvAPI functions return one of these codes.
// ====================================================

type
  NvAPI_Status = (
    NVAPI_OK                                    =  0,      // Success
    NVAPI_ERROR                                 = -1,      // Generic error
    NVAPI_LIBRARY_NOT_FOUND                     = -2,      // nvapi.dll can not be loaded
    NVAPI_NO_IMPLEMENTATION                     = -3,      // not implemented in current driver installation
    NVAPI_API_NOT_INTIALIZED                    = -4,      // NvAPI_Initialize has not been called (successfully)
    NVAPI_INVALID_ARGUMENT                      = -5,      // invalid argument
    NVAPI_NVIDIA_DEVICE_NOT_FOUND               = -6,      // no NVIDIA display driver was found
    NVAPI_END_ENUMERATION                       = -7,      // no more to enum
    NVAPI_INVALID_HANDLE                        = -8,      // invalid handle
    NVAPI_INCOMPATIBLE_STRUCT_VERSION           = -9,      // an argument's structure version is not supported
    NVAPI_HANDLE_INVALIDATED                    = -10,     // handle is no longer valid (likely due to GPU or display re-configuration)
    NVAPI_OPENGL_CONTEXT_NOT_CURRENT            = -11,     // no NVIDIA OpenGL context is current (but needs to be)
    NVAPI_NO_GL_EXPERT                          = -12,     // OpenGL Expert is not supported by the current drivers
    NVAPI_INSTRUMENTATION_DISABLED              = -13,     // OpenGL Expert is supported, but driver instrumentation is currently disabled
    NVAPI_EXPECTED_LOGICAL_GPU_HANDLE           = -100,    // expected a logical GPU handle for one or more parameters
    NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE          = -101,    // expected a physical GPU handle for one or more parameters
    NVAPI_EXPECTED_DISPLAY_HANDLE               = -102,    // expected an NV display handle for one or more parameters
    NVAPI_INVALID_COMBINATION                   = -103,    // used in some commands to indicate that the combination of parameters is not valid
    NVAPI_NOT_SUPPORTED                         = -104,    // Requested feature not supported in the selected GPU
    NVAPI_PORTID_NOT_FOUND                      = -105,    // NO port ID found for I2C transaction
    NVAPI_EXPECTED_UNATTACHED_DISPLAY_HANDLE    = -106,    // expected an unattached display handle as one of the input param
    NVAPI_INVALID_PERF_LEVEL                    = -107,    // invalid perf level
    NVAPI_DEVICE_BUSY                           = -108,    // device is busy, request not fulfilled
    NVAPI_NV_PERSIST_FILE_NOT_FOUND             = -109,    // NV persist file is not found
    NVAPI_PERSIST_DATA_NOT_FOUND                = -110,    // NV persist data is not found
    NVAPI_EXPECTED_TV_DISPLAY                   = -111,    // expected TV output display
    NVAPI_EXPECTED_TV_DISPLAY_ON_DCONNECTOR     = -112,    // expected TV output on D Connector - HDTV_EIAJ4120.
    NVAPI_NO_ACTIVE_SLI_TOPOLOGY                = -113,    // SLI is not active on this device
    NVAPI_SLI_RENDERING_MODE_NOTALLOWED         = -114,    // setup of SLI rendering mode is not possible right now
    NVAPI_EXPECTED_DIGITAL_FLAT_PANEL           = -115,    // expected digital flat panel
    NVAPI_ARGUMENT_EXCEED_MAX_SIZE              = -116,    // argument exceeds expected size
    NVAPI_DEVICE_SWITCHING_NOT_ALLOWED          = -117,    // inhibit ON due to one of the flags in NV_GPU_DISPLAY_CHANGE_INHIBIT or SLI Active
    NVAPI_TESTING_CLOCKS_NOT_SUPPORTED          = -118,    // testing clocks not supported
    NVAPI_UNKNOWN_UNDERSCAN_CONFIG              = -119,    // the specified underscan config is from an unknown source (e.g. INF)
    NVAPI_TIMEOUT_RECONFIGURING_GPU_TOPO        = -120,    // timeout while reconfiguring GPUs
    NVAPI_DATA_NOT_FOUND                        = -121,    // Requested data was not found
    NVAPI_EXPECTED_ANALOG_DISPLAY               = -122,    // expected analog display
    NVAPI_NO_VIDLINK                            = -123,    // No SLI video bridge present
    NVAPI_REQUIRES_REBOOT                       = -124,    // NVAPI requires reboot for its settings to take effect
    NVAPI_INVALID_HYBRID_MODE                   = -125,    // the function is not supported with the current hybrid mode.
    NVAPI_MIXED_TARGET_TYPES                    = -126,    // The target types are not all the same
    NVAPI_SYSWOW64_NOT_SUPPORTED                = -127,    // the function is not supported from 32-bit on a 64-bit system
    NVAPI_IMPLICIT_SET_GPU_TOPOLOGY_CHANGE_NOT_ALLOWED = -128,    //there is any implicit GPU topo active. Use NVAPI_SetHybridMode to change topology.
    NVAPI_REQUEST_USER_TO_CLOSE_NON_MIGRATABLE_APPS = -129,      //Prompt the user to close all non-migratable apps.
    NVAPI_OUT_OF_MEMORY                         = -130,    // Could not allocate sufficient memory to complete the call
    NVAPI_WAS_STILL_DRAWING                     = -131,    // The previous operation that is transferring information to or from this surface is incomplete
    NVAPI_FILE_NOT_FOUND                        = -132,    // The file was not found
    NVAPI_TOO_MANY_UNIQUE_STATE_OBJECTS         = -133,    // There are too many unique instances of a particular type of state object
    NVAPI_INVALID_CALL                          = -134,    // The method call is invalid. For example, a method's parameter may not be a valid pointer
    NVAPI_D3D10_1_LIBRARY_NOT_FOUND             = -135,    // d3d10_1.dll can not be loaded
    NVAPI_FUNCTION_NOT_FOUND                    = -136     // Couldn't find the function in loaded dll library
  );

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_Initialize
//
//   DESCRIPTION: Initializes NVAPI library. This must be called before any
//                other NvAPI_ function.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_ERROR            Something is wrong during the initialization process (generic error)
//                NVAPI_LIBRARYNOTFOUND  Can not load nvapi.dll
//                NVAPI_OK                  Initialized
//
///////////////////////////////////////////////////////////////////////////////
function NvAPI_Initialize(): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetErrorMessage
//
//   DESCRIPTION: converts an NvAPI error code into a null terminated string
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: null terminated string (always, never NULL)
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetErrorMessage: function(nr: NvAPI_Status; var szDesc: NvAPI_ShortString): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetInterfaceVersionString
//
//   DESCRIPTION: Returns a string describing the version of the NvAPI library.
//                Contents of the string are human readable.  Do not assume a fixed
//                format.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: User readable string giving info on NvAPI's version
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetInterfaceVersionString: function(var szDesc: NvAPI_ShortString): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetDisplayDriverVersion
//
//   DESCRIPTION: Returns a struct that describes aspects of the display driver
//                build.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_ERROR or NVAPI_OK
//
///////////////////////////////////////////////////////////////////////////////
type
  NV_DISPLAY_DRIVER_VERSION = record
    version: NvU32;             // Structure version
    drvVersion: NvU32;
    bldChangeListNum: NvU32;
    szBuildBranchString: NvAPI_ShortString;
    szAdapterString: NvAPI_ShortString;
  end;
  TNvDisplayDriverVersion = NV_DISPLAY_DRIVER_VERSION;
  PNvDisplayDriverVersion = ^TNvDisplayDriverVersion;

const
//#define NV_DISPLAY_DRIVER_VERSION_VER  MAKE_NVAPI_VERSION(NV_DISPLAY_DRIVER_VERSION,1)
  NV_DISPLAY_DRIVER_VERSION_VER = NvU32(SizeOf(NV_DISPLAY_DRIVER_VERSION) or (1 shl 16));

var
  NvAPI_GetDisplayDriverVersion: function(hNvDisplay: PNvDisplayHandle; pVersion: PNvDisplayDriverVersion): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_EnumNvidiaDisplayHandle
//
//   DESCRIPTION: Returns the handle of the NVIDIA display specified by the enum
//                index (thisEnum). The client should keep enumerating until it
//                returns NVAPI_END_ENUMERATION.
//
//                Note: Display handles can get invalidated on a modeset, so the calling applications need to
//                renum the handles after every modeset.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: either the handle pointer is NULL or enum index too big
//                NVAPI_OK: return a valid NvDisplayHandle based on the enum index
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA device found in the system
//                NVAPI_END_ENUMERATION: no more display device to enumerate.
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_EnumNvidiaDisplayHandle: function(thisEnum: NvU32; pNvDispHandle: PNvDisplayHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_EnumNvidiaUnAttachedDisplayHandle
//
//   DESCRIPTION: Returns the handle of the NVIDIA UnAttached display specified by the enum
//                index (thisEnum). The client should keep enumerating till it
//                return error.
//
//                Note: Display handles can get invalidated on a modeset, so the calling applications need to
//                renum the handles after every modeset.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: either the handle pointer is NULL or enum index too big
//                NVAPI_OK: return a valid NvDisplayHandle based on the enum index
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA device found in the system
//                NVAPI_END_ENUMERATION: no more display device to enumerate.
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_EnumNvidiaUnAttachedDisplayHandle: function(thisEnum: NvU32; pNvUnAttachedDispHandle: PNvUnAttachedDisplayHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_EnumPhysicalGPUs
//
//   DESCRIPTION: Returns an array of physical GPU handles.
//
//                Each handle represents a physical GPU present in the system.
//                That GPU may be part of a SLI configuration, or not be visible to the OS directly.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//                The array nvGPUHandle will be filled with physical GPU handle values.  The returned
//                gpuCount determines how many entries in the array are valid.
//
//                Note: In drivers older than 105.00, all physical GPU handles get invalidated on a modeset. So the calling applications
//                      need to renum the handles after every modeset.
//                      With drivers 105.00 and up all physical GPU handles are constant.
//                      Physical GPU handles are constant as long as the GPUs are not physically moved and the SBIOS VGA order is unchanged.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: nvGPUHandle or pGpuCount is NULL
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_EnumPhysicalGPUs: function(var nvGPUHandle: TNvPhysicalGpuHandleArray; var pGpuCount: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_EnumLogicalGPUs
//
//   DESCRIPTION: Returns an array of logical GPU handles.
//
//                Each handle represents one or more GPUs acting in concert as a single graphics device.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//                The array nvGPUHandle will be filled with logical GPU handle values.  The returned
//                gpuCount determines how many entries in the array are valid.
//
//                Note: All logical GPUs handles get invalidated on a GPU topology change, so the calling application is required to
//                renum the logical GPU handles to get latest physical handle mapping after every GPU topology change activated
//                by a call to NvAPI_SetGpuTopologies.
//
//                To detect if SLI rendering is enabled please use NvAPI_D3D_GetCurrentSLIState
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: nvGPUHandle or pGpuCount is NULL
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_EnumLogicalGPUs: function(var nvGPUHandle: TNvLogicalGpuHandleArray; var pGpuCount: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetPhysicalGPUsFromDisplay
//
//   DESCRIPTION: Returns an array of physical GPU handles associated with the specified display.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//                The array nvGPUHandle will be filled with physical GPU handle values.  The returned
//                gpuCount determines how many entries in the array are valid.
//
//                If the display corresponds to more than one physical GPU, the first GPU returned
//                is the one with the attached active output.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hNvDisp is not valid; nvGPUHandle or pGpuCount is NULL
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetPhysicalGPUsFromDisplay: function(hNvDisp: PNvDisplayHandle; var nvGPUHandle: TNvPhysicalGpuHandleArray; var pGpuCount: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetPhysicalGPUFromUnAttachedDisplay
//
//   DESCRIPTION: Returns a physical GPU handle associated with the specified unattached display.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hNvUnAttachedDisp is not valid or pPhysicalGpu is NULL.
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetPhysicalGPUFromUnAttachedDisplay: function(hNvUnAttachedDisp: PNvUnAttachedDisplayHandle; pPhysicalGpu: PNvPhysicalGpuHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_CreateDisplayFromUnAttachedDisplay
//
//   DESCRIPTION: The unattached display handle is converted to a active attached display handle.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hNvUnAttachedDisp is not valid or pNvDisplay is NULL.
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_CreateDisplayFromUnAttachedDisplay: function(hNvUnAttachedDisp: PNvUnAttachedDisplayHandle; pNvDisplay: PNvDisplayHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetLogicalGPUFromDisplay
//
//   DESCRIPTION: Returns the logical GPU handle associated with the specified display.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hNvDisp is not valid; pLogicalGPU is NULL
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetLogicalGPUFromDisplay: function(hNvDisp: PNvDisplayHandle; pLogicalGPU: PNvLogicalGpuHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetLogicalGPUFromPhysicalGPU
//
//   DESCRIPTION: Returns the logical GPU handle associated with specified physical GPU handle.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGPU is not valid; pLogicalGPU is NULL
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetLogicalGPUFromPhysicalGPU: function(hPhysicalGPU: PNvPhysicalGpuHandle; pLogicalGPU: PNvLogicalGpuHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetPhysicalGPUsFromLogicalGPU
//
//   DESCRIPTION: Returns the physical GPU handles associated with the specified logical GPU handle.
//
//                At least 1 GPU must be present in the system and running an NV display driver.
//
//                The array hPhysicalGPU will be filled with physical GPU handle values.  The returned
//                gpuCount determines how many entries in the array are valid.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hLogicalGPU is not valid; hPhysicalGPU is NULL
//                NVAPI_OK: one or more handles were returned
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_LOGICAL_GPU_HANDLE: hLogicalGPU was not a logical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetPhysicalGPUsFromLogicalGPU: function(hLogicalGPU: PNvLogicalGpuHandle; var hPhysicalGPU: TNvPhysicalGpuHandleArray; var pGpuCount: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetAssociatedNvidiaDisplayHandle
//
//   DESCRIPTION: Returns the handle of the NVIDIA display that is associated
//                with the display name given.  Eg: "\\DISPLAY1"
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: either argument is NULL
//                NVAPI_OK: *pNvDispHandle is now valid
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA device maps to that display name
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetAssociatedNvidiaDisplayHandle: function(const szDisplayName: PAnsiChar; pNvDispHandle: PNvDisplayHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetAssociatedNvidiaDisplayName
//
//   DESCRIPTION: Returns the display name given.  Eg: "\\DISPLAY1" using the NVIDIA display handle
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: either argument is NULL
//                NVAPI_OK: *pNvDispHandle is now valid
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA device maps to that display name
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetAssociatedNvidiaDisplayName: function(NvDispHandle: PNvDisplayHandle; var szDisplayName: NvAPI_ShortString): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetUnAttachedAssociatedDisplayName
//
//   DESCRIPTION: Returns the display name given.  Eg: "\\DISPLAY1" using the NVIDIA unattached display handle
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: either argument is NULL
//                NVAPI_OK: *pNvDispHandle is now valid
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA device maps to that display name
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetUnAttachedAssociatedDisplayName: function(hNvUnAttachedDisp: PNvUnAttachedDisplayHandle; var szDisplayName: NvAPI_ShortString): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_EnableHWCursor
//
//   DESCRIPTION: Enable hardware cursor support
//
//  SUPPORTED OS: Windows XP
//
// RETURN STATUS: NVAPI_ERROR or NVAPI_OK
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_EnableHWCursor: function(hNvDisplay: PNvDisplayHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_DisableHWCursor
//
//   DESCRIPTION: Disable hardware cursor support
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_ERROR or NVAPI_OK
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_DisableHWCursor: function(hNvDisplay: PNvDisplayHandle): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetVBlankCounter
//
//   DESCRIPTION: get vblank counter
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_ERROR or NVAPI_OK
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetVBlankCounter: function(hNvDisplay: PNvDisplayHandle; var pCounter: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME: NvAPI_SetRefreshRateOverride
//   DESCRIPTION: Override the refresh rate on the given  display/outputsMask.
//                The new refresh rate can be applied right away in this API call or deferred to happen with the
//                next OS modeset. The override is only good for one modeset (doesn't matter it's deferred or immediate).
//
//  SUPPORTED OS: Windows XP
//
//
//         INPUT: hNvDisplay - the NVIDIA display handle. It can be NVAPI_DEFAULT_HANDLE or a handle
//                             enumerated from NvAPI_EnumNVidiaDisplayHandle().
//
//                outputsMask - a set of bits that identify all target outputs which are associated with the NVIDIA
//                              display handle to apply the refresh rate override. Note when SLI is enabled,  the
//                              outputsMask only applies to the GPU that is driving the display output.
//
//                refreshRate - the override value. "0.0" means cancel the override.
//
//
//                bSetDeferred - "0": apply the refresh rate override immediately in this API call.
//                               "1":  apply refresh rate at the next OS modeset.
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hNvDisplay or outputsMask is invalid
//                NVAPI_OK: the refresh rate override is correct set
//                NVAPI_ERROR: the operation failed
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_SetRefreshRateOverride: function(hNvDisplay: PNvDisplayHandle; outputMask: NvU32; refreshRate: Double; bSetDeferred: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetAssociatedDisplayOutputId
//
//   DESCRIPTION: Gets the active outputId associated with the display handle.
//
//  SUPPORTED OS: Windows XP and higher
//
//    PARAMETERS: hNvDisplay(IN) - NVIDIA Display selection. It can be NVAPI_DEFAULT_HANDLE or a handle enumerated from NvAPI_EnumNVidiaDisplayHandle().
//                outputId(OUT)  - The active display output id associated with the selected display handle hNvDisplay.
//                                 The outputid will have only one bit set. In case of clone or span this  will indicate the display
//                                 outputId of the primary display that the GPU is driving.
// RETURN STATUS: NVAPI_OK: call successful.
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found.
//                NVAPI_EXPECTED_DISPLAY_HANDLE: hNvDisplay is not a valid display handle.
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetAssociatedDisplayOutputId: function(hNvDisplay: PNvDisplayHandle; var pOutputId: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_GetDisplayPortInfo
//
// DESCRIPTION:     This API returns the current DP related into on the specified device(monitor)
//
//  SUPPORTED OS: Windows XP and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA Display selection. It can be NVAPI_DEFAULT_HANDLE or a handle enumerated from NvAPI_EnumNVidiaDisplayHandle().
//                  outputId(IN)   - The display output id. If it's "0" then the default outputId from NvAPI_GetAssociatedDisplayOutputId() will be used.
//                  pInfo(OUT)     - The display port info
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT: Invalid input parameter.
//
///////////////////////////////////////////////////////////////////////////////
type
  NV_DP_LINK_RATE = (
    NV_DP_1_62GBPS            = 6,
    NV_DP_2_70GBPS            = $A
  );

  NV_DP_LANE_COUNT = (
    NV_DP_1_LANE              = 1,
    NV_DP_2_LANE              = 2,
    NV_DP_4_LANE              = 4
  );

  NV_DP_COLOR_FORMAT = (
    NV_DP_COLOR_FORMAT_RGB = 0,
    NV_DP_COLOR_FORMAT_YCbCr422,
    NV_DP_COLOR_FORMAT_YCbCr444
  );

  NV_DP_COLORIMETRY = (
    NV_DP_COLORIMETRY_RGB = 0,
    NV_DP_COLORIMETRY_YCbCr_ITU601,
    NV_DP_COLORIMETRY_YCbCr_ITU709
  );

  NV_DP_DYNAMIC_RANGE = (
    NV_DP_DYNAMIC_RANGE_VESA = 0,
    NV_DP_DYNAMIC_RANGE_CEA
  );

  NV_DP_BPC = (
    NV_DP_BPC_DEFAULT = 0,
    NV_DP_BPC_6,
    NV_DP_BPC_8,
    NV_DP_BPC_10,
    NV_DP_BPC_12,
    NV_DP_BPC_16
  );

  TTNvDisplayPortInfoFlags = (
    isDp, isInternalDp, isColorCtrlSupported, is6BPCSupported, is8BPCSupported, is10BPCSupported,
    is12BPCSupported, is16BPCSupported
  );

  NV_DISPLAY_PORT_INFO = record
    version: NvU32;                                    // structure version
    dpcd_ver: NvU32;                                   // the DPCD version of the monitor
    maxLinkRate: NV_DP_LINK_RATE;                      // the max supported link rate
    maxLaneCount: NV_DP_LANE_COUNT;                    // the max supported lane count
    curLinkRate: NV_DP_LINK_RATE;                      // the current link rate
    curLaneCount: NV_DP_LANE_COUNT;                    // the current lane count
    colorFormat: NV_DP_COLOR_FORMAT;                   // the current color format
    dynamicRange: NV_DP_DYNAMIC_RANGE;                 // the dynamic range
    colorimetry: NV_DP_COLORIMETRY;                    // ignored in RGB space
    bpc: NV_DP_BPC;                                    // the current bit-per-component;

    Flags: TTNvDisplayPortInfoFlags;
   {isDp: NvU32                                  : 1;  // if the monitor is driven by display port
    isInternalDp: NvU32                          : 1;  // if the monitor is driven by NV Dp transmitter
    isColorCtrlSupported: NvU32                  : 1;  // if the color format change is supported
    is6BPCSupported: NvU32                       : 1;  // if 6 bpc is supported
    is8BPCSupported: NvU32                       : 1;  // if 8 bpc is supported
    is10BPCSupported: NvU32                      : 1;  // if 10 bpc is supported
    is12BPCSupported: NvU32                      : 1;  // if 12 bpc is supported
    is16BPCSupported: NvU32                      : 1;  // if 16 bpc is supported}
  end;
  TNvDisplayPortInfo = NV_DISPLAY_PORT_INFO;

const
//#define NV_DISPLAY_PORT_INFO_VER   MAKE_NVAPI_VERSION(NV_DISPLAY_PORT_INFO,1)
  NV_DISPLAY_PORT_INFO_VER = NvU32(SizeOf(NV_DISPLAY_PORT_INFO) or (1 shl 16));

var
  NvAPI_GetDisplayPortInfo: function(hNvDisplay: PNvDisplayHandle; outputId: NvU32; var pInfo: TNvDisplayPortInfo): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_SetDisplayPort
//
// DESCRIPTION:     This API is used to setup DP related configurations.
//
//  SUPPORTED OS: Windows XP and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA display handle. It can be NVAPI_DEFAULT_HANDLE or a handle enumerated from NvAPI_EnumNVidiaDisplayHandle().
//                  outputId(IN)   - This display output ID, when it's "0" it means the default outputId generated from the return of NvAPI_GetAssociatedDisplayOutputId().
//                  pCfg(IN)       - The display port config structure. If pCfg is NULL, it means to use the driver's default value to setup.
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT: Invalid input parameter.
///////////////////////////////////////////////////////////////////////////////
type
  TNvDisplayPortConfigFlags = (isHPD, isSetDeferred, isChromaLpfOff, isDitherOff);

  NV_DISPLAY_PORT_CONFIG = record
    version: NvU32;                                    // structure version - 2 is latest
    linkRate: NV_DP_LINK_RATE;                         // the link rate
    laneCount: NV_DP_LANE_COUNT;                       // the lane count
    colorFormat: NV_DP_COLOR_FORMAT;                   // the color format to set
    dynamicRange: NV_DP_DYNAMIC_RANGE;                 // the dynamic range
    colorimetry: NV_DP_COLORIMETRY;                    // ignored in RGB space
    bpc: NV_DP_BPC;                                    // the current bit-per-component;

    Flags: TNvDisplayPortConfigFlags;
   {isHPD: NvU32                              : 1;     // if CPL is making this call due to HPD
    isSetDeferred: NvU32                      : 1;     // requires an OS modeset to finalize the setup if set
    isChromaLpfOff: NvU32                     : 1;     // force the chroma low_pass_filter to be off
    isDitherOff: NvU32                        : 1;     // force to turn off dither}
  end;
  TNvDisplayPortConfig = NV_DISPLAY_PORT_CONFIG;

const
//#define NV_DISPLAY_PORT_CONFIG_VER   MAKE_NVAPI_VERSION(NV_DISPLAY_PORT_CONFIG,2)
//#define NV_DISPLAY_PORT_CONFIG_VER_1 MAKE_NVAPI_VERSION(NV_DISPLAY_PORT_CONFIG,1)
//#define NV_DISPLAY_PORT_CONFIG_VER_2 MAKE_NVAPI_VERSION(NV_DISPLAY_PORT_CONFIG,2)
  NV_DISPLAY_PORT_CONFIG_VER   = NvU32(SizeOf(NV_DISPLAY_PORT_CONFIG) or (2 shl 16));
  NV_DISPLAY_PORT_CONFIG_VER_1 = NvU32(SizeOf(NV_DISPLAY_PORT_CONFIG) or (1 shl 16));
  NV_DISPLAY_PORT_CONFIG_VER_2 = NvU32(SizeOf(NV_DISPLAY_PORT_CONFIG) or (2 shl 16));

var
  NvAPI_SetDisplayPort: function(hNvDisplay: PNvDisplayHandle; outputId: NvU32; var pCfg: TNvDisplayPortConfig): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_GetHDMISupportInfo
//
// DESCRIPTION:     This API returns the current infoframe data on the specified device(monitor)
//
//  SUPPORTED OS: Windows Vista and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA Display selection. It can be NVAPI_DEFAULT_HANDLE or a handle enumerated from NvAPI_EnumNVidiaDisplayHandle().
//                  outputId(IN)   - The display output id. If it's "0" then the default outputId from NvAPI_GetAssociatedDisplayOutputId() will be used.
//                  pInfo(OUT)     - The monitor and GPU's HDMI support info
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT: Invalid input parameter.
//
///////////////////////////////////////////////////////////////////////////////
type
  TNvHDMISupportInfoFlags = (
    isGpuHDMICapable, isMonUnderscanCapable, isMonBasicAudioCapable, isMonYCbCr444Capable,
    isMonYCbCr422Capable, isMonxvYCC601Capable, isMonxvYCC709Capable, isMonHDMI
  );

  NV_HDMI_SUPPORT_INFO = record
    version: NvU32;                           // structure version

    flags: TNvHDMISupportInfoFlags;
   {isGpuHDMICapable: NvU32             : 1;  // if the GPU can handle HDMI
    isMonUnderscanCapable: NvU32        : 1;  // if the monitor supports underscan
    isMonBasicAudioCapable: NvU32       : 1;  // if the monitor supports basic audio
    isMonYCbCr444Capable: NvU32         : 1;  // if YCbCr 4:4:4 is supported
    isMonYCbCr422Capable: NvU32         : 1;  // if YCbCr 4:2:2 is supported
    isMonxvYCC601Capable: NvU32         : 1;  // if xvYCC 601 is supported
    isMonxvYCC709Capable: NvU32         : 1;  // if xvYCC 709 is supported
    isMonHDMI: NvU32                    : 1;  // if the monitor is HDMI (with IEEE's HDMI registry ID)}

    EDID861ExtRev: NvU32;                     // the revision number of the EDID 861 extension
 end;
 TNvHDMISupportInfo = NV_HDMI_SUPPORT_INFO;

const
//#define NV_HDMI_SUPPORT_INFO_VER  MAKE_NVAPI_VERSION(NV_HDMI_SUPPORT_INFO,1)
  NV_HDMI_SUPPORT_INFO_VER = NvU32(SizeOf(NV_HDMI_SUPPORT_INFO) or (1 shl 16));

var
  NvAPI_GetHDMISupportInfo: function(hNvDisplay: PNvDisplayHandle; outputId: NvU32; var pInfo: TNvHDMISupportInfo): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetAllOutputs
//
//   DESCRIPTION: Returns set of all GPU-output identifiers as a bitmask.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pOutputsMask is NULL
//                NVAPI_OK: *pOutputsMask contains a set of GPU-output identifiers
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetAllOutputs: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pOutputsMask: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetConnectedOutputs
//
//   DESCRIPTION: Same as NvAPI_GPU_GetAllOutputs but returns only the set of GPU-output
//                identifiers that are connected to display devices.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pOutputsMask is NULL
//                NVAPI_OK: *pOutputsMask contains a set of GPU-output identifiers
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetConnectedOutputs: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pOutputsMask: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetConnectedSLIOutputs
//
//   DESCRIPTION: Same as NvAPI_GPU_GetConnectedOutputs but returns only the set of GPU-output
//                identifiers that can be selected in an SLI configuration. With SLI disabled
//                this function matches NvAPI_GPU_GetConnectedOutputs
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pOutputsMask is NULL
//                NVAPI_OK: *pOutputsMask contains a set of GPU-output identifiers
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetConnectedSLIOutputs: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pOutputsMask: NvU32): NvAPI_Status; cdecl;


///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetConnectedOutputsWithLidState
//
//   DESCRIPTION: Similar to NvAPI_GPU_GetConnectedOutputs this API returns the connected display identifiers that are connected
//                as a output mask but unlike NvAPI_GPU_GetConnectedOutputs this API "always" reflects the Lid State in the output mask.
//                Thus if you expect the LID close state to be available in the connection mask use this API.
//                If LID is closed then this API will remove the LID panel from the connected display identifiers.
//                If LID is open then this API will reflect the LID panel in the connected display identifiers.
//                Note:This API should be used on laptop systems and on systems where LID state is required in the connection output mask.
//                     On desktop systems the returned identifiers will match NvAPI_GPU_GetConnectedOutputs.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pOutputsMask is NULL
//                NVAPI_OK: *pOutputsMask contains a set of GPU-output identifiers
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetConnectedOutputsWithLidState: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pOutputsMask: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetConnectedSLIOutputsWithLidState
//
//   DESCRIPTION: Same as NvAPI_GPU_GetConnectedOutputsWithLidState but returns only the set of GPU-output
//                identifiers that can be selected in an SLI configuration. With SLI disabled
//                this function matches NvAPI_GPU_GetConnectedOutputsWithLidState
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pOutputsMask is NULL
//                NVAPI_OK: *pOutputsMask contains a set of GPU-output identifiers
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetConnectedSLIOutputsWithLidState: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pOutputsMask: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetSystemType
//
//   DESCRIPTION: Returns information to identify if the GPU type is for a laptop system or a desktop system.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pOutputsMask is NULL
//                NVAPI_OK: *pSystemType contains the GPU system type
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
type
  NV_SYSTEM_TYPE = (
    NV_SYSTEM_TYPE_UNKNOWN = 0,
    NV_SYSTEM_TYPE_LAPTOP  = 1,
    NV_SYSTEM_TYPE_DESKTOP = 2
  );

var
  NvAPI_GPU_GetSystemType: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pSystemType: NV_SYSTEM_TYPE): NvAPI_Status; cdecl;


///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetActiveOutputs
//
//   DESCRIPTION: Same as NvAPI_GPU_GetAllOutputs but returns only the set of GPU-output
//                identifiers that are actively driving display devices.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pOutputsMask is NULL
//                NVAPI_OK: *pOutputsMask contains a set of GPU-output identifiers
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetActiveOutputs: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pOutputsMask: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetEDID
//
//   DESCRIPTION: Returns the EDID data for the specified GPU handle and connection bit mask.
//                displayOutputId should have exactly 1 bit set to indicate a single display.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: pEDID is NULL; displayOutputId has 0 or > 1 bits set.
//                NVAPI_OK: *pEDID contains valid data.
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found.
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle.
//                NVAPI_DATA_NOT_FOUND: requested display does not contain an EDID
//
///////////////////////////////////////////////////////////////////////////////
const
  NV_EDID_V1_DATA_SIZE   = 256;
  NV_EDID_DATA_SIZE      = NV_EDID_V1_DATA_SIZE;

type
  NV_EDID = record
    version: NvU32;        //structure version
    EDID_Data: array[0..NV_EDID_DATA_SIZE - 1] of NvU8;
    sizeofEDID: NvU32;
  end;
  TNvEDID = NV_EDID;

const
//#define NV_EDID_VER         MAKE_NVAPI_VERSION(NV_EDID,2)
  NV_EDID_VER = NvU32(SizeOf(NV_EDID) or (2 shl 16));

var
  NvAPI_GPU_GetEDID: function(hPhysicalGpu: PNvPhysicalGpuHandle; displayOutputId: NvU32; var pEDID: TNvEDID): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetOutputType
//
//   DESCRIPTION: Give a physical GPU handle and a single outputId (exactly 1 bit set), this API
//                returns the output type.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu, outputId or pOutputsMask is NULL; or outputId has > 1 bit set
//                NVAPI_OK: *pOutputType contains a NvGpuOutputType value
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
type
  _NV_GPU_OUTPUT_TYPE = (
    NVAPI_GPU_OUTPUT_UNKNOWN  = 0,
    NVAPI_GPU_OUTPUT_CRT      = 1,     // CRT display device
    NVAPI_GPU_OUTPUT_DFP      = 2,     // Digital Flat Panel display device
    NVAPI_GPU_OUTPUT_TV       = 3      // TV display device
  );
  NV_GPU_OUTPUT_TYPE = _NV_GPU_OUTPUT_TYPE;

var
  NvAPI_GPU_GetOutputType: function(hPhysicalGpu: PNvPhysicalGpuHandle; outputId: NvU32; var pOutputType: NV_GPU_OUTPUT_TYPE): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_ValidateOutputCombination
//
//   DESCRIPTION: This call is used to determine if a set of GPU outputs can be active
//                simultaneously.  While a GPU may have <n> outputs, they can not typically
//                all be active at the same time due to internal resource sharing.
//
//                Given a physical GPU handle and a mask of candidate outputs, this call
//                will return NVAPI_OK if all of the specified outputs can be driven
//                simultaneously.  It will return NVAPI_INVALID_COMBINATION if they cannot.
//
//                Use NvAPI_GPU_GetAllOutputs() to determine which outputs are candidates.
//
//  SUPPORTED OS: Windows XP and higher
//
// RETURN STATUS: NVAPI_OK: combination of outputs in outputsMask are valid (can be active simultaneously)
//                NVAPI_INVALID_COMBINATION: combination of outputs in outputsMask are NOT valid
//                NVAPI_INVALID_ARGUMENT: hPhysicalGpu or outputsMask does not have at least 2 bits set
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_ValidateOutputCombination: function(hPhysicalGpu: PNvPhysicalGpuHandle; outputsMask: NvU32): NvAPI_Status; cdecl;

type
  _NV_GPU_CONNECTOR_TYPE = (
    NVAPI_GPU_CONNECTOR_VGA_15_PIN                      = $00000000,
    NVAPI_GPU_CONNECTOR_TV_COMPOSITE                    = $00000010,
    NVAPI_GPU_CONNECTOR_TV_SVIDEO                       = $00000011,
    NVAPI_GPU_CONNECTOR_TV_HDTV_COMPONENT               = $00000013,
    NVAPI_GPU_CONNECTOR_TV_SCART                        = $00000014,
    NVAPI_GPU_CONNECTOR_TV_COMPOSITE_SCART_ON_EIAJ4120  = $00000016,
    NVAPI_GPU_CONNECTOR_TV_HDTV_EIAJ4120                = $00000017,
    NVAPI_GPU_CONNECTOR_PC_POD_HDTV_YPRPB               = $00000018,
    NVAPI_GPU_CONNECTOR_PC_POD_SVIDEO                   = $00000019,
    NVAPI_GPU_CONNECTOR_PC_POD_COMPOSITE                = $0000001A,
    NVAPI_GPU_CONNECTOR_DVI_I_TV_SVIDEO                 = $00000020,
    NVAPI_GPU_CONNECTOR_DVI_I_TV_COMPOSITE              = $00000021,
    NVAPI_GPU_CONNECTOR_DVI_I                           = $00000030,
    NVAPI_GPU_CONNECTOR_DVI_D                           = $00000031,
    NVAPI_GPU_CONNECTOR_ADC                             = $00000032,
    NVAPI_GPU_CONNECTOR_LFH_DVI_I_1                     = $00000038,
    NVAPI_GPU_CONNECTOR_LFH_DVI_I_2                     = $00000039,
    NVAPI_GPU_CONNECTOR_SPWG                            = $00000040,
    NVAPI_GPU_CONNECTOR_OEM                             = $00000041,
    NVAPI_GPU_CONNECTOR_DISPLAYPORT_EXTERNAL            = $00000046,
    NVAPI_GPU_CONNECTOR_DISPLAYPORT_INTERNAL            = $00000047,
    NVAPI_GPU_CONNECTOR_HDMI_A                          = $00000061,
    NVAPI_GPU_CONNECTOR_UNKNOWN                         = Integer($FFFFFFFF)
  );
  NV_GPU_CONNECTOR_TYPE = _NV_GPU_CONNECTOR_TYPE;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetFullName
//
//   DESCRIPTION: Retrieves the full GPU name as an ascii string.  Eg: "Quadro FX 1400"
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_ERROR or NVAPI_OK
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetFullName: function(hPhysicalGpu: PNvPhysicalGpuHandle; var szName: NvAPI_ShortString): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetPCIIdentifiers
//
//   DESCRIPTION: Returns the PCI identifiers associated with this GPU.
//                  DeviceId - the internal PCI device identifier for the GPU.
//                  SubSystemId - the internal PCI subsystem identifier for the GPU.
//                  RevisionId - the internal PCI device-specific revision identifier for the GPU.
//                  ExtDeviceId - the external PCI device identifier for the GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or an argument is NULL
//                NVAPI_OK: arguments are populated with PCI identifiers
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetPCIIdentifiers: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pDeviceId, pSubSystemId, pRevisionId, pExtDeviceId: NvU32): NvAPI_Status; cdecl;

type
  _NV_GPU_TYPE = (
    NV_SYSTEM_TYPE_GPU_UNKNOWN     = 0,
    NV_SYSTEM_TYPE_IGPU            = 1, //integrated
    NV_SYSTEM_TYPE_DGPU            = 2  //discrete
  );
  NV_GPU_TYPE = _NV_GPU_TYPE;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetGPUType
//
// DESCRIPTION: Returns information to identify the GPU type
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu
// NVAPI_OK: *pGpuType contains the GPU type
// NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
// NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetGPUType: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pGpuType: NV_GPU_TYPE): NvAPI_Status; cdecl;

type
  _NV_GPU_BUS_TYPE = (
    NVAPI_GPU_BUS_TYPE_UNDEFINED    = 0,
    NVAPI_GPU_BUS_TYPE_PCI          = 1,
    NVAPI_GPU_BUS_TYPE_AGP          = 2,
    NVAPI_GPU_BUS_TYPE_PCI_EXPRESS  = 3,
    NVAPI_GPU_BUS_TYPE_FPCI         = 4
  );
  NV_GPU_BUS_TYPE = _NV_GPU_BUS_TYPE;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetBusType
//
//   DESCRIPTION: Returns the type of bus associated with this GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pBusType is NULL
//                NVAPI_OK: *pBusType contains bus identifier
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetBusType: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pBusType: NV_GPU_BUS_TYPE): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetBusId
//
//   DESCRIPTION: Returns the ID of bus associated with this GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pBusId is NULL
//                NVAPI_OK: *pBusId contains bus id
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetBusId: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pBusId: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetBusSlotId
//
//   DESCRIPTION: Returns the ID of bus-slot associated with this GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pBusSlotId is NULL
//                NVAPI_OK: *pBusSlotId contains bus-slot id
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetBusSlotId: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pBusSlotId: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetIRQ
//
//   DESCRIPTION: Returns the interrupt number associated with this GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pIRQ is NULL
//                NVAPI_OK: *pIRQ contains interrupt number
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetIRQ: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pIRQ: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetVbiosRevision
//
//   DESCRIPTION: Returns the revision of the video bios associated with this GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pBiosRevision is NULL
//                NVAPI_OK: *pBiosRevision contains revision number
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetVbiosRevision: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pBiosRevision: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetVbiosOEMRevision
//
//   DESCRIPTION: Returns the OEM revision of the video bios associated with this GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu or pBiosRevision is NULL
//                NVAPI_OK: *pBiosRevision contains revision number
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetVbiosOEMRevision: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pBiosRevision: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetVbiosVersionString
//
//   DESCRIPTION: Returns the full bios version string in the form of xx.xx.xx.xx.yy where
//                the xx numbers come from NvAPI_GPU_GetVbiosRevision and yy comes from
//                NvAPI_GPU_GetVbiosOEMRevision.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: hPhysicalGpu is NULL
//                NVAPI_OK: szBiosRevision contains version string
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetVbiosVersionString: function(hPhysicalGpu: PNvPhysicalGpuHandle; var szBiosRevision: NvAPI_ShortString): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetAGPAperture
//
//   DESCRIPTION: Returns AGP aperture in megabytes
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: pSize is NULL
//                NVAPI_OK: call successful
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetAGPAperture: function(hPhysicalGpu: PNvPhysicalGpuHandle; pSize: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetCurrentAGPRate
//
//   DESCRIPTION: Returns the current AGP Rate (1 = 1x, 2=2x etc, 0 = AGP not present)
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: pRate is NULL
//                NVAPI_OK: call successful
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetCurrentAGPRate: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pRate: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetCurrentPCIEDownstreamWidth
//
//   DESCRIPTION: Returns the number of PCIE lanes being used for the PCIE interface
//                downstream from the GPU.
//
//                On systems that do not support PCIE, the maxspeed for the root link
//                will be zero.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: pWidth is NULL
//                NVAPI_OK: call successful
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetCurrentPCIEDownstreamWidth: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pWidth: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetPhysicalFrameBufferSize
//
//   DESCRIPTION: Returns the physical size of framebuffer in Kb.  This does NOT include any
//                system RAM that may be dedicated for use by the GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: pSize is NULL
//                NVAPI_OK: call successful
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetPhysicalFrameBufferSize: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pSize: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GPU_GetVirtualFrameBufferSize
//
//   DESCRIPTION: Returns the virtual size of framebuffer in Kb.  This includes the physical RAM plus any
//                system RAM that has been dedicated for use by the GPU.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: pSize is NULL
//                NVAPI_OK: call successful
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND: no NVIDIA GPU driving a display was found
//                NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE: hPhysicalGpu was not a physical GPU handle
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetVirtualFrameBufferSize: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pSize: NvU32): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////////
//  Thermal API
//  Provides ability to get temperature levels from the various thermal sensors associated with the GPU

const
  NVAPI_MAX_THERMAL_SENSORS_PER_GPU = 3;

type
  NV_THERMAL_TARGET = (
    NVAPI_THERMAL_TARGET_NONE          = 0,
    NVAPI_THERMAL_TARGET_GPU           = 1,
    NVAPI_THERMAL_TARGET_MEMORY        = 2,
    NVAPI_THERMAL_TARGET_POWER_SUPPLY  = 4,
    NVAPI_THERMAL_TARGET_BOARD         = 8,
    NVAPI_THERMAL_TARGET_ALL           = 15,
    NVAPI_THERMAL_TARGET_UNKNOWN       = -1
  );

  NV_THERMAL_CONTROLLER = (
    NVAPI_THERMAL_CONTROLLER_NONE = 0,
    NVAPI_THERMAL_CONTROLLER_GPU_INTERNAL,
    NVAPI_THERMAL_CONTROLLER_ADM1032,
    NVAPI_THERMAL_CONTROLLER_MAX6649,
    NVAPI_THERMAL_CONTROLLER_MAX1617,
    NVAPI_THERMAL_CONTROLLER_LM99,
    NVAPI_THERMAL_CONTROLLER_LM89,
    NVAPI_THERMAL_CONTROLLER_LM64,
    NVAPI_THERMAL_CONTROLLER_ADT7473,
    NVAPI_THERMAL_CONTROLLER_SBMAX6649,
    NVAPI_THERMAL_CONTROLLER_VBIOSEVT,
    NVAPI_THERMAL_CONTROLLER_OS,
    NVAPI_THERMAL_CONTROLLER_UNKNOWN = -1
  );

  NV_GPU_THERMAL_SETTINGS = record
    version: NvU32;                   //structure version
    count: NvU32;                     //number of associated thermal sensors with the selected GPU
    sensor: array[0..NVAPI_MAX_THERMAL_SENSORS_PER_GPU - 1] of
      record
        controller: NV_THERMAL_CONTROLLER;         //internal, ADM1032, MAX6649...
        defaultMinTemp: NvU32;                     //the min default temperature value of the thermal sensor in degrees centigrade
        defaultMaxTemp: NvU32;                     //the max default temperature value of the thermal sensor in degrees centigrade
        currentTemp: NvU32;                        //the current temperature value of the thermal sensor in degrees centigrade
        target: NV_THERMAL_TARGET;                 //thermal senor targeted @ GPU, memory, chipset, powersupply, canoas...
      end;
  end;
  TNvGPUThermalSettings = NV_GPU_THERMAL_SETTINGS;
  PNvGPUThermalSettings = ^TNvGPUThermalSettings;

const
//#define NV_GPU_THERMAL_SETTINGS_VER  MAKE_NVAPI_VERSION(NV_GPU_THERMAL_SETTINGS,1)
  NV_GPU_THERMAL_SETTINGS_VER = NvU32(SizeOf(NV_GPU_THERMAL_SETTINGS) or (1 shl 16));

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME:   NvAPI_GPU_GetThermalSettings
//
// DESCRIPTION:     Retrieves the thermal information of all thermal sensors or specific thermal sensor associated with the selected GPU.
//                  Thermal sensors are indexed 0 to NVAPI_MAX_THERMAL_SENSORS_PER_GPU-1.
//                  To retrieve specific thermal sensor info set the sensorIndex to the required thermal sensor index.
//                  To retrieve info for all sensors set sensorIndex to NVAPI_THERMAL_TARGET_ALL.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// PARAMETERS :     hPhysicalGPU(IN) - GPU selection.
//                  sensorIndex(IN)  - Explicit thermal sensor index selection.
//                  pThermalSettings(OUT) - Array of thermal settings.
//
// RETURN STATUS:
//    NVAPI_OK - completed request
//    NVAPI_ERROR - miscellaneous error occurred
//    NVAPI_INVALID_ARGUMENT - pThermalInfo is NULL
//    NVAPI_HANDLE_INVALIDATED - handle passed has been invalidated (see user guide)
//    NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE - handle passed is not a physical GPU handle
//    NVAPI_INCOMPATIBLE_STRUCT_VERSION - the version of the INFO struct is not supported
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GPU_GetThermalSettings: function(hPhysicalGpu: PNvPhysicalGpuHandle; sensorIndex: NvU32; pThermalSettings: PNvGPUThermalSettings): NvAPI_Status; cdecl;

////////////////////////////////////////////////////////////////////////////////
//NvAPI_TVOutput Information
type
  _NV_DISPLAY_TV_FORMAT = (
    NV_DISPLAY_TV_FORMAT_NONE         = 0,
    NV_DISPLAY_TV_FORMAT_SD_NTSCM     = $00000001,
    NV_DISPLAY_TV_FORMAT_SD_NTSCJ     = $00000002,
    NV_DISPLAY_TV_FORMAT_SD_PALM      = $00000004,
    NV_DISPLAY_TV_FORMAT_SD_PALBDGH   = $00000008,
    NV_DISPLAY_TV_FORMAT_SD_PALN      = $00000010,
    NV_DISPLAY_TV_FORMAT_SD_PALNC     = $00000020,
    NV_DISPLAY_TV_FORMAT_SD_576i      = $00000100,
    NV_DISPLAY_TV_FORMAT_SD_480i      = $00000200,
    NV_DISPLAY_TV_FORMAT_ED_480p      = $00000400,
    NV_DISPLAY_TV_FORMAT_ED_576p      = $00000800,
    NV_DISPLAY_TV_FORMAT_HD_720p      = $00001000,
    NV_DISPLAY_TV_FORMAT_HD_1080i     = $00002000,
    NV_DISPLAY_TV_FORMAT_HD_1080p     = $00004000,
    NV_DISPLAY_TV_FORMAT_HD_720p50    = $00008000,
    NV_DISPLAY_TV_FORMAT_HD_1080p24   = $00010000,
    NV_DISPLAY_TV_FORMAT_HD_1080i50   = $00020000,
    NV_DISPLAY_TV_FORMAT_HD_1080p50   = $00040000
  );
  NV_DISPLAY_TV_FORMAT = _NV_DISPLAY_TV_FORMAT;

///////////////////////////////////////////////////////////////////////////////////
//  I2C API
//  Provides ability to read or write data using I2C protocol.
//  These APIs allow I2C access only to DDC monitors
const
  NVAPI_MAX_SIZEOF_I2C_DATA_BUFFER = 256;
  NVAPI_NO_PORTID_FOUND = 5;
  NVAPI_DISPLAY_DEVICE_MASK_MAX = 24;

type
  NV_I2C_INFO = record
    version: NvU32;                           //structure version
    displayMask: NvU32;                       //the Display Mask of the concerned display
    bIsDDCPort: NvU8;                         //Flag indicating DDC port or a communication port
    i2cDevAddress: NvU8;                      //the I2C target device address
    pbI2cRegAddress: PNvU8;                   //the I2C target register address
    regAddrSize: NvU32;                       //the size in bytes of target register address
    pbData: PNvU8;                            //The buffer of data which is to be read/written
    cbSize: NvU32;                            //The size of Data buffer to be read.
    i2cSpeed: NvU32;                          //The speed at which the transaction is be made(between 28kbps to 40kbps)
  end;
  TNvI2CInfo = NV_I2C_INFO;

const
//#define NV_I2C_INFO_VER  MAKE_NVAPI_VERSION(NV_I2C_INFO,1)
  NV_I2C_INFO_VER = NvU32(SizeOf(NV_I2C_INFO) or (1 shl 16));

{***********************************************************************************}

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME:  NvAPI_I2CRead
//
// DESCRIPTION:    Read data buffer from I2C port
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// PARAMETERS:     hPhysicalGPU(IN) - GPU selection.
//                 NV_I2C_INFO *pI2cInfo -The I2c data input structure
//
// RETURN STATUS:
//    NVAPI_OK - completed request
//    NVAPI_ERROR - miscellaneous error occurred
//    NVAPI_HANDLE_INVALIDATED - handle passed has been invalidated (see user guide)
//    NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE - handle passed is not a physical GPU handle
//    NVAPI_INCOMPATIBLE_STRUCT_VERSION - structure version is not supported
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_I2CRead: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pI2cInfo: TNvI2CInfo): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME:  NvAPI_I2CWrite
//
// DESCRIPTION:    Writes data buffer to I2C port
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// PARAMETERS:     hPhysicalGPU(IN) - GPU selection.
//                 NV_I2C_INFO *pI2cInfo -The I2c data input structure
//
// RETURN STATUS:
//    NVAPI_OK - completed request
//    NVAPI_ERROR - miscellaneous error occurred
//    NVAPI_HANDLE_INVALIDATED - handle passed has been invalidated (see user guide)
//    NVAPI_EXPECTED_PHYSICAL_GPU_HANDLE - handle passed is not a physical GPU handle
//    NVAPI_INCOMPATIBLE_STRUCT_VERSION - structure version is not supported
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_I2CWrite: function(hPhysicalGpu: PNvPhysicalGpuHandle; var pI2cInfo: TNvI2CInfo): NvAPI_Status; cdecl;


type
  NV_CHIPSET_INFO = record
    version: NvU32;                       //structure version
    vendorId: NvU32;                      //vendorId
    deviceId: NvU32;                      //deviceId
    szVendorName: NvAPI_ShortString;      //vendor Name
    szChipsetName: NvAPI_ShortString;     //device Name
    flags: NvU32;                         //Chipset info flags - obsolete
    subSysVendorId: NvU32;                //subsystem vendorId
    subSysDeviceId: NvU32;                //subsystem deviceId
    szSubSysVendorName: NvAPI_ShortString;//subsystem vendor Name
  end;
  TNvChipsetInfo = NV_CHIPSET_INFO;

const
//#define NV_CHIPSET_INFO_VER     MAKE_NVAPI_VERSION(NV_CHIPSET_INFO,3)
  NV_CHIPSET_INFO_VER = NvU32(SizeOf(NV_CHIPSET_INFO) or (3 shl 16));

{type
  NV_CHIPSET_INFO_FLAGS = (
    NV_CHIPSET_INFO_HYBRID          = $00000001
  );}
const
  NV_CHIPSET_INFO_HYBRID          = $00000001;

type
  NV_CHIPSET_INFO_v2 = record
    version: NvU32;                       //structure version
    vendorId: NvU32;                      //vendorId
    deviceId: NvU32;                      //deviceId
    szVendorName: NvAPI_ShortString;      //vendor Name
    szChipsetName: NvAPI_ShortString;     //device Name
    flags: NvU32;                         //Chipset info flags
  end;
  TNvChipsetInfoV2 = NV_CHIPSET_INFO_v2;

const
//#define NV_CHIPSET_INFO_VER_2   MAKE_NVAPI_VERSION(NV_CHIPSET_INFO_v2,2)
  NV_CHIPSET_INFO_VER_2 = NvU32(SizeOf(NV_CHIPSET_INFO) or (2 shl 16));

type
  NV_CHIPSET_INFO_v1 = record
    version: NvU32;                       //structure version
    vendorId: NvU32;                      //vendorId
    deviceId: NvU32;                      //deviceId
    szVendorName: NvAPI_ShortString;      //vendor Name
    szChipsetName: NvAPI_ShortString;     //device Name
  end;
  TNvChipsetInfoV1 = NV_CHIPSET_INFO_v1;

const
//#define NV_CHIPSET_INFO_VER_1  MAKE_NVAPI_VERSION(NV_CHIPSET_INFO_v1,1)
  NV_CHIPSET_INFO_VER_1 = NvU32(SizeOf(NV_CHIPSET_INFO) or (1 shl 16));

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_SYS_GetChipSetInfo
//
//   DESCRIPTION: Returns information about the System's ChipSet
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_INVALID_ARGUMENT: pChipSetInfo is NULL
//                NVAPI_OK: *pChipSetInfo is now set
//                NVAPI_INCOMPATIBLE_STRUCT_VERSION - NV_CHIPSET_INFO version not compatible with driver
//
///////////////////////////////////////////////////////////////////////////////
function NvAPI_SYS_GetChipSetInfo(var pChipSetInfo: TNvChipsetInfo): NvAPI_Status; cdecl; overload;
function NvAPI_SYS_GetChipSetInfo(var pChipSetInfo: TNvChipsetInfoV2): NvAPI_Status; cdecl; overload;
function NvAPI_SYS_GetChipSetInfo(var pChipSetInfo: TNvChipsetInfoV1): NvAPI_Status; cdecl; overload;

type
  NV_LID_DOCK_PARAMS = record
    version: NvU32;    // Structure version, constructed from macro below
    currentLidState: NvU32;
    currentDockState: NvU32;
    currentLidPolicy: NvU32;
    currentDockPolicy: NvU32;
    forcedLidMechanismPresent: NvU32;
    forcedDockMechanismPresent: NvU32;
  end;
  TNvLIDDockParams = NV_LID_DOCK_PARAMS;

const
//#define NV_LID_DOCK_PARAMS_VER  MAKE_NVAPI_VERSION(NV_LID_DOCK_PARAMS,1)
  NV_LID_DOCK_PARAMS_VER = NvU32(SizeOf(NV_LID_DOCK_PARAMS) or (1 shl 16));

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_GetLidDockInfo
//
// DESCRIPTION: Returns current lid and dock information.
//
//  SUPPORTED OS: Mac OS X, Windows XP and higher
//
// RETURN STATUS: NVAPI_OK: now *pLidAndDock contains the returned lid and dock information.
//                NVAPI_ERROR:If any way call is not success.
//                NVAPI_NOT_SUPPORTED:If any way call is not success.
//                NVAPI_HANDLE_INVALIDATED:If nvapi escape result handle is invalid.
//                NVAPI_API_NOT_INTIALIZED:If NVAPI is not initialized.
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_SYS_GetLidAndDockInfo: function(var pLidAndDock: TNvLIDDockParams): NvAPI_Status; cdecl;


///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_OGL_ExpertModeSet[Get]
//
//   DESCRIPTION: Configure OpenGL Expert Mode, an API usage feedback and
//                advice reporting mechanism. The effects of this call are
//                applied only to the current context, and are reset to the
//                defaults when the context is destroyed.
//
//                Note: This feature is valid at runtime only when GLExpert
//                      functionality has been built into the OpenGL driver
//                      installed on the system. All Windows Vista OpenGL
//                      drivers provided by NVIDIA have this instrumentation
//                      included by default. Windows XP, however, requires a
//                      special display driver available with the NVIDIA
//                      PerfSDK found at developer.nvidia.com.
//
//                Note: These functions are valid only for the current OpenGL
//                      context. Calling these functions prior to creating a
//                      context and calling MakeCurrent with it will result
//                      in errors and undefined behavior.
//
//    PARAMETERS: expertDetailMask  Mask made up of NVAPI_OGLEXPERT_DETAIL bits,
//                                  this parameter specifies the detail level in
//                                  the feedback stream.
//
//                expertReportMask  Mask made up of NVAPI_OGLEXPERT_REPORT bits,
//                                  this parameter specifies the areas of
//                                  functional interest.
//
//                expertOutputMask  Mask made up of NVAPI_OGLEXPERT_OUTPUT bits,
//                                  this parameter specifies the feedback output
//                                  location.
//
//                expertCallback    Used in conjunction with OUTPUT_TO_CALLBACK,
//                                  this is a simple callback function the user
//                                  may use to obtain the feedback stream. The
//                                  function will be called once per fully
//                                  qualified feedback stream entry.
//
// RETURN STATUS: NVAPI_API_NOT_INTIALIZED         : NVAPI not initialized
//                NVAPI_NVIDIA_DEVICE_NOT_FOUND    : no NVIDIA GPU found
//                NVAPI_OPENGL_CONTEXT_NOT_CURRENT : no NVIDIA OpenGL context
//                                                   which supports GLExpert
//                                                   has been made current
//                NVAPI_ERROR : OpenGL driver failed to load properly
//                NVAPI_OK    : success
//
///////////////////////////////////////////////////////////////////////////////
const
  NVAPI_OGLEXPERT_DETAIL_NONE                 = $00000000;
  NVAPI_OGLEXPERT_DETAIL_ERROR                = $00000001;
  NVAPI_OGLEXPERT_DETAIL_SWFALLBACK           = $00000002;
  NVAPI_OGLEXPERT_DETAIL_BASIC_INFO           = $00000004;
  NVAPI_OGLEXPERT_DETAIL_DETAILED_INFO        = $00000008;
  NVAPI_OGLEXPERT_DETAIL_PERFORMANCE_WARNING  = $00000010;
  NVAPI_OGLEXPERT_DETAIL_QUALITY_WARNING      = $00000020;
  NVAPI_OGLEXPERT_DETAIL_USAGE_WARNING        = $00000040;
  NVAPI_OGLEXPERT_DETAIL_ALL                  = $FFFFFFFF;

  NVAPI_OGLEXPERT_REPORT_NONE                 = $00000000;
  NVAPI_OGLEXPERT_REPORT_ERROR                = $00000001;
  NVAPI_OGLEXPERT_REPORT_SWFALLBACK           = $00000002;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_VERTEX      = $00000004;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_GEOMETRY    = $00000008;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_XFB         = $00000010;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_RASTER      = $00000020;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_FRAGMENT    = $00000040;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_ROP         = $00000080;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_FRAMEBUFFER = $00000100;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_PIXEL       = $00000200;
  NVAPI_OGLEXPERT_REPORT_PIPELINE_TEXTURE     = $00000400;
  NVAPI_OGLEXPERT_REPORT_OBJECT_BUFFEROBJECT  = $00000800;
  NVAPI_OGLEXPERT_REPORT_OBJECT_TEXTURE       = $00001000;
  NVAPI_OGLEXPERT_REPORT_OBJECT_PROGRAM       = $00002000;
  NVAPI_OGLEXPERT_REPORT_OBJECT_FBO           = $00004000;
  NVAPI_OGLEXPERT_REPORT_FEATURE_SLI          = $00008000;
  NVAPI_OGLEXPERT_REPORT_ALL                  = $FFFFFFFF;

  NVAPI_OGLEXPERT_OUTPUT_TO_NONE              = $00000000;
  NVAPI_OGLEXPERT_OUTPUT_TO_CONSOLE           = $00000001;
  NVAPI_OGLEXPERT_OUTPUT_TO_DEBUGGER          = $00000004;
  NVAPI_OGLEXPERT_OUTPUT_TO_CALLBACK          = $00000008;
  NVAPI_OGLEXPERT_OUTPUT_TO_ALL               = $FFFFFFFF;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION TYPE: NVAPI_OGLEXPERT_CALLBACK
//
//   DESCRIPTION: Used in conjunction with OUTPUT_TO_CALLBACK, this is a simple
//                callback function the user may use to obtain the feedback
//                stream. The function will be called once per fully qualified
//                feedback stream entry.
//
//    PARAMETERS: categoryId   Contains the bit from the NVAPI_OGLEXPERT_REPORT
//                             mask that corresponds to the current message
//                messageId    Unique Id for the current message
//                detailLevel  Contains the bit from the NVAPI_OGLEXPERT_DETAIL
//                             mask that corresponds to the current message
//                objectId     Unique Id of the object that corresponds to the
//                             current message
//                messageStr   Text string from the current message
//
///////////////////////////////////////////////////////////////////////////////
type
//typedef void (* NVAPI_OGLEXPERT_CALLBACK) (unsigned int categoryId, unsigned int messageId, unsigned int detailLevel, int objectId, const char *messageStr): NvAPI_Status; cdecl;
  NVAPI_OGLEXPERT_CALLBACK = procedure (categoryId, messageId, detailLevel: Cardinal; objectId: Integer; const messageStr: PChar); cdecl;

//  SUPPORTED OS: Windows XP and higher
var
  NvAPI_OGL_ExpertModeSet: function(expertDetailLevel: NvU32;
                                 expertReportMask: NvU32;
                                 expertOutputMask: NvU32;
                                 expertCallback: NVAPI_OGLEXPERT_CALLBACK): NvAPI_Status; cdecl;


//  SUPPORTED OS: Windows XP and higher
var
  NvAPI_OGL_ExpertModeGet: function(var pExpertDetailLevel: NvU32;
                                 var pExpertReportMask: NvU32;
                                 var pExpertOutputMask;
                                 var pExpertCallback: NVAPI_OGLEXPERT_CALLBACK): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
//
// FUNCTION NAME: NvAPI_OGL_ExpertModeDefaultsSet[Get]
//
//   DESCRIPTION: Configure OpenGL Expert Mode global defaults. These settings
//                apply to any OpenGL application which starts up after these
//                values are applied (i.e. these settings *do not* apply to
//                currently running applications).
//
//    PARAMETERS: expertDetailLevel Value which specifies the detail level in
//                                  the feedback stream. This is a mask made up
//                                  of NVAPI_OGLEXPERT_LEVEL bits.
//
//                expertReportMask  Mask made up of NVAPI_OGLEXPERT_REPORT bits,
//                                  this parameter specifies the areas of
//                                  functional interest.
//
//                expertOutputMask  Mask made up of NVAPI_OGLEXPERT_OUTPUT bits,
//                                  this parameter specifies the feedback output
//                                  location. Note that using OUTPUT_TO_CALLBACK
//                                  here is meaningless and has no effect, but
//                                  using it will not cause an error.
//
// RETURN STATUS: NVAPI_ERROR or NVAPI_OK
//
///////////////////////////////////////////////////////////////////////////////

//  SUPPORTED OS: Windows XP and higher
var
  NvAPI_OGL_ExpertModeDefaultsSet: function(expertDetailLevel: NvU32;
                                         expertReportMask: NvU32;
                                         expertOutputMask: NvU32): NvAPI_Status; cdecl;

//  SUPPORTED OS: Windows XP and higher
var
  NvAPI_OGL_ExpertModeDefaultsGet: function(var pExpertDetailLevel: NvU32;
                                         var pExpertReportMask: NvU32;
                                         var pExpertOutputMask: NvU32): NvAPI_Status; cdecl;

const
  NVAPI_MAX_VIEW_TARGET = 2;

type
  _NV_TARGET_VIEW_MODE = (
    NV_VIEW_MODE_STANDARD  = 0,
    NV_VIEW_MODE_CLONE     = 1,
    NV_VIEW_MODE_HSPAN     = 2,
    NV_VIEW_MODE_VSPAN     = 3,
    NV_VIEW_MODE_DUALVIEW  = 4,
    NV_VIEW_MODE_MULTIVIEW = 5
  );
  NV_TARGET_VIEW_MODE = _NV_TARGET_VIEW_MODE;
  TNvTargetViewMode = NV_TARGET_VIEW_MODE;
  PNvTargetViewMode = ^TNvTargetViewMode;


// Following definitions are used in NvAPI_SetViewEx.
// Scaling modes
  _NV_SCALING = (
    NV_SCALING_DEFAULT          = 0,        // No change
    NV_SCALING_MONITOR_SCALING  = 1,
    NV_SCALING_ADAPTER_SCALING  = 2,
    NV_SCALING_CENTERED         = 3,
    NV_SCALING_ASPECT_SCALING   = 5,
    NV_SCALING_CUSTOMIZED       = 255       // For future use
  );
  NV_SCALING = _NV_SCALING;

// Rotate modes
  _NV_ROTATE = (
    NV_ROTATE_0           = 0,
    NV_ROTATE_90          = 1,
    NV_ROTATE_180         = 2,
    NV_ROTATE_270         = 3
  );
  NV_ROTATE = _NV_ROTATE;

// Color formats
  _NV_FORMAT = (
    NV_FORMAT_UNKNOWN       =  0,       // unknown. Driver will choose one as following value.
    NV_FORMAT_P8            = 41,       // for 8bpp mode
    NV_FORMAT_R5G6B5        = 23,       // for 16bpp mode
    NV_FORMAT_A8R8G8B8      = 21,       // for 32bpp mode
    NV_FORMAT_A16B16G16R16F = 113       // for 64bpp(floating point) mode.
  );
  NV_FORMAT = _NV_FORMAT;

// TV standard


///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_SetView
//
// DESCRIPTION:     This API lets caller to modify target display arrangement for selected source display handle in any of the nview modes.
//                  It also allows to modify or extend the source display in dualview mode.
//
//  SUPPORTED OS: Windows Vista and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA Display selection. NVAPI_DEFAULT_HANDLE not allowed, it has to be a handle enumerated with NvAPI_EnumNVidiaDisplayHandle().
//                  pTargetInfo(IN) - Pointer to array of NV_VIEW_TARGET_INFO, specifying device properties in this view.
//                                    The first device entry in the array is the physical primary.
//                                    The device entry with the lowest source id is the desktop primary.
//                  targetCount(IN) - Count of target devices specified in pTargetInfo.
//                  targetView(IN) - Target view selected from NV_TARGET_VIEW_MODE.
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT: Invalid input parameter.
//
///////////////////////////////////////////////////////////////////////////////
type
  TNvViewTargetInfoFlags = (bPrimary, bInterlaced, bGDIPrimary);
  NV_VIEW_TARGET_INFO = record
    version: NvU32;     // (IN) structure version
    count: NvU32;       // (IN) target count
    target: array[0..NVAPI_MAX_VIEW_TARGET - 1] of
      record
        deviceMask: NvU32;    // (IN/OUT) device mask
        sourceId: NvU32;      // (IN/OUT) source id

        Flags: TNvViewTargetInfoFlags;
       {bPrimary: NvU32 :1;   // (OUT) Indicates if this is the GPU's primary view target. This is not the desktop GDI primary.
                              // NvAPI_SetView automatically selects the first target in NV_VIEW_TARGET_INFO index 0 as the GPU's primary view.
        bInterlaced: NvU32 :1;// (IN/OUT) Indicates if the timing being used on this monitor is interlaced
        bGDIPrimary: NvU32 :1;// (IN/OUT) Indicates if this is the desktop GDI primary.}
      end;
  end;
  TNvViewTargetInfo = NV_VIEW_TARGET_INFO;
  PNvViewTargetInfo = ^TNvViewTargetInfo;

const
//#define NV_VIEW_TARGET_INFO_VER  MAKE_NVAPI_VERSION(NV_VIEW_TARGET_INFO,2)
  NV_VIEW_TARGET_INFO_VER = NvU32(SizeOf(NV_VIEW_TARGET_INFO) or (2 shl 16));

var
  NvAPI_SetView: function(hNvDisplay: PNvDisplayHandle; pTargetInfo: PNvViewTargetInfo; targetView: TNvTargetViewMode): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_GetView
//
// DESCRIPTION:     This API lets caller retrieve the target display arrangement for selected source display handle.
//
//  SUPPORTED OS: Windows Vista and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA Display selection. NVAPI_DEFAULT_HANDLE not allowed, it has to be a handle enumerated with NvAPI_EnumNVidiaDisplayHandle().
//                  pTargetInfo(OUT) - User allocated storage to retrieve an array of  NV_VIEW_TARGET_INFO. Can be NULL to retrieve the targetCount.
//                  targetMaskCount(IN/OUT) - Count of target device mask specified in pTargetMask.
//                  targetView(OUT) - Target view selected from NV_TARGET_VIEW_MODE.
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT: Invalid input parameter.
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetView: function(hNvDisplay: PNvDisplayHandle; pTargets: PNvViewTargetInfo; var pTargetMaskCount: NvU32; var pTargetView: TNvTargetViewMode): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_SetViewEx
//
// DESCRIPTION:     This API lets caller to modify the display arrangement for selected source display handle in any of the nview modes.
//                  It also allows to modify or extend the source display in dualview mode.
//
//  SUPPORTED OS: Windows Vista and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA Display selection. NVAPI_DEFAULT_HANDLE not allowed, it has to be a handle enumerated with NvAPI_EnumNVidiaDisplayHandle().
//                  pPathInfo(IN)  - Pointer to array of NV_VIEW_PATH_INFO, specifying device properties in this view.
//                                    The first device entry in the array is the physical primary.
//                                    The device entry with the lowest source id is the desktop primary.
//                  pathCount(IN)  - Count of paths specified in pPathInfo.
//                  displayView(IN)- Display view selected from NV_TARGET_VIEW_MODE.
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT: Invalid input parameter.
//
///////////////////////////////////////////////////////////////////////////////
const
  NVAPI_MAX_DISPLAY_PATH = NVAPI_MAX_VIEW_TARGET;

type
  NV_DISPLAY_PATH_INFO = record
    version: NvU32;     // (IN) structure version
    count: NvU32;       // (IN) path count
    path: array[0..NVAPI_MAX_DISPLAY_PATH - 1] of
      record
        deviceMask: NvU32;                        // (IN) device mask
        sourceId: NvU32;                          // (IN) source id
        bPrimary: LongBool;
       {bPrimary: NvU32;                  :1;     // (IN/OUT) Indicates if this is the GPU's primary view target. This is not the desktop GDI primary.
                                                  // NvAPI_SetViewEx automatically selects the first target in NV_DISPLAY_PATH_INFO index 0 as the GPU's primary view.}
        connector: NV_GPU_CONNECTOR_TYPE;         // (IN) Specify connector type. For TV only.

        // source mode information
        width: NvU32;                             // (IN) width of the mode
        height: NvU32;                            // (IN) height of the mode
        depth: NvU32;                             // (IN) depth of the mode
        colorFormat: NV_FORMAT;                   //      color format if needs to specify. Not used now.

        //rotation setting of the mode
        rotation: NV_ROTATE;                      // (IN) rotation setting.

        // the scaling mode
        scaling: NV_SCALING;                      // (IN) scaling setting

        // Timing info
        refreshRate: NvU32;                       // (IN) refresh rate of the mode
        interlaced: LongBool;
       {interlaced: NvU32                   :1;   // (IN) interlaced mode flag}

        tvFormat: NV_DISPLAY_TV_FORMAT;           // (IN) to choose the last TV format set this value to NV_DISPLAY_TV_FORMAT_NONE

        // Windows desktop position
        posx: NvU32;                              // (IN/OUT) x offset of this display on the Windows desktop
        posy: NvU32;                              // (IN/OUT) y offset of this display on the Windows desktop
        bGDIPrimary: LongBool;
       {bGDIPrimary: NvU32;                  :1;  // (IN/OUT) Indicates if this is the desktop GDI primary.}
      end;
  end;
  TNvDisplayPathInfo = NV_DISPLAY_PATH_INFO;
  PNvDisplayPathInfo = ^TNvDisplayPathInfo;

const
//#define NV_DISPLAY_PATH_INFO_VER  MAKE_NVAPI_VERSION(NV_DISPLAY_PATH_INFO,2)
  NV_DISPLAY_PATH_INFO_VER = NvU32(SizeOf(NV_DISPLAY_PATH_INFO) or (2 shl 16));


var
  NvAPI_SetViewEx: function(hNvDisplay: PNvDisplayHandle; pPathInfo: PNvDisplayPathInfo; displayView: TNvTargetViewMode): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_GetViewEx
//
// DESCRIPTION:     This API lets caller retrieve the target display arrangement for selected source display handle.
//
//  SUPPORTED OS: Windows Vista and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA Display selection. NVAPI_DEFAULT_HANDLE not allowed, it has to be a handle enumerated with NvAPI_EnumNVidiaDisplayHandle().
//                  pPathInfo(IN/OUT) - count field should be set to NVAPI_MAX_DISPLAY_PATH. Can be NULL to retrieve just the pathCount.
//                  pPathCount(IN/OUT) - Number of elements in array pPathInfo->path.
//                  pTargetViewMode(OUT)- Display view selected from NV_TARGET_VIEW_MODE.
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_API_NOT_INTIALIZED - NVAPI not initialized
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT - Invalid input parameter.
//                  NVAPI_EXPECTED_DISPLAY_HANDLE - hNvDisplay is not a valid display handle.
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetViewEx: function(hNvDisplay: PNvDisplayHandle; pPathInfo: PNvDisplayPathInfo; var pPathCount: NvU32; var pTargetViewMode: TNvTargetViewMode): NvAPI_Status; cdecl;

///////////////////////////////////////////////////////////////////////////////
// FUNCTION NAME:   NvAPI_GetSupportedViews
//
// DESCRIPTION:     This API lets caller enumerate all the supported NVIDIA display views - nview and dualview modes.
//
//  SUPPORTED OS: Windows XP and higher
//
// PARAMETERS:      hNvDisplay(IN) - NVIDIA Display selection. It can be NVAPI_DEFAULT_HANDLE or a handle enumerated from NvAPI_EnumNVidiaDisplayHandle().
//                  pTargetViews(OUT) - Array of supported views. Can be NULL to retrieve the pViewCount first.
//                  pViewCount(IN/OUT) - Count of supported views.
//
// RETURN STATUS:
//                  NVAPI_OK - completed request
//                  NVAPI_ERROR - miscellaneous error occurred
//                  NVAPI_INVALID_ARGUMENT: Invalid input parameter.
//
///////////////////////////////////////////////////////////////////////////////
var
  NvAPI_GetSupportedViews: function(hNvDisplay: PNvDisplayHandle; pTargetViews: PNvTargetViewMode; var pViewCount: NvU32): NvAPI_Status; cdecl;

implementation

uses
  Windows;

{ Macros }
function GetNvAPIVersion(Ver: NvU32): NvU32;
begin
  Result := Ver shr 16;
end;

function GetNvAPISize(Ver: NvU32): NvU32;
begin
  Result := Ver and $FFFF;
end;

var
  _NvAPI_SYS_GetChipSetInfo: function(var pChipSetInfo: TNvChipsetInfo): NvAPI_Status; cdecl;

function NvAPI_SYS_GetChipSetInfo(var pChipSetInfo: TNvChipsetInfo): NvAPI_Status;
begin
  Result := _NvAPI_SYS_GetChipSetInfo(pChipSetInfo);
end;

function NvAPI_SYS_GetChipSetInfo(var pChipSetInfo: TNvChipsetInfoV2): NvAPI_Status;
begin
  Result := _NvAPI_SYS_GetChipSetInfo(TNvChipsetInfo(Pointer(@pChipSetInfo)^));
end;

function NvAPI_SYS_GetChipSetInfo(var pChipSetInfo: TNvChipsetInfoV1): NvAPI_Status;
begin
  Result := _NvAPI_SYS_GetChipSetInfo(TNvChipsetInfo(Pointer(@pChipSetInfo)^));
end;


{ Initialization }
var
  Initialized: Boolean = False;

type
  PNvAPIFuncRec = ^TNvAPIFuncRec;
  TNvAPIFuncRec = record
    ID: Cardinal;
    Func: Pointer;
  end;

const
  NvAPIFunctions: array[0..63] of TNvAPIFuncRec = (
    (ID: $6C2D048C; Func: @@NvAPI_GetErrorMessage),
    (ID: $01053FA5; Func: @@NvAPI_GetInterfaceVersionString),
    (ID: $F951A4D1; Func: @@NvAPI_GetDisplayDriverVersion),
    (ID: $9ABDD40D; Func: @@NvAPI_EnumNvidiaDisplayHandle),
    (ID: $20DE9260; Func: @@NvAPI_EnumNvidiaUnAttachedDisplayHandle),
    (ID: $E5AC921F; Func: @@NvAPI_EnumPhysicalGPUs),
    (ID: $48B3EA59; Func: @@NvAPI_EnumLogicalGPUs),
    (ID: $34EF9506; Func: @@NvAPI_GetPhysicalGPUsFromDisplay),
    (ID: $5018ED61; Func: @@NvAPI_GetPhysicalGPUFromUnAttachedDisplay),
    (ID: $63F9799E; Func: @@NvAPI_CreateDisplayFromUnAttachedDisplay),
    (ID: $EE1370CF; Func: @@NvAPI_GetLogicalGPUFromDisplay),
    (ID: $ADD604D1; Func: @@NvAPI_GetLogicalGPUFromPhysicalGPU),
    (ID: $AEA3FA32; Func: @@NvAPI_GetPhysicalGPUsFromLogicalGPU),
    (ID: $35C29134; Func: @@NvAPI_GetAssociatedNvidiaDisplayHandle),
    (ID: $22A78B05; Func: @@NvAPI_GetAssociatedNvidiaDisplayName),
    (ID: $4888D790; Func: @@NvAPI_GetUnAttachedAssociatedDisplayName),
    (ID: $2863148D; Func: @@NvAPI_EnableHWCursor),
    (ID: $AB163097; Func: @@NvAPI_DisableHWCursor),
    (ID: $67B5DB55; Func: @@NvAPI_GetVBlankCounter),
    (ID: $3092AC32; Func: @@NvAPI_SetRefreshRateOverride),
    (ID: $D995937E; Func: @@NvAPI_GetAssociatedDisplayOutputId),
    (ID: $C64FF367; Func: @@NvAPI_GetDisplayPortInfo),
    (ID: $FA13E65A; Func: @@NvAPI_SetDisplayPort),
    (ID: $6AE16EC3; Func: @@NvAPI_GetHDMISupportInfo),
    (ID: $7D554F8E; Func: @@NvAPI_GPU_GetAllOutputs),
    (ID: $1730BFC9; Func: @@NvAPI_GPU_GetConnectedOutputs),
    (ID: $0680DE09; Func: @@NvAPI_GPU_GetConnectedSLIOutputs),
    (ID: $CF8CAF39; Func: @@NvAPI_GPU_GetConnectedOutputsWithLidState),
    (ID: $96043CC7; Func: @@NvAPI_GPU_GetConnectedSLIOutputsWithLidState),
    (ID: $BAAABFCC; Func: @@NvAPI_GPU_GetSystemType),
    (ID: $E3E89B6F; Func: @@NvAPI_GPU_GetActiveOutputs),
    (ID: $37D32E69; Func: @@NvAPI_GPU_GetEDID),
    (ID: $40A505E4; Func: @@NvAPI_GPU_GetOutputType),
    (ID: $34C9C2D4; Func: @@NvAPI_GPU_ValidateOutputCombination),
    (ID: $CEEE8E9F; Func: @@NvAPI_GPU_GetFullName),
    (ID: $2DDFB66E; Func: @@NvAPI_GPU_GetPCIIdentifiers),
    (ID: $C33BAEB1; Func: @@NvAPI_GPU_GetGPUType),
    (ID: $1BB18724; Func: @@NvAPI_GPU_GetBusType),
    (ID: $1BE0B8E5; Func: @@NvAPI_GPU_GetBusId),
    (ID: $2A0A350F; Func: @@NvAPI_GPU_GetBusSlotId),
    (ID: $E4715417; Func: @@NvAPI_GPU_GetIRQ),
    (ID: $ACC3DA0A; Func: @@NvAPI_GPU_GetVbiosRevision),
    (ID: $2D43FB31; Func: @@NvAPI_GPU_GetVbiosOEMRevision),
    (ID: $A561FD7D; Func: @@NvAPI_GPU_GetVbiosVersionString),
    (ID: $6E042794; Func: @@NvAPI_GPU_GetAGPAperture),
    (ID: $C74925A0; Func: @@NvAPI_GPU_GetCurrentAGPRate),
    (ID: $D048C3B1; Func: @@NvAPI_GPU_GetCurrentPCIEDownstreamWidth),
    (ID: $46FBEB03; Func: @@NvAPI_GPU_GetPhysicalFrameBufferSize),
    (ID: $5A04B644; Func: @@NvAPI_GPU_GetVirtualFrameBufferSize),
    (ID: $E3640A56; Func: @@NvAPI_GPU_GetThermalSettings),
    (ID: $2FDE12C5; Func: @@NvAPI_I2CRead),
    (ID: $E812EB07; Func: @@NvAPI_I2CWrite),
    (ID: $53DABBCA; Func: @@_NvAPI_SYS_GetChipSetInfo),
    (ID: $CDA14D8A; Func: @@NvAPI_SYS_GetLidAndDockInfo),
    (ID: $3805EF7A; Func: @@NvAPI_OGL_ExpertModeSet),
    (ID: $22ED9516; Func: @@NvAPI_OGL_ExpertModeGet),
    (ID: $B47A657E; Func: @@NvAPI_OGL_ExpertModeDefaultsSet),
    (ID: $AE921F12; Func: @@NvAPI_OGL_ExpertModeDefaultsGet),
    (ID: $0957D7B6; Func: @@NvAPI_SetView),
    (ID: $D6B99D89; Func: @@NvAPI_GetView),
    (ID: $06B89E68; Func: @@NvAPI_SetViewEx),
    (ID: $DBBC0AF4; Func: @@NvAPI_GetViewEx),
    (ID: $66FB7FC0; Func: @@NvAPI_GetSupportedViews),

    (ID: 0; Func: nil) // stop signal
  );

function NotImplemented: NvAPI_Status; cdecl;
begin
  Result := NVAPI_NO_IMPLEMENTATION;
end;

function NvAPI_Initialize;
const
  NvAPILib = 'nvapi.dll';
  NvAPI_ID_INIT = $0150E828;
var
  Lib: THandle;
  nvapi_QueryInterface: function(ID: LongWord): Pointer; cdecl;
  InitFunc: function: Integer; stdcall;
  P: Pointer;
  Rec: PNvAPIFuncRec;
begin
  if Initialized then
  begin
    Result := NVAPI_OK;
    Exit;
  end;

  Lib := LoadLibrary(NvAPILib);
  if Lib <> 0 then
  begin
    nvapi_QueryInterface := GetProcAddress(Lib, 'nvapi_QueryInterface');
    Result := NVAPI_ERROR;
    if Assigned(nvapi_QueryInterface) then
    begin
      InitFunc := nvapi_QueryInterface(NvAPI_ID_INIT);
      if Assigned(InitFunc) then
      begin
        if InitFunc() >= 0 then
        begin
          { Initialize all function pointers }
          Rec := @NvAPIFunctions;
          while Rec.ID <> 0 do
          begin
            PPointer(Rec.Func)^ := @NotImplemented;
            P := nvapi_QueryInterface(Rec.ID);
            if P <> nil then
              PPointer(Rec.Func)^ := P;
            Inc(Rec);
          end;
          Result := NVAPI_OK;
        end;
      end;
    end;
  end
  else
    Result := NVAPI_LIBRARY_NOT_FOUND;

  Initialized := Result = NVAPI_OK;
end;

end.
