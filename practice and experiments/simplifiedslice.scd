s.boot
b = Buffer.readChannel(s, "/Users/greykeith/Downloads/202537__gowers__140-bpm-amen-break-original-processed.wav", channels: [0])
(x.free; x = {
	var loopDur = 8;
	var loopHz = loopDur.reciprocal;
	var gHz = loopHz * 512;
	var sliceDiv = 1;
	var sliceNum = 0;
	var repeats = 16;
	var pos = LFSaw.ar((loopHz * sliceDiv) * repeats, 1).linlin(-1,1,0 ,1/(sliceDiv * repeats)) + (sliceNum / sliceDiv);
	BufGrain.ar(Impulse.ar(gHz), 2/gHz, b, 1, pos)
}.play)

(SynthDef(\slice, {
	var loopHz = (\loopDur.kr(8) * \tempo.kr(2).reciprocal).reciprocal;
	var sliceDiv = \sliceDiv.kr(16);
	var sliceHz = sliceDiv * loopHz;
	var gHz = sliceHz * 2.pow(\gStretch.kr(1) * 10);
	var sliceNum = \sliceNum.kr(0);
	var repeats = \repeats.kr(1);
	var pitch = \pitch.kr(1);
	var pos = LFSaw.ar((sliceHz) * repeats, 1).linlin(-1,1,0 ,1/(sliceDiv * repeats)) + (sliceNum / sliceDiv);
	var sig = BufGrain.ar(Impulse.ar(gHz), 2/gHz, b, pitch, pos);
	sig = sig * Env.asr(0.01, 1, 0.01).ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.8));

	Out.ar(\out.kr(0), sig);
}).add)

p = ProxySpace.push(s)
p.makeTempoClock
p.clock.tempo_(165/60)
p.quant_(4)
(
~a[1] = Pbind(\instrument, \slice,
	\tempo, Pfunc({~tempo.asBus.getSynchronous}),
	\sliceNum, Pn(Plazy({Pseq((0..15).scramble, 4)})),
	\dur, 1/2,
	\loopDur, 16,
	\legato, Pn(Pwrand([1,0.5], [0.8, 0.2], inf), 2),
	// \legato, 1,
	\sliceDiv, Pwrand([16, 8, 32], [4, 1, 1].normalizeSum, inf),
	\gStretch, 1,
	\repeats, Pn(Plazy({Pseq(Array.fill(8, {[1,2,4].choose}))})),
	\pitch, 1,
	\amp, 1
)
)

~b = Pbind(\instrument, \default, \degree, Pn(Plazy({ if (0.5.coin, {Pseq(Array.rand(4, 1, 4))}, {Pseq([1,2,3,4])})})))
~b.play
~a.play
2.pow(1 * 10)