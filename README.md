# Mezz'Estate Neogeo Audio Driver

## (Patch for limited support for ADPCM-B, used in Scorpion Engine - best to use the original version unless you know what you're doing!)

Two new commands:

* Command 12 ($C) used to trigger ADPCM-B sample (parameter = sample number. Based on FreeM driver)
* Command 13 ($D) used to stop ADPCM-B sample (using existing function in Mezz'Estate)

No ability to set the loop, volume, left/right channel values at runtime - but these can be baked into the ROM. Details are below.

No support for ADPCM-B in the MLM music, and of course no support for NeoGeo CD (the driver can still be used on NeoGeo CD if you do not use the new commands - but if you're only developing for NeoGeo CD, there's no reason to use this version of the driver at all).

ADPCM-B uses the same sample table and format as ADPCM-A, with the exception that two slots are needed per sample. For the second slot:

* First two bytes are N-DELTA value (low byte first)
* Third byte is the volume ($FF for full volume)
* Fourth byte combines the channel select and control bits (bits 7/6 for left/right and bit 4 for loop - eg $D0 for a sample that loops on both channels)

No update to the toolchain has been made, you'll need to generate your sample table and convert samples to ADPCM-B at your end.

ROM size has been increased to $6100 bytes in order to accomodate the new code.

An audio driver for the NeoGeo MVS and AES written in assembly.<br/>
Check [the wiki](https://github.com/stereomimi/Mezz-Estate-NeoGeo-Audio-Driver/wiki) for further information

## Compilation dependencies
* This specific [ZASM fork](https://github.com/neogeo-mzs/zasm) (You'll have to compile it yourself, there's no actual executables)
* [RomWak](https://github.com/freem/romwak)
* Python 3.9.7+ (Might work with other versions higher than 3.0.0, not tested)
* [adpcma](https://github.com/freem/adpcma) (Just for converting the test's program's samples)
* [ngdevkit](https://github.com/dciabrin/ngdevkit) (Just for compiling the test software)
* Mame (Can be any emulator, but this repo has neat stuff for Mame SDL)
* [NeoSdConv](https://github.com/city41/neosdconv) (Just for exporting to TerraOnion's flashcart)

## Z80 memory map
Address space | Description           | Usage
--------------|-----------------------|--------------------------
$0000 ~ $60FF | Static main code bank | Code (Earok - additional 256 bytes reserved for PCMB code)
$6100 ~ $7FFF | Static main code bank | MLM header and song data
$8000 ~ $F7FF | Switchable banks      | Song data
$F800 ~ $FFFF | Work RAM              | Work RAM
