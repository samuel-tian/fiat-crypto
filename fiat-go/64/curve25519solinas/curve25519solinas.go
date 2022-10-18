// Code generated by Fiat Cryptography. DO NOT EDIT.
//
// Autogenerated: 'src/ExtractionOCaml/solinas_reduction' --lang Go --no-wide-int --relax-primitive-carry-to-bitwidth 32,64 --cmovznz-by-mul --internal-static --package-case flatcase --public-function-case UpperCamelCase --private-function-case camelCase --public-type-case UpperCamelCase --private-type-case camelCase --no-prefix-fiat --doc-newline-in-typedef-bounds --doc-prepend-header 'Code generated by Fiat Cryptography. DO NOT EDIT.' --doc-text-before-function-name '' --doc-text-before-type-name '' --package-name curve25519solinas '' 64 '2^255 - 19' mul
//
// curve description (via package name): curve25519solinas
//
// machine_wordsize = 64 (from "64")
//
// requested operations: mul
//
// s-c = 2^255 - [(1, 19)] (from "2^255 - 19")
//
//
//
// Computed values:
//
//
package curve25519solinas

import "math/bits"

type uint1 uint64 // We use uint64 instead of a more narrow type for performance reasons; see https://github.com/mit-plv/fiat-crypto/pull/1006#issuecomment-892625927
type int1 int64 // We use uint64 instead of a more narrow type for performance reasons; see https://github.com/mit-plv/fiat-crypto/pull/1006#issuecomment-892625927

