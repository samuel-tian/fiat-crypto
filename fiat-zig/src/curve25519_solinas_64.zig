// Autogenerated: 'src/ExtractionOCaml/solinas_reduction' --lang Zig --internal-static --public-function-case camelCase --private-function-case camelCase --public-type-case UpperCamelCase --private-type-case UpperCamelCase --no-prefix-fiat --package-name curve25519_solinas '' 64 '2^255 - 19' mul
// curve description (via package name): curve25519_solinas
// machine_wordsize = 64 (from "64")
// requested operations: mul
// s-c = 2^255 - [(1, 19)] (from "2^255 - 19")
//
// Computed values:
//

const std = @import("std");
const mode = @import("builtin").mode; // Checked arithmetic is disabled in non-debug modes to avoid side channels

inline fn cast(comptime DestType: type, target: anytype) DestType {
    @setEvalBranchQuota(10000);
    if (@typeInfo(@TypeOf(target)) == .Int) {
        const dest = @typeInfo(DestType).Int;
        const source = @typeInfo(@TypeOf(target)).Int;
        if (dest.bits < source.bits) {
            return @bitCast(DestType, @truncate(std.meta.Int(source.signedness, dest.bits), target));
        } else {
            return @bitCast(DestType, @as(std.meta.Int(source.signedness, dest.bits), target));
        }
    }
    return @as(DestType, target);
}

/// The function addcarryxU64 is an addition with carry.
///
/// Postconditions:
///   out1 = (arg1 + arg2 + arg3) mod 2^64
///   out2 = ⌊(arg1 + arg2 + arg3) / 2^64⌋
///
/// Input Bounds:
///   arg1: [0x0 ~> 0x1]
///   arg2: [0x0 ~> 0xffffffffffffffff]
///   arg3: [0x0 ~> 0xffffffffffffffff]
/// Output Bounds:
///   out1: [0x0 ~> 0xffffffffffffffff]
///   out2: [0x0 ~> 0x1]
inline fn addcarryxU64(out1: *u64, out2: *u1, arg1: u1, arg2: u64, arg3: u64) void {
    @setRuntimeSafety(mode == .Debug);

    const x1 = ((cast(u128, arg1) + cast(u128, arg2)) + cast(u128, arg3));
    const x2 = cast(u64, (x1 & cast(u128, 0xffffffffffffffff)));
    const x3 = cast(u1, (x1 >> 64));
    out1.* = x2;
    out2.* = x3;
}

/// The function subborrowxU64 is a subtraction with borrow.
///
/// Postconditions:
///   out1 = (-arg1 + arg2 + -arg3) mod 2^64
///   out2 = -⌊(-arg1 + arg2 + -arg3) / 2^64⌋
///
/// Input Bounds:
///   arg1: [0x0 ~> 0x1]
///   arg2: [0x0 ~> 0xffffffffffffffff]
///   arg3: [0x0 ~> 0xffffffffffffffff]
/// Output Bounds:
///   out1: [0x0 ~> 0xffffffffffffffff]
///   out2: [0x0 ~> 0x1]
inline fn subborrowxU64(out1: *u64, out2: *u1, arg1: u1, arg2: u64, arg3: u64) void {
    @setRuntimeSafety(mode == .Debug);

    const x1 = ((cast(i128, arg2) - cast(i128, arg1)) - cast(i128, arg3));
    const x2 = cast(i1, (x1 >> 64));
    const x3 = cast(u64, (x1 & cast(i128, 0xffffffffffffffff)));
    out1.* = x3;
    out2.* = cast(u1, (cast(i2, 0x0) - cast(i2, x2)));
}

