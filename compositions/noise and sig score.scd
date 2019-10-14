// when beat stops to play voice, it's kinda awkard, maybe more over lap or better hardstop
// the plucks need better timing to get them all lined up
// also add some pan to the bass to make it more dynamic

// what's left,
// maybe bring back the chords
// drop out some rhythm parts,
// bring back some voice stuff to just transform from crazy rain to intelligible and just let it fade out like that.

(
t = TempoClock.new(140/60);
// time in beats
~introPt1Dur = 400;
~introPt2Dur = 100;
~stopDur = 10;
t.beats =0;
 t.schedAbs(0, {
 	Pbind(
 		\instrument, \ambiFlutterWorm,
 		\delta, 1,
 		\atk, 5,
 		\sus, Pseg([1, 10], ~introPt1Dur),
 		\rel, 5,
 		\amp, Pwhite(hi: 0.3),
 		\degree, Pseg([1, 12, 12], ~introPt1Dur / 2, \cub),
 		\octave, Pseg([1, 3, 3], ~introPt1Dur / 2, \cub),
 		\filter_freq, Pwrand([7, 10] * 12, [0.5, 0.5], inf).midicps,
 		\filter_q, Pwhite(0.01),
 		\flutter_freq, Pwrand([20, 25], [0.9, 0.1], inf),
 		\flutter_filter_freq, Pwrand([10000, 1000, 500], [0.8, 0.1, 0.1], inf),
 		\flutter_filter_q, Pwhite(0.01, 0.5),
 		\flutter_mix, Pseg([1, 0], ~introPt1Dur),
 		\flutter_mix_chaos_depth, Pseg([0, 1, 0], ~introPt1Dur / 2, \cub),
 		\flutter_mix_chaos_speed, Pseg([0, 5, 0], ~introPt1Dur / 2, \cub),
 		\sig_chaos_depth, Pseg([2, 0.001], ~introPt1Dur, \cub),
 		\sig_chaos_speed, Pseg([0, 5, 0], ~introPt1Dur / 2, \cub),
 		\pos, Pwhite(0.0, 2.0),
 		\pos_chaos_depth, Pseg([1, 0], ~introPt1Dur, \cub),
 		\pos_chaos_speed, 1,
 		\group, ~mainGroup,
 		\out, Prand([~bus[\reverb][0].index, ~out], inf)
 	).play(t);
});

 t.schedAbs(370, {
 	Pdef(\chords,
 		Pbind(
 			\instrument, \ambiFlutterWorm,
 			\delta, 1,
 			\atk, 2,
 			\sus, Pseg([2, 5], ~introPt2Dur),
 			\rel, 2,
 			\amp, Pseg([0.1, 0.3], ~introPt2Dur, \cub),
 			\degree, Prand([1, 3, 5, 6, 7, 9, 11], inf),
 			\octave, Prand([2, 3, 4, 5, 6], inf),
 			\filter_freq, 7500,
 			\filter_q, Pwhite(0.01),
 			\flutter_mix, 0,
 			\sig_chaos_speed, 0.001,
 			\pos, Pwhite(0.0, 2.0),
 			\pos_chaos_depth, 0,
 			\group, ~mainGroup,
 			\out, Prand([~bus[\reverb][0].index, ~out], inf)
 		)
 	).play(t);

 	Pdef(\reverbSwell,
 		Pbind(
            \type, \set,
 			\id, ~reverbGroup.nodeID,
 			\args, [\room, \damp],
 			\room, Pseg([0.5, 5], ~introPt2Dur),
 			\damp, Pseg([0.5, 0], ~introPt2Dur)
 		)
 	).play
});

t.schedAbs(450, {
 	Pdef(\chords).stop;
 	~mainGroup.freeAll;
});

t.schedAbs(462, {
	~reverbGroup.set(\room, 1, \damp, 1);

	Pdef(\hatgrains,
		Pbind(
			\instrument, \grainSampler,
			\delta, Pwrand([1/3, Pseq([1/9], 3)], [0.95, 0.05], inf),
			\out, Prand([~out, ~bus[\reverb][0].index],inf),
			\bufnum, ~buffers[0],
			\grainEnv, Prand(~grainEnvs, inf),
			\startPos, 0,
			\windowPosNoise, 0,
			\windowRate, 0.1,
			\atk, 0,
			\sus, 0,
			\grainPitchRatio, Pwhite(0.9, 1.1),
			\rel, Pwrand([0.01, 0.5], [0.95, 0.05], inf),
			\amp, Pwhite(2, 3.5),
			\trigRate, 25,
			\trigNoise, Pwhite(),
			\grainSize, 0.01,
			\panSpread, 0.5,
			\pan, Pwhite(0.0, 2.0),
			\group, ~rhythmGroup
		)
	).play(t);
});

t.schedAbs(498, {
	Pdef(\bass,
		Pbind(
			\instrument, \ambiFlutterWorm,
			\delta, 16,
			\atk, 0,
			\sus, 4,
			\rel, 1,
			\amp, 0.7,
			\degree, 1,
			\octave, 3,
			\out, ~bus[\reverb][0].index,
			\filter_freq, Pseg([750, 1250, 750], 50,repeats: inf),
			\filter_q, 0.05,
			\flutter_mix, 0.1,
			\flutter_filter_freq, 10000,
			\pos, Pwhite(0.0, 2.0),
			\pos_chaos_depth, 1,
			\pos_chaos_speed, 0.5,
			\group, ~rhythmGroup
		)
	).play(t);
});

t.schedAbs(562, {
	Pdef(\kik,
		Pbind(
			\instrument, \ambiFlutterWorm,
			\delta, Pseq([4/3, 2/3, 1, 1, 2/3], inf),
			\atk, 0,
			\sus, 0.05,
			\rel, Pwrand([0, 0.1], [0.95, 0.05], inf),
			\amp, 0.8,
			\degree, 1,
			\octave, 2,
			\out, ~out,
			\filter_freq, 75,
			\filter_q, 0.01,
			\flutter_mix, Pwhite(hi: 0.2),
			\flutter_filter_freq, Prand([1000, 5000, 10000], inf),
			\pan, Pseg([0, 2], 48, repeats: inf),
			\group, ~rhythmGroup
		)
	).play(t);
});

t.schedAbs(578, {
	Pdef(\longKik,
		Pbind(
			\instrument, \ambiFlutterWorm,
			\delta, Prand([24, 12], inf),
			\atk, 0,
			\sus, 0,
			\rel, 4,
			\amp, 0.1,
			\degree, 1,
			\octave, 5,
			\out, ~out,
			\filter_freq, 15000,
			\filter_q, 0.01,
			\flutter_mix, Pwhite(hi: 0.2),
			\pos, Pwhite(0.0, 2.0),
			\group, ~rhythmGroup
		)
	).play(t);

	Pdef(\longGrains,
		Pbind(
			\instrument, \grainSampler,
			\delta, Pwhite(16, 32),
			\atk, 5,
			\sus, 0,
			\rel, 5,
			\bufnum, Prand(~buffers, inf),
			\grainEnv, Prand(~grainEnvs, inf),
			\out, Prand([~bus[\reverb][0].index, ~out], inf),
			\start, Pwhite(),
			\windowPosNoise, Pwhite(),
			\windowRate, Pwhite(),
			\trigRate, Pwhite(50, 250),
			\grainSize, Pwhite(0.0001, 0.01),
			\grainPitchRatio, Pwhite(0.5, 1.5),
			\trigNoise, Pwhite(),
			\pan, Pwhite(0.0, 2.0),
			\amp, 2,
			\panSpread, Pwhite(hi: 2.0),
			\group, ~rhythmGroup
		)
	).play(t);
});

t.schedAbs(690, {
	~rhythmGroup.freeAll;
	Pdef(\hatgrains).stop;
	Pdef(\bass).stop;
	Pdef(\kik).stop;
	Pdef(\longKik).stop;
	Pdef(\longGrains).stop;

	~voiceLength = 16;
	~voice = Synth(\grainSampler, [
		\atk, 0,
		\sus, 20,
		\rel, 5,
		\amp, 2,
		\out, ~bus[\reverb][0].index,
		\bufnum, ~buffers.choose,
		\grainEnvs, ~grainEnvs.choose,
		\start, 0,
		\windowPosNoise, 0,
		\windowRate, 0.3,
		\grainSize, 0.01,
		\grainPitchRatio, 1,
		\trigRate, 25,
		\trigNoise, 0,
		\pan, 1,
		\panSpread, 0,
	]);

	Pdef(\voice,
		Pbind(
			\type, \set,
			\delta, 1/4,
			\id, ~voice.nodeID,
			\args, [
				\amp,
				\windowPosNoise,
				\windowRate,
				\grainSize,
				\grainPitchRatio,
				\trigRate,
				\trigNoise,
				\pan,
				\panSpread
			],
			\amp, Pseg([3, 1], ~voiceLength),
			\windowPosNoise, Pseg([1, 0], ~voiceLength),
			\windowRate, Pseg([0.3, 1], ~voiceLength),
			\grainSize, Pwhite(0.0001, Pseg([0.001, 0.5], ~voiceLength)),
			\grainPitchRatio, 1,
			\trigRate, Pseg([25, 250], ~voiceLength),
			\trigNoise, Pseg([1, 0], ~voiceLength),
			\pan, Pseg([1, 0, 2], ~voiceLength / 2),
			\panSpread, 0
		)
	).play(t);
});

t.schedAbs(722, {
	~voiceDestroyLength = 8;
	Pdef(\voicedestroy,
		Pbind(
			\type, \set,
			\delta, 1/8,
			\id, ~voice.nodeID,
			\args, [
				\amp,
				\windowPosNoise,
				\windowRate,
				\grainSize,
				\grainPitchRatio,
				\trigRate,
				\trigNoise,
				\pan,
				\panSpread
			],
			\amp, Pseg([1, 4], ~voiceDestroyLength),
			\windowPosNoise, Pseg([0, 1], ~voiceDestroyLength),
			\windowRate, Pseg([1, 3, 0.5], ~voiceDestroyLength / 2),
			\grainSize, Pwhite(0.0001, 0.5),
			\grainPitchRatio, Pwhite(Pseg([1, 0.5], ~voiceDestroyLength), Pseg([1, 2], ~voiceDestroyLength)),
			\trigRate, 250,
			\trigNoise, Pseg([0, 1], ~voiceDestroyLength),
			\pan, Pseg([2, 0, 1, 0.5], ~voiceDestroyLength / 2),
			\panSpread, Pseg([0, 1], ~voiceDestroyLength)
		)
	).play(t);

	// maybe set reverb growing here
});

t.schedAbs(730, {
	Pdef(\bass).play(t);
	Pdef(\hatgrains).play(t);

	Pdef(\kik,
		Pbind(
			\instrument, \ambiFlutterWorm,
			\delta, Pseq([Pwrand([4/3, Pseq([1/3, 2/3, 1/3])], [0.7, 0.3]), 2/3, 1, 1, 2/3], inf).trace,
			\atk, 0,
			\sus, 0.05,
			\rel, 0,
			\amp, 0.8,
			\degree, 1,
			\octave, 2,
			\out, ~out,
			\filter_freq, 250,
			\filter_q, 0.5,
			\flutter_mix, Pwhite(hi: 0.2),
			\flutter_filter_freq, Prand([1000, 5000, 10000], inf)
		)
	).play(t);

	Pdef(\sizzle,
		Pbind(
			\instrument, \ambiFlutterWorm,
			\delta, 8,
			\atk, 0,
			\rel, 0,
			\amp, 2,
			\sus, 3,
			\degree, 5,
			\octave, 8,
			\flutter_freq, Pwhite(15, 30),
			\flutter_mix, 1,
			\flutter_filter_freq, Pwhite(14000, 15000),
			\flutter_filter_q, 0.03,
			\pos, Pseg([2, 0, 2], 30, repeats: inf),
			\pos_chaos_depth, 1,
			\pos_chaos_speed, 0.3
		)
	).play(t);
});

t.schedAbs(746, {
	Pdef(\longGrains,
		Pbind(
			\instrument, \grainSampler,
			\delta, 1,
			\atk, 0,
			\sus, t.beatDur,
			\rel, Pwrand([0, t.beatDur], [0.8, 0.2], inf),
			\bufnum, Prand(~buffers, inf),
			\grainEnv, Prand(~grainEnvs, inf),
			\out, Prand([~bus[\reverb][0].index, ~out], inf),
			\start, Pwhite(),
			\windowPosNoise, Pwhite(),
			\windowRate, Pwhite(),
			\trigRate, Pwhite(50, 250),
			\grainSize, Pwhite(0.0001, 0.1),
			\grainPitchRatio, Pwhite(0.5, 1.5),
			\trigNoise, Pwhite(),
			\pan, Pseq([0, 0.5, 2, 1.5], inf),
			\amp, 0.6,
			\panSpread, Pseg([0, 1, 0], 30, repeats: inf),
			\group, ~rhythmGroup
		)
	).play(t);
});

t.schedAbs(762, {
	Pdef(\plucks,
		Pbind(
			\instrument, \plucky,
			\delta, Pwhite(0.0, Pseg([8, 0.1, 0.1], [48, 32], repeats: 1)),
			\degree, Prand([1, 5, 7, 11], inf),
			\octave, Prand([4, 5, 6], inf),
			\rel, Pwhite(0.001, Pseg([0.01, 5, 0.01], [48, 32], repeats: 1)),
			\timbre, Pseg([0.9, 0.1], 80, repeats: inf),
			\out, Prand([~bus[\reverb][0].index, ~out], inf),
			\pan, Pseg([0, 2], 24, repeats: inf),
			\amp, 0.5
		)
	).play(t);
});

t.schedAbs(840, {
	Pdef(\longGrains).stop;
	Pdef(\sizzle).stop;
	Pdef(\kik).stop;
	Pdef(\bass).stop;
	Pdef(\hatgrains).stop;
	~rhythmGroup.freeAll;
});

 t.schedAbs(848, {
 	Pdef(\plucks,
 		Pbind(
 			\instrument, \plucky,
 			\delta, Pwhite(0.0, 0.1),
 			\degree, Prand([1, 5, 7, 11], inf),
 			\octave, Prand([4, 5, 6], inf),
 			\rel, Pwhite(Pseg([0.01, 5.0], 32), 7.0),
 			\timbre, Pwhite(0.0, 0.3),
 			\out, Prand([~bus[\reverb][0].index, ~out], inf),
 			\pan, Pseg([0, 2], 24, repeats: inf),
 			\amp, Pwhite(0.2, 0.5)
 		)
 	).play(t);
 });

t.schedAbs(882, {
	Pdef(\pulse,
		Pbind(
			\instrument, \ambiFlutterWorm,
			\delta, Pseq([1.5, 1, 1], inf),
			\atk, 0,
			\sus, 0.2,
			\rel, 0.05,
			\amp, 0.5,
			\degree, Pwrand([5, 1],[0.9, 0.1], inf),
			\octave, 2,
			\out, ~out,
			\filter_freq, 150,
			\filter_q, 0.05,
			\flutter_mix, 0,
			\pos, Pwhite(0.0, 2.0),
			\pos_chaos_depth, 0,
			\group, ~rhythmGroup
		)
	).play(t);
	Pdef(\plucks,
		Pbind(
			\instrument, \plucky,
			\delta, 1/4,
			\degree, Pseq([Prand([1, 5, 7, 11], 4 * 16), Prand([2, 4, 6, 9], 4 * 16)], inf),
			\octave, Prand([4, 5, 6], inf),
			\rel, Pwhite(Pseg([0.001, 3.0], 32, repeats: inf), 5.0),
	        \timbre, Pwhite(0.0, 0.3),
			\out, Prand([~bus[\reverb][0].index, ~out], inf),
			\pan, Pwhite(hi: 2.0),
			\amp, 0.5,
			\group, ~rhythmGroup
		)
	).play(t);
});

t.schedAbs(946, {
	Pdef(\chords,
		Pbind(
			\instrument, \ambiFlutterWorm,
			\delta, 0.5,
			\atk, 1,
			\sus, 2,
			\rel, 1,
			\amp, Pwhite(hi: 0.1),
			\degree, Prand([1, 3, 5, 6, 7, 9, 11], inf),
			\octave, Prand([4, 5, 6], inf),
			\filter_freq, 7500,
			\filter_q, Pwhite(0.01),
			\flutter_mix, 0,
			\sig_chaos_speed, 0.001,
			\pos, Pwhite(0.0, 2.0),
			\pos_chaos_depth, 0,
			\group, ~mainGroup,
			\out, Prand([~bus[\reverb][0].index, ~out], inf)
		)
	).play(t);

	v = Synth.new(
		\grainSampler, [
			\atk, 20,
			\sus, 40,
			\rel, 20,
			\amp, 1,
			\out, ~bus[\reverb][0].index,
			\bufnum, ~buffers.choose,
			\start, 0,
			\windowPosNoise, 0,
			\windowRate, 1,
			\grainSize, 0.1,
			\grainPitchRatio, 1,
			\trigRate, 250,
			\trigNoise, 0,
			\pan, 0.5,
			\panSpread, 0,
	]);
});

t.schedAbs(1010, {
	Pdef(\voice,
		Pbind(
			\type, \set,
			\id, v.nodeID,
			\args, [\windowRate, \windowPosNoise, \amp, \grainSize, \trigRate, \trigNoise, \pan, \panSpread],
			\windowRate, Pseg([1.0, 0.1, 0.1], 64),
			\windowPosNoise, Pseg([0.0, 0.5, 0.5], 64),
			\amp, Pseg([1, 3, 3], 64),
			\grainSize, Pseg([0.1, 0.5, 0.5], 64),
			\trigRate, Pseg([250, 50, 50], 64),
			\trigNoise, Pseg([0.0, 1.0, 1.0], 64),
			\pan, Pseg([1, 0, 2, 1], 64/3),
			\panSpread, Pseg([0.0, 1.0, 1.0], 64)
		)
	).play(t);

	Pdef(\plucksTwo,
		Pbind(
			\instrument, \plucky,
			\delta, Pwhite(Pseg([1/4, 0.0, 0.0], 64), Pseg([1/4, 0.1, 0.1], 64)),
			\degree, Prand([1, 5, 7, 11], inf),
			\octave, Prand([4, 5, 6], inf),
			\rel, Pwhite(Pseg([0.01, 5.0, 5.0], 64), 7.0),
	        \timbre, Pwhite(0.0, 0.3),
			\out, Prand([~bus[\reverb][0].index, ~out], inf),
			\pan, Pwhite(Pseg([0.0, 0.0, 1.0], 64), Pseg([2.0, 2.0, 1.0], 64)),
			\amp, Pwhite(Pseg([0, 0.2, 0.2], 64), Pseg([0, 0.5, 0.5], 64)),
			\group, ~rhythymGroup
		)
	).play(t);
});

t.schedAbs(1074, {
	Pbind(
		\type, \set,
		\id, ~mainGroup,
		\args, [\amp],
		\amp, Pseg([0.1, 0.4], 32)
	).play(t);
});
t.schedAbs(1106, {
	~mainGroup.freeAll;
	~rhythmGroup.freeAll;
	Pdef.removeAll;
});
)
(
~voiceLength = 16;
	~voice = Synth(\grainSampler, [
		\atk, 0,
		\sus, 20,
		\rel, 5,
		\amp, 2,
		\out, ~bus[\reverb][0].index,
		\bufnum, ~buffers.choose,
		\grainEnvs, ~grainEnvs.choose,
		\start, 0,
		\windowPosNoise, 0,
		\windowRate, 0.3,
		\grainSize, 0.01,
		\grainPitchRatio, 1,
		\trigRate, 25,
		\trigNoise, 0,
		\pan, 0
	]);

	Pdef(\voice,
		Pbind(
			\type, \set,
			\delta, 1/4,
			\id, ~voice.nodeID,
			\args, [
				\amp,
				\windowPosNoise,
				\windowRate,
				\grainSize,
				\grainPitchRatio,
				\trigRate,
				\trigNoise,
				\pan,
				\panSpread
			],
			\amp, Pseg([3, 1], ~voiceLength),
			\windowPosNoise, Pseg([1, 0], ~voiceLength),
			\windowRate, Pseg([0.3, 1], ~voiceLength),
			\grainSize, Pwhite(0.0001, Pseg([0.001, 0.5], ~voiceLength)),
			\grainPitchRatio, 1,
			\trigRate, Pseg([25, 250], ~voiceLength),
			\trigNoise, Pseg([1, 0], ~voiceLength),
			\pan, 0
		)
	).play;
)
