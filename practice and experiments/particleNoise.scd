s.boot


({
	var trig = Ringz.ar(K2A.ar(1), MouseY.kr(0, 1000), MouseX.kr);
	[CombC.ar(trig, 0.1, LFNoise2.kr(1, 0.05, 0.05)), CombC.ar(trig, 0.1, LFNoise2.kr(1.2, 0.05, 0.05))]
	trig!2
}.play)

(
SynthDef.new(\particleNoise, {
	arg freq=440, dec=0, pan=0, amp=1;
	var sig = Ringz.ar(K2A.ar(1), freq, dec) * amp;
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(0, Pan2.ar(sig, pan));
}).add
)


(
Pbindef(\particleNoise,
	\instrument, \particleNoise,
	\delta, Pwhite(0.01, 0.1),
	\freq, Pwhite(50, 5000),
	\dec, Pwhite(0.01, 2),
	\amp, Pwhite()
).play
)