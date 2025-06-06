s.boot

(x.free; x = {
	var sig = DWGBowed.ar(50 * [1,2,3,4], LFNoise2.ar(0.2).bi2uni, LFNoise2.ar(0.2).bi2uni, 1, LFNoise2.ar(0.2).bi2uni);
	sig = DWGSoundBoard.ar(sig);
	sig = sig * SinOscFB.ar(Env.perc(0, 2, curve: -4).ar(0, 1) * 50, [100, 150]).bi2uni;
	50.do({sig = BAllPass.ar(sig, 1000, 2)});
	sig;
}.play)

