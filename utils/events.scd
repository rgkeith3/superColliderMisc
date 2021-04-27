(
// bug:
// when you put an osc message inside a proxy it can't send
Event.addParentType(\note, (
	finish: {
		if(~netAddr.notNil) {
			~oscArgs.do {|key|
				~netAddr.sendMsg("/" ++ key, currentEnvironment[key])
			}
		}
	}
));

Event.addParentType(\set, (
	finish: {
		if(~netAddr.notNil) {
			~oscArgs.do {|key|
				~netAddr.sendMsg("/" ++ key, currentEnvironment[key]);
			}
		}
	}
));

//usage:
// SynthDef(\test, {|freq=440, filter_freq=1000| RLPF.ar(Saw.ar(freq), filter_freq) });
// Pbind(\type, \freqable, \instrument, \test, \degree, 1, \filter_degree, Prand([1,3,5], inf)).play

Event.addEventType(\freqable, {
	var base_values, freq_ables, calc_prefixable_freq;
	// establish all defaults
	base_values = (
		_mtranspose: 0,
		_gtranspose: 0.0,
		_ctranspose: 0.0,

		_octave: 5.0,
		_root: 0.0,					// root of the scale
		_degree: 0,
		_scale: #[0, 2, 4, 5, 7, 9, 11], 	// diatonic major scale
		_stepsPerOctave: 12.0,
		_detune: 0.0,					// detune in Hertz
		_harmonic: 1.0,				// harmonic ratio
		_octaveRatio: 2.0,
	);

	// get all prefixed freq-able values
	freq_ables = currentEnvironment.keys.select({|key|
		base_values.keys.any({|base_key| var key_string, base_key_string;
			key_string = key.asString;
			base_key_string = base_key.asString;
			base_key_string.matchRegexp(key_string);
		})
	}).collect({|key|key.asString.split($_)[0]});

	// calculate prefixable freq
	calc_prefixable_freq = {|prefix|
		var prefixed_vals, note, midinote, freq;

		prefixed_vals = (
			mtranspose: currentEnvironment[(prefix ++ "_mtranspose").asSymbol] ? base_values[\_mtranspose],
			gtranspose: currentEnvironment[(prefix ++ "_gtranspose").asSymbol] ? base_values[\_gtranspose],
			ctranspose: currentEnvironment[(prefix ++ "_ctranspose").asSymbol] ? base_values[\_ctranspose],
			octave: currentEnvironment[(prefix ++ "_octave").asSymbol] ? base_values[\_octave],
			root: currentEnvironment[(prefix++"_root").asSymbol] ? base_values[\_root],
			degree: currentEnvironment[(prefix++"_degree").asSymbol] ? base_values[\_degree],
			scale: currentEnvironment[(prefix++"_scale").asSymbol] ? base_values[\_scale],
			stepsPerOctave: currentEnvironment[(prefix++"_stepsPerOctave").asSymbol] ? base_values[\_stepsPerOctave],
			detune: currentEnvironment[(prefix++"_detune").asSymbol] ? base_values[\_detune],
			harmonic: currentEnvironment[(prefix++"_harmonic").asSymbol] ? base_values[\_harmonic],
			octaveRatio: currentEnvironment[(prefix++"_octaveRatio").asSymbol] ? base_values[\_octaveRatio]
		);

		note = (prefixed_vals.degree + prefixed_vals.mtranspose).degreeToKey(
						prefixed_vals.scale,
						prefixed_vals.scale.respondsTo(\stepsPerOctave).if(
							{ prefixed_vals.scale.stepsPerOctave },
							prefixed_vals.stepsPerOctave
						)
					);

		midinote = (((note + prefixed_vals.gtranspose + prefixed_vals.root) /
						prefixed_vals.scale.respondsTo(\stepsPerOctave).if(
							{ prefixed_vals.scale.stepsPerOctave },
							prefixed_vals.stepsPerOctave) + prefixed_vals.octave - 5.0) *
						(12.0 * prefixed_vals.scale.respondsTo(\octaveRatio).if
							({ prefixed_vals.scale.octaveRatio }, prefixed_vals.octaveRatio).log2) + 60.0);

		freq = (midinote + prefixed_vals.ctranspose).midicps * prefixed_vals.harmonic;

		freq + prefixed_vals.detune;
	};

	freq_ables.do({|freq_able|
		currentEnvironment[(freq_able ++ "_freq").asSymbol] = calc_prefixable_freq.value(freq_able);
	});

	~type = \note;
	currentEnvironment.play;
});
)
