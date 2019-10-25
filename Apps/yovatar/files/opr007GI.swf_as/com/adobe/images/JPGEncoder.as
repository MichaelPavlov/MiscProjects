package com.adobe.images 
{
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    
    public class JPGEncoder extends Object
    {
        public function JPGEncoder(arg1:Number=50)
        {
            var loc2:*;

            ZigZag = [0, 1, 5, 6, 14, 15, 27, 28, 2, 4, 7, 13, 16, 26, 29, 42, 3, 8, 12, 17, 25, 30, 41, 43, 9, 11, 18, 24, 31, 40, 44, 53, 10, 19, 23, 32, 39, 45, 52, 54, 20, 22, 33, 38, 46, 51, 55, 60, 21, 34, 37, 47, 50, 56, 59, 61, 35, 36, 48, 49, 57, 58, 62, 63];
            YTable = new Array(64);
            UVTable = new Array(64);
            fdtbl_Y = new Array(64);
            fdtbl_UV = new Array(64);
            std_dc_luminance_nrcodes = [0, (0), 1, 5, 1, (1), (1), 1, (1), (1), 0, (0), (0), 0, (0), (0), 0];
            std_dc_luminance_values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
            std_ac_luminance_nrcodes = [0, (0), 2, 1, 3, (3), 2, 4, 3, 5, (5), 4, (4), 0, (0), 1, 125];
            std_ac_luminance_values = [1, 2, 3, 0, 4, 17, 5, 18, 33, 49, 65, 6, 19, 81, 97, 7, 34, 113, 20, 50, 129, 145, 161, 8, 35, 66, 177, 193, 21, 82, 209, 240, 36, 51, 98, 114, 130, 9, 10, 22, 23, 24, 25, 26, 37, 38, 39, 40, 41, 42, 52, 53, 54, 55, 56, 57, 58, 67, 68, 69, 70, 71, 72, 73, 74, 83, 84, 85, 86, 87, 88, 89, 90, 99, 100, 101, 102, 103, 104, 105, 106, 115, 116, 117, 118, 119, 120, 121, 122, 131, 132, 133, 134, 135, 136, 137, 138, 146, 147, 148, 149, 150, 151, 152, 153, 154, 162, 163, 164, 165, 166, 167, 168, 169, 170, 178, 179, 180, 181, 182, 183, 184, 185, 186, 194, 195, 196, 197, 198, 199, 200, 201, 202, 210, 211, 212, 213, 214, 215, 216, 217, 218, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250];
            std_dc_chrominance_nrcodes = [0, (0), 3, 1, (1), (1), 1, (1), (1), 1, (1), (1), 0, (0), (0), 0, (0)];
            std_dc_chrominance_values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
            std_ac_chrominance_nrcodes = [0, (0), 2, 1, 2, 4, (4), 3, 4, 7, 5, 4, (4), 0, 1, 2, 119];
            std_ac_chrominance_values = [0, 1, 2, 3, 17, 4, 5, 33, 49, 6, 18, 65, 81, 7, 97, 113, 19, 34, 50, 129, 8, 20, 66, 145, 161, 177, 193, 9, 35, 51, 82, 240, 21, 98, 114, 209, 10, 22, 36, 52, 225, 37, 241, 23, 24, 25, 26, 38, 39, 40, 41, 42, 53, 54, 55, 56, 57, 58, 67, 68, 69, 70, 71, 72, 73, 74, 83, 84, 85, 86, 87, 88, 89, 90, 99, 100, 101, 102, 103, 104, 105, 106, 115, 116, 117, 118, 119, 120, 121, 122, 130, 131, 132, 133, 134, 135, 136, 137, 138, 146, 147, 148, 149, 150, 151, 152, 153, 154, 162, 163, 164, 165, 166, 167, 168, 169, 170, 178, 179, 180, 181, 182, 183, 184, 185, 186, 194, 195, 196, 197, 198, 199, 200, 201, 202, 210, 211, 212, 213, 214, 215, 216, 217, 218, 226, 227, 228, 229, 230, 231, 232, 233, 234, 242, 243, 244, 245, 246, 247, 248, 249, 250];
            bitcode = new Array(65535);
            category = new Array(65535);
            DU = new Array(64);
            YDU = new Array(64);
            UDU = new Array(64);
            VDU = new Array(64);
            super();
            if (arg1 <= 0)
            {
                arg1 = 1;
            }
            if (arg1 > 100)
            {
                arg1 = 100;
            }
            loc2 = 0;
            if (arg1 < 50)
            {
                loc2 = int(5000 / arg1);
            }
            else 
            {
                loc2 = int(200 - arg1 * 2);
            }
            initHuffmanTbl();
            initCategoryNumber();
            initQuantTables(loc2);
            return;
        }

        private function initHuffmanTbl():void
        {
            YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes, std_dc_luminance_values);
            UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes, std_dc_chrominance_values);
            YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes, std_ac_luminance_values);
            UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes, std_ac_chrominance_values);
            return;
        }

        private function RGB2YUV(arg1:flash.display.BitmapData, arg2:int, arg3:int):void
        {
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;

            loc6 = 0;
            loc7 = 0;
            loc8 = NaN;
            loc9 = NaN;
            loc10 = NaN;
            loc4 = 0;
            loc5 = 0;
            while (loc5 < 8) 
            {
                loc6 = 0;
                while (loc6 < 8) 
                {
                    loc7 = arg1.getPixel32(arg2 + loc6, arg3 + loc5);
                    loc8 = Number(loc7 >> 16 & 255);
                    loc9 = Number(loc7 >> 8 & 255);
                    loc10 = Number(loc7 & 255);
                    YDU[loc4] = 0.299 * loc8 + 0.587 * loc9 + 0.114 * loc10 - 128;
                    UDU[loc4] = -0.16874 * loc8 + -0.33126 * loc9 + 0.5 * loc10;
                    VDU[loc4] = 0.5 * loc8 + -0.41869 * loc9 + -0.08131 * loc10;
                    ++loc4;
                    ++loc6;
                }
                ++loc5;
            }
            return;
        }

        private function writeBits(arg1:com.adobe.images.BitString):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;

            loc2 = arg1.val;
            loc3 = (arg1.len - 1);
            while (loc3 >= 0) 
            {
                if (loc2 & uint(1 << loc3))
                {
                    bytenew = bytenew | uint(1 << bytepos);
                }
                loc3 = (loc3 - 1);
                bytepos--;
                if (!(bytepos < 0))
                {
                    continue;
                }
                if (bytenew != 255)
                {
                    writeByte(bytenew);
                }
                else 
                {
                    writeByte(255);
                    writeByte(0);
                }
                bytepos = 7;
                bytenew = 0;
            }
            return;
        }

        private function writeWord(arg1:int):void
        {
            writeByte(arg1 >> 8 & 255);
            writeByte(arg1 & 255);
            return;
        }

        private function writeByte(arg1:int):void
        {
            byteout.writeByte(arg1);
            return;
        }

        private function writeDHT():void
        {
            var loc1:*;

            loc1 = 0;
            writeWord(65476);
            writeWord(418);
            writeByte(0);
            loc1 = 0;
            while (loc1 < 16) 
            {
                writeByte(std_dc_luminance_nrcodes[(loc1 + 1)]);
                ++loc1;
            }
            loc1 = 0;
            while (loc1 <= 11) 
            {
                writeByte(std_dc_luminance_values[loc1]);
                ++loc1;
            }
            writeByte(16);
            loc1 = 0;
            while (loc1 < 16) 
            {
                writeByte(std_ac_luminance_nrcodes[(loc1 + 1)]);
                ++loc1;
            }
            loc1 = 0;
            while (loc1 <= 161) 
            {
                writeByte(std_ac_luminance_values[loc1]);
                ++loc1;
            }
            writeByte(1);
            loc1 = 0;
            while (loc1 < 16) 
            {
                writeByte(std_dc_chrominance_nrcodes[(loc1 + 1)]);
                ++loc1;
            }
            loc1 = 0;
            while (loc1 <= 11) 
            {
                writeByte(std_dc_chrominance_values[loc1]);
                ++loc1;
            }
            writeByte(17);
            loc1 = 0;
            while (loc1 < 16) 
            {
                writeByte(std_ac_chrominance_nrcodes[(loc1 + 1)]);
                ++loc1;
            }
            loc1 = 0;
            while (loc1 <= 161) 
            {
                writeByte(std_ac_chrominance_values[loc1]);
                ++loc1;
            }
            return;
        }

        public function encode(arg1:flash.display.BitmapData):flash.utils.ByteArray
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc6 = 0;
            loc7 = null;
            byteout = new ByteArray();
            bytenew = 0;
            bytepos = 7;
            writeWord(65496);
            writeAPP0();
            writeDQT();
            writeSOF0(arg1.width, arg1.height);
            writeDHT();
            writeSOS();
            loc2 = 0;
            loc3 = 0;
            loc4 = 0;
            bytenew = 0;
            bytepos = 7;
            loc5 = 0;
            while (loc5 < arg1.height) 
            {
                loc6 = 0;
                while (loc6 < arg1.width) 
                {
                    RGB2YUV(arg1, loc6, loc5);
                    loc2 = processDU(YDU, fdtbl_Y, loc2, YDC_HT, YAC_HT);
                    loc3 = processDU(UDU, fdtbl_UV, loc3, UVDC_HT, UVAC_HT);
                    loc4 = processDU(VDU, fdtbl_UV, loc4, UVDC_HT, UVAC_HT);
                    loc6 = loc6 + 8;
                }
                loc5 = loc5 + 8;
            }
            if (bytepos >= 0)
            {
                (loc7 = new BitString()).len = bytepos + 1;
                loc7.val = (1 << bytepos + 1 - 1);
                writeBits(loc7);
            }
            writeWord(65497);
            return byteout;
        }

        private function initCategoryNumber():void
        {
            var loc1:*;
            var loc2:*;
            var loc3:*;
            var loc4:*;

            loc3 = 0;
            loc1 = 1;
            loc2 = 2;
            loc4 = 1;
            while (loc4 <= 15) 
            {
                loc3 = loc1;
                while (loc3 < loc2) 
                {
                    category[(32767 + loc3)] = loc4;
                    bitcode[(32767 + loc3)] = new BitString();
                    bitcode[(32767 + loc3)].len = loc4;
                    bitcode[(32767 + loc3)].val = loc3;
                    ++loc3;
                }
                loc3 = -(loc2 - 1);
                while (loc3 <= -loc1) 
                {
                    category[(32767 + loc3)] = loc4;
                    bitcode[(32767 + loc3)] = new BitString();
                    bitcode[(32767 + loc3)].len = loc4;
                    bitcode[(32767 + loc3)].val = (loc2 - 1) + loc3;
                    ++loc3;
                }
                loc1 = loc1 << 1;
                loc2 = loc2 << 1;
                ++loc4;
            }
            return;
        }

        private function writeDQT():void
        {
            var loc1:*;

            loc1 = 0;
            writeWord(65499);
            writeWord(132);
            writeByte(0);
            loc1 = 0;
            while (loc1 < 64) 
            {
                writeByte(YTable[loc1]);
                ++loc1;
            }
            writeByte(1);
            loc1 = 0;
            while (loc1 < 64) 
            {
                writeByte(UVTable[loc1]);
                ++loc1;
            }
            return;
        }

        private function writeAPP0():void
        {
            writeWord(65504);
            writeWord(16);
            writeByte(74);
            writeByte(70);
            writeByte(73);
            writeByte(70);
            writeByte(0);
            writeByte(1);
            writeByte(1);
            writeByte(0);
            writeWord(1);
            writeWord(1);
            writeByte(0);
            writeByte(0);
            return;
        }

        private function writeSOS():void
        {
            writeWord(65498);
            writeWord(12);
            writeByte(3);
            writeByte(1);
            writeByte(0);
            writeByte(2);
            writeByte(17);
            writeByte(3);
            writeByte(17);
            writeByte(0);
            writeByte(63);
            writeByte(0);
            return;
        }

        private function processDU(arg1:Array, arg2:Array, arg3:Number, arg4:Array, arg5:Array):Number
        {
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;

            loc8 = 0;
            loc12 = 0;
            loc13 = 0;
            loc14 = 0;
            loc6 = arg5[0];
            loc7 = arg5[240];
            loc9 = fDCTQuant(arg1, arg2);
            loc8 = 0;
            while (loc8 < 64) 
            {
                DU[ZigZag[loc8]] = loc9[loc8];
                ++loc8;
            }
            loc10 = DU[0] - arg3;
            arg3 = DU[0];
            if (loc10 != 0)
            {
                writeBits(arg4[category[(32767 + loc10)]]);
                writeBits(bitcode[(32767 + loc10)]);
            }
            else 
            {
                writeBits(arg4[0]);
            }
            loc11 = 63;
            while (loc11 > 0 && DU[loc11] == 0) 
            {
                loc11 = (loc11 - 1);
            }
            if (loc11 == 0)
            {
                writeBits(loc6);
                return arg3;
            }
            loc8 = 1;
            while (loc8 <= loc11) 
            {
                loc12 = loc8;
                while (DU[loc8] == 0 && loc8 <= loc11) 
                {
                    ++loc8;
                }
                if ((loc13 = loc8 - loc12) >= 16)
                {
                    loc14 = 1;
                    while (loc14 <= loc13 / 16) 
                    {
                        writeBits(loc7);
                        ++loc14;
                    }
                    loc13 = int(loc13 & 15);
                }
                writeBits(arg5[(loc13 * 16 + category[(32767 + DU[loc8])])]);
                writeBits(bitcode[(32767 + DU[loc8])]);
                ++loc8;
            }
            if (loc11 != 63)
            {
                writeBits(loc6);
            }
            return arg3;
        }

        private function initQuantTables(arg1:int):void
        {
            var loc2:*;
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;

            loc2 = 0;
            loc3 = NaN;
            loc8 = 0;
            loc4 = [16, 11, 10, 16, 24, 40, 51, 61, 12, (12), 14, 19, 26, 58, 60, 55, 14, 13, 16, 24, 40, 57, 69, 56, 14, 17, 22, 29, 51, 87, 80, 62, 18, 22, 37, 56, 68, 109, 103, 77, 24, 35, 55, 64, 81, 104, 113, 92, 49, 64, 78, 87, 103, 121, 120, 101, 72, 92, 95, 98, 112, 100, 103, 99];
            loc2 = 0;
            while (loc2 < 64) 
            {
                loc3 = Math.floor((loc4[loc2] * arg1 + 50) / 100);
                if (loc3 < 1)
                {
                    loc3 = 1;
                }
                else 
                {
                    if (loc3 > 255)
                    {
                        loc3 = 255;
                    }
                }
                YTable[ZigZag[loc2]] = loc3;
                ++loc2;
            }
            loc5 = [17, 18, 24, 47, 99, (99), (99), 99, 18, 21, 26, 66, 99, (99), (99), 99, 24, 26, 56, 99, (99), (99), 99, (99), 47, 66, 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99), (99), 99, (99)];
            loc2 = 0;
            while (loc2 < 64) 
            {
                loc3 = Math.floor((loc5[loc2] * arg1 + 50) / 100);
                if (loc3 < 1)
                {
                    loc3 = 1;
                }
                else 
                {
                    if (loc3 > 255)
                    {
                        loc3 = 255;
                    }
                }
                UVTable[ZigZag[loc2]] = loc3;
                ++loc2;
            }
            loc6 = [1, 1.387039845, 1.306562965, 1.175875602, 1, 0.785694958, 0.5411961, 0.275899379];
            loc2 = 0;
            loc7 = 0;
            while (loc7 < 8) 
            {
                loc8 = 0;
                while (loc8 < 8) 
                {
                    fdtbl_Y[loc2] = 1 / (YTable[ZigZag[loc2]] * loc6[loc7] * loc6[loc8] * 8);
                    fdtbl_UV[loc2] = 1 / (UVTable[ZigZag[loc2]] * loc6[loc7] * loc6[loc8] * 8);
                    ++loc2;
                    ++loc8;
                }
                ++loc7;
            }
            return;
        }

        private function writeSOF0(arg1:int, arg2:int):void
        {
            writeWord(65472);
            writeWord(17);
            writeByte(8);
            writeWord(arg2);
            writeWord(arg1);
            writeByte(3);
            writeByte(1);
            writeByte(17);
            writeByte(0);
            writeByte(2);
            writeByte(17);
            writeByte(1);
            writeByte(3);
            writeByte(17);
            writeByte(1);
            return;
        }

        private function computeHuffmanTbl(arg1:Array, arg2:Array):Array
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;

            loc7 = 0;
            loc3 = 0;
            loc4 = 0;
            loc5 = new Array();
            loc6 = 1;
            while (loc6 <= 16) 
            {
                loc7 = 1;
                while (loc7 <= arg1[loc6]) 
                {
                    loc5[arg2[loc4]] = new BitString();
                    loc5[arg2[loc4]].val = loc3;
                    loc5[arg2[loc4]].len = loc6;
                    ++loc4;
                    ++loc3;
                    ++loc7;
                }
                loc3 = loc3 * 2;
                ++loc6;
            }
            return loc5;
        }

        private function fDCTQuant(arg1:Array, arg2:Array):Array
        {
            var loc3:*;
            var loc4:*;
            var loc5:*;
            var loc6:*;
            var loc7:*;
            var loc8:*;
            var loc9:*;
            var loc10:*;
            var loc11:*;
            var loc12:*;
            var loc13:*;
            var loc14:*;
            var loc15:*;
            var loc16:*;
            var loc17:*;
            var loc18:*;
            var loc19:*;
            var loc20:*;
            var loc21:*;
            var loc22:*;
            var loc23:*;

            loc3 = NaN;
            loc4 = NaN;
            loc5 = NaN;
            loc6 = NaN;
            loc7 = NaN;
            loc8 = NaN;
            loc9 = NaN;
            loc10 = NaN;
            loc11 = NaN;
            loc12 = NaN;
            loc13 = NaN;
            loc14 = NaN;
            loc15 = NaN;
            loc16 = NaN;
            loc17 = NaN;
            loc18 = NaN;
            loc19 = NaN;
            loc20 = NaN;
            loc21 = NaN;
            loc22 = 0;
            loc23 = 0;
            loc22 = 0;
            while (loc22 < 8) 
            {
                loc3 = arg1[(loc23 + 0)] + arg1[(loc23 + 7)];
                loc10 = arg1[(loc23 + 0)] - arg1[(loc23 + 7)];
                loc4 = arg1[(loc23 + 1)] + arg1[(loc23 + 6)];
                loc9 = arg1[(loc23 + 1)] - arg1[(loc23 + 6)];
                loc5 = arg1[(loc23 + 2)] + arg1[(loc23 + 5)];
                loc8 = arg1[(loc23 + 2)] - arg1[(loc23 + 5)];
                loc6 = arg1[(loc23 + 3)] + arg1[(loc23 + 4)];
                loc7 = arg1[(loc23 + 3)] - arg1[(loc23 + 4)];
                loc11 = loc3 + loc6;
                loc14 = loc3 - loc6;
                loc12 = loc4 + loc5;
                loc13 = loc4 - loc5;
                arg1[(loc23 + 0)] = loc11 + loc12;
                arg1[(loc23 + 4)] = loc11 - loc12;
                loc15 = (loc13 + loc14) * 0.707106781;
                arg1[(loc23 + 2)] = loc14 + loc15;
                arg1[(loc23 + 6)] = loc14 - loc15;
                loc11 = loc7 + loc8;
                loc12 = loc8 + loc9;
                loc13 = loc9 + loc10;
                loc19 = (loc11 - loc13) * 0.382683433;
                loc16 = 0.5411961 * loc11 + loc19;
                loc18 = 1.306562965 * loc13 + loc19;
                loc17 = loc12 * 0.707106781;
                loc20 = loc10 + loc17;
                loc21 = loc10 - loc17;
                arg1[(loc23 + 5)] = loc21 + loc16;
                arg1[(loc23 + 3)] = loc21 - loc16;
                arg1[(loc23 + 1)] = loc20 + loc18;
                arg1[(loc23 + 7)] = loc20 - loc18;
                loc23 = loc23 + 8;
                ++loc22;
            }
            loc23 = 0;
            loc22 = 0;
            while (loc22 < 8) 
            {
                loc3 = arg1[(loc23 + 0)] + arg1[(loc23 + 56)];
                loc10 = arg1[(loc23 + 0)] - arg1[(loc23 + 56)];
                loc4 = arg1[(loc23 + 8)] + arg1[(loc23 + 48)];
                loc9 = arg1[(loc23 + 8)] - arg1[(loc23 + 48)];
                loc5 = arg1[(loc23 + 16)] + arg1[(loc23 + 40)];
                loc8 = arg1[(loc23 + 16)] - arg1[(loc23 + 40)];
                loc6 = arg1[(loc23 + 24)] + arg1[(loc23 + 32)];
                loc7 = arg1[(loc23 + 24)] - arg1[(loc23 + 32)];
                loc11 = loc3 + loc6;
                loc14 = loc3 - loc6;
                loc12 = loc4 + loc5;
                loc13 = loc4 - loc5;
                arg1[(loc23 + 0)] = loc11 + loc12;
                arg1[(loc23 + 32)] = loc11 - loc12;
                loc15 = (loc13 + loc14) * 0.707106781;
                arg1[(loc23 + 16)] = loc14 + loc15;
                arg1[(loc23 + 48)] = loc14 - loc15;
                loc11 = loc7 + loc8;
                loc12 = loc8 + loc9;
                loc13 = loc9 + loc10;
                loc19 = (loc11 - loc13) * 0.382683433;
                loc16 = 0.5411961 * loc11 + loc19;
                loc18 = 1.306562965 * loc13 + loc19;
                loc17 = loc12 * 0.707106781;
                loc20 = loc10 + loc17;
                loc21 = loc10 - loc17;
                arg1[(loc23 + 40)] = loc21 + loc16;
                arg1[(loc23 + 24)] = loc21 - loc16;
                arg1[(loc23 + 8)] = loc20 + loc18;
                arg1[(loc23 + 56)] = loc20 - loc18;
                ++loc23;
                ++loc22;
            }
            loc22 = 0;
            while (loc22 < 64) 
            {
                arg1[loc22] = Math.round(arg1[loc22] * arg2[loc22]);
                ++loc22;
            }
            return arg1;
        }

        private var fdtbl_UV:Array;

        private var std_ac_chrominance_values:Array;

        private var std_dc_chrominance_values:Array;

        private var ZigZag:Array;

        private var YDC_HT:Array;

        private var YAC_HT:Array;

        private var bytenew:int=0;

        private var fdtbl_Y:Array;

        private var std_ac_chrominance_nrcodes:Array;

        private var DU:Array;

        private var std_ac_luminance_values:Array;

        private var std_dc_chrominance_nrcodes:Array;

        private var UVTable:Array;

        private var YDU:Array;

        private var UDU:Array;

        private var byteout:flash.utils.ByteArray;

        private var UVAC_HT:Array;

        private var UVDC_HT:Array;

        private var bytepos:int=7;

        private var VDU:Array;

        private var std_ac_luminance_nrcodes:Array;

        private var std_dc_luminance_values:Array;

        private var YTable:Array;

        private var std_dc_luminance_nrcodes:Array;

        private var bitcode:Array;

        private var category:Array;
    }
}
