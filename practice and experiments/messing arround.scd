s.boot

{
	SinOsc.ar(
		freq: SinOsc.kr(
			freq: 1,
			mul: 50,
			add: 100
		)
	) * SinOsc.kr(freq: 1.1, add: 0.5)
}.play

(
{
	EnvGen.kr(
		Env(
			levels: [0, 0.1, 1, 0.3],
			times: [0.1, 0.2, 0.1],
			curve: 8
		),
		gate: Impulse.kr(3)
	);
}.plot(duration: 1)
)

(
{
	var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
	SinOsc.ar(470) * EnvGen.kr(env, doneAction: Done.freeSelf);
}.play
)

(
{
	GrainSin.ar(
		numChannels: 2,
		trigger: Dust.kr(MouseX.kr(512, 1)),
		dur: MouseX.kr(0, 0.05),
		freq: Diwhite.new(
			lo:MouseY.kr(50, 500),
			hi:MouseY.kr(50, 500) * MouseY.kr(0, 4.0)
		),
		pan: Diwhite.new(),
		mul: 0.5
	)
}.play
)

(
{
	Grain
}
)

s.quit