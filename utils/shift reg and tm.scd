(
Tdef(\shiftRegister, {
	var octaveRegister, register, size;
	size = 4;
	register = Array.fill(size, {0});
	octaveRegister = Array.fill(size, {0});


	loop {
		var note, octave;
		note = Scale.major.degrees.choose;

		register = register.shift(1, note);

		octave = [2,3,4,5,6,7].choose;
		octaveRegister = octaveRegister.shift(1, octave);

		(degree: register, octave: octaveRegister, pan: [-1.0, -0.3, 0.3, 1.0][0..register.size], legato: Array.fill(4, {rand(2.0)})).play;
		(1/4).yield;
	};
}).play;
)
s.boot
v = 4
[1,2,3, 4, 5, 6, 7].shift(1, rand(1.0))

Array.fill(4, {rand(2.0)})

p = ProxySpace.push()

~shiftRegister.play
(
~shiftRegister = Task({
	var octaveRegister, register, size;
	size = 4;
	register = Array.fill(size, {0});
	octaveRegister = Array.fill(size, {0});


	loop {
		var note, octave;
		note = Scale.major.degrees.choose;

		register = register.shift(1, note);

		octave = [2,3,4,5,6,7].choose;
		octaveRegister = octaveRegister.shift(1, octave);

		(degree: register, octave: octaveRegister, pan: [-1.0, -0.3, 0.3, 1.0][0..register.size], legato: Array.fill(4, {rand(2.0)})).play;
		(1/4).yield;
	};
}).play
)

~shiftRegister.play

p.pop
(
~shiftRegRout = {
	|n=4, degrees=#[1], prob=1|
	{
		var register = Array.fill(n, {degrees.choose});
		prob = prob.asStream;
		loop {
			if (prob.value.coin) {
				register = register.shift(1, degrees.choose);
			};
			register.yield;
		};
	};
};

~turingMachine = {
	|n=4, degrees=#[1], prob=1|
	{
		var register = Array.fill(n, {degrees.choose});
		prob = prob.asStream;
		loop {
			if (prob.value.coin) {
				register = register.shift(1, degrees.choose);
			} {
				register = register.rotate(1);
			};
			register[0].yield
		};
	};
}
);

x = ~shiftRegister.value(4, Scale.major.degrees)
x.value


Pbind(\dur, 1/4, \degree, Prout(~shiftRegRout.value(4, Scale.major.degrees)), \octave, Prout(~shiftRegRout.value(4, [3,4,6,7])), \strum, 0.0625, \pan, Pwhite(-1.0)).play

Pbind(\dur, 1/4, \legato, 0.0625, \degree, Prout(~shiftRegRout.value(4, Scale.major.degrees, Pwrand([0, 1], [0.8, 0.2], inf))), \strum, 0.0625).play

Pbind(\dur, Prout(~turingMachine.value(4, [1/2, 1/4, 1/8], Pwrand([0, 1], [0.9, 0.1], inf))), \degree, Prout(~turingMachine.value(4, Scale.major.degrees, Pwrand([0, 1], [0.8, 0.2], inf)))).play



a = Pwhite().class.superclass.superclass
{}.class.superclass

a.rotate(1)
a.shift(1)
a = Pwhite().asStream
b = {1}.asStream
b.value


a = [1,2,3,4]
a.shift(1, a[a.size -1])
rand(0.7)
a.value

0.25 / 2 /2

x = 1.asStream
x.value
0.1.coin

