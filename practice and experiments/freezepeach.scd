(
SynthDef(\freezePeach, {
	|freq=440, freeze = 0|
	var in, localBuf, chain, sig, trackedFreq, hasFreq, pitchRatio;
	in = SoundIn.ar();
	Out.ar(0, (in * ((freeze * -1) +1))!2);
	localBuf = LocalBuf.new(2.pow(10));
	chain = FFT(localBuf, in);
	chain = PV_Freeze(chain, freeze);
	sig = IFFT(chain);
	# trackedFreq, hasFreq = Pitch.kr(sig);
	pitchRatio = freq / trackedFreq;
	sig = PitchShift.ar(sig, pitchRatio: pitchRatio);
	Out.ar(0, (sig * freeze)!2);
}).add
)

x =Synth(\freezePeach)

(
Pdef(\freezePeach,
	Pbind(
		\delta, 0.2,
		\type, \set,
		\id, x.nodeID,
		\args, [\freq, \freeze],
		\scale, Scale.major.degrees,
		\octave, 3,
		\degree, Pseq([1, 4,5,4,5,7,8], inf),
		\freeze, Pwhite(0, 1).trace
	)
).play

)


( y = {
	|ratio1 = 1, ratio2 = 1|
	var sig = SoundIn.ar();
	sig = PitchShift.ar(sig, pitchRatio: ratio1);
	sig = PitchShift.ar(sig, pitchRatio: ratio2);
	sig!2
}.play)

y.set(\ratio2, 5)
y.set(\ratio1, 5.reciprocal)


(1..3)