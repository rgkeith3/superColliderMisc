(
{
	var freqCenter = 50;
	var sig = {SawDPW.ar(freqCenter + rrand(-3.0, 3.0), rrand(0.0, 1.0))}!3;
	var mixedSig = Mix.new(sig);
	var filterEnv = EnvGen.ar(Env([1, 0], [1]), doneAction: 2);
	var lpf = BLowPass.ar(mixedSig, (freqCenter - 50) + (filterEnv * (freqCenter * -1)), 0.01);
	var hpf = BHiPass.ar(mixedSig, (freqCenter + 50) + (filterEnv * freqCenter), 0.01);
	[lpf, hpf]
}.play
)



{Formants.ar(50, Vowel(\o, \alto))}.play
(
{
	Formant.ar(
		LFBrownNoise2.kr(5, mul: 200, add: 200),
		LFBrownNoise2.kr(10, mul: 200, add: 300),
		LFBrownNoise2.kr(1, mul: 200, add: 500)
	)
}.play
)

{ Ringz.ar(SawDPW.ar(MouseX.kr(50, 400)), MouseY.kr(50, 400), 0.1) }.play

{ Resonz.ar(SawDPW.ar(MouseX.kr(50, 400)), MouseY.kr(50, 400), 6) }.play

{ Formlet.ar(SawDPW.ar(MouseY.kr(50, 1000)), MouseX.kr(50, 1000), 0, 1) }.play;

{ RLPF.ar(Saw.ar(50, 0.6), SinOsc.ar(XLine.kr(0.1, 300, {rrand(15.0, 25.0)}!2), 0, 3600, 4000), 0.2) }.play;

s.options.memSize_(65536 * 4);
s.reboot;

(
{
	var sig = SawDPW.ar(75) * EnvGen.ar(Env.perc());
	Greyhole.ar(sig, 0.1, 0.5);
}.play
)

(
{
	var sig = Pluck.ar(WhiteNoise.ar(), Impulse.kr(1), delaytime: 250.reciprocal);
	#w, x, y, z = BFEncode1.ar(sig,MouseX.kr(-0.5pi, 0.5pi), MouseY.kr(-0.5pi, 0.5pi), 1, 0.3);
    //decode for 4 channels
    BFDecode1.ar(w, x, y, z, [-0.25pi, 0.25pi, 0.75pi, 1.25pi], 0);
}.scope(4)
);

{Perlin3.ar(Integrator.ar(K2A.ar(MouseX.kr(0, 0.1))), Integrator.ar(K2A.ar(MouseY.kr(0, 0.1))))}.play(s)
