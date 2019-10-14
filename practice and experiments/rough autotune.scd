
[60, 62, 64, 65, 67, 71].midicps

(((350.cpsmidi.round % 12) / 12) * 6).round

// incoming freq
~freq = 350
// define correct_freq var
~correct_freq;

// get how many 12 note octaves this note is up
~octave = (~freq.cpsmidi.round / 12).round
// get the note in the 12 note scale,
// divide by number of notes in an octave to get it's normalized ratio
// multiply by number of notes in scale and round to get index in degree array
~degree = (((350.cpsmidi.round % 12) / 12) * 6).round

[0, 2, 4, 5, 7, 11][~degree] + (~octave * 12)

65.midicps

s.boot;
(
SynthDef(\major_autotune, {
	var scale, degree, octave, sig, freq, has_freq, freq_midi, corrected_midi, pitch_ratio;
	sig = SoundIn.ar();
	#freq, has_freq = Tartini.kr(sig);
	has_freq = has_freq.round;

	scale = Scale.major.degrees;

	freq_midi = freq.cpsmidi.round;

	octave = (freq_midi / 12).trunc;
	degree = (((freq_midi % 12) / 12) * scale.size).trunc;
	corrected_midi = Select.kr(degree, scale) + (octave * 12);

	freq.poll;
	corrected_midi.midicps.poll;

	pitch_ratio = corrected_midi.midicps / freq;
	pitch_ratio.poll;

	sig = PitchShift.ar(sig, pitchRatio: pitch_ratio);
	Out.ar(0, sig!2);
}).add
)

x = Synth(\major_autotune)
s.scope


(
SynthDef(\sin, {
	arg atk=0.1, rel=0.1, sus=1, freq=440, amp=0.5 ;
	var sig, env;
	env = EnvGen.ar(Env([0, amp, amp, 0], [atk, sus, rel]), doneAction: 2);
	sig = SinOsc.ar(freq) * env;
	Out.ar(0, sig!2)
}).add
)

Scale.major.degrees + 60

(
p = Pbind(
	\instrument, \sin,
	\dur, 1,
	\freq, [60, 64, 67].midicps,
	\amp, 0.1
).play
)