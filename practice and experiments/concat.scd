s.boot

b = Buffer.read(s,"/Users/greykeith/superCollider/samples/breaks/eric_moore_breaks_cuts_3.wav" )

b.play


(
{
	var input, length, sig, factor;
	input = PlayBuf.ar(1, b, 1.5, loop: 1);
	length = (BufSamples.kr(b) / SampleRate.ir()) / 1.5;
	factor = 0.5.pow(MouseY.kr(0, 8).floor);
	sig = Concat.ar(SawDPW.ar(LFNoise0.kr(length.reciprocal, 500, 500)), input, length,  length * factor, length * factor, length * factor, 0, 1, 0, 1, 1);
	sig = SelectX.ar(LFNoise0.kr(length.reciprocal * 8, 0.5, 0.5).poll, [input, sig]);
	[CombC.ar(sig, 0.2, SinOsc.ar(0.01, mul: 0.01).clip(0.0001, 0.01), SinOsc.ar(0.01, phase: 0.2).clip(0, 0.1)), CombC.ar(sig, 0.1, SinOsc.ar(0.02, phase: 0.4, mul: 0.01).clip(0.0001, 0.01), SinOsc.ar(0.01, 0.5).clip(0, 0.1))];
}.play
)
0.125 *0.5

0.5.pow(3)
0.5.pow(1)

{MouseY.kr(0, 8).floor}.play

