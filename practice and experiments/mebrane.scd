(
{ var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * PinkNoise.ar(0.4);
  var tension = MouseX.kr(0.01, 0.1);
  var loss = MouseY.kr(0.999999, 0.999, 1);
  MembraneCircle.ar(excitation, tension, loss);
}.play;
)


(
SynthDef(\drum, {
	|tension=0.1, atk=0.01, rel=0.1, lpfreq=1000, loss=0.9, pan=0|
	var excitation, sig;
	excitation = EnvGen.kr(Env.perc(atk, rel)) * LPF.ar(WhiteNoise.ar(), lpfreq);
	sig = MembraneHexagon.ar(excitation, tension, loss);
	DetectSilence.ar(sig, doneAction: 2);
	Out.ar(0, Pan2.ar(sig, pan))
}).add
)


(
Pbindef(
	\drums,
	\instrument, \drum,
	\delta, Pwrand([1/6, Pseq([1/24], 4)], [0.9, 0.1], inf),
	\tension, Pexprand(0.001, 0.1).trace,
	\atk, 0.01,
	\rel, 0.01,
	\lpfreq, Pseg([500, 5000, 500], 35, repeats: inf),
	\loss, Pseg([0.999, 0.99999, 0.999], 25, repeats: inf),
	\pan, Pwhite(-1.0, 1.0)
).play
)