/// The function mulxU64 is a multiplication, returning the full double-width result.
///
/// Postconditions:
///   out1 = (arg1 * arg2) mod 2^64
///   out2 = ⌊arg1 * arg2 / 2^64⌋
///
/// Input Bounds:
///   arg1: [0x0 ~> 0xffffffffffffffff]
///   arg2: [0x0 ~> 0xffffffffffffffff]
/// Output Bounds:
///   out1: [0x0 ~> 0xffffffffffffffff]
///   out2: [0x0 ~> 0xffffffffffffffff]
inline fn mulxU64(out1: *u64, out2: *u64, arg1: u64, arg2: u64) void {
    @setRuntimeSafety(mode == .Debug);

    const x1 = (cast(u128, arg1) * cast(u128, arg2));
    const x2 = cast(u64, (x1 & cast(u128, 0xffffffffffffffff)));
    const x3 = cast(u64, (x1 >> 64));
    out1.* = x2;
    out2.* = x3;
}

/// The function mul multiplies two field elements.
///
/// Postconditions:
///   evalf out1 mod 57896044618658097711785492504343953926634992332820282019728792003956564819949 = (evalf arg1 * evalf arg2) mod 57896044618658097711785492504343953926634992332820282019728792003956564819949
///
/// Input Bounds:
///   arg1: [[0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff]]
///   arg2: [[0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff]]
/// Output Bounds:
///   out1: [[0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff], [0x0 ~> 0xffffffffffffffff]]
pub fn mul(out1: *[4]u64, arg1: [4]u64, arg2: [4]u64) void {
    @setRuntimeSafety(mode == .Debug);

    var x1: u64 = undefined;
    var x2: u64 = undefined;
    mulxU64(&x1, &x2, (arg1[3]), (arg2[3]));
    var x3: u64 = undefined;
    var x4: u64 = undefined;
    mulxU64(&x3, &x4, (arg1[3]), (arg2[2]));
    var x5: u64 = undefined;
    var x6: u64 = undefined;
    mulxU64(&x5, &x6, (arg1[3]), (arg2[1]));
    var x7: u64 = undefined;
    var x8: u64 = undefined;
    mulxU64(&x7, &x8, (arg1[3]), (arg2[0]));
    var x9: u64 = undefined;
    var x10: u64 = undefined;
    mulxU64(&x9, &x10, (arg1[2]), (arg2[3]));
    var x11: u64 = undefined;
    var x12: u64 = undefined;
    mulxU64(&x11, &x12, (arg1[2]), (arg2[2]));
    var x13: u64 = undefined;
    var x14: u64 = undefined;
    mulxU64(&x13, &x14, (arg1[2]), (arg2[1]));
    var x15: u64 = undefined;
    var x16: u64 = undefined;
    mulxU64(&x15, &x16, (arg1[2]), (arg2[0]));
    var x17: u64 = undefined;
    var x18: u64 = undefined;
    mulxU64(&x17, &x18, (arg1[1]), (arg2[3]));
    var x19: u64 = undefined;
    var x20: u64 = undefined;
    mulxU64(&x19, &x20, (arg1[1]), (arg2[2]));
    var x21: u64 = undefined;
    var x22: u64 = undefined;
    mulxU64(&x21, &x22, (arg1[1]), (arg2[1]));
    var x23: u64 = undefined;
    var x24: u64 = undefined;
    mulxU64(&x23, &x24, (arg1[1]), (arg2[0]));
    var x25: u64 = undefined;
    var x26: u64 = undefined;
    mulxU64(&x25, &x26, (arg1[0]), (arg2[3]));
    var x27: u64 = undefined;
    var x28: u64 = undefined;
    mulxU64(&x27, &x28, (arg1[0]), (arg2[2]));
    var x29: u64 = undefined;
    var x30: u64 = undefined;
    mulxU64(&x29, &x30, (arg1[0]), (arg2[1]));
    var x31: u64 = undefined;
    var x32: u64 = undefined;
    mulxU64(&x31, &x32, (arg1[0]), (arg2[0]));
    var x33: u64 = undefined;
    var x34: u1 = undefined;
    addcarryxU64(&x33, &x34, 0x0, x28, x7);
    var x35: u64 = undefined;
    var x36: u1 = undefined;
    addcarryxU64(&x35, &x36, x34, x26, x5);
    const x37 = (cast(u64, x36) + x18);
    var x38: u64 = undefined;
    var x39: u1 = undefined;
    addcarryxU64(&x38, &x39, 0x0, x33, x13);
    var x40: u64 = undefined;
    var x41: u1 = undefined;
    addcarryxU64(&x40, &x41, x39, x35, x8);
    var x42: u64 = undefined;
    var x43: u1 = undefined;
    addcarryxU64(&x42, &x43, x41, x37, cast(u64, 0x0));
    const x44 = (cast(u64, x43) + x10);
    var x45: u64 = undefined;
    var x46: u1 = undefined;
    addcarryxU64(&x45, &x46, 0x0, x30, x15);
    var x47: u64 = undefined;
    var x48: u1 = undefined;
    addcarryxU64(&x47, &x48, x46, x38, x16);
    var x49: u64 = undefined;
    var x50: u1 = undefined;
    addcarryxU64(&x49, &x50, x48, x40, x11);
    var x51: u64 = undefined;
    var x52: u1 = undefined;
    addcarryxU64(&x51, &x52, x50, x42, x3);
    var x53: u64 = undefined;
    var x54: u1 = undefined;
    addcarryxU64(&x53, &x54, x52, x44, cast(u64, 0x0));
    const x55 = (cast(u64, x54) + x2);
    var x56: u64 = undefined;
    var x57: u1 = undefined;
    addcarryxU64(&x56, &x57, 0x0, x45, x21);
    var x58: u64 = undefined;
    var x59: u1 = undefined;
    addcarryxU64(&x58, &x59, x57, x47, x19);
    var x60: u64 = undefined;
    var x61: u1 = undefined;
    addcarryxU64(&x60, &x61, x59, x49, x14);
    var x62: u64 = undefined;
    var x63: u1 = undefined;
    addcarryxU64(&x62, &x63, x61, x51, x6);
    var x64: u64 = undefined;
    var x65: u1 = undefined;
    addcarryxU64(&x64, &x65, x63, x53, cast(u64, 0x0));
    var x66: u64 = undefined;
    var x67: u1 = undefined;
    addcarryxU64(&x66, &x67, x65, x55, cast(u64, 0x0));
    var x68: u64 = undefined;
    var x69: u1 = undefined;
    addcarryxU64(&x68, &x69, 0x0, x32, x23);
    var x70: u64 = undefined;
    var x71: u1 = undefined;
    addcarryxU64(&x70, &x71, x69, x56, x24);
    var x72: u64 = undefined;
    var x73: u1 = undefined;
    addcarryxU64(&x72, &x73, x71, x58, x22);
    var x74: u64 = undefined;
    var x75: u1 = undefined;
    addcarryxU64(&x74, &x75, x73, x60, x17);
    var x76: u64 = undefined;
    var x77: u1 = undefined;
    addcarryxU64(&x76, &x77, x75, x62, x9);
    var x78: u64 = undefined;
    var x79: u1 = undefined;
    addcarryxU64(&x78, &x79, x77, x64, x1);
    var x80: u64 = undefined;
    var x81: u1 = undefined;
    addcarryxU64(&x80, &x81, x79, x66, cast(u64, 0x0));
    var x82: u64 = undefined;
    var x83: u1 = undefined;
    addcarryxU64(&x82, &x83, 0x0, x68, x29);
    var x84: u64 = undefined;
    var x85: u1 = undefined;
    addcarryxU64(&x84, &x85, x83, x70, x27);
    var x86: u64 = undefined;
    var x87: u1 = undefined;
    addcarryxU64(&x86, &x87, x85, x72, x25);
    var x88: u64 = undefined;
    var x89: u1 = undefined;
    addcarryxU64(&x88, &x89, x87, x74, x20);
    var x90: u64 = undefined;
    var x91: u1 = undefined;
    addcarryxU64(&x90, &x91, x89, x76, x12);
    var x92: u64 = undefined;
    var x93: u1 = undefined;
    addcarryxU64(&x92, &x93, x91, x78, x4);
    var x94: u64 = undefined;
    var x95: u1 = undefined;
    addcarryxU64(&x94, &x95, x93, x80, cast(u64, 0x0));
    var x96: u64 = undefined;
    var x97: u64 = undefined;
    mulxU64(&x96, &x97, 0x26, x92);
    var x98: u64 = undefined;
    var x99: u64 = undefined;
    mulxU64(&x98, &x99, 0x26, x90);
    var x100: u64 = undefined;
    var x101: u64 = undefined;
    mulxU64(&x100, &x101, 0x26, x88);
    var x102: u64 = undefined;
    var x103: u1 = undefined;
    addcarryxU64(&x102, &x103, 0x0, x82, x98);
    var x104: u64 = undefined;
    var x105: u1 = undefined;
    addcarryxU64(&x104, &x105, x103, x84, x96);
    var x106: u64 = undefined;
    var x107: u64 = undefined;
    mulxU64(&x106, &x107, 0x26, x94);
    var x108: u64 = undefined;
    var x109: u1 = undefined;
    addcarryxU64(&x108, &x109, x105, x86, x106);
    var x110: u64 = undefined;
    var x111: u64 = undefined;
    mulxU64(&x110, &x111, 0x26, x94);
    const x112 = (cast(u64, x109) + x111);
    var x113: u64 = undefined;
    var x114: u1 = undefined;
    addcarryxU64(&x113, &x114, 0x0, x31, x100);
    var x115: u64 = undefined;
    var x116: u1 = undefined;
    addcarryxU64(&x115, &x116, x114, x102, x101);
    var x117: u64 = undefined;
    var x118: u1 = undefined;
    addcarryxU64(&x117, &x118, x116, x104, x99);
    var x119: u64 = undefined;
    var x120: u1 = undefined;
    addcarryxU64(&x119, &x120, x118, x108, x97);
    const x121 = (cast(u64, x120) + x112);
    var x122: u64 = undefined;
    var x123: u64 = undefined;
    mulxU64(&x122, &x123, 0x26, x121);
    var x124: u64 = undefined;
    var x125: u1 = undefined;
    addcarryxU64(&x124, &x125, 0x0, x113, x122);
    var x126: u64 = undefined;
    var x127: u1 = undefined;
    addcarryxU64(&x126, &x127, x125, x115, cast(u64, 0x0));
    var x128: u64 = undefined;
    var x129: u1 = undefined;
    addcarryxU64(&x128, &x129, x127, x117, cast(u64, 0x0));
    var x130: u64 = undefined;
    var x131: u1 = undefined;
    addcarryxU64(&x130, &x131, x129, x119, cast(u64, 0x0));
    var x132: u64 = undefined;
    var x133: u64 = undefined;
    mulxU64(&x132, &x133, 0x26, x131);
    var x134: u64 = undefined;
    var x135: u1 = undefined;
    addcarryxU64(&x134, &x135, 0x0, x124, x132);
    var x136: u64 = undefined;
    var x137: u1 = undefined;
    addcarryxU64(&x136, &x137, x135, x126, cast(u64, 0x0));
    var x138: u64 = undefined;
    var x139: u1 = undefined;
    addcarryxU64(&x138, &x139, x137, x128, cast(u64, 0x0));
    var x140: u64 = undefined;
    var x141: u1 = undefined;
    addcarryxU64(&x140, &x141, x139, x130, cast(u64, 0x0));
    out1[0] = x134;
    out1[1] = x136;
    out1[2] = x138;
    out1[3] = x140;
}
