s.options.sampleRate_(44100)
s.options.memSize_(8192 * 8)
s.reboot




b = PathName(Platform.recordingsDir).files.collect({|file| Buffer.readChannel(s, file.fullPath, channels: [0])})
b[5].play
~b = Buffer.loadCollection(s, Env([0, 1, 0], [0.01, 1]).discretize);
~b2 = Buffer.loadCollection(s, Env.perc(1, 0.01).discretize);
(
~irBuf = Buffer.alloc(s, s.sampleRate);
~irBuf2 = Buffer.alloc(s, s.sampleRate);
~fft = 2048;
)

{RecordBuf.ar(PlayBuf.ar(1, b[5], 1, startPos: Rand(0, b[5].numFrames)) * Env.perc.ar * 0.1, ~irBuf, loop: 0, doneAction: 2)}.play
{RecordBuf.ar(PlayBuf.ar(1, b[5], 1, startPos: Rand(0, b[5].numFrames)) * Env.perc.ar * 0.1, ~irBuf2, loop: 0, doneAction: 2)}.play
~irBuf.play
~irBuf2.play

(
var bufSize = PartConv.calcBufSize(~fft, ~irBuf);
~ir1 = Buffer.alloc(s, bufSize, 1);
~ir1.preparePartConv(~irBuf, ~fft);
)
(
var bufSize = PartConv.calcBufSize(~fft, ~irBuf2);
~ir2 = Buffer.alloc(s, bufSize, 1);
~ir2.preparePartConv(~irBuf2, ~fft);
)

(x.free; x = {
	// var sig = Warp1.ar(1, b[4], MouseX.kr, 1, LFNoise2.ar(1).exprange(0.1, 0.5), -1, 8, LFNoise2.ar(1).range(0, 0.1));
	var sig = GrainBuf.ar(2, Impulse.ar(50), 0.01, b[5], 1, WhiteNoise.ar.bi2uni, envbufnum: ~b, pan: WhiteNoise.ar, mul: 0.01);
	// [PartConv.ar(sig, ~fft, ~ir1), PartConv.ar(sig, ~fft, ~ir2)];
	[PartConv.ar(sig[0], ~fft, ~ir1), PartConv.ar(sig[1], ~fft, ~ir2)];
}.play)
{GrainBuf.ar(2, Impulse.ar(8), 1, b.last, 0.125, 0.2 + LFNoise2.ar(1).range(0, 0.8), 2, LFNoise2.ar(1))}.play

GrainB
b.last.plot