// Mul multiplies two field elements.
//
// Postconditions:
//   evalf out1 mod 57896044618658097711785492504343953926634992332820282019728792003956564819949 = (evalf arg1 * evalf arg2) mod 57896044618658097711785492504343953926634992332820282019728792003956564819949
//
// Input Bounds:
//   arg1: [[0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff]]
//   arg2: [[0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff]]
// Output Bounds:
//   out1: [[0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff]]
func Mul(out1 *[4]uint64, arg1 *[4]uint64, arg2 *[4]uint64) {
	var x1 uint64
	var x2 uint64
	x2, x1 = bits.Mul64(arg1[3], arg2[3])
	var x3 uint64
	var x4 uint64
	x4, x3 = bits.Mul64(arg1[3], arg2[2])
	var x5 uint64
	var x6 uint64
	x6, x5 = bits.Mul64(arg1[3], arg2[1])
	var x7 uint64
	var x8 uint64
	x8, x7 = bits.Mul64(arg1[3], arg2[0])
	var x9 uint64
	var x10 uint64
	x10, x9 = bits.Mul64(arg1[2], arg2[3])
	var x11 uint64
	var x12 uint64
	x12, x11 = bits.Mul64(arg1[2], arg2[2])
	var x13 uint64
	var x14 uint64
	x14, x13 = bits.Mul64(arg1[2], arg2[1])
	var x15 uint64
	var x16 uint64
	x16, x15 = bits.Mul64(arg1[2], arg2[0])
	var x17 uint64
	var x18 uint64
	x18, x17 = bits.Mul64(arg1[1], arg2[3])
	var x19 uint64
	var x20 uint64
	x20, x19 = bits.Mul64(arg1[1], arg2[2])
	var x21 uint64
	var x22 uint64
	x22, x21 = bits.Mul64(arg1[1], arg2[1])
	var x23 uint64
	var x24 uint64
	x24, x23 = bits.Mul64(arg1[1], arg2[0])
	var x25 uint64
	var x26 uint64
	x26, x25 = bits.Mul64(arg1[0], arg2[3])
	var x27 uint64
	var x28 uint64
	x28, x27 = bits.Mul64(arg1[0], arg2[2])
	var x29 uint64
	var x30 uint64
	x30, x29 = bits.Mul64(arg1[0], arg2[1])
	var x31 uint64
	var x32 uint64
	x32, x31 = bits.Mul64(arg1[0], arg2[0])
	var x33 uint64
	var x34 uint64
	x33, x34 = bits.Add64(x28, x7, uint64(0x0))
	var x35 uint64
	var x36 uint64
	x35, x36 = bits.Add64(x26, x5, uint64(uint1(x34)))
	x37 := (uint64(uint1(x36)) + x18)
	var x38 uint64
	var x39 uint64
	x38, x39 = bits.Add64(x33, x13, uint64(0x0))
	var x40 uint64
	var x41 uint64
	x40, x41 = bits.Add64(x35, x8, uint64(uint1(x39)))
	var x42 uint64
	var x43 uint64
	x42, x43 = bits.Add64(x37, uint64(0x0), uint64(uint1(x41)))
	x44 := (uint64(uint1(x43)) + x10)
	var x45 uint64
	var x46 uint64
	x45, x46 = bits.Add64(x30, x15, uint64(0x0))
	var x47 uint64
	var x48 uint64
	x47, x48 = bits.Add64(x38, x16, uint64(uint1(x46)))
	var x49 uint64
	var x50 uint64
	x49, x50 = bits.Add64(x40, x11, uint64(uint1(x48)))
	var x51 uint64
	var x52 uint64
	x51, x52 = bits.Add64(x42, x3, uint64(uint1(x50)))
	var x53 uint64
	var x54 uint64
	x53, x54 = bits.Add64(x44, uint64(0x0), uint64(uint1(x52)))
	x55 := (uint64(uint1(x54)) + x2)
	var x56 uint64
	var x57 uint64
	x56, x57 = bits.Add64(x45, x21, uint64(0x0))
	var x58 uint64
	var x59 uint64
	x58, x59 = bits.Add64(x47, x19, uint64(uint1(x57)))
	var x60 uint64
	var x61 uint64
	x60, x61 = bits.Add64(x49, x14, uint64(uint1(x59)))
	var x62 uint64
	var x63 uint64
	x62, x63 = bits.Add64(x51, x6, uint64(uint1(x61)))
	var x64 uint64
	var x65 uint64
	x64, x65 = bits.Add64(x53, uint64(0x0), uint64(uint1(x63)))
	var x66 uint64
	x66, _ = bits.Add64(x55, uint64(0x0), uint64(uint1(x65)))
	var x68 uint64
	var x69 uint64
	x68, x69 = bits.Add64(x32, x23, uint64(0x0))
	var x70 uint64
	var x71 uint64
	x70, x71 = bits.Add64(x56, x24, uint64(uint1(x69)))
	var x72 uint64
	var x73 uint64
	x72, x73 = bits.Add64(x58, x22, uint64(uint1(x71)))
	var x74 uint64
	var x75 uint64
	x74, x75 = bits.Add64(x60, x17, uint64(uint1(x73)))
	var x76 uint64
	var x77 uint64
	x76, x77 = bits.Add64(x62, x9, uint64(uint1(x75)))
	var x78 uint64
	var x79 uint64
	x78, x79 = bits.Add64(x64, x1, uint64(uint1(x77)))
	var x80 uint64
	x80, _ = bits.Add64(x66, uint64(0x0), uint64(uint1(x79)))
	var x82 uint64
	var x83 uint64
	x82, x83 = bits.Add64(x68, x29, uint64(0x0))
	var x84 uint64
	var x85 uint64
	x84, x85 = bits.Add64(x70, x27, uint64(uint1(x83)))
	var x86 uint64
	var x87 uint64
	x86, x87 = bits.Add64(x72, x25, uint64(uint1(x85)))
	var x88 uint64
	var x89 uint64
	x88, x89 = bits.Add64(x74, x20, uint64(uint1(x87)))
	var x90 uint64
	var x91 uint64
	x90, x91 = bits.Add64(x76, x12, uint64(uint1(x89)))
	var x92 uint64
	var x93 uint64
	x92, x93 = bits.Add64(x78, x4, uint64(uint1(x91)))
	var x94 uint64
	x94, _ = bits.Add64(x80, uint64(0x0), uint64(uint1(x93)))
	var x96 uint64
	var x97 uint64
	x97, x96 = bits.Mul64(0x26, x92)
	var x98 uint64
	var x99 uint64
	x99, x98 = bits.Mul64(0x26, x90)
	var x100 uint64
	var x101 uint64
	x101, x100 = bits.Mul64(0x26, x88)
	var x102 uint64
	var x103 uint64
	x102, x103 = bits.Add64(x82, x98, uint64(0x0))
	var x104 uint64
	var x105 uint64
	x104, x105 = bits.Add64(x84, x96, uint64(uint1(x103)))
	var x106 uint64
	_, x106 = bits.Mul64(0x26, x94)
	var x108 uint64
	var x109 uint64
	x108, x109 = bits.Add64(x86, x106, uint64(uint1(x105)))
	var x111 uint64
	x111, _ = bits.Mul64(0x26, x94)
	x112 := (uint64(uint1(x109)) + x111)
	var x113 uint64
	var x114 uint64
	x113, x114 = bits.Add64(x31, x100, uint64(0x0))
	var x115 uint64
	var x116 uint64
	x115, x116 = bits.Add64(x102, x101, uint64(uint1(x114)))
	var x117 uint64
	var x118 uint64
	x117, x118 = bits.Add64(x104, x99, uint64(uint1(x116)))
	var x119 uint64
	var x120 uint64
	x119, x120 = bits.Add64(x108, x97, uint64(uint1(x118)))
	x121 := (uint64(uint1(x120)) + x112)
	var x122 uint64
	_, x122 = bits.Mul64(0x26, x121)
	var x124 uint64
	var x125 uint64
	x124, x125 = bits.Add64(x113, x122, uint64(0x0))
	var x126 uint64
	var x127 uint64
	x126, x127 = bits.Add64(x115, uint64(0x0), uint64(uint1(x125)))
	var x128 uint64
	var x129 uint64
	x128, x129 = bits.Add64(x117, uint64(0x0), uint64(uint1(x127)))
	var x130 uint64
	var x131 uint64
	x130, x131 = bits.Add64(x119, uint64(0x0), uint64(uint1(x129)))
	var x132 uint64
	_, x132 = bits.Mul64(0x26, uint1(x131))
	var x134 uint64
	var x135 uint64
	x134, x135 = bits.Add64(x124, x132, uint64(0x0))
	var x136 uint64
	var x137 uint64
	x136, x137 = bits.Add64(x126, uint64(0x0), uint64(uint1(x135)))
	var x138 uint64
	var x139 uint64
	x138, x139 = bits.Add64(x128, uint64(0x0), uint64(uint1(x137)))
	var x140 uint64
	x140, _ = bits.Add64(x130, uint64(0x0), uint64(uint1(x139)))
	out1[0] = x134
	out1[1] = x136
	out1[2] = x138
	out1[3] = x140
}
