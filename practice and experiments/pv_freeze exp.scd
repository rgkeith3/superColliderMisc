(
{
	var chainArray, in, trigArray, gateArray, sigs, envs;
	chainArray = LocalBuf(512!8);
	in = SoundIn.ar();
	trigArray = Dust.ar(1!8);
	gateArray = ToggleFF.ar(trigArray);
	envs = EnvGen.ar(Env.adsr(releaseTime: 0.1), gateArray);

	chainArray = FFT(chainArray, in);
	chainArray = PV_Freeze(chainArray, envs > 0);
	chainArray = IFFT(chainArray) * envs;

	sigs = Pan2.ar(chainArray, Latch.kr(WhiteNoise.ar(1!8), gateArray));
	FreeVerb.ar(Mix(sigs));
}.play
)

// could expand this with each freeze being a certain length long, so it's more like a delay with echos


({
	var chains, tick, ramp, step, freezeGate, sigsA, sigsB, sigsC;
	chains = LocalBuf(512!3);
	chains = FFT(chains, SoundIn.ar());

	// with each tick, we freeze anew fftbuffer, switch a and b in the morph, and morph between them
	//[a,b] c
	//tick
	//[b,c] a
	tick = Impulse.ar(1);
	ramp = Sweep.ar(tick);
	step = WrapSummer.ar(tick!3, min: 0, max: 3);
	//[1, 0, 1] 1
	//[1, 1, 0] 2
	//[0, 1, 1] 3

	freezeGate = Select.ar(step, [
		K2A.ar([1,0,1]),
		K2A.ar([1,1,0]),
		K2A.ar([0,1,1])
	]);

	chains = PV_Freeze(chains, freezeGate);

	sigsA = PV_Morph(chains[0], chains[2], ramp);
	sigsB = PV_Morph(chains[1], chains[0], ramp);
	sigsC = PV_Morph(chains[2], chains[1], ramp);

	Select.ar(step, [IFFT(sigsA), IFFT(sigsB), IFFT(sigsC)]);
}.scope